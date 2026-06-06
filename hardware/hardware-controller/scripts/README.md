# hardware-controller scripts

Scripted schematic generator for the OpenChess controller board.

Run from `hardware/`:

```bash
for s in hardware-controller/scripts/sch/[0-9][0-9]_*.py; do python3 "$s"; done
```

Current generated chunks:

| Script | Places |
|--------|--------|
| `01_skeleton.py` | Page setup, embedded symbols, functional boxes |
| `02_j_main.py` | `J_MAIN` connector matching matrix `J_CTRL` |
| `03_row_pullups.py` | `R1..R8` 10k pullups from `S0..S7` to `+3V3` |
| `04_power_flags.py` | Schematic-only ERC flags for `+3V3`, `+5V_LED`, `GND` |
| `05_test_mech.py` | Testpoints, M3 holes, fiducials |

Pending chunks after part decisions:

- power input / charger / boost
- ESP32 module/devkit
- column drivers for `CA_PWR..CH_PWR`
- WS2812 data level shifter to `LED_DATA_5V`
- control-panel cable connector
