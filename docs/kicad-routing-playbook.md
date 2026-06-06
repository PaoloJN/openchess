# KiCad Routing Playbook

Current status: schematic-first. PCB layout rules here are draft guidance for
when the split boards move from schematic to PCB.

## Board Priorities

### Matrix Board

- Keep `+5V_LED` wide and low impedance.
- Use a strong GND return near LED data.
- Keep Hall sense routing away from noisy LED power/data where practical.
- Place row bulk caps near their LED rows.
- Put `J_CTRL` where cable/stacking geometry works mechanically.
- Add visible pin-1 and orientation marks for A3144 sensors and connector.

### Controller Board

- Keep power entry, protection, regulation, and bulk caps compact.
- Keep row sense inputs short and quiet after `J_MAIN`.
- Keep LED data level shifter close to the controller/matrix connector path.
- Put testpoints on rails, scan signals, LED data, and panel connector nets.

### Control Panel

- Optimize for enclosure mounting and cable strain relief.
- Put buttons/LEDs on a human-friendly grid before optimizing traces.
- Mark connector pin 1 clearly.

## Net Classes To Define Later

| Class | Example Nets | Notes |
|---|---|---|
| LED power | `+5V_LED` | widest traces / pours |
| Ground | `GND` | low impedance return |
| Logic | `+3V3`, GPIO, `S0..S7` | ordinary signals |
| LED data | `LED_DATA_5V` | route with nearby GND return |
| Column power | `CA_PWR..CH_PWR` | switched sensor-column supply |

## Before Fab

- Run schematic ERC for every board.
- Run PCB DRC for every board.
- Check connector pinouts against `docs/inter-board-connector.md`.
- Print 1:1 paper layouts for connector, button, mounting-hole, and sensor
  position sanity checks.
