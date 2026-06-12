# Project Status

Current snapshot as of **2026-06-12**. This file tracks progress and next
actions. For hardware details, inspect the active KiCad schematic and PCB files
directly; older design notes may be stale.

## Project Intent

OpenChess is a one-off personal learning project. The goal is one reliable
physical chess board, not a product line or reusable hardware platform.

## Canonical References

| Reference | Role |
|---|---|
| `hardware/hardware-board/openchess-board.kicad_sch` / `.kicad_pcb` | Current 8x8 matrix schematic and PCB |
| `hardware/hardware-board-3x3/openchess-board-3x3.kicad_sch` / `.kicad_pcb` | Current 3x3 validation schematic and PCB |
| `hardware/hardware-controller/openchess-controller.kicad_sch` / `.kicad_pcb` | Current controller schematic and PCB |
| `docs/inter-board-connector.md` | Human-readable connector contracts |
| `docs/gpio-map.md` | ESP32 GPIO assignment plan |
| `docs/bom.md` | Human-readable planning BOM |
| `firmware/README.md` | Firmware status and build notes |
| `web/package.json` | Web UI package and scripts |

## Current Hardware State

| Subsystem | Schematic | PCB layout | Notes |
|---|---|---|---|
| `hardware-board-3x3` | Present | 132 mm by 132 mm | Validation board: 9x DRV5032FC SOT-23, 16x WS2812B, 16x 100 nF, 4x 47 uF, 2x13 matrix connector. Order and bring up first. |
| `hardware-board` | Present | 282 mm by 282 mm | Full matrix: 64x DRV5032FC SOT-23, 81x WS2812B, 81x 100 nF, 9x 47 uF, 4x M3 holes, 3x fiducials, 2x13 matrix connector. Order after 3x3 validation. |
| `hardware-controller` | Present | 58 mm by 71 mm | ESP32-DevKitC, Lipo Rider Plus, 74AHCT125, TBD62783A DIP-18, SS14/BAT60A diode, row/button pullups, battery divider, J1 matrix connector, J3 panel connector. |
| Panel harness | N/A | N/A | SSD1306 OLED plus POWER, MODE, SELECT buttons on flying leads to controller `J3`. No active panel PCB. |

All active 2x13 matrix/controller `J` connectors are intended to use
`PinSocket_2x13` footprints.

## Firmware And Web State

`firmware/` is populated with a PlatformIO ESP32 codebase and adapted OpenChess
engine code. `web/` is populated with a React/Vite UI shell and shared WebSocket
protocol definitions.

Both are active but still need real-hardware validation against the current
3x3/controller bring-up path:

- GPIO map and boot-pin behavior
- 9x9 LED corner indexing and brightness limits
- Hall scan timing with DRV5032FC sensors
- OLED I2C behavior on GPIO1/GPIO3
- POWER/MODE/SELECT button handling
- battery voltage reading via `VBAT_MON`
- web UI connection and board-state protocol

## Next Actions

1. Re-export or inspect the current 3x3 validation board and controller
   fabrication/assembly files.
2. Order the 3x3 validation board and controller together.
3. Source plug-in modules and harness parts:
   - ESP32-DevKitC
   - Seeed Lipo Rider Plus
   - protected 1S LiPo
   - SSD1306 OLED module
   - 3x panel-mount momentary buttons
   - magnets for sensing tests
4. Build the panel harness from controller `J3` to OLED/buttons.
5. Bench-test controller power rails, OLED/buttons, LED data level shifting,
   and battery monitor before connecting the matrix board.
6. Bring up the 3x3 validation board: first power, LED chain, single Hall,
   then full scan.
7. If the 3x3/controller validation is clean, order the full 8x8 matrix board.
8. Continue firmware/web integration against measured hardware behavior.
9. Start enclosure work around the validated PCB stack, panel harness, USB-C
   access, and battery placement.

## Current Constraints

- During this cleanup pass, `hardware/` is read-only.
- `planning/` and `docs/archive/` are history unless explicitly re-reviewed.
- Hardware facts in active docs should be checked against the KiCad files, not
  copied forward from stale design notes.
- The project is optimized for one successful build, not repeat manufacture.
