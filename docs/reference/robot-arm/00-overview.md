# RoArm-M2-S Overview

Source: https://www.waveshare.com/wiki/RoArm-M2-S (fetched 2026-07-28)
Driver board details: https://www.waveshare.com/wiki/General_Driver_for_Robots (fetched 2026-07-28)

## What it is

- **Waveshare RoArm-M2-S**: 4-DOF desktop robotic arm (base, shoulder, elbow,
  gripper/wrist EoAT). Weight < 850 g, payload 0.5 kg @ 0.5 m, 1 m diameter
  workspace, 360° base.
- Joints are driven by **ST3215 serial bus servos** (12-bit magnetic encoders,
  0.088° repeat accuracy). 5 physical servos: base (ID 11), shoulder
  driving/driven pair (ID 12, 13 — dual-drive), elbow (ID 14), gripper (ID 15).
- Controller: **ESP32-WROOM-32** on Waveshare's **"General Driver for Robots"**
  board (65 × 65 mm). Firmware is open source (Arduino):
  https://github.com/waveshareteam/roarm_m2
- Control interfaces: USB serial (Type-C), UART RX/TX pins, WiFi HTTP + web app,
  ESP-NOW. All use the same JSON command set.

## Power

- Working voltage **7–12.6 V** (12 V 5 A supply recommended, or 3S LiPo).
  XH2.54 power connector; power switch on the board.
- The power input rail directly powers the bus servos and motor ports.
- Onboard DC-DC 5 V regulator (can power a Raspberry Pi/Jetson host on the
  40-pin header).

## Power-on behavior

- On power-up all joints move to the center/init position.
- OLED shows: line 1 = WiFi AP mode (hotspot `RoArm-M2`, password `12345678`),
  line 2 = STA mode status/IP, line 3 = **device MAC address** (used for
  ESP-NOW).
- Web app: connect to the `RoArm-M2` WiFi, browse to `http://192.168.4.1`.
  The web UI's buttons are all wrappers around the JSON commands; there is a
  free-form JSON input box with feedback display.

## Driver board interfaces (General Driver for Robots)

| # | Resource | Notes |
|---|----------|-------|
| 1 | ESP32-WROOM-32 | Arduino IDE development |
| 3 | Lidar interface | UART via second CP2102 |
| 4 | IIC peripheral expansion connector | OLED (used by the arm) / I2C sensors |
| 7 | DC-DC 5 V regulator | can power a Pi/Jetson |
| 8 | Type-C (LADAR) | lidar data USB |
| 9 | **Type-C (USB)** | ESP32 serial (CP2102), JSON control + flashing |
| 10 | XH2.54 power connector | DC 7–12.6 V in |
| 11 | INA219 | voltage/current monitor (feedback `v` field, 0.01 V units) |
| 13 | **ST3215 bus servo interface** | TTL serial servo chain (arm joints) |
| 14/15 | PH2.0 6P motor ports A/B | for encoder motors (unused on the arm) |
| 16 | PH2.0 2P motor port A | **LED lamp interface on RoArm-M2-S** (12 V switched, T:114) |
| 17 | PH2.0 2P motor port B | second switched 12 V port (T:113 `pwm_b`) |
| 18/19 | AK09918C + QMI8658 | 9-axis IMU |
| 20 | TB6612FNG | H-bridge driving ports 14–17 |
| 22 | TF card slot | logs / WiFi config |
| 23/24 | 40-pin headers | Raspberry Pi mounting + host serial/I2C access |
| 25/26 | CP2102 ×2 | lidar USB / ESP32 USB serial |
| 27 | Auto-download circuit | flash without pressing BOOT/EN |

The board also exposes spare GPIO for PWM servos/relays ("multi-functional
extended interface"); Waveshare's own PWM-servo demo for this board uses
**GPIO4**. See `40-custom-servo-io.md`.

## Factory reset / reflash

- Factory firmware + flash tool: `RoArm-M2_FACTORY-260701.zip` (linked from the
  wiki), flashed over the USB Type-C port with the ESP32 download tool
  (CP2102 driver may be needed).
- After reflashing, clear NVS with `{"T":604}` over serial if WiFi
  misbehaves.

## Key resources

- Wiki hub: https://www.waveshare.com/wiki/RoArm-M2-S
- Open-source firmware: https://github.com/waveshareteam/roarm_m2
- Driver board schematic PDF:
  https://files.waveshare.com/wiki/RoArm-M2-S/General_Driver_for_Robots.pdf
- Python demos: https://files.waveshare.com/wiki/RoArm-M2-S/RoArm-M2-S_python.zip
- ROS2 packages: https://github.com/waveshareteam/roarm_ws
