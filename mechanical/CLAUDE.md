# CLAUDE.md - Mechanical Session

Mechanical work is not active yet. Design the enclosure around the current
two-PCB plus panel-harness hardware, not around the old integrated PCB or a
separate panel PCB.

## Active Hardware To Fit

- `hardware/hardware-board`: 282 mm by 282 mm matrix board under the playing
  surface.
- `hardware/hardware-board-3x3`: 132 mm by 132 mm validation board for early
  bench testing.
- `hardware/hardware-controller`: 58 mm by 71 mm controller/power board.
- Panel harness: SSD1306 OLED plus POWER, MODE, SELECT buttons.

## Mechanical Priorities

- Keep the matrix board aligned to the chess surface.
- Provide service access to controller, battery, ESP32 USB, and reset access.
- Make the OLED/button panel easy to mount and service.
- Route the panel harness cleanly.
- Place the LiPo so it is supported, protected, and serviceable.
- Design chess pieces with magnets oriented for DRV5032FC sensing tests.

## Do Not Use

Old references to `hardware/openchess.kicad_pcb`, `BATT_LED`, TP4056 module
placement, older boost modules, a panel PCB, or a single integrated PCB are
historical only.
