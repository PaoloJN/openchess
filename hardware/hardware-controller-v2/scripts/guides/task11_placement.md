# Task 11 — PCB Placement Guide

**Goal:** Place all v2 footprints onto the 58×71 mm board in KiCad's PCB editor.
When done, `check_task11.py` must pass all geometry assertions and KiCad DRC
must show zero courtyard-overlap or board-edge-violation errors (unrouted-net
warnings are expected at this stage and can be ignored).

---

## 0. Area Math — Is 58×71 mm Enough?

| Zone | Key parts | Courtyard area (est.) |
|---|---|---|
| Antenna (top-left) | U2 WROOM-32E body 18×25.5 mm | 459 mm² |
| USB cluster (bottom-centre) | J4, U7, U8 | 145 mm² |
| Charger cluster (centre-left) | U9, C20, C21 | 110 mm² |
| Boost cluster (centre) | U10, L1, C22–C25 | 165 mm² |
| LDO (centre-right) | U11, C17, C18 | 60 mm² |
| Matrix drivers (bottom-right) | U3, U6 | 135 mm² |
| Matrix connector | J1 2×13 header | 228 mm² |
| Panel connectors (left edge) | J6, J7, J8, J9 | 240 mm² |
| Battery/switch (left edge) | J5, SW1 | 90 mm² |
| Misc passives, LEDs, tactiles | R/C fleet, D4/D5, SW_EN1/SW_BOOT1, FIDs | ~290 mm² |
| **Total** | | **~1922 mm²** |

Board area 58×71 = **4118 mm²**. Total courtyard ≈ 1922 mm² = **47 % packing ratio**.
This is well within the comfortable 40–60 % range for single-sided SMT.
**58×71 mm is sufficient — do not grow the board.**

---

## 1. ASCII Floor Plan

The board occupies the KiCad canvas rectangle `(50, 50)` → `(108, 121)` mm
(x increases right, y increases down).

```
x=50                                                   x=108
 |  58 mm                                                 |
 +-------------------------------------------------------+  ← y=50  TOP EDGE (ANTENNA SIDE)
 |  ~~~ANTENNA KEEPOUT (no copper, no parts)~~~          |
 |  [ U2 WROOM-32E ]  18×25.5 mm    | [SW_BOOT1][SW_EN1]|
 |  antenna overhang ~3 mm above top |                   |
 +- - - - - - - - - - - - - - - - - +-------------------+  ← y≈72  (U2 bottom)
 |[J5 bat]  [D5 PWR][D4 CHG]        |                   |  71 mm
 |[LEFT]    [U9 BQ24074 charger]  [U10 TPS61022 boost]  |  TALL
 |EDGE      [L1]                   [U11 LDO]            |
 |                                              [J1 2×13]|
 |[J6 OLED] [U6 TBD62783A SOP-18][U3 74AHCT125]  ||||  |  ← J1 right edge
 |[J7 UP  ] [         bottom-right driver zone  ] ||||  |
 |[J8 DOWN]                                      [J1]   |
 |[J9 OK  ]                                             |
 |[SW1]      [ U7 CH340C ]  [U8]   [J4 USB-C]          |
 +---------+------------------------------------------+-+  ← y=121 BOTTOM EDGE (USB SIDE)
           ↑ panel connectors                    ↑ USB-C slot in case
           left edge: battery/switch/panel
```

**Edge assignments and rationale:**

| Edge | Parts | Reasoning |
|---|---|---|
| **Top (y=50)** | U2 antenna overhang | Antenna must clear copper on all sides; overhanging the board edge keeps it off the board without needing a cutout |
| **Right (x=108)** | J1 matrix connector (on **B.Cu** — back side) | V1 J1 is at (103.6125, 85.4187) rot 180° on B.Cu — the matrix ribbon cable plugs from the back and exits the right side of the case |
| **Bottom (y=121)** | J4 USB-C | Case has a USB-C slot in the bottom panel; USB is the heaviest-use external port |
| **Left (x=50)** | J5 battery, J6–J9 panel connectors, SW1 slide switch | Battery leads and panel harness exit via the left case panel; SW1 is the power switch and must be fingertip-reachable |

---

## 2. Placement Steps (in Priority Order)

> **Coordinate frame:** every coordinate in this guide is an absolute KiCad
> canvas position inside the board rectangle **(50, 50) → (108, 121)**
> (x increases right, y increases down). You can type these directly into a
> footprint's Properties dialog (`E` key) — no conversion needed.

### Step 0 — Draw the Board Outline (Currently Missing)

The v2 PCB has **no Edge.Cuts outline yet** — the schematic import only placed
footprints. Draw it first so every later edge-distance rule has meaning:

1. Select the **Edge.Cuts** layer in the right-hand layer panel.
2. `Place → Draw Rectangle`, click twice anywhere to create a rectangle.
3. Double-click the rectangle (or select it and press `E`) to open its
   Properties dialog. Set exactly:
   - **Start point:** X = `50` mm, Y = `50` mm
   - **End point:** X = `108` mm, Y = `121` mm
   - **Corner radius:** `3` mm
4. Confirm the board reads **58 × 71 mm** — identical to v1 (the case depends
   on this exact outline).

The check script asserts the outline bounds match (50,50)→(108,121) within
±0.5 mm.

### Step 1 — U2 ESP32-WROOM-32E (Antenna Overhang)

**Why first:** Every other part must stay clear of the antenna keepout zone.
Once U2 is anchored, you know the forbidden region.

**The footprint:** `RF_Module:ESP32-WROOM-32E`
Module body: 18 mm wide × 25.5 mm tall. The antenna occupies the **top 3.5 mm**
of the footprint (the area above the first row of castellated pads).

**Target position:** Center at approximately **(67, 59.25)**, rotation **0°**.

At this position:
- Module spans x = 58–76, y = 46.5–72 in KiCad coordinates.
- The antenna tip is at y ≈ 46.5, i.e., **~3.5 mm above the board edge** at y = 50.
- The entire module body below the antenna zone (y > 53.5) is on-board.
- The antenna **courtyard extends past Edge.Cuts** — this is intentional and
  required; KiCad will flag this as an "Edge.Cuts violation" which you will
  **suppress** for the antenna zone only.

**How to add the antenna keepout rule-area in KiCad:**
1. Select `Place → Rule Area`.
2. Draw a rectangle covering the antenna strip: roughly
   `(58, 46) → (76, 53.5)` — the zone above the first pad row.
3. In the rule-area properties, tick **No copper fills**, **No tracks**,
   **No footprints** on all copper layers.
4. Label it `ANTENNA_KEEPOUT` in the Description field.

**Antenna overhang math:**
The Espressif WROOM-32E datasheet requires no copper (signal or plane) within
the antenna area. By overhanging the board edge by ≥ 3 mm you satisfy this
without a PCB cutout. The RF_Module footprint courtyard already encodes this
keepout boundary.

---

### Step 2 — J4 USB-C + U7 CH340C + U8 USBLC6 (USB Cluster)

**Priority:** Place before other power parts because J4 must be flush with the
bottom edge and the rest of the cluster must fit above it.

**J4 (TYPE-C-31-M-12 HRO USB-C receptacle):**
- Target position: **(68, 117)**, rotation **0°** (connector mouth faces down toward y = 121).
- The receptacle body extends ~4 mm above y = 121; place center so the port
  mouth is flush with the bottom edge.
- J4 **must be within 3 mm of a board edge** — the check script enforces this.

**U8 USBLC6-2SC6 (ESD protection, SOT-363):**
- Place immediately between J4 and U7: target **(71, 114)**.
- The D+ and D- lines run J4 → U8 I/O pins → U7 UD+/UD- pins.
- Keep this path short and straight (< 10 mm total).

**U7 CH340C (SOP-16):**
- Target: **(78, 109)**.
- Orient so UD+ (pin 5) and UD- (pin 6) face toward U8 (left/bottom side).
- C16 (100 nF V3 decoupling) and C19 (100 nF VCC decoupling) go within 3 mm
  of U7 pins 4 and 16 respectively.

**D+/D- path rule:** J4 A6/B6 (D+) → U8 I/O1 → U7 UD+; J4 A7/B7 (D−) → U8 I/O2 → U7 UD−.
These three parts form a straight line; the path should be < 15 mm end-to-end.

---

### Step 3 — U10 TPS61022 Boost Cluster (L1, C22–C25)

**Why tight:** Boost converters are switching at MHz frequencies. Long traces
between the inductor, input cap, and IC create EMI and efficiency loss. Copy
the TPS61022 datasheet layout example (SLVSDE9, Figure 19).

**U10 (VQFN-7, 2.5×2.5 mm):**
- Target: **(73, 95)**.

**Layout pattern (words + ASCII sketch):**

```
            VSYS in
               |
         [C22 10µF]   ← input cap, pin 1 to VSYS, pin 2 to GND
               |
         U10 TPS61022
         +----------+
  SW(2)--|           |--VOUT(3) ──────────┬──[C23 100µF]──GND
         |           |                    ├──[C24 22µF] ──GND
  VIN(7)─|           |                    └──[C25 22µF] ──GND
  GND(1)─|           |--FB(4) ─── R31/R32 divider
         +----------+
              |
         [L1 1µH]
              |
           SW node
```

**Exact placement rules:**
| Part | Target center | Max distance from U10 |
|---|---|---|
| L1 (APH0420, 4×4 mm) | (73, 89) | ≤ 5 mm — L1 **above** U10 (lower y) |
| C22 (10 µF input) | (73, 99) — below U10 | ≤ 5 mm |
| C23 (100 µF bulk) | (80, 95) — right of U10 | ≤ 8 mm |
| C24 (22 µF ceramic) | (83, 93) | ≤ 10 mm |
| C25 (22 µF ceramic) | (83, 97) | ≤ 10 mm |

**Routing hint:** The SW pin (2) trace goes from U10 directly to L1 pad 1.
Keep this trace short and wide (≥ 0.5 mm). L1 pad 2 connects back to the VSYS
input (or directly to VIN pad 7 of U10). Use a copper pour for SW node.

The output caps C23–C25 fan out from VOUT (pin 3). Place them in a cluster on
the side of U10 away from the inductor to avoid coupling.

---

### Step 4 — U9 BQ24074 Charger + C20, C21

**U9 (QFN-16-EP, 4×4 mm):**
- Target: **(58, 90)**.
- Place near J5 battery connector (left edge) and within ~20 mm of J4 USB input.

**Decoupling caps:**
| Part | Function | Target | Max distance from U9 |
|---|---|---|---|
| C20 (10 µF) | U9 IN pin decoupling | (58, 86) — above U9 | ≤ 5 mm |
| C21 (10 µF) | U9 OUT pin decoupling | (58, 94) — below U9 | ≤ 5 mm |

Place C20 between J5/J4 input and U9 IN pin.
Place C21 between U9 OUT and U10 VIN.

---

### Step 5 — U11 AMS1117-3.3 LDO + C17, C18

**U11 (SOT-223, ~6.5×3.5 mm):**
- Target: **(87, 95)**.
- SOT-223 has a large exposed tab on one side — ensure exposed tab faces toward
  a copper pour you can use as a small heatsink (optional at this stage).

**Decoupling:**
| Part | Function | Target | Max from U11 |
|---|---|---|---|
| C18 (10 µF) | LDO input bypass | (87, 91) | ≤ 5 mm |
| C17 (10 µF) | LDO output bypass | (87, 99) | ≤ 5 mm |

---

### Step 6 — Connectors J5/J6/J7/J8/J9, Switch SW1, LEDs D4/D5, Tactiles SW_EN1/SW_BOOT1

All connectors in this group go on the **left edge** (x = 50) or near it.
The check script requires each within **5 mm of any board edge**.

**J5 (battery XH-2, 2-pin):**
- Target: **(53, 76)**, rotation so JST latch faces left (toward x = 50).

**J6 (OLED XH-4, 4-pin):**
- Target: **(53, 98)**, rotation so latch faces left.

**J7 / J8 / J9 (button XH-2, 2-pin each):**
- Stack vertically below J6: J7 at (53, 104), J8 at (53, 108), J9 at (53, 112) — adjust spacing to avoid courtyard overlaps. The exact targets can shift ±3 mm; just keep them within 5 mm of the left or bottom edge.

**SW1 (MSK12C02 slide switch):**
- Target: **(53, 116)** near bottom-left corner, switch travel direction horizontal (along x axis) so it slides parallel to the bottom edge. This is ergonomically natural for a power switch.

**D4 (CHG LED, 0603):**
- Target: **(58, 83)**. Orient cathode (K, pin 1) toward GND fill.
- Place near the left edge so it is visible through a window in the case lid.

**D5 (PWR LED, 0603):**
- Target: **(58, 79)**.
- Stack directly above D4; same orientation. D5 is driven from +3.3V and is always on when powered.

**SW_BOOT1 (tactile, Boot button):**
- Target: **(82, 57)** near top-right, accessible through a small hole in the case top.
- Used only during firmware flashing; does not need to be prominently accessible.

**SW_EN1 (tactile, EN/reset button):**
- Target: **(82, 62)**, below SW_BOOT1. Same rationale.

---

### Step 7 — J1 Matrix Connector, then U3 (74AHCT125) and U6 (TBD62783A SOP-18) Near It

**J1 (2×13 matrix header) — restore the exact v1 position:**

The v1 board (the physical proven one) has J1 at **(103.6125, 85.418666),
rotation 180°, on layer B.Cu** — the matrix ribbon cable plugs in **from the
back of the board**, and both the cable and the case assume this. This is
deliberate: **do NOT flip J1 to the front.**

The schematic update moved J1 into the dump clump (it is currently at
~(122.1, 103.8) rot 90°). To restore it:

1. Find J1 (`Ctrl+F` → `J1`), select it.
2. Press `E` to open Properties. Set:
   - **Position X:** `103.6125` mm
   - **Position Y:** `85.418666` mm
   - **Orientation:** `180`°
   - **Side/Layer:** Back (B.Cu) — it should already be there; if it somehow
     ended up on Front, press `F` once to flip it to the back.
3. Lock it (right-click → Properties → Locked) so it cannot drift.

The check script asserts J1 is at this exact position (±1 mm), rotation 180°,
on B.Cu.

**U3 and U6 near J1:**

V1 had U6 (then DIP-18) at approximately (71, 116) and U3 at (59, 112).
Now U6 is **SMD SOP-18** (~11.6 × 7.5 mm courtyard) instead of DIP.

**U6 (TBD62783A, Package_SO:SOP-18 ~11.6×7.5 mm):**
- Target: **(72, 112)**, rotation **0°** (pins along top and bottom edges).
- U6 drives the 8 matrix row sink lines. Keep it close to J1 row pins.

**U3 (74AHCT125 SOIC-14, ~8.7×4 mm):**
- Target: **(87, 112)**.
- U3 buffers WS2812B data (level-shift 3.3V→5V). Output goes to J1 pin for LED_DATA.

**R11 (33 Ω series resistor for LED_DATA):**
- Place between U3 output and J1 LED_DATA pin, within 5 mm of U3.

---

### Step 8 — Decoupling Capacitors (Place Each Adjacent to its IC)

Place every decoupling cap within the stated distance; shorter is always better.

| Cap | Value | IC / pin | Max distance | Notes |
|---|---|---|---|---|
| C13 | 100 nF | U2 pin 1 (3V3) | ≤ 4 mm | U2 internal 3V3 decoupling |
| C14 | 10 µF | U2 pin 1 (3V3) | ≤ 5 mm | U2 bulk supply |
| C15 | 1 µF | U2 3V3 out | ≤ 5 mm | |
| C16 | 100 nF | U7 pin 4 (V3) | ≤ 3 mm | CH340C internal 3V3 |
| C19 | 100 nF | U7 pin 16 (VCC) | ≤ 3 mm | CH340C VCC bypass |
| C20 | 10 µF | U9 IN pin | ≤ 5 mm | Charger input decoupling |
| C21 | 10 µF | U9 OUT pin | ≤ 5 mm | Charger output decoupling |
| C22 | 10 µF | U10 VIN | ≤ 5 mm | Boost input cap — SW side |
| C23 | 100 µF | U10 VOUT | ≤ 8 mm | Boost output bulk |
| C24 | 22 µF | U10 VOUT | ≤ 10 mm | Boost output ceramic |
| C25 | 22 µF | U10 VOUT | ≤ 10 mm | Boost output ceramic |
| C17 | 10 µF | U11 VOUT | ≤ 5 mm | LDO output bypass |
| C18 | 10 µF | U11 VIN | ≤ 5 mm | LDO input bypass |
| C1 | 10 µF | U3 VCC | ≤ 5 mm | 74AHCT125 supply bypass |
| C2 | 10 µF | U6 VCC | ≤ 5 mm | TBD62783A supply bypass |
| C5 | 100 nF | U6 VCC | ≤ 3 mm | TBD62783A HF bypass |
| C11 | 100 nF | U3 VCC | ≤ 3 mm | 74AHCT125 HF bypass |
| C12 | 100 nF | miscellaneous | n/a | Place near power entry |

---

### Step 9 — Fiducials and Mounting Holes

**Keep the v1 positions exactly:**

| Ref | V1 position | Action |
|---|---|---|
| FID1 | (60.31, 53.15) | Keep at this position |
| FID2 | (99.06, 53.15) | Keep at this position |
| FID3 | (95.96, 111.12) | Keep at this position |
| FID4 | Add near (60, 111) | V1 had 3; add a 4th for symmetry (schematic has FID4) |

If FID4 does not exist in the PCB yet, place it at approximately **(60, 111)** as
a fourth corner fiducial.

**Mounting holes:** The v1 board had no explicit M3 through-hole footprints in
the v1 KiCad file (only the PCB fab corner radius). If your case design requires
M3 holes, add `MountingHole:MountingHole_3.2mm_M3` footprints at the four
corners (e.g., at (53, 53), (105, 53), (53, 118), (105, 118)) — all at ≥ 3 mm
from Edge.Cuts.

---

## 3. How to Move Parts in KiCad (Mini-Help)

When you "Update PCB from Schematic", KiCad dumps new footprints in a clump
(often at the centre or near (0,0)). Here is how to work through the cluster:

1. **Find a part:** Press `T` or use Edit → Find (`Ctrl+F`) and type the
   reference (e.g., `U10`). KiCad will highlight it.

2. **Select it:** Click the reference label or the courtyard outline. If you
   accidentally select a whole group, press `U` to expand selection, or click
   a single pad.

3. **Move:** Press `M` (Move). The part follows your cursor. Click to drop.
   While moving, type an exact coordinate: press `Space` then type `x,y` in the
   interactive router command bar, or use the Position dialog (`E` → Position).

4. **Rotate:** Press `R` while the part is selected (or being moved) to rotate
   90° counter-clockwise. Press `R` again for another 90°.

5. **Flip to back copper (B.Cu):** Press `F`. **All SMD parts must stay on
   F.Cu (front/top)** for single-side JLC assembly — if you accidentally flip
   an SMD part, press `F` again to flip it back. **Exception: J1 lives on
   B.Cu deliberately** (the matrix cable plugs from the back — see Step 7).
   Through-hole parts (J1, J5–J9) may sit on either side; only J1 is expected
   on the back.

6. **Lock in place:** After placing a critical anchor (U2, J1, J4), right-click
   → Properties → check "Locked". This prevents accidental moves.

7. **Check courtyard overlaps:** After placing a cluster, run
   `Inspect → Board Statistics` or quick DRC (`Inspect → Design Rules Checker`)
   and filter for "courtyard overlap" errors. Fix these before moving on.

8. **Rotate U6 (SOP-18):** SOP-18 is 11.6 mm long. Place with long axis
   horizontal (rotation 0° or 180°) so it fits in the ~15 mm bottom zone
   between J1 and the left edge.

---

## 4. Placement Checklist

Work through these in order. Tick each before moving to the next.

- [ ] **PCB from Schematic updated** — `Tools → Update PCB from Schematic`,
      deleted v1 stale footprints flagged as removed (DevKitC headers, DIP U6,
      Lipo Rider socket J2, SS14 diode, v1 J3).
- [ ] **Board outline drawn** — Edge.Cuts rectangle from `(50,50)` to
      `(108,121)`, 58×71 mm, 3 mm corner radius (Step 0).
- [ ] **U2 placed** at ~(67, 59.25), rot 0°, antenna overhangs top edge.
- [ ] **Antenna keepout rule-area added** covering ~(58,46)→(76,54).
- [ ] **J4 USB-C placed** at ~(68, 117), mouth flush with bottom edge (y=121),
      within 3 mm of edge.
- [ ] **U8 USBLC6 placed** between J4 and U7, within 5 mm of J4.
- [ ] **U7 CH340C placed** with UD+/UD- facing J4/U8, C16 and C19 within 3 mm.
- [ ] **U10 TPS61022 placed** at ~(73, 95); L1 within 5 mm; C22 within 5 mm;
      C23–C25 within 10 mm.
- [ ] **U9 BQ24074 placed** at ~(58, 90); C20/C21 within 5 mm each.
- [ ] **U11 AMS1117 placed** at ~(87, 95); C17/C18 within 5 mm each.
- [ ] **J5 battery placed** near left edge (x≈53), within 5 mm of edge.
- [ ] **J6/J7/J8/J9 placed** on left edge, stacked vertically.
- [ ] **SW1 slide switch placed** near bottom-left, within 5 mm of edge.
- [ ] **SW_EN1 and SW_BOOT1 placed** near top-right, reachable.
- [ ] **D4 CHG LED** at ~(58, 83), D5 PWR LED at ~(58, 79) — near left/visible.
- [ ] **U6 TBD62783A SOP-18 placed** at ~(72, 112), near J1.
- [ ] **U3 74AHCT125 SOIC-14 placed** at ~(87, 112), near J1.
- [ ] **J1 matrix 2×13 header restored** to exact v1 position
      (103.6125, 85.418666), rot 180°, **on B.Cu** (cable plugs from the back
      — do not flip to front).
- [ ] **All decoupling caps placed** per table in Step 8.
- [ ] **FID1–FID3 kept** at v1 positions; **FID4 added** at ~(60, 111).
- [ ] **All SMD footprints on F.Cu** — no flipped SMD parts (J1 on B.Cu is
      the only expected back-side part).
- [ ] **No footprint (except U2 antenna tip) outside board outline.**
- [ ] **No courtyard overlaps** — DRC courtyard check clean.
- [ ] **DRC run:** `kicad-cli pcb drc openchess-controller.kicad_pcb` — no
      edge-clearance or courtyard errors (unrouted-net errors OK).
- [ ] **Save PCB file.**
- [ ] **Run `check_task11.py`** — all proximity and layer assertions pass.
- [ ] **Commit:** `git add openchess-controller.kicad_pcb && git commit -m "feat(hw): v2 pcb — outline, placement, antenna keepout"`.

---

## 5. Quick DRC Command

```bash
/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli pcb drc \
  hardware/hardware-controller-v2/openchess-controller.kicad_pcb \
  --output /tmp/drc-task11.rpt \
  --schematic-parity
grep -i "courtyard\|edge\|outside" /tmp/drc-task11.rpt | grep -v "unconnected"
```

Expected output after correct placement: zero lines (only unconnected-net lines
are suppressed by the grep). If you see courtyard or edge errors, go back to
the relevant cluster and adjust.
