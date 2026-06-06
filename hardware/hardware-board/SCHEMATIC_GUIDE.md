# Matrix Board Schematic — Hand-Drawing Guide / Reference

This is the build sheet for the OpenChess matrix board. It documents
every component, every pin, and every net so you can either:

1. **Use it as reference** for the existing scripted schematic (which is
   already ERC-clean), or
2. **Use it as a build sheet** to hand-redraw the schematic in the
   KiCad GUI.

## ⚠️ Honest warning about going hand-drawn on this board

The matrix board has **236 electrical components**:

- 64 A3144 Hall sensors
- 81 WS2812B LEDs
- 81 100 nF LED decoupling caps
- 9 47 µF row bulk caps
- 1 470 µF entry cap
- 1 J_CTRL 2x13 connector
- Plus test points, mounting holes, fiducials

The 81 LEDs are wired in a **single daisy-chained data line** (DIN of
LED N+1 connects to DOUT of LED N) — drawing 80 of those wires by hand
is tedious and error-prone. The scripted version snaps every pin to
grid and gets ERC-clean automatically; hand-drawn versions almost
always pick up at least one stray wire that ERC then complains about.

**Recommendation: keep the scripts running this board.** They work,
they're already ERC-clean, and the matrix board is exactly the kind of
repetitive component-on-a-grid layout where scripts shine. If you want
to update placement, edit `scripts/sch/geometry.py` and re-run the
chunks — it's faster than redrawing 236 components.

If you've made the decision anyway and want to hand-draw it: this guide
gives you the full build sheet. Allocate a few hours and brew coffee.

---

## 0. Setup

### Backup before doing anything destructive

```bash
cd /Users/paolonessim/Projects/openchess/hardware/hardware-board
cp openchess-board.kicad_sch openchess-board.kicad_sch.scripted_backup
```

### Two paths

**Path A — Keep scripts as-is (recommended).** Use this guide as a
read-only reference. Nothing to change.

**Path B — Switch to hand-drawn.** Open the schematic, Edit → Select All
→ Delete (keeps page + title block + lib_symbols). Then archive the
scripts so nothing wipes your work:

```bash
mv scripts/sch scripts/sch.archived
mkdir -p scripts/sch
echo "Scripts archived 2026-06-05 — matrix board maintained by hand in KiCad GUI." > scripts/sch/README.md
```

---

## 1. Conventions used in this guide

### Power vs net labels

- **Power port** (`P`) → `GND` only. The 5 V rail is named `+5V_LED`
  (a custom name), so use a **net label** for it everywhere.
- **Net label** (`L`) → `+5V_LED`, `LED_DATA_5V`, `LED_DOUT_END`,
  `S0..S7`, `CA_PWR..CH_PWR`, and the per-LED DIN/DOUT mid-nets if you
  choose to name them.
- **No-Connection flag** (`Q`) → none needed on this board.

### KiCad shortcuts

| Key | Action |
|---|---|
| `A` | Add symbol |
| `W` | Wire |
| `L` | Net label |
| `P` | Power port |
| `R` | Rotate |
| `M` | Move |
| `G` | Drag with wires |
| `E` | Edit properties |
| `Ctrl+D` | Duplicate (great for placing 64 of something) |

### Reference designators

| Range | Section |
|---|---|
| U1..U64 | A3144 Hall sensors, **file-major**: U1=A1, U2=A2, …, U8=A8, U9=B1, …, U64=H8 |
| D1..D81 | WS2812B LEDs, **row-major top-down**: D1=top-left corner, D9=top-right, D10=row-2-left, …, D81=bottom-right |
| C1..C9 | Row bulk caps (47 µF), one per row of the LED grid |
| C10..C90 | Per-LED 100 nF decoupling caps (one per WS2812). Number-matched with LED: D1↔C10, D2↔C11, …, D81↔C90 |
| C91 | 470 µF entry cap on `+5V_LED` |
| J1 | J_CTRL 2x13 connector to the controller |
| TP1..TP4 | Test points (one per rail/data net) |
| MH1..MH4 | M3 mounting holes |
| FID1..FID3 | Fiducials |

### Custom symbol

| lib_id | What | Where it lives |
|---|---|---|
| `openchess:A3144` | A3144 Hall sensor (TO-92, 3-pin) | `hardware-board/lib/openchess.kicad_sym` |

The other symbols are stock KiCad: `LED:WS2812B`, `Device:C`,
`Device:C_Polarized`, `Connector_Generic:Conn_02x13_Odd_Even`,
`Connector:TestPoint`, `Mechanical:MountingHole`, `Mechanical:Fiducial`,
`power:PWR_FLAG`.

### Board nets summary (every net used)

**Power & data:**
- `+5V_LED` — 5 V supplied by controller through J_CTRL
- `GND` — ground
- `LED_DATA_5V` — WS2812 chain input (from controller, level-shifted)
- `LED_DOUT_END` — last WS2812 DOUT, exposed only as a test point

**Matrix interface (to J_CTRL):**
- `S0..S7` — row sense nets, one per chess rank
- `CA_PWR..CH_PWR` — column power rails, one per chess file

If your schematic has any other label, it's a typo.

### Page layout

The chunk-01 skeleton gives you four boxes:

```
A2 page, top-left origin (rough coordinates from the script)

   ┌─────────────────────────────────────────────────┐
   │   Box: 8x8 HALL GRID                            │
   │     U1..U64, A3144 sensors                      │
   │     file-major (U1=A1, U64=H8)                  │
   └─────────────────────────────────────────────────┘
   ┌─────────────────────────────────────────────────┐
   │   Box: 9x9 LED GRID                             │
   │     D1..D81 WS2812B + C10..C90 100 nF caps      │
   │     daisy-chained DIN/DOUT                      │
   └─────────────────────────────────────────────────┘
   ┌──────────────────┐ ┌─────────────────────────────┐
   │  Box: BULK CAPS  │ │  Box: J_CTRL + TEST + MECH  │
   │  C1..C9 (47µF)   │ │  J1 + C91 + TP1..TP4 + MH   │
   │  one per row     │ │                             │
   └──────────────────┘ └─────────────────────────────┘
```

Exact box coordinates are in `scripts/sch/01_skeleton.py` — if you
re-run only that script (Path B above), you'll get the boxes back as
visual guides.

---

## Section A — 8×8 Hall Sensor Grid (64 sensors)

The chess board has 8 files (A–H, left to right) and 8 ranks (1–8, bottom
to top in chess convention but you can flip on the PCB). Each square
gets one A3144 Hall sensor.

### A.1 Component template (1 of 64)

| Field | Value |
|---|---|
| Symbol | `openchess:A3144` |
| Value | A3144 |
| Footprint | `Package_TO_SOT_THT:TO-92_Inline` |

Pin map:
- Pin 1 = VCC
- Pin 2 = GND
- Pin 3 = OUT (open-collector)

### A.2 Refdes scheme

```
ref(file, rank) = U(1 + file_idx * 8 + rank_idx)
                  where file_idx = 0..7 for files A..H
                        rank_idx = 0..7 for ranks 1..8

U1  = A1   U9  = B1   U17 = C1   ...   U57 = H1
U2  = A2   U10 = B2                    U58 = H2
...                                    ...
U8  = A8   U16 = B8                    U64 = H8
```

### A.3 Wiring per sensor

For Hall sensor at file F (A..H) and rank R (1..8):

| Pin | Net |
|---|---|
| 1 (VCC) | Net label `C{F}_PWR` — e.g. `CA_PWR` for file A, `CH_PWR` for file H |
| 2 (GND) | `GND` power port |
| 3 (OUT) | Net label `S{R-1}` — e.g. `S0` for rank 1, `S7` for rank 8 |

So all 8 sensors in **file A** share `CA_PWR` on their VCC pins, and all
8 sensors in **rank 1** share `S0` on their OUT pins. The matrix is
formed entirely by net labels — no wiring between sensors is needed
beyond the per-pin stubs to labels.

### A.4 Practical placement workflow

1. Place **one** A3144 at the A1 position (bottom-left of the grid)
   with the three net labels on its pins (`CA_PWR`, `GND`, `S0`).
2. `Ctrl+D` to duplicate it 7 times vertically (file A, ranks 1..8) and
   update the OUT label to `S0..S7` accordingly. Update refs to U1..U8.
3. Select the column, copy, paste 7 times to the right (one paste per
   file B..H). Update VCC labels to `CB_PWR..CH_PWR` per file. Update
   refs.

Total: 64 sensors × 3 labels each = 192 label updates. Real talk: this
is the moment to reconsider keeping the script.

---

## Section B — 9×9 WS2812B LED Grid (81 LEDs)

LEDs sit at the **corners** of the chess squares, so the grid is 9×9 (one
more than 8×8). The chain enters at the top-left, snakes through, and
exits at the bottom-right.

### B.1 Component template (1 of 81)

| Field | Value |
|---|---|
| Symbol | `LED:WS2812B` |
| Value | WS2812B |
| Footprint | `LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm` |

Pin map:
- Pin 1 = VDD
- Pin 2 = DOUT
- Pin 3 = VSS (GND)
- Pin 4 = DIN

### B.2 Refdes + chain order

Row-major top-down: D1 is the top-left, D9 is the top-right of row 1,
D10 is the leftmost of row 2, etc., D81 is the bottom-right.

```
D1  D2  D3  D4  D5  D6  D7  D8  D9
D10 D11 D12 D13 D14 D15 D16 D17 D18
...
D73 D74 D75 D76 D77 D78 D79 D80 D81
```

Chain direction depends on the script's chosen serpentine pattern. The
simplest hand-drawable choice: **left-to-right then snake back**:

```
D1 → D2 → D3 → ... → D9
                     ↓
D18 ← D17 ← D16 ← ... ← D10
↓
D19 → D20 → ... → D27
                     ↓
...
```

You can match the existing script's order by reading
`scripts/sch/03_leds.py` — but for the schematic to be electrically
correct, **the chain order only matters for firmware indexing, not for
the schematic itself.** As long as you connect DIN of each LED to DOUT
of one specific other LED, the chain is valid.

### B.3 Wiring per LED

For LED `Dk` (1 ≤ k ≤ 81):

| Pin | Net |
|---|---|
| 1 (VDD) | Net label `+5V_LED` |
| 2 (DOUT) | Wire to **next LED's pin 4 (DIN)** — except for D81 which goes to net label `LED_DOUT_END` |
| 3 (VSS) | `GND` power port |
| 4 (DIN) | Wire from **previous LED's pin 2 (DOUT)** — except for D1 which gets net label `LED_DATA_5V` |

So:
- **D1 pin 4 (DIN)** = `LED_DATA_5V` (chain entry)
- **D1 pin 2 (DOUT)** → wire to **D2 pin 4 (DIN)**
- **D2 pin 2 (DOUT)** → wire to **D3 pin 4 (DIN)**
- … (continue along your chosen chain order) …
- **D80 pin 2 (DOUT)** → wire to **D81 pin 4 (DIN)**
- **D81 pin 2 (DOUT)** = `LED_DOUT_END` (chain exit / test point)

### B.4 Practical placement workflow

1. Place **one** WS2812 (D1) in the top-left.
2. `Ctrl+D` to duplicate. Repeat for D2..D9 across the top row.
3. Wire each DOUT → next DIN.
4. Once you have one row wired correctly, copy the whole row to row 2,
   relabel D10..D18, fix the wrap-around wire from D9 DOUT → D10 DIN (or
   D9 DOUT → D18 DIN if snaking).
5. Repeat 7 more times.

Reality check: a copy-paste row of 9 LEDs takes about 5 minutes per row
once you have the first one. 9 rows × 5 min = 45 min. Plus another hour
fixing wiring mistakes.

---

## Section C — Per-LED Decoupling Caps (81 × 100 nF)

One 100 nF cap across VDD/VSS of each WS2812, placed physically as close
to the LED as the layout allows.

### C.1 Component template

| Field | Value |
|---|---|
| Symbol | `Device:C` |
| Value | 100nF |
| Footprint | `Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder` |

### C.2 Refdes

`Ck` is the decoupling cap for `D(k - 9)` (because C10 pairs with D1,
C11 with D2, …, C90 with D81).

| Cap | Pairs with LED |
|---|---|
| C10 | D1 |
| C11 | D2 |
| … | … |
| C90 | D81 |

### C.3 Wiring per cap

| Pin | Net |
|---|---|
| 1 (top) | Net label `+5V_LED` |
| 2 (bottom) | `GND` power port |

No wires between cap and LED needed — the connection is by label
(`+5V_LED` and `GND` are shared with the LED's VDD and VSS).

### C.4 Practical placement workflow

Place one cap next to D1 with both labels. Select the cap + its labels,
`Ctrl+D` 80 times, updating the ref each time. Or: place all 81 caps
without labels first, then mass-edit labels in the schematic editor
(KiCad supports "edit value of all selected" which can save time).

---

## Section D — Row Bulk Caps (9 × 47 µF)

One bulk cap per row of the LED grid, between `+5V_LED` and `GND`. These
absorb the current spikes when many LEDs simultaneously update.

### D.1 Component template

| Field | Value |
|---|---|
| Symbol | `Device:C` |
| Value | 47uF |
| Footprint | `Capacitor_SMD:C_1206_3216Metric` |

### D.2 Refdes + placement

| Ref | Position |
|---|---|
| C1 | Near row 1 (D1..D9) |
| C2 | Near row 2 (D10..D18) |
| C3 | Near row 3 |
| C4 | Row 4 |
| C5 | Row 5 |
| C6 | Row 6 |
| C7 | Row 7 |
| C8 | Row 8 |
| C9 | Row 9 (D73..D81) |

### D.3 Wiring per cap

| Pin | Net |
|---|---|
| 1 (top) | Net label `+5V_LED` |
| 2 (bottom) | `GND` power port |

Same labels for all 9 — they all parallel the same rail.

---

## Section E — `+5V_LED` Entry Bulk Cap (1 × 470 µF)

One large electrolytic at the J_CTRL entry to smooth the rail at its
source on the board.

### E.1 Component

| Ref | Symbol | Value | Footprint |
|---|---|---|---|
| C91 | `Device:C_Polarized` | 470uF | `Capacitor_THT:CP_Radial_D10.0mm_P5.00mm` |

> **Polarity matters** — pin 1 is the **+** (anode), pin 2 is the **−**
> (cathode). Make sure pin 1 connects to `+5V_LED`, not GND, or the cap
> will pop.

### E.2 Wiring

| Pin | Net |
|---|---|
| 1 (+) | Net label `+5V_LED` |
| 2 (−) | `GND` power port |

Place near J1 (J_CTRL).

---

## Section F — J_CTRL Connector

The 26-pin connector to the controller board. This is the contract
side — pins must match the controller's J_MAIN exactly (see
`docs/inter-board-connector.md`).

### F.1 Component

| Ref | Symbol | Value | Footprint |
|---|---|---|---|
| J1 | `Connector_Generic:Conn_02x13_Odd_Even` | J_CTRL 2x13 | `Connector_PinHeader_2.54mm:PinHeader_2x13_P2.54mm_Vertical` |

### F.2 Pin-by-pin

| Pin | Net | How |
|---:|---|---|
| 1 | `+5V_LED` | Net label |
| 2 | GND | Power port |
| 3 | `+5V_LED` | Net label |
| 4 | GND | Power port |
| 5 | `+5V_LED` | Net label |
| 6 | GND | Power port |
| 7 | `LED_DATA_5V` | Net label |
| 8 | GND | Power port |
| 9 | `S0` | Net label |
| 10 | `S1` | Net label |
| 11 | `S2` | Net label |
| 12 | `S3` | Net label |
| 13 | `S4` | Net label |
| 14 | `S5` | Net label |
| 15 | `S6` | Net label |
| 16 | `S7` | Net label |
| 17 | `CA_PWR` | Net label |
| 18 | `CB_PWR` | Net label |
| 19 | `CC_PWR` | Net label |
| 20 | `CD_PWR` | Net label |
| 21 | `CE_PWR` | Net label |
| 22 | `CF_PWR` | Net label |
| 23 | `CG_PWR` | Net label |
| 24 | `CH_PWR` | Net label |
| 25 | `+5V_LED` | Net label |
| 26 | GND | Power port |

---

## Section G — Test Points, Mounting Holes, Fiducials

### G.1 Recommended test points

Minimal — just the four nets that aren't already accessible through
labels at the connector:

| TP | Net |
|---|---|
| TP1 | `+5V_LED` |
| TP2 | `GND` |
| TP3 | `LED_DATA_5V` |
| TP4 | `LED_DOUT_END` |

Symbol `Connector:TestPoint`, footprint
`TestPoint:TestPoint_Pad_D1.5mm`. Wire the pin to a net label /
power port.

> Don't bother test-pointing every `S0..S7` or `CA_PWR..CH_PWR` — those
> are all accessible at J1's pin pads with a scope probe.

### G.2 Mechanical

| Ref | Symbol | Footprint |
|---|---|---|
| MH1..MH4 | `Mechanical:MountingHole` | `MountingHole:MountingHole_3.2mm_M3` |
| FID1..FID3 | `Mechanical:Fiducial` | `Fiducial:Fiducial_1mm_Mask2mm` |

### G.3 PWR_FLAG symbols

The matrix board **consumes** `+5V_LED` and `GND` from the controller
through J1. ERC can't see the controller, so drop a `power:PWR_FLAG` on
both rails to silence the "no driver" warnings:

- `PWR_FLAG` on `+5V_LED`
- `PWR_FLAG` on `GND`

---

## Section H — Final Checks

### H.1 ERC

Inspect → **Electrical Rules Checker**. Expected: 0 violations.

Likely issues on a hand-drawn version of this board:

- **One stray DIN/DOUT in the LED chain** — if you skipped a connection
  between two LEDs, you'll see "pin not driven" on one DIN. Trace the
  chain to find the gap.
- **Mislabeled column or row net** — for example, a Hall sensor with
  `CA_PWR` on its VCC but it's physically in file C (should be
  `CC_PWR`). Check by selecting one sensor at a time and verifying its
  refdes (Uk where k = 1 + file*8 + rank) matches its file/rank labels.
- **Missing PWR_FLAG** — adds the "no driver" warnings on `+5V_LED` and
  `GND`. Easy fix.
- **Polarity error on C91** — won't be caught by ERC but will smoke at
  power-on. Double-check before assembly.

### H.2 Annotate

Tools → **Annotate Schematic**. For a 236-component board this matters
— make sure refs are sequential without gaps.

### H.3 Commit

```bash
git add openchess-board.kicad_sch
git commit -m "matrix board schematic: hand-drawn rev0.1 — 8x8 halls + 9x9 LEDs + J_CTRL"
```

---

## Quick-reference: every net on this board

For sanity-checking labels.

**Power:**
- `+5V_LED` — from controller via J1
- `GND` — ground

**Data:**
- `LED_DATA_5V` — WS2812 chain input at D1
- `LED_DOUT_END` — WS2812 chain exit at D81 (test point)

**Matrix:**
- `S0..S7` — 8 row sense lines (one per rank); pullups on controller
- `CA_PWR..CH_PWR` — 8 column power lines (one per file)

If your schematic has a label not in this list, it's a typo.

---

## One more time on the recommendation

The matrix board is the worst-case for hand-drawing because the
component count is high and the pattern is mechanical. Scripts are good
at mechanical patterns. **You almost certainly want to keep the
scripts for this board** and use this document strictly as reference for
what the script generates.

The 5-minute fix to the script for placement issues:

```bash
# Edit scripts/sch/geometry.py to tweak grid spacing
# Then re-run from scripts/sch/:
python3 01_skeleton.py
python3 02_halls.py
python3 03_leds.py
python3 04_bulks.py
python3 05_j_ctrl.py
python3 06_led_decoup.py
python3 07_test_mech.py
```

That regenerates 236 components in seconds. Worth it.
