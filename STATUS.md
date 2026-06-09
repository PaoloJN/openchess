# Project Status

A snapshot of where the project is right now. **For design details,
the source of truth is `hardware/DESIGN_NOTES.md`.** This file tracks
progress, not decisions.

This is a **one-off personal learning project**, not for sale. Goal:
build one board that works first try. When it works on Paolo's desk,
the project is done.

Last updated: 2026-06-08

## Canonical references

| Document | What lives there |
|---|---|
| `hardware/DESIGN_NOTES.md` | **Source of truth** — full design, connector contracts, BOM, known issues, change log |
| `hardware/hardware-board/SCHEMATIC_GUIDE.md` | Matrix board build sheet (8×8) |
| `hardware/hardware-board-3x3/` | 3×3 test board (cloned from 8×8 with `MATRIX_COLS=MATRIX_ROWS=3`) |
| `hardware/hardware-controller/SCHEMATIC_GUIDE.md` | Controller hand-draw build sheet |
| `docs/gpio-map.md` | ESP32 GPIO assignments |
| `docs/inter-board-connector.md` | Formal cable contracts |
| `CLAUDE.md` | Project intent + durable context |

## Current state

| Subsystem | Schematic | PCB layout | Notes |
|---|---|---|---|
| `hardware-board-3x3` (3×3 test) | Script-generated halls + LEDs + caps; J1/MH/FID/TP manual | **132×132 mm**, layout script run | DRV5032FC SOT-23, fully JLC-assemblable. Built to validate before ordering 8×8. |
| `hardware-board` (8×8 full matrix) | Script-generated halls + LEDs + caps; J1/MH/FID/TP manual | **292×292 mm**, layout script ready | DRV5032FC SOT-23, fully JLC-assemblable. Order AFTER 3×3 validates. |
| `hardware-controller` | Hand-drawn, complete | Hand-routed power; autoroute + GND pour done | DRC clean (only cosmetic silk warnings). PCBA BOM (`assembly/openchess-controller-jlc-*.csv`) ready for JLC. |
| Panel components (no PCB) | N/A — discrete OLED + 3 panel-mount buttons on flying leads | N/A | Plugged into controller `J3` via JST XH 10-pin harness. See DESIGN_NOTES §6. |

## Matrix board dimensions (matches Paolo's folding chess board model)

- **`SQUARE_SIZE = 32 mm`** (matches model's wood squares)
- **`BOARD_MARGIN = 18 mm`** (model has 20 mm inner-frame cavity; 18 mm leaves ~2 mm wiggle per side)
- **3×3 = 132×132 mm** (≤150 mm tier at JLC, ~$10 fab)
- **8×8 = 292×292 mm** (≤300 mm tier at JLC, ~$30 fab)
- The folding board's 10 mm outer fold/decorative edge is NOT part of the PCB

## Next actions

1. **Order the 3×3 test board first** — JLC PCBA on `hardware-board-3x3`,
   ~$15-25, validates the entire design (DRV5032FC sensing, WS2812 chain,
   J_CTRL stack mating with controller) before paying for the 8×8 fab.
2. **Order the controller PCB** alongside the 3×3 (same JLC order, one
   shipping fee). PCBA includes everything except the modules (M1, ESP32-DevKitC).
3. **Source the modules from DigiKey** (minimum verification list):
   - Seeed Lipo Rider Plus (M1)
   - ESP32-DevKitC v4 (U2)
   - 2× 1×19 female sockets for ESP32 mount
   - 5 N35 magnets for sensor testing
   - Total ~$20.
4. **Bench-test the 3×3 + controller**: power-up, OLED hello, WS2812 chain,
   magnet detection on a single Hall, full matrix scan. If clean → order
   the 8×8 fab. If broken → spin a controller v2 without losing the 8×8
   fab cost.
5. **Build the panel harness** (OLED + 3 buttons + USB-C extension cable)
   once the 3×3 validates the controller.

## Schematic script architecture (matrix boards)

Updated 2026-06-08 to be a **merger, not a replacer** — the assembler
preserves anything the user adds in KiCad GUI:

- Active chunk scripts: `02_halls.py`, `03_leds.py`
- Archived (user does these by hand): `01_skeleton.py`, `04_bulks.py` → `scripts/sch/_archived/`
- `99_assemble.py` reads the existing `.kicad_sch`, removes only items
  whose UUID prefix matches a script-owned prefix (`ba11` halls, `1ed0`
  LEDs, `1ed5` LED decoupling), then inserts fresh chunk content.
  Manual additions (J1 connector, MH, FID, TP, row bulks, PWR_FLAGs)
  are preserved untouched.
- PCB layout script (`01_chess_grid.py`) positions halls, LEDs, LED caps,
  row bulks, AND J1 on B.Cu at the center of the bottom edge (with
  anchor offset for body centering).

## Firmware status

Firmware Phase A foundations exist from earlier work, but pin
assignments and LED indexing need to be re-verified against the
current `docs/gpio-map.md` and the matrix board chain order before any
real-board validation.

Firmware-author heads-up items (no UART debug, Hall settling timing,
LED brightness limits, battery-state visual indicator on the Lipo Rider
Plus, etc.) are documented in `hardware/DESIGN_NOTES.md` §12.

## Open questions

- Magnet form factor and orientation for chess pieces (need to test on
  the 4×4 prototype before committing).
- Panelize the matrix + controller PCBs into one JLCPCB order to save
  fab cost?
- Enclosure design — material (3D printed vs laser cut vs CNC),
  cable routing for the matrix ribbon, OLED window, button hole
  positions.

## Recent activity

For the full change log (design-affecting decisions with dates), see
`hardware/DESIGN_NOTES.md` §15.

### 2026-06-08 (matrix boards finalised for fab)

- **Board dimensions locked to Paolo's folding chess board model**:
  SQUARE_SIZE = 32 mm, BOARD_MARGIN = 18 mm. 3×3 = 132×132 mm, 8×8 = 292×292 mm.
- **DRV5032FC SOT-23** confirmed as the Hall sensor across both matrix
  schematics — JLC Basic Part C527532, omnipolar, open-drain, compatible
  with the controller's R1..R8 pull-ups. A3144 (TO-92) fully retired.
- **C91 (470 µF entry cap) dropped.** Row bulks (47 µF × N) cover the rail.
  Matrix boards are now fully JLC-SMT-assemblable — no through-hole parts.
- **3×3 test board** (`hardware-board-3x3/`) created with full schematic +
  PCB pipeline. Identical design to 8×8, just scaled. Purpose: fab the
  3×3 first (~$15) to validate before committing to the 8×8 (~$30+).
- **Script architecture overhaul**: `99_assemble.py` is now a merger —
  preserves user-added components by UUID prefix instead of overwriting
  the whole schematic on every run. `01_skeleton.py` and `04_bulks.py`
  archived; only halls + LEDs regenerated by scripts now.
- **PCB layout script updated**: row bulks placed in the LEFT margin
  Y-aligned with each LED row; J1 (J_CTRL) placed at center bottom edge
  on B.Cu, rotated 90°, with anchor shifted left 15.24 mm so the
  connector BODY (not pin 1) is centered.

### 2026-06-05

The TL;DR of 2026-06-05:

- Switched from monolithic single-PCB to a 2-PCB + flying-leads layout
  (matrix board + controller; panel components in the enclosure).
- Consolidated 40 discrete column-driver parts into one TBD62783A.
- Replaced 3 panel status LEDs with an SSD1306 I²C OLED.
- Replaced the entire discrete power chain (~25 parts: BQ24074 +
  TPS63060 + protection block) with one daughterboard module —
  initially the Adafruit PowerBoost 1000C, later switched to the
  **Seeed Lipo Rider Plus** ($4 on DigiKey, USB-C, 5V/2.4A boost +
  3V3/250mA output) because it's cheaper, USB-C, and lets us drop
  the AP2112K LDO too. Added a Schottky diode (SS14) between +5V_LED
  and DevKit pin 19 so the ESP32 can run on battery.
- Added analog battery state-of-charge monitor: R14/R15 voltage divider
  on M1's raw BAT pad (pin 6) → VBAT_MON → ESP32 GPIO34 ADC. Firmware
  shows battery percentage on the OLED. Cleaned up the leftover
  PowerBoost 1000C lib files from `hardware-controller/lib/`.
- **Locked the assembly layout** based on the user's enclosure mockup:
  controller PCB mounts **inverted** directly underneath the matrix PCB
  (components face the enclosure floor, bare B.Cu face up). J_MAIN
  (controller B.Cu, male) mates back-to-back with J_CTRL (matrix B.Cu,
  female). **No standoffs, no controller-side mounting holes, no ribbon
  cable** — the connector pair is the only mechanical join, and the
  matrix's bolting to the enclosure top frame carries the weight.
  LiPo battery sits alongside the controller PCB in the space between
  the matrix back and the enclosure floor. Side-mounted panel (OLED +
  3 buttons + USB-C panel-mount) on one wall of the enclosure.
- **Dropped the panel PCB entirely** — OLED + 3 panel-mount buttons
  on flying leads to the controller's `J3` (JST XH 10-pin).
- Kept the shrouded/keyed IDC footprint for the matrix cable.
- Rebrandled the project intent: this is a one-off learning project,
  not a product.
