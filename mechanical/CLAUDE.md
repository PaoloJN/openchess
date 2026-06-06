# CLAUDE.md — mechanical session

Mechanical work is not active yet. Design the enclosure around the split-board
hardware, not around the old integrated PCB.

## Active Boards To Fit

- `hardware/hardware-board`: chess matrix board under the playing surface
- `hardware/hardware-controller`: controller/power board, likely side or lower compartment
- `hardware/hardware-control-panel`: side-mounted buttons/status LEDs

## Mechanical Priorities

- Keep the matrix board aligned to the chess surface.
- Provide cable paths between matrix, controller, and control panel.
- Make the control panel easy to mount and service.
- Keep USB/power access dependent on the final controller power design.
- Design chess pieces with magnets oriented for A3144 detection.

## Do Not Use

Old references to `hardware/openchess.kicad_pcb`, `BATT_LED`, TP4056 module
placement, or a single integrated PCB are historical only.
