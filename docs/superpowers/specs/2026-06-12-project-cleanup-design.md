# OpenChess Project Cleanup Design

## Goal

Clean up and synchronize the non-hardware parts of the OpenChess repository so
they accurately describe the current schematic and PCB state without modifying
anything under `hardware/`.

## Source Of Truth

For this cleanup, the active KiCad files are the hardware source of truth:

- `hardware/hardware-board/openchess-board.kicad_sch`
- `hardware/hardware-board/openchess-board.kicad_pcb`
- `hardware/hardware-board-3x3/openchess-board-3x3.kicad_sch`
- `hardware/hardware-board-3x3/openchess-board-3x3.kicad_pcb`
- `hardware/hardware-controller/openchess-controller.kicad_sch`
- `hardware/hardware-controller/openchess-controller.kicad_pcb`

`hardware/DESIGN_NOTES.md` may be stale and should not override the schematic
or PCB files during this cleanup.

## Hardware Facts To Reflect

- Active hardware projects are `hardware-board`, `hardware-board-3x3`, and
  `hardware-controller`.
- The 8x8 matrix PCB is 282 mm by 282 mm.
- The 3x3 validation PCB is 132 mm by 132 mm.
- The controller PCB is 58 mm by 71 mm.
- Matrix sensors are DRV5032FC SOT-23 parts in the PCB files, despite the
  legacy `openchess:A3144` symbol name in the schematic library.
- The 8x8 matrix has 64 DRV5032FC sensors, 81 WS2812B LEDs, 81 per-LED 100 nF
  capacitors, 9 row bulk capacitors, 4 mounting holes, 3 fiducials, and one
  2x13 matrix connector.
- The 3x3 validation board has 9 DRV5032FC sensors, 16 WS2812B LEDs, 16
  per-LED 100 nF capacitors, 4 row bulk capacitors, and one 2x13 matrix
  connector.
- The controller has ESP32-DevKitC, Seeed Lipo Rider Plus, 74AHCT125,
  TBD62783A DIP-18, SS14-or-BAT60A diode, row pullups, button pullups, matrix
  connector `J1`, and panel connector `J3`.
- All active 2x13 matrix/controller `J` connectors are `PinSocket_2x13`
  footprints.
- Panel components are a flying-lead harness with an SSD1306 OLED and three
  buttons. There is no active panel PCB.

## Documentation Updates

Update only non-hardware files. The cleanup should make the following docs
consistent with the current KiCad files:

- `README.md`
- `STATUS.md`
- `WORKSPACE.md`
- `CLAUDE.md`
- `docs/README.md`
- `docs/bom.md`
- `docs/assembly.md`
- `docs/design-decisions.md`
- `docs/inter-board-connector.md`
- `docs/gpio-map.md`
- `docs/kicad-routing-playbook.md`
- `firmware/README.md`
- `firmware/AUDIT.md`
- `firmware/CLAUDE.md`

The edits should remove or clearly mark stale active guidance that mentions:

- A3144 TO-92 sensors as the active hardware choice
- a separate `hardware-control-panel` PCB as active
- a 4x4 prototype as the next validation board
- a 470 uF matrix entry capacitor as present on the current board
- panel status LEDs as active hardware
- old PowerBoost power-module assumptions

Historical notes may keep stale terms if they are clearly inside an archive or
history section.

## Organization Boundaries

This cleanup should not reorganize hardware, firmware, or web source trees.
Instead, it should improve orientation:

- Make root docs explain that `firmware/` and `web/` currently exist.
- Make generated and historical material easy to distinguish from active
  guidance.
- Keep `references/` documented as read-only upstream snapshots.
- Keep `planning/` documented as historical or planning context, not current
  hardware truth.

## Verification

After editing, run text searches outside `hardware/` for stale terms:

- `A3144`
- `hardware-control-panel`
- `4x4`
- `C91`
- `470uF`
- `status LEDs`
- `PowerBoost`

Remaining matches must either be removed, updated, or intentionally historical.
Also run `git diff -- hardware` to confirm no hardware files changed.
