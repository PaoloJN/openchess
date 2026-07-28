# Driving a DIY Hobby PWM Servo (Custom Gripper) from the RoArm-M2-S

Sources (fetched 2026-07-28):
- https://www.waveshare.com/wiki/General_Driver_for_Robots (the arm's driver board)
- https://www.waveshare.com/wiki/Tutorial_IV:_PWM_Servo_Control_Demo
- https://www.waveshare.com/wiki/WAVE_ROVER (for contrast: its firmware HAS an IO PWM command)
- https://github.com/waveshareteam/roarm_m2 (`json_cmd.h`, `switch_module.h`, `RoArm-M2_config.h`)

## TL;DR

| Question | Answer |
|----------|--------|
| Can a 3-wire hobby PWM servo plug into the arm's servo daisy chain? | **No.** The chain is an ST3215 TTL serial bus at ~12 V, not PWM. It would not work and the ~12 V rail can destroy a 5–6 V hobby servo. |
| Does the stock JSON command set have a PWM-servo / raw-PWM-pin command? | **No.** T:113/T:114/T:115 exist but drive switched 12 V H-bridge ports (LED/accessory power), not 50 Hz servo signals. (`{"T":132,"IO4":..,"IO5":..}` is WAVE ROVER/UGV firmware, not RoArm-M2-S.) |
| Does the board have hardware for a hobby servo? | **Yes.** Spare PWM-capable ESP32 GPIO are broken out (Waveshare's own PWM-servo demo for this exact board drives a servo on **GPIO4**), and the board has a 5 V regulator. But using it from JSON requires a small firmware modification. |
| Easiest paths | (a) Actuate the DIY gripper with the arm's existing gripper servo (ID 15, `T:106`) if mechanically possible; (b) drive the hobby servo from your own second ESP32; (c) add ~20 lines to the open-source arm firmware to expose GPIO4 as a servo output with a custom JSON command. |

## 1. The servo daisy chain is a serial bus — hobby servos cannot join it

- The arm's five joint servos are **ST3215 serial bus servos**. The 3-pin
  daisy-chain carries: servo power (the raw 7–12.6 V supply, typically 12 V),
  GND, and a **half-duplex TTL UART data line** (ESP32 GPIO18/19 through the
  board's bus-servo driver circuit). Each servo has an ID (11–15 on the arm)
  and receives addressed serial packets — up to 253 servos per bus.
- A standard hobby servo's 3 wires look similar (power/GND/signal) but expect
  **4.8–6 V power** and a **50 Hz, 1–2 ms pulse** on the signal pin. Plugged
  into the chain it would receive ~12 V power (likely fatal) and serial data
  it cannot interpret. **Do not plug it in.**
- If you want something that *does* join the chain: use another ST-series bus
  servo (e.g. ST3215) as the gripper actuator. Note the stock firmware only
  addresses IDs 11–15, so a sixth bus servo still needs firmware changes —
  simplest is to keep the stock gripper servo (ID 15) as the actuator for a
  redesigned gripper, controlled by `{"T":106,"cmd":<rad>,"spd":0,"acc":0}`
  and torque-limited with `{"T":107,"tor":200}`.

## 2. What the stock JSON set CAN switch: two 12 V PWM power ports

The firmware's only "extra output" commands drive the TB6612FNG H-bridge
(PWMA=GPIO25, AIN1=21, AIN2=17; PWMB=GPIO26, BIN1=22, BIN2=23; 100 kHz PWM):

```json
{"T":113,"pwm_a":-255,"pwm_b":-255}   // switch-12V ctrl, -255..0(off)..255
{"T":114,"led":255}                    // LED port (channel A), 0-255
{"T":115}                              // both off
```

These appear on the two PH2.0 2P "motor without encoder" connectors (port A is
the arm's LED lamp interface). Good for lights, a relay, a DC motor/pump —
**not usable as a hobby-servo control signal** (wrong waveform, 12 V).

## 3. Spare PWM-capable IO on the board

- Waveshare's **PWM Servo Control demo for this driver board** attaches an
  ESP32Servo object to **`PSERVO_PIN 4` (GPIO4)** — i.e. GPIO4 is broken out
  and intended for exactly this ("multi-functional extended interface ... for
  additional functions, such as controlling servos or relays"). On the
  sibling UGV firmware the equivalent outputs are called IO4/IO5.
- GPIO4 (and GPIO5) are unused by the RoArm-M2-S firmware pin map
  (used pins: 18/19 servo bus, 25/17/21/22/23/26 TB6612, 32/33 I2C OLED,
  34 encoder input, 1/3 UART0).
- Locate the physical header via the board silkscreen ("IO4"/"IO5") or the
  schematic PDF:
  https://files.waveshare.com/wiki/RoArm-M2-S/General_Driver_for_Robots.pdf
- **Power warning from Waveshare:** the board's 5 V rail is only good for
  micro servos (their recommended WP90); MG996R/MG90S-class and other
  high-power PWM servos are explicitly unsupported from board power. For a
  bigger gripper servo, feed it 5–6 V from a separate BEC/regulator off the
  12 V supply and share **only GND + signal** with the board.

## 4. Options ranked

1. **Reuse the stock gripper servo (no electronics changes).** If the DIY
   gripper can be driven by the existing ID-15 bus servo, control it with
   `T:106` (angle), `T:107` (grab torque). Zero firmware work.
2. **Drive the hobby servo from your own second ESP32** (the one you'd use to
   command the arm anyway). A hobby servo needs just one PWM pin
   (ESP32Servo/LEDC, 50 Hz) + 5 V supply. Keeps the arm firmware stock;
   coordinate gripper and arm motion in your own code.
3. **Modify the arm firmware (open source, Arduino) to add a servo command.**
   In `RoArm-M2_example`: include ESP32Servo, `pwmServo.attach(4)`, and add a
   case to the JSON handler, e.g. `{"T":117,"angle":90}` → `pwmServo.write()`.
   Waveshare's demo skeleton:

   ```c
   #include <ESP32_Servo.h>
   Servo pwmServo;
   #define PSERVO_PIN 4          // GPIO4 on the General Driver board
   pwmServo.attach(PSERVO_PIN);
   pwmServo.write(90);           // degrees
   ```

   Then the gripper becomes controllable over USB/UART/HTTP/ESP-NOW like
   everything else (ESP-NOW `cmd:1` + `megs` can carry the new command).
4. **Swap in an ST-series bus servo for the DIY gripper** and extend the
   firmware to address a 6th ID — most work, only worth it if you want
   position/torque feedback from the gripper.
