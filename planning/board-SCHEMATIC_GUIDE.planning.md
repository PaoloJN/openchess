# Matrix Board Schematic — Spec

Build sheet for the OpenChess matrix PCB. Documents every component, every pin, and every net.

236 components total, all passive:
- 64× A3144 Hall sensors
- 81× WS2812B LEDs (daisy-chained, row-major)
- 81× 100 nF per-LED decoupling caps
- 9× 47 µF row bulk caps
- 1× 470 µF entry cap
- 1× J_CTRL 2×13 stacking socket
- 4× test points, 4× M3 mounting holes, 3× fiducials

The schematic is **script-generated** at `scripts/sch/` (ERC clean).

---

## 1. Net list (every label on this board)

**Power & data:**
- `+5V_LED` — 5 V supplied by controller through J1 (consume only — needs PWR_FLAG)
- `GND` — ground (consume only — needs PWR_FLAG)
- `LED_DATA_5V` — WS2812 chain input at D1 (from controller, level-shifted)
- `LED_DOUT_END` — last WS2812 DOUT, exposed as TP4

**Matrix interface (to J_CTRL):**
- `S0..S7` — row sense, one per chess rank
- `CA_PWR..CH_PWR` — column power, one per chess file

Any other label is a typo.

---

## 2. Custom symbol

| lib_id | Description | Location |
|---|---|---|
| `openchess:A3144` | A3144 Hall sensor (TO-92, 3-pin) | `hardware-board/lib/openchess.kicad_sym` |

Other symbols are stock KiCad: `LED:WS2812B`, `Device:C`, `Device:C_Polarized`, `Connector_Generic:Conn_02x13_Odd_Even`, `Connector:TestPoint`, `Mechanical:MountingHole`, `Mechanical:Fiducial`, `power:PWR_FLAG`.

---

## 3. Section A — Hall sensor grid (`U1..U64`)

### A.1 Component template

| Field | Value |
|---|---|
| Symbol | `openchess:A3144` |
| Value | `A3144` |
| Footprint | `Package_TO_SOT_THT:TO-92_Inline` |

Pin map: 1=VCC, 2=GND, 3=OUT (open-collector).

### A.2 Ref scheme

```
ref(file_idx, rank_idx) = U{1 + file_idx * 8 + rank_idx}
   file_idx = 0..7 (files A..H)
   rank_idx = 0..7 (ranks 1..8)

U1=A1, U2=A2, …, U8=A8, U9=B1, U10=B2, …, U64=H8
```

### A.3 Per-sensor wiring

For Hall at file `F` (A..H) and rank `R` (1..8):

| Pin | Net |
|---|---|
| 1 (VCC) | Net label `C{F}_PWR` (e.g. `CA_PWR` for file A) |
| 2 (GND) | `GND` |
| 3 (OUT) | Net label `S{R-1}` (e.g. `S0` for rank 1) |

All 8 sensors in file A share `CA_PWR`. All 8 sensors in rank 1 share `S0`. Open-collector pull-down — pullups live on the controller (`R1..R8`).

---

## 4. Section B — WS2812B LED grid (`D1..D81`)

### B.1 Component template

| Field | Value |
|---|---|
| Symbol | `LED:WS2812B` |
| Value | `WS2812B` |
| Footprint | `LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm` |

Pin map: 1=VDD, 2=DOUT, 3=VSS, 4=DIN.

### B.2 Ref scheme (row-major)

`D1` = top-left corner. `D9` = top-right of row 1. `D10..D18` = row 2 (left to right). … `D81` = bottom-right.

```
D1  D2  D3  D4  D5  D6  D7  D8  D9
D10 D11 D12 D13 D14 D15 D16 D17 D18
...
D73 D74 D75 D76 D77 D78 D79 D80 D81
```

### B.3 Chain wiring

| Pin | Net |
|---|---|
| 1 (VDD) | `+5V_LED` |
| 2 (DOUT) | Wire to next LED's Pin 4 (DIN); for `D81` → `LED_DOUT_END` |
| 3 (VSS) | `GND` |
| 4 (DIN) | Wire from previous LED's Pin 2 (DOUT); for `D1` → `LED_DATA_5V` |

Chain entry: `D1` Pin 4 = `LED_DATA_5V`.
Chain exit: `D81` Pin 2 = `LED_DOUT_END` (TP only).

The actual chain order between row-major and serpentine doesn't affect electrical correctness — only firmware indexing. Schematic chain follows raster row-major (D1→D2→…→D81 in linear order).

---

## 5. Section C — Per-LED decoupling (`C10..C90`)

One 100 nF cap per WS2812, placed adjacent on the PCB.

### C.1 Component template

| Field | Value |
|---|---|
| Symbol | `Device:C` |
| Value | `100nF` |
| Footprint | `Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder` |

### C.2 Ref pairing

`C{k+9}` pairs with `D{k}`. So `C10 ↔ D1`, `C11 ↔ D2`, …, `C90 ↔ D81`.

### C.3 Wiring (all 81 identical)

| Pin | Net |
|---|---|
| 1 | `+5V_LED` |
| 2 | `GND` |

PCB placement: within 3 mm of the paired LED's VDD pin.

---

## 6. Section D — Row bulk caps (`C1..C9`)

One bulk cap per row of the LED grid.

### D.1 Component template

| Field | Value |
|---|---|
| Symbol | `Device:C` |
| Value | `47uF` |
| Footprint | `Capacitor_SMD:C_1206_3216Metric` |

### D.2 Ref → row pairing

| Ref | LED row |
|---|---|
| C1 | D1..D9 (row 1) |
| C2 | D10..D18 (row 2) |
| C3 | D19..D27 |
| C4 | D28..D36 |
| C5 | D37..D45 |
| C6 | D46..D54 |
| C7 | D55..D63 |
| C8 | D64..D72 |
| C9 | D73..D81 (row 9) |

### D.3 Wiring (all 9 identical)

| Pin | Net |
|---|---|
| 1 | `+5V_LED` |
| 2 | `GND` |

---

## 7. Section E — Entry cap (`C91`)

Single 470 µF electrolytic at the J_CTRL entry to smooth the rail at its board entry point.

### E.1 Component

| Ref | Symbol | Value | Footprint |
|---|---|---|---|
| C91 | `Device:C_Polarized` | `470uF` | `Capacitor_THT:CP_Radial_D10.0mm_P5.00mm` |

### E.2 Wiring (polarity matters)

| Pin | Net |
|---|---|
| 1 (+, anode) | `+5V_LED` |
| 2 (−, cathode) | `GND` |

PCB placement: within ~10 mm of J1.

---

## 8. Section F — Matrix connector (`J1` = J_CTRL)

### F.1 Component

| Ref | Symbol | Value | Footprint |
|---|---|---|---|
| J1 | `Connector_Generic:Conn_02x13_Odd_Even` | `J_CTRL 2x13` | `Connector_PinSocket_2.54mm:PinSocket_2x13_P2.54mm_Vertical` |

**Female socket on the matrix PCB's BACK face.** Mates with controller J_MAIN's 2×13 male pin header on the controller's top face when the boards stack.

Mark Pin 1 with silkscreen dot.

### F.2 Pin-by-pin

| Pin | Net |
|----:|-----|
| 1 | `+5V_LED` |
| 2 | `GND` |
| 3 | `+5V_LED` |
| 4 | `GND` |
| 5 | `+5V_LED` |
| 6 | `GND` |
| 7 | `LED_DATA_5V` |
| 8 | `GND` |
| 9 | `S0` |
| 10 | `S1` |
| 11 | `S2` |
| 12 | `S3` |
| 13 | `S4` |
| 14 | `S5` |
| 15 | `S6` |
| 16 | `S7` |
| 17 | `CA_PWR` |
| 18 | `CB_PWR` |
| 19 | `CC_PWR` |
| 20 | `CD_PWR` |
| 21 | `CE_PWR` |
| 22 | `CF_PWR` |
| 23 | `CG_PWR` |
| 24 | `CH_PWR` |
| 25 | `+5V_LED` |
| 26 | `GND` |

Must mirror the controller's J_MAIN pinout exactly.

---

## 9. Section G — Test points, mounting, fiducials

### G.1 Test points

| Ref | Net |
|---|---|
| TP1 | `+5V_LED` |
| TP2 | `GND` |
| TP3 | `LED_DATA_5V` |
| TP4 | `LED_DOUT_END` |

Symbol `Connector:TestPoint`, footprint `TestPoint:TestPoint_Pad_D1.5mm`.

### G.2 Mechanical (no electrical connection)

| Ref | Symbol | Footprint |
|---|---|---|
| MH1..MH4 | `Mechanical:MountingHole` | `MountingHole:MountingHole_3.2mm_M3` |
| FID1..FID3 | `Mechanical:Fiducial` | `Fiducial:Fiducial_1mm_Mask2mm` |

MH1..MH4 must align with the controller PCB's MH1..MH4 so M3 standoffs thread through both boards.

### G.3 PWR_FLAGs

The matrix board only **consumes** `+5V_LED` and `GND`. Add `power:PWR_FLAG` symbols on both rails to satisfy ERC:

- One `PWR_FLAG` on `+5V_LED`
- One `PWR_FLAG` on `GND`

---

## 10. Validation rules

- Every Hall sensor `U{1 + file*8 + rank}` has VCC = `C{file_letter}_PWR` matching its file.
- Every Hall sensor has OUT = `S{rank}` matching its rank.
- Every WS2812 except `D1` has its DIN wired from the previous LED's DOUT.
- Every WS2812 except `D81` has its DOUT wired to the next LED's DIN.
- `D1` DIN = `LED_DATA_5V`. `D81` DOUT = `LED_DOUT_END`.
- Every `C{k+9}` pairs with `D{k}` — both on `+5V_LED` / `GND`.
- Every `C1..C9` on `+5V_LED` / `GND`.
- `C91` Pin 1 (+) on `+5V_LED`, Pin 2 (−) on `GND`.
- J1 pinout matches §8.2 exactly.
- PWR_FLAGs on `+5V_LED` and `GND`.
