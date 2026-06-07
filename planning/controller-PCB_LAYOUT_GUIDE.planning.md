# Controller PCB Layout — Spec

PCB layout constraints for the OpenChess controller. Companion to `controller-SCHEMATIC_GUIDE.planning.md`.

---

## 1. Board outline

- **Outline**: 2-layer rectangle, ~80 × 90 mm starting size (shrink to fit after placement).
- **Layer stack**: F.Cu (top) + B.Cu (bottom). Standard FR-4, 1.6 mm thick.
- **Edge.Cuts**: clean rectangle, drill origin at one corner.
- **Component side**: F.Cu (all SMD + module pads on top). B.Cu reserved for the GND pour and a few escape traces.

---

## 2. Mounting holes

| Ref | Position | Drill | Required |
|---|---|---|---|
| MH1 | Top-left corner, ~5 mm inset | 3.2 mm M3 | Yes |
| MH2 | Top-right corner, ~5 mm inset | 3.2 mm M3 | Yes |
| MH3 | Bottom-left corner, ~5 mm inset | 3.2 mm M3 | Yes |
| MH4 | Bottom-right corner, ~5 mm inset | 3.2 mm M3 | Yes |

**Critical constraint:** MH1..MH4 must align with the matrix PCB's MH1..MH4 so M3 standoffs (~11 mm tall) thread through both boards. Coordinate exact X/Y positions with the matrix PCB outline.

---

## 3. Component placement zones

Zones are arranged so the natural signal flow is **left → right → bottom**, with the connector edge at the bottom for clean stacking with the matrix.

| Zone | Components | Edge / position |
|---|---|---|
| **Top edge** | `M1` (Lipo Rider Plus), oriented so its USB-C jack and slide switch face the side wall of the enclosure | Top of board |
| **Near M1 (top area)** | `C1`, `C2` (10 µF bulk on `+5V_LED`) within 5 mm of M1 pin 4; `R14`, `R15` within 15 mm of M1 pin 6 | Adjacent to M1 |
| **Left half (center)** | `U2` ESP32-DevKitC socket (drawn as `J3` left + `J4` right sockets, 25.4 mm row pitch). Orient so USB-B faces the enclosure access edge (typically top or bottom). | Left center |
| **Right edge of U2** | `R1..R8` (row pullups), stacked vertically next to the matrix-scan GPIO pins (S0..S7 on the J4-side socket) | Right side of U2 |
| **Above U2 pin 19** | `D2` Schottky; anode toward M1's `+5V_LED` zone, cathode at DevKit pin 19 | Adjacent to U2 right side |
| **Near U2 GPIO34** | `C12` (ADC filter, 100 nF), within 5 mm of DevKit pin 5 (GPIO34) | Right side of U2 |
| **Between U2 and J1 (center-bottom)** | `U6` TBD62783A, rotated so outputs (O1..O8 / `CA_PWR..CH_PWR`) face J1. `C11` (100 nF) within 3 mm of U6 VCC pin. | Center-bottom |
| **Between U2 and J1 (next to U6)** | `U3` 74AHCT125 with `C5` (100 nF) within 3 mm of U3 pin 14. `R11` (33 Ω) immediately at U3 pin 3 output, in series toward J1 pin 7. | Center-bottom |
| **Bottom edge** | `J1` (J_MAIN), 2×13 male pin header, horizontal across the bottom edge; pin 1 marked with silkscreen dot | Bottom edge |
| **Side edge** | `J3` (J_PANEL JST XH 10-pin), polarized notch facing the enclosure panel side | One side edge |
| **Near J_PANEL pins 6, 7** | `R36`, `R37` (button pullups), within 10 mm of J_PANEL pins 6 and 7 *or* alternatively within 5 mm of DevKit GPIO36/39 pins — pick the location with the shorter signal trace | Near J_PANEL or U2 |
| **Anywhere on F.SilkS** | `TP1` (+5V_LED), `TP2` (+3V3), `TP3` (GND); `FID1`, `FID2` non-collinear on F.Cu, ≥5 mm from edge | Free placement |

### 3.1 Orientation rules

- **M1**: USB-C jack and slide switch must face the **enclosure side wall** (so they're accessible without disassembly). The 8-pin header points away from the wall.
- **U6**: rotate so its **output pins (O1..O8) face J1**, not away. This puts `CA_PWR..CH_PWR` on the J1 side of the chip and removes the rats-nest crossing.
- **U3**: input (pin 2 = `LED_DATA`) faces U2 (ESP32); output (pin 3) faces J1 with R11 inline.
- **J1**: pin 1 should be at the end closest to `U6` output O1 (`CA_PWR`) — minimizes the column bus length.

---

## 4. Net classes

| Net class | Members | Track width | Clearance |
|---|---|---|---|
| `Power_5V` | `+5V_LED` | **1.0 mm** | 0.15 mm |
| `Power_3V3` | `+3V3` | **0.5 mm** | 0.15 mm |
| `GND` | `GND` | **1.0 mm** for any trace (mostly a B.Cu pour) | 0.15 mm |
| `Default` | All signals (`S0..S7`, `CA_PWR..CH_PWR`, `LED_DATA`, `LED_DATA_5V`, `COL_DRV_*`, `BTN_*`, `I2C_*`, `VBAT_MON`, `BAT`) | 0.25 mm | 0.15 mm |

JLCPCB minimums (do not violate):
- Minimum track width: 0.15 mm
- Minimum clearance: 0.15 mm
- Minimum annular ring: 0.15 mm
- Minimum hole: 0.3 mm

---

## 5. Routing priority (hand-route in this order)

Hand-route the critical nets first. Auto-route everything else.

### 5.1 Power (route first, on F.Cu, fat traces)

1. **`+5V_LED`** trunk: M1 pin 4 → C1 → C2 → branch to U6 pin 9, U3 pin 14, D2 anode, J1 pins 1/3/5/25. Star from M1 if possible; 1.0 mm width.
2. **`+3V3`** trunk: M1 pin 1 → DevKit 3V3-consuming pin (NOT DevKit pin 1, which is NC) → branch to R1..R8 top pins, R36, R37, J_PANEL pin 1. 0.5 mm width.

### 5.2 High-speed signal integrity

3. **`LED_DATA`**: DevKit GPIO32 → U3 pin 2 (short, direct, no vias if possible).
4. **`LED_DATA_5V`**: U3 pin 3 → R11 → J1 pin 7 (short, no GND-plane breaks under this trace).

### 5.3 Sensitive analog

5. **`BAT` + `VBAT_MON`**: M1 pin 6 → R14 → junction (R15, C12, GPIO34). Keep `VBAT_MON` away from `LED_DATA*` and U6 outputs. Place `C12` next to GPIO34.

### 5.4 D2 path

6. **`+5V_LED` → D2 → DevKit pin 19**: 0.5 mm trace; carries ~150 mA when running on battery.

### 5.5 Column drive bus (8 parallel)

7. **`COL_DRV_A..H`**: 8 parallel traces from DevKit GPIOs to U6 inputs (I1..I8). Route as a horizontal bus.
8. **`CA_PWR..CH_PWR`**: 8 parallel traces from U6 outputs (O1..O8) to J1 column pins. Short and direct since U6 was rotated to face J1.

### 5.6 Row scan + panel

9. **`S0..S7`**: 8 traces from J1 row pins → R1..R8 pin 2 → DevKit GPIOs (R1..R8 each act as a tap point).
10. **`I2C_SDA`, `I2C_SCL`**: DevKit GPIO1/3 → J_PANEL pins 3/4. Route **around** M1 (do not pass under the module).
11. **`BTN_SELECT`, `BTN_POWER`, `BTN_MODE`**: J_PANEL pins 5/6/7 → DevKit GPIOs.

### 5.7 GND pour (last)

12. Fill `GND` zone on **B.Cu** covering the entire board outline. Thermal-relief connections to all GND pads. Verify continuity at every GND pad after fill.

---

## 6. GND pour spec

- **Layer**: B.Cu only (don't pour `GND` on F.Cu — leaves room for top-side signal escape).
- **Net**: `GND`.
- **Pad connection**: Thermal reliefs on all GND-net pads.
- **Outline**: follows the board's Edge.Cuts outline at 0.5 mm clearance.
- **Re-fill** after any move/route change.

If a GND pad shows an unrouted ratsnest line after pouring, place a via from F.Cu to B.Cu near that pad to bridge.

---

## 7. Silkscreen

| Item | Layer | Notes |
|---|---|---|
| Component refs | F.SilkS | Auto-placed, then nudged off pads. Keep readable orientation. |
| Pin 1 dot on J1 | F.SilkS | Required for assembly + matrix-board mating verification |
| Pin 1 indicator on M1 | F.SilkS | Required (matches module silkscreen) |
| Pin 1 indicator on U3, U6 | F.SilkS | Standard IC pin 1 marker |
| `+5V_LED`, `+3V3`, `GND` labels at TP1..TP3 | F.SilkS | Required for probing |
| Project title + rev | F.SilkS | "OpenChess Controller rev 0.1" in a corner |
| Net labels on key traces | F.SilkS (optional) | Useful if Flux is shown a render |

---

## 8. DRC rules

- **0 errors required** before fab.
- **Warnings acceptable** if intentional (e.g. single-pin `PANEL_SPARE*` nets that touch J_PANEL only — won't pass an "unconnected" check but is by design).

Common violations to expect during iteration:
- `Unconnected items` — net has unrouted ratsnest, finish the trace.
- `Clearance violation` — move two features apart.
- `Silkscreen overlapping pad` — reposition the silk text.

---

## 9. Mechanical verification

After placement and routing:

1. **3D view** check: M1 + 1.6 mm PCB ≤ 11 mm headroom (matches standoff height to matrix).
2. M1's USB-C jack faces a board edge (so the panel-mount USB-C extension cable can reach).
3. J1 (J_MAIN) and the matrix's J_CTRL pin-1 positions align when boards stack.
4. All 4 MH align with matrix MH positions.
5. J_PANEL connector points outward toward the panel edge of the enclosure.
6. No components extend past the board outline.

---

## 10. Fab output checklist

| File | Layer / contents |
|---|---|
| F.Cu, B.Cu | Copper |
| F.Mask, B.Mask | Solder mask |
| F.Silks, B.Silks | Silkscreen |
| Edge.Cuts | Board outline |
| `.drl` | Drill file (mm units, drill/place origin) |
| `BOM.csv` | Reference, value, footprint, LCSC part number (if JLC assembly) |
| `CPL.csv` | Component placement, mm, separate front/back |

JLCPCB defaults: FR-4, 2 layers, 1.6 mm thick, HASL or ENIG, green or matte black mask.
