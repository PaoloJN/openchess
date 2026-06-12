# OpenChess Docs

Active documentation for the current two-PCB plus panel-harness OpenChess
hardware. For exact schematic and layout truth, inspect the active KiCad files
under `hardware/`.

## Active Docs

| File | Purpose |
|---|---|
| `../STATUS.md` | Current project state and next actions |
| `inter-board-connector.md` | Matrix/controller and panel-harness connector contracts |
| `gpio-map.md` | ESP32 GPIO assignments for the current controller |
| `bom.md` | Human-readable BOM summary from current PCB files |
| `assembly.md` | Bring-up and assembly order |
| `design-decisions.md` | Current architecture rationale |
| `kicad-routing-playbook.md` | Layout/export checks for current boards |
| `../firmware/README.md` | Firmware status and build notes |
| `../web/package.json` | Web UI scripts and dependencies |

## Active Hardware Projects

- `hardware/hardware-board/`: 8x8 matrix PCB, 282 mm by 282 mm.
- `hardware/hardware-board-3x3/`: 3x3 validation PCB, 132 mm by 132 mm.
- `hardware/hardware-controller/`: controller PCB, 58 mm by 71 mm.
- Panel harness: SSD1306 OLED plus 3 buttons wired to controller `J3`.

There is no active panel PCB.

## Archived Docs

`archive/` contains historical notes, old reviews, and previous Superpowers
specs/plans. Keep them for context, but do not treat them as active hardware
guidance unless they are explicitly re-reviewed against the current KiCad files.
