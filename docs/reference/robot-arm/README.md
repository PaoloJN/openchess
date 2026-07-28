# Waveshare RoArm-M2-S Reference (for the chess-piece-moving arm)

Compiled 2026-07-28 from the official Waveshare wiki and the
`waveshareteam/roarm_m2` firmware source. Files in this directory:

- `00-overview.md` — product, driver board, power, boot behavior, resources
- `10-json-commands.md` — full JSON command reference (the critical file)
- `20-esp-now.md` — ESP-NOW leader/follower control + data struct
- `30-uart-serial.md` — USB/UART wiring, baud, Python demos
- `40-custom-servo-io.md` — driving a DIY hobby-servo gripper

## Confirmed model

**RoArm-M2-S** — 4-DOF desktop arm, ST3215 serial bus servos, ESP32-WROOM-32
on Waveshare's "General Driver for Robots" board. Wiki:
https://www.waveshare.com/wiki/RoArm-M2-S — firmware:
https://github.com/waveshareteam/roarm_m2
(Lineup context: M2-Pro = metal-servo M2; RoArm-M3-S/Pro = newer 5+1 DOF
models. This doc set covers the M2-S only.)

## ESP32-to-ESP32 control options, ranked by simplicity

1. **UART wire (recommended for reliability).** Default **115200 baud** 8N1,
   3.3 V TTL. Either plug USB into the arm's USB Type-C (CP2102) from a
   computer, or wire your ESP32's spare UART to the arm's RX/TX pins (broken
   out on the 40-pin Pi header; same UART0 as USB — don't use both). Send
   newline-terminated JSON; read JSON feedback. No pairing, no RF flakiness.
2. **ESP-NOW (recommended for wireless).** Arm is a Follower obeying
   broadcast frames out of the box. Your ESP32 sends a fixed
   `struct_message` (devCode, 4 joint floats, cmd byte, 210-char message) to
   the arm's MAC or `FF:FF:FF:FF:FF:FF`. `cmd=0` = joint pose in radians;
   `cmd=1` = execute the JSON string in `message` (non-blocking commands
   only). Low latency, no router needed. See `20-esp-now.md`.
3. **HTTP over WiFi.** `GET http://192.168.4.1/js?json=<cmd>` against the
   arm's AP (`RoArm-M2` / `12345678`). Easiest from a laptop/phone; on a
   second ESP32 it adds WiFi-client overhead for no benefit vs ESP-NOW.

## UART physical details

- Baud 115200 (default), 3.3 V logic.
- USB path: Type-C port labeled USB (board port #9) → CP2102 → UART0.
- Pin path: RX/TX on the 40-pin expansion header (cross TX↔RX, common GND);
  exact positions per board silkscreen / schematic PDF (linked in
  `30-uart-serial.md`).
- If scripting over USB: deassert DTR/RTS (they drive the auto-reset circuit).

## Custom PWM servo (DIY gripper) — the answer

- **Do NOT plug a hobby PWM servo into the arm's servo daisy chain.** That
  chain is an ST3215 **TTL serial bus** running at the ~12 V supply rail:
  wrong protocol, and the voltage will likely kill a 5–6 V hobby servo.
- **The stock JSON command set has no PWM-servo command.** The only spare
  outputs it controls are two switched 12 V H-bridge ports:
  `{"T":113,"pwm_a":..,"pwm_b":..}` / `{"T":114,"led":..}` — power switching,
  not servo signals.
- **The board CAN drive one with a small firmware mod:** GPIO4 (and GPIO5)
  are spare, broken out, and are exactly what Waveshare's own PWM-servo demo
  for this board uses (`Servo.attach(4)`). Add a custom JSON case (e.g.
  `{"T":117,"angle":90}`) to the open-source firmware. Power a non-micro
  servo from a separate 5–6 V BEC (board 5 V rail is only rated for micro
  servos like WP90), sharing GND + signal.
- **Zero-mod alternatives:** actuate the DIY gripper with the arm's existing
  gripper bus servo (ID 15) via `{"T":106,...}`, or drive the hobby servo
  from the second (chess-controller) ESP32's own PWM pin.

## The 10 most important JSON commands

| Purpose | Command |
|---------|---------|
| Emergency stop / clear | `{"T":0}` / `{"T":999}` |
| Init pose (all joints home) | `{"T":100}` |
| Move end effector, smooth (IK, blocking) | `{"T":104,"x":235,"y":0,"z":234,"t":3.14,"spd":0.25}` |
| Move end effector, streamed (IK, non-blocking) | `{"T":1041,"x":235,"y":0,"z":234,"t":3.14}` |
| All joints by angle (deg) | `{"T":122,"b":0,"s":0,"e":90,"h":180,"spd":10,"acc":10}` |
| Gripper open/close (rad; 1.08 open – 3.14 closed) | `{"T":106,"cmd":3.14,"spd":0,"acc":0}` |
| Gripper clamp torque limit | `{"T":107,"tor":200}` |
| Get pose/load/voltage feedback | `{"T":105}` → `{"T":1051,...}` |
| Torque lock off/on (hand-teach) | `{"T":210,"cmd":0}` / `{"T":210,"cmd":1}` |
| LED on the arm | `{"T":114,"led":255}` |

Coordinate frame: X forward, Y left, Z up (mm); `t` = end-effector angle
(rad). Init pose ≈ (235, 0, 234, 3.14). Speed 0 = maximum.
