# Project Status

Snapshot as of **2026-10-24**. Dated specs live in `docs/superpowers/specs/`. For hardware facts, inspect the active KiCad
files directly. Older notes may lag behind the design.

## Project Intent

OpenChess is a one-off personal learning project. The goal is one reliable
physical chess board, not a product line or reusable hardware platform.

## Canonical References

| Reference | Role |
|---|---|
| `hardware/hardware-board/openchess-board.kicad_sch` / `.kicad_pcb` | 8x8 matrix board (v0.1, built) |
| `hardware/hardware-controller/openchess-controller.kicad_sch` / `.kicad_pcb` | Controller v0.1 (built, frozen) |
| `docs/gpio-map.md` | ESP32 GPIO assignments for the built controller |
| `docs/inter-board-connector.md` | Matrix and panel connector contracts |
| `firmware/src/pins.h` | GPIO map the firmware actually uses (v0.1 hardware) |
| `firmware/BENCH.md` | Bench bring-up sequence and sketches |
| `mechanical/exports/README.md` | Print package, screw list, assembly order |
| `app/README.md` | Companion app setup |

## Hardware

| Subsystem | State | Notes |
|---|---|---|
| Matrix board v0.1 | Built, verified | 64x DRV5032FC, 81x WS2812B. 2 assembled plus 3 bare spares from JLCPCB. All sensors and LEDs read and light correctly. One sensor (U5, square A5) wakes slowly and is handled in firmware with a longer per-column settle. |
| Controller v0.1 | Built, verified on USB | ESP32-DevKitC, 74AHCT125, TBD62783A, row and button pullups, battery divider. The Seeed Lipo Rider Plus was swapped out: its IP5306 shuts the 5 V boost down under light load, so the board would not start on battery. Replacement is the Adafruit bq25185 charger plus boost module on the same jumper points. |
| Controller v2 | Shelved | Integrated ESP32-WROOM-32E, USB-C with CH340C, BQ24074 charger, TPS61022 boost. Schematic reached ERC-clean, layout was started, then dropped: the v0.1 controller with the bq25185 module swap does the job. Files stay in `hardware/hardware-controller-v2/` for reference. |
| Panel | Built | 0.91" SSD1306 OLED plus 3 buttons (UP, DOWN, OK) on flying leads. OLED I2C on GPIO1/3, so unplug it to flash. |

## Firmware

Default PlatformIO env `esp32dev` builds the integrated product:

- OLED menu with UP/DOWN/OK buttons, in-game banners and results.
- Offline game controller with settle-detection, capture gating, castling
  and en-passant tracking, draw detection.
- Offline AI: alpha-beta with quiescence, iterative deepening, piece-square
  tables, MVV-LVA ordering, per-level time budgets. Native tests under
  `firmware/test/test_ai/`.
- Coaching light language over the corner LEDs.
- BLE server (NimBLE) matching the app's `board/types.ts` contract.
- Auto-sleep and low-battery deep sleep.

Verified on hardware: sensor scan, LED chain, OLED, buttons, battery monitor,
BLE scan and connect from the phone.

Not yet verified on hardware: the 2026-08-27 LED fixes (I2S DMA driver,
periodic refresh, scan waits for frame end), dip-gated capture detection in a
real game, GUIDE phase banner, LED corner map orientation after the OLED flip.

Bench sketches live in `firmware/src/bench/`, one PlatformIO env each. See
`firmware/BENCH.md`.

## Companion App

Expo SDK 57 app in `app/`. All ten screens built. Real BLE transport
(`BleBoard`) pairs and connects to the board from an iPhone dev build. Wi-Fi
provisioning is an optional, skippable step because nothing online exists yet.

## Mechanical

Fusion 360 case driven through the Fusion MCP. Final print package exported
2026-08-11 under `mechanical/exports/`: case walls with the integrated front
panel, two-color top plate, back cover, corner test piece (v9). Fastening is
M3 heat-set inserts throughout. The 308 mm parts need a large-format printer
or a split. Plexi top is laser-cut from `mechanical/plexi-top/`.

## Robot Arm Side Quest

The board can command a Waveshare RoArm-M2-S over ESP-NOW with no wires. The
arm firmware is vendored in `firmware-roarm/` with a small patch for a DIY
hobby-servo gripper. Bench sketch `bench_roarm`, console in
`scripts/roarm_console.py`. Not integrated into chess play.

## Next Actions

1. Flash the current `esp32dev` build and play through a full game to verify
   the August LED and capture-detection fixes on hardware.
2. Confirm the bq25185 module wiring runs the full board on battery, including
   cold start into the LED bulk capacitance.
3. Print the corner test piece v9, then the full case once fit is confirmed.
4. Decide whether the plexi top or the printed top is the daily driver.
5. Chunk the Wi-Fi scan notification in firmware so it fits iOS BLE limits,
   then revisit online play.

## Constraints

- `docs/archive/` holds history only. Do not treat it as hardware truth.
- Hardware facts in active docs should be checked against the KiCad files.
- The project is optimized for one successful build, not repeat manufacture.
