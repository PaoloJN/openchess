# hardware-control-panel scripts

Scripted schematic generator for the OpenChess physical control panel.

Run from `hardware/`:

```bash
for s in hardware-control-panel/scripts/sch/[0-9][0-9]_*.py; do python3 "$s"; done
```

Current chunks:

| Script | Places |
|--------|--------|
| `01_skeleton.py` | Page setup, embedded symbols, functional boxes |
| `02_connector.py` | `J_PANEL` 1x10 cable connector to controller |
| `03_controls.py` | 3 normal status LEDs with resistors, 3 pushbuttons |
| `04_power_flags.py` | Schematic-only ERC flags for `+3V3`, `GND` |
| `05_test_mech.py` | Testpoints, M3 holes, fiducials |

Panel behavior:

- LEDs are wired active-low: controller sinks `LED_*_N` nets.
- Buttons short `BTN_*` nets to GND; pullups live on the controller board.
- `PANEL_SPARE` is reserved for one extra GPIO.
