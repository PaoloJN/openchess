# OpenChess Docs

Active documentation for the current hardware. For exact schematic and layout
truth, inspect the KiCad files under `hardware/`.

## Active Docs

| File | Purpose |
|---|---|
| `../STATUS.md` | Current project state and next actions |
| `gpio-map.md` | ESP32 GPIO assignments, v2 table plus frozen v1 table |
| `inter-board-connector.md` | Matrix and panel connector contracts |
| `bom.md` | Human-readable BOM for the v0.1 boards |
| `assembly.md` | Assembly and bring-up order |
| `design-decisions.md` | Architecture rationale |
| `kicad-routing-playbook.md` | Layout and export checks |
| `../firmware/BENCH.md` | Bench bring-up sequence |
| `../mechanical/exports/README.md` | Print package and assembly |

## Specs

`superpowers/specs/` holds the dated design specs for each chunk of work:
enclosure, companion app, BLE transport, swappable top plate, controller v2,
robot arm link, side panel. They are accurate for their date and are the best
record of why decisions were made.

## Reference

`reference/robot-arm/` is a compiled reference for the Waveshare RoArm-M2-S:
JSON commands, ESP-NOW, serial, custom servo IO.

## Archive

`archive/` contains early planning notes, the rev 0.1 design walkthroughs,
and superseded specs. Keep them for context, not for current hardware facts.
