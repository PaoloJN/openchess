# Project Status

Quick "where are we" snapshot. Update this when major milestones complete.

Last updated: 2026-06-03

## Phase progress

| Phase | Status | Notes |
|---|---|---|
| Schematic (root + LED_Chain sub-sheet) | ✅ DONE | ERC clean except for footprint library warning |
| Footprint assignment | ✅ DONE | All ~200 components have valid footprints |
| Grid placement (sensors + LEDs + board outline) | ✅ DONE | Via `hardware/scripts/grid_placement.py`, idempotent |
| Silkscreen decorations (labels, grid, title, mounting markers) | ✅ DONE | All toggleable in `grid_placement.py` config section |
| Repo restructure (CERN-OHL-S licensing, fab/lib/datasheets dirs, references/, .backups/) | ✅ DONE | See README.md for new layout |
| Claude Code project config (`.claude/` commands + agents + WORKSPACE.md) | ✅ DONE | Slash commands: /backup /restore /run-script /sync-gpio /status |
| Back-side component placement | 🟡 IN PROGRESS | Manual layout in KiCad. The old `02_back_side_placement.py` lives in `hardware/scripts/experimental/` — output was too cramped |
| Mounting holes (actual drilled holes, not just silk markers) | ⬜ TODO | Markers added on silk; convert to KiCad MountingHole footprints |
| Trace routing | ⬜ TODO | Plan: Freerouting plugin for most + manual cleanup |
| Power planes (+5V on F.Cu, GND on B.Cu) | ⬜ TODO | Add LAST, after routing is complete, so pours flow around traces |
| DRC pass | ⬜ TODO | After routing |
| `pcb-reviewer` agent pass | ⬜ TODO | Before Gerber export |
| Gerber export | ⬜ TODO | Via `hardware/scripts/export_gerbers.py` → outputs to `hardware/fab/` |
| PCB fab order (JLCPCB or PCBWay) | ⬜ TODO | With PCBA service for WS2812 + SMD parts |
| Firmware fork from joojoooo | ⬜ TODO | Clone into `firmware/`, adapt LED layout for 9×9 corners |
| Wooden enclosure CAD (`mechanical/case/`) | ⬜ TODO | Phase 3 |
| 3D-printed chess pieces with magnets (`mechanical/pieces/`) | ⬜ TODO | Phase 3 |
| Assembly + first power-on | ⬜ TODO | After PCB arrives |

## Latest snapshot

- KiCad shows clean 8×8 hall sensor grid + 9×9 LED grid + 280×280mm outline + full silkscreen decorations (chess grid, A1-H8 labels, file/rank labels, title block, WHITE/BLACK markers, mounting hole markers)
- Support components (ESP32, 74HC595, transistors, etc.) still in their default placement near the bottom-left of the board — need manual back-side placement next
- Project restructured into proper hardware-project layout (`hardware/fab/`, `hardware/lib/`, `hardware/datasheets/`, `references/`, `.backups/`, `mechanical/`)
- Master backup of everything: `.backups/master/*.20260603_074909` (or use `/backup` to make a fresh one)
- Claude Code project config in place: `.claude/commands/` + `.claude/agents/pcb-reviewer.md` + `WORKSPACE.md` at root

## Active sessions to keep open

Per `WORKSPACE.md`:
- **PCB** — KiCad work, scripts (the main session right now)
- **Planning** — chatty, doc updates, "should I X or Y" questions

## Open questions to resolve before fabbing

1. **2-layer vs 4-layer PCB?** 2-layer is cheaper (~$30 vs $80 for ~280mm board). 4-layer makes routing easier (dedicated power + GND inner layers). **Pending decision** — likely 2-layer for v1 to keep cost low.
2. **Hand-solder vs PCBA service?** All resistors/caps are `HandSolder` footprints (slightly larger pads, both work). The 81 WS2812 LEDs are SMD — would benefit greatly from PCBA. Hall sensors are TO-92 through-hole, definitely hand-solder. **Likely:** PCBA for the LEDs + 74HC595 + transistors, hand-solder the rest.
3. **Which edge gets the USB-C / power switch / BATT_LED?** Affects back-side component layout. **Default plan:** bottom edge (closer to user when sitting).
4. **Mounting hole positions** — current silk markers are at 6mm inset from each corner. Verify against the wooden enclosure design (which doesn't exist yet — so the silk markers ARE the constraint right now; the enclosure will design around them).
5. **Battery placement & connector** — JST-PH 2-pin from the TP4056 module to J1. Where does the battery physically sit? Recessed in the wood under the board? In a separate compartment? TBD.

## Next concrete step

Manually place the 28 support components on the back side (B.Cu) in KiCad. Use `WORKSPACE.md`'s shortcut list (M for move, F for flip, R for rotate) and the proximity rules from the planning discussion (decoupling caps near their chips, etc.).
