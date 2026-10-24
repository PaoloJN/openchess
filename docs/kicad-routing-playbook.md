# KiCad Routing And Export Playbook

Checklist for reviewing or re-exporting the current OpenChess KiCad boards.
Use the KiCad files as source of truth.

## Active Boards

- `hardware/hardware-board/`: 8x8 matrix board, 282 mm by 282 mm.
- `hardware/hardware-controller/`: controller v0.1, 58 mm by 71 mm, frozen.
- `hardware/hardware-controller-v2/`: controller v2, same outline, in design.

There is no active panel PCB.

## Matrix Board Checks

- Confirm DRV5032FC SOT-23 placement and orientation.
- Confirm WS2812B chain order and `LED_DOUT_END`.
- Keep `+5V_LED` wide and low impedance.
- Keep a strong GND return near LED data.
- Keep Hall sense routing away from noisy LED power/data where practical.
- Place row bulk caps near their LED rows.
- Confirm matrix connector footprint is the intended `PinSocket_2x13` family.
- Confirm board outline dimensions before fab export.

## Controller Board Checks

- Keep power path from Lipo Rider Plus compact and easy to probe.
- Keep row sense inputs short and quiet after the matrix connector.
- Keep LED data level shifter close to the controller/matrix path.
- Confirm TBD62783A column-driver output order.
- Confirm `VBAT_MON` divider and ADC filter routing.
- Confirm `J3` panel harness pin order against `docs/inter-board-connector.md`.
- Confirm matrix connector footprint is the intended `PinSocket_2x13` family.

## Net Classes

| Class | Example Nets | Notes |
|---|---|---|
| LED power | `+5V_LED` | widest traces or pours |
| Ground | `GND` | low-impedance return |
| Logic | `+3.3V`, GPIO, `S0..S7` | ordinary signals |
| LED data | `LED_DATA_5V` | route with nearby GND return |
| Column power | `CA_PWR..CH_PWR` | switched sensor-column supply |

## Before Fab Or Re-Export

- Run schematic ERC for the board being exported.
- Run PCB DRC for the board being exported.
- Check connector pinouts against `docs/inter-board-connector.md`.
- Print or view 1:1 board outlines for connector and mounting sanity checks.
- Review generated BOM/CPL files against actual footprints.
