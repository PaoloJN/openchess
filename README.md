# OpenChess

A one-off physical chess board with magnetic piece detection, corner-LED move
feedback, ESP32 firmware, local OLED controls, and a small web UI.

This is a personal learning project, not a product. The target is one board
that works on Paolo's desk. Design choices favor first-build reliability and
clear bring-up over cost optimization or manufacturing scale.

Last meaningful docs refresh: **2026-06-12**.

## Current Source Of Truth

For hardware details, inspect the active KiCad schematic and PCB files directly.
`hardware/DESIGN_NOTES.md` and older planning notes may lag behind the design.

Active hardware files:

- `hardware/hardware-board/openchess-board.kicad_sch`
- `hardware/hardware-board/openchess-board.kicad_pcb`
- `hardware/hardware-board-3x3/openchess-board-3x3.kicad_sch`
- `hardware/hardware-board-3x3/openchess-board-3x3.kicad_pcb`
- `hardware/hardware-controller/openchess-controller.kicad_sch`
- `hardware/hardware-controller/openchess-controller.kicad_pcb`

Current progress and next actions live in [`STATUS.md`](STATUS.md).

## What It Does

| Capability | Current implementation direction |
|---|---|
| Piece detection | DRV5032FC SOT-23 Hall sensors in a scanned matrix |
| Move feedback | WS2812B RGB LEDs at square corners |
| Controller | ESP32-DevKitC on the controller PCB |
| Local UI | SSD1306 OLED plus POWER, MODE, and SELECT panel buttons |
| Web UI | React/Vite shell in `web/`, embedded into firmware data for ESP32 hosting |
| Online/offline play | Firmware foundation adapted from joojoooo/OpenChess, still requiring real-hardware validation |
| Power | Seeed Lipo Rider Plus module for LiPo charging, 5 V LED rail, and 3.3 V logic rail |

## Hardware Architecture

The active build is two PCBs plus one cable-mounted panel harness:

- `hardware/hardware-board/`: full 8x8 matrix board, 282 mm by 282 mm
- `hardware/hardware-board-3x3/`: 3x3 validation board, 132 mm by 132 mm
- `hardware/hardware-controller/`: controller board, 58 mm by 71 mm
- Panel harness: SSD1306 OLED module and 3 panel-mount buttons wired to controller `J3`

The 3x3 board is the first validation target. It exists to test the Hall
sensors, WS2812B chain, controller connector contract, power path, and firmware
bring-up before ordering the full 8x8 matrix.

All active 2x13 matrix/controller `J` connectors are intended to use
`PinSocket_2x13` footprints.

## Current Board Summary

| Board | Current contents |
|---|---|
| 8x8 matrix | 64x DRV5032FC SOT-23 Hall sensors, 81x WS2812B LEDs, 81x 100 nF LED caps, 9x 47 uF row bulk caps, 4x M3 holes, 3x fiducials, 2x13 matrix connector |
| 3x3 validation | 9x DRV5032FC SOT-23 Hall sensors, 16x WS2812B LEDs, 16x 100 nF LED caps, 4x 47 uF row bulk caps, 2x13 matrix connector |
| Controller | ESP32-DevKitC, Seeed Lipo Rider Plus, 74AHCT125 LED level shifter, TBD62783A column driver, SS14/BAT60A diode, row pullups, button pullups, battery divider, matrix connector `J1`, panel connector `J3` |
| Panel harness | SSD1306 OLED, POWER button, MODE button, SELECT button, wiring harness to controller `J3` |

## Firmware And Web

`firmware/` is populated with a PlatformIO ESP32 firmware shell and adapted
OpenChess engine code. `web/` contains a React/Vite interface and shared
WebSocket protocol types.

Firmware and web are active but not yet proven against the physical boards. Pin
assignments, LED indexing, Hall scan timing, OLED behavior, button semantics,
and power/battery reporting must be checked during 3x3/controller bring-up.

## Repository Layout

```text
openchess/
├── README.md                  Project entry point
├── STATUS.md                  Current status and next actions
├── CLAUDE.md                  Durable agent context
├── WORKSPACE.md               Workspace conventions
├── hardware/                  KiCad projects and hardware exports
│   ├── hardware-board/        8x8 matrix PCB
│   ├── hardware-board-3x3/    3x3 validation PCB
│   └── hardware-controller/   ESP32 controller PCB
├── firmware/                  PlatformIO ESP32 firmware
├── web/                       React/Vite web UI shell
├── mechanical/                Enclosure and piece planning
├── docs/                      Active documentation and archive
├── planning/                  Historical/planning context, not hardware truth
├── scripts/                   General utility scripts
└── references/                Read-only upstream project snapshots
```

## Where To Look

| Need | Read |
|---|---|
| Current phase and bring-up order | [`STATUS.md`](STATUS.md) |
| Active documentation index | [`docs/README.md`](docs/README.md) |
| Matrix/controller connector contract | [`docs/inter-board-connector.md`](docs/inter-board-connector.md) |
| ESP32 GPIO assignments | [`docs/gpio-map.md`](docs/gpio-map.md) |
| Human-readable BOM | [`docs/bom.md`](docs/bom.md) |
| Assembly and bring-up order | [`docs/assembly.md`](docs/assembly.md) |
| Hardware design rationale | [`docs/design-decisions.md`](docs/design-decisions.md) |
| Firmware notes | [`firmware/README.md`](firmware/README.md) |
| Web UI package | [`web/package.json`](web/package.json) |

Archived docs and old planning files are useful history, but the active KiCad
files are the authority for current schematic and PCB state.
