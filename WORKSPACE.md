# Workspace Guide

How to work on OpenChess without mixing old and new hardware assumptions.

## Active Sessions

| Session | cwd | Purpose |
|---|---|---|
| Hardware | `hardware/` | KiCad projects, schematic scripts, PCB layout planning |
| Planning | repo root | Design decisions, docs, task planning |
| Firmware | `firmware/` | ESP32 firmware and web UI |
| Mechanical | `mechanical/` | Case, panel mounting, pieces |

## Hardware Projects

Open these KiCad projects directly:

- `hardware/hardware-board/openchess-board.kicad_pro`
- `hardware/hardware-controller/openchess-controller.kicad_pro`
- `hardware/hardware-control-panel/openchess-control-panel.kicad_pro`

Close KiCad before running schematic scripts. KiCad lock files are real; stale
locks may remain after crashes, but check with `lsof` before removing them.

## Scripted Schematic Workflow

From `hardware/`:

```bash
for s in hardware-board/scripts/sch/[0-9][0-9]_*.py; do python3 "$s"; done
for s in hardware-controller/scripts/sch/[0-9][0-9]_*.py; do python3 "$s"; done
for s in hardware-control-panel/scripts/sch/[0-9][0-9]_*.py; do python3 "$s"; done
```

Run ERC after generation:

```bash
/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli sch erc --severity-all hardware-board/openchess-board.kicad_sch
/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli sch erc --severity-all hardware-controller/openchess-controller.kicad_sch
/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli sch erc --severity-all hardware-control-panel/openchess-control-panel.kicad_sch
```

## Current Hardware Priorities

1. Keep pinout contracts in `docs/inter-board-connector.md` and `hardware/DESIGN_NOTES.md` aligned with script `config.py` files.
2. Finish controller schematic chunks before PCB layout.
3. Build a 4x4 matrix prototype before ordering a full 8x8 matrix board.
4. Treat archived rev0.1 docs as historical only.

## KiCad Shortcuts

### Schematic

| Key | Action |
|---|---|
| `A` | Add symbol |
| `P` | Add power port |
| `L` | Add label |
| `W` | Draw wire |
| `Q` | Add no-connect flag |
| `M` | Move |
| `G` | Drag while preserving connections |
| `R` | Rotate |
| `E` | Edit properties |
| `Cmd+F` | Find reference |

### PCB

| Key | Action |
|---|---|
| `M` | Move |
| `G` | Drag |
| `R` | Rotate |
| `F` | Flip side |
| `X` | Route track |
| `B` | Refill zones |
| `Home` | Zoom to fit |

## Do Not Use As Active Guidance

These are historical or stale unless explicitly re-reviewed:

- `docs/archive/rev0.1/`
- old integrated-board files in `delete/old-hardware-2026-06-04/`
- old references to `hardware/openchess.kicad_sch` or `led_chain.kicad_sch`
