# hardware-board scripts

Scripted generators for the OpenChess **matrix board**.

This folder is also the template style for the later controller and control-panel
boards: keep board decisions in a small `config.py`, keep grid coordinates in
`geometry.py`, and put repeated KiCad S-expression mechanics in `parts.py`.

## Schematic generation

Run the schematic chunks in order:

```bash
for s in scripts/sch/[0-9][0-9]_*.py; do python3 "$s"; done
```

Each script writes one chunk to `build/sch/` and reassembles
`openchess-board.kicad_sch`.

| Script | Places |
|--------|--------|
| `01_skeleton.py` | Page setup, embedded symbols, functional boxes |
| `02_halls.py` | 64x A3144 Hall sensors, `U1..U64` |
| `03_leds.py` | 81x WS2812B LEDs, `D1..D81`, plus `C10..C90` decoupling |
| `04_bulks.py` | 9x row bulk caps, `C1..C9` |
| `05_j_ctrl.py` | Matrix/controller connector, `J1` |
| `06_led_decoup.py` | LED rail entry capacitor, `C91` |
| `07_test_mech.py` | Test pads, mounting holes, fiducials |
| `99_assemble.py` | Assembles existing chunks into the final schematic |

Matrix-board scope:

- Hall sensors
- Chess-square/corner LEDs
- LED decoupling and row bulk capacitance
- Matrix connector
- Test pads, mounting holes, fiducials

Not on this board:

- ESP32/controller logic
- Battery, charger, boost, switches, or controller-rail PWR_FLAGs
- Row pullups
- Status LEDs or user buttons

Those belong on the controller board or cable-mounted control-panel board.

## Shared modules

- `sch/config.py` is the electrical contract: nets, footprints, values, and
  `JCTRL_PIN_NETS`.
- `sch/geometry.py` is placement math only.
- `sch/parts.py` has reusable helpers for repeated schematic parts.
- `sch/_lib.py` is the low-level KiCad S-expression writer.

For a 4x4 prototype, make a variant by changing the matrix constants and
geometry in a copy of this structure. Do not edit generated `.sexp` chunks by
hand; change the scripts and regenerate.

## Conventions

- Close KiCad before running scripts.
- Reference designators are firmware/mechanical contracts.
- Nets connect by labels, not long schematic wires.
- Keep `+5V_LED` separate from controller logic rails.
- Matrix ERC uses schematic-only PWR_FLAGs on external `+5V_LED` and GND.
- Keep connector pinout changes in `config.JCTRL_PIN_NETS` first, then update
  controller-board scripts to match.
