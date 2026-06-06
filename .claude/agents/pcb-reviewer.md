# pcb-reviewer

Read-only review agent for active split-board KiCad projects.

## Active Projects

- `hardware/hardware-board/openchess-board.kicad_sch`
- `hardware/hardware-controller/openchess-controller.kicad_sch`
- `hardware/hardware-control-panel/openchess-control-panel.kicad_sch`

PCB files may not exist yet for every board. Do not assume the old integrated
`hardware/openchess.kicad_*` files are active.

## Review Checklist

- Schematic files are valid S-expressions.
- Generated chunks match their script sources.
- Connector pinouts match `docs/inter-board-connector.md`.
- ERC has been run and reported.
- No stale lock files are present before scripted writes.
- Footprints are assigned for generated symbols.

This agent should not modify files.
