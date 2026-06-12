# Workspace Guide

How to work on OpenChess without mixing current hardware with stale planning
assumptions.

## Active Work Areas

| Area | Path | Purpose |
|---|---|---|
| Hardware | `hardware/` | KiCad schematics, PCB layouts, Gerbers, assembly exports |
| Firmware | `firmware/` | ESP32 PlatformIO firmware and hardware bring-up code |
| Web | `web/` | React/Vite web UI shell and shared protocol types |
| Mechanical | `mechanical/` | Enclosure, panel mounting, battery placement, chess pieces |
| Docs | `docs/` plus root docs | Current status, connector contracts, BOM, assembly notes |
| Planning | `planning/` | Historical/planning context, not current hardware truth |
| References | `references/` | Read-only upstream snapshots |

## Active KiCad Projects

Open these KiCad projects directly:

- `hardware/hardware-board/openchess-board.kicad_pro`
- `hardware/hardware-board-3x3/openchess-board-3x3.kicad_pro`
- `hardware/hardware-controller/openchess-controller.kicad_pro`

For this cleanup pass, hardware files are read-only. Inspect `.kicad_sch` and
`.kicad_pcb` files for current facts, but do not edit anything under
`hardware/`.

## Current Hardware Assumptions

- 8x8 matrix board: 282 mm by 282 mm.
- 3x3 validation board: 132 mm by 132 mm.
- Controller board: 58 mm by 71 mm.
- Matrix sensors: DRV5032FC SOT-23.
- Matrix LEDs: WS2812B corner LEDs.
- Panel: SSD1306 OLED plus 3 buttons on a flying-lead harness to controller
  `J3`.
- Active 2x13 matrix/controller `J` connectors are intended to use
  `PinSocket_2x13` footprints.

## Hardware Workflow Notes

Close KiCad before running any hardware scripts or exports. KiCad lock files
are real; stale locks can remain after crashes, but check with `lsof` before
removing them.

The matrix board schematic has scripted sections. The controller schematic is
hand-maintained. Do not run archived controller schematic scripts unless the
hardware workflow is deliberately being rebuilt.

## Do Not Use As Active Guidance

These are historical or stale unless explicitly re-reviewed:

- `docs/archive/`
- `planning/`
- old references to a separate control-panel PCB
- old references to through-hole Hall sensors
- old references to a 470 uF matrix entry capacitor
- old references to a larger validation board
- old boost-module power architecture notes

When in doubt, inspect the current KiCad schematic and PCB files directly.
