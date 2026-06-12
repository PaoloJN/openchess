# Prototype BOM

Human-readable planning BOM for the current OpenChess prototype. KiCad
schematic, PCB, and assembly exports remain the source of truth for exact refs,
footprints, and machine-readable ordering data.

Last refreshed: 2026-06-12.

## 8x8 Matrix Board (`hardware/hardware-board`)

| Part | Qty | Refs / Notes |
|---|---:|---|
| DRV5032FC Hall sensor, SOT-23 | 64 | `U1..U64`; matrix sensing |
| WS2812B 5050 LED | 81 | `D1..D81`; 9x9 corner LED grid |
| 100 nF capacitor, 0805 | 81 | `C10..C90`; one per WS2812B |
| 47 uF capacitor, 1206 | 9 | `C1..C9`; row bulk caps |
| 2x13 connector | 1 | `J1`; intended active footprint family is `PinSocket_2x13` |
| M3 mounting hole | 4 | board mounting |
| Fiducial | 3 | assembly alignment |

Board outline: 282 mm by 282 mm.

## 3x3 Validation Board (`hardware/hardware-board-3x3`)

| Part | Qty | Refs / Notes |
|---|---:|---|
| DRV5032FC Hall sensor, SOT-23 | 9 | `U1..U9`; validation matrix |
| WS2812B 5050 LED | 16 | `D1..D16`; corner LED grid around 3x3 squares |
| 100 nF capacitor, 0805 | 16 | `C10..C25`; one per WS2812B |
| 47 uF capacitor, 1206 | 4 | `C1..C4`; row bulk caps |
| 2x13 connector | 1 | `J1`; intended active footprint family is `PinSocket_2x13` |

Board outline: 132 mm by 132 mm.

## Controller Board (`hardware/hardware-controller`)

| Part | Qty | Refs / Notes |
|---|---:|---|
| ESP32-DevKitC | 1 | `U2` |
| Seeed Lipo Rider Plus | 1 | `M1`; LiPo charging, 5 V rail, 3.3 V rail |
| 74AHCT125 | 1 | `U3`; WS2812B data level shifter |
| TBD62783A DIP-18 | 1 | `U6`; 8-channel high-side column driver |
| SS14 or BAT60A diode | 1 | `D2`; power path into DevKit pin |
| 10 k resistor, 0805 | 8 | `R1..R8`; row pullups |
| 10 k resistor, 0603 | 2 | `R36`, `R37`; button pullups |
| 33 ohm resistor, 0603 | 1 | `R11`; LED data series resistor |
| 220 k resistor, 0603 | 1 | `R14`; battery divider top |
| 100 k resistor, 0603 | 1 | `R15`; battery divider bottom |
| 10 uF capacitor, 0805 | 2 | `C1`, `C2`; +5V_LED bulk |
| 100 nF capacitor | 3 | `C5`, `C11`, `C12`; IC decoupling and ADC filter |
| 2x13 connector | 1 | `J1`; matrix connector, intended active footprint family is `PinSocket_2x13` |
| 1x10 connector | 1 | `J3`; panel harness connector |
| Fiducial | 3 | assembly alignment |

Board outline: 58 mm by 71 mm.

## Panel Harness

| Part | Qty | Notes |
|---|---:|---|
| SSD1306 0.96 inch 128x64 I2C OLED module | 1 | Wired to controller `J3` |
| Panel-mount momentary pushbutton | 3 | POWER, MODE, SELECT |
| 10-conductor harness | 1 | Controller `J3` to panel components |
| 4.7 k I2C pullups | 0-2 | Add only if the OLED module lacks usable pullups |

## Buying Notes

- Order and validate the 3x3 board and controller before ordering the full 8x8
  matrix.
- Prefer JLC/LCSC assembly for SMD matrix parts where practical.
- Verify OLED module pin order before wiring the panel harness.
- Confirm magnet strength and orientation during 3x3 validation.

## Not Current

Active ordering guidance no longer uses the older through-hole Hall sensor
choice, a separate panel PCB, a large matrix entry capacitor, older boost-module
hardware, or matrix-side indicator LEDs.
