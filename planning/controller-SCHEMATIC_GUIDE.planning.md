# Controller Schematic — Spec

Build sheet for the OpenChess controller PCB. Every component, every pin, every net.

The cross-board contracts (J_MAIN ↔ matrix J_CTRL, J_PANEL → harness) live in `DESIGN_NOTES.planning.md` §3 and `docs/inter-board-connector.md`.

---

## 1. Reference designator map

| Ref | What |
|---|---|
| `M1` | Seeed Lipo Rider Plus (USB-C charging + 5V/2.4A boost + 3V3/250mA) |
| `D2` | Schottky diode (SS14 or BAT60A) — `+5V_LED` → DevKit pin 19 |
| `U2` | ESP32-DevKitC v4 module (drawn as two 1×19 sockets, `J3` left + `J4` right) |
| `U3` | 74AHCT125 LED data level shifter (3.3V→5V) |
| `U6` | TBD62783A 8-channel high-side column driver |
| `J1` | J_MAIN — 2×13 male pin header, board-to-board stacking to matrix (mates with matrix J_CTRL female socket on the matrix's back face) |
| `J3` (panel) | J_PANEL — JST XH 10-pin, plugs into the panel flying-lead harness *(separate from DevKit socket `J3` — distinct refs that must be deconflicted at annotation)* |
| `R1..R8` | Matrix row pullups (10 kΩ, `S0..S7` → `+3V3`) |
| `R11` | LED data series resistor (33 Ω, U3 output → J1) |
| `R14, R15` | Battery monitor divider (220 k top / 100 k bottom) |
| `R36, R37` | Panel button pullups (10 kΩ on `BTN_POWER`, `BTN_MODE`) |
| `C1, C2` | `+5V_LED` bulk caps (10 µF each, at M1's 5V output) |
| `C5` | 74AHCT125 decoupling (100 nF) |
| `C11` | TBD62783A decoupling (100 nF) |
| `C12` | VBAT_MON ADC filter (100 nF) |
| `BT1` | LiPo cell — documentation symbol only, `(in_bom no)` |
| `TP1..TP3` | Test points: `+5V_LED`, `+3V3`, `GND` |
| `MH1..MH4` | M3 mounting holes (4 corners; must align with matrix MH1..MH4) |
| `FID1, FID2` | Fiducials |

---

## 2. Net list (every label on this board)

**Power rails:**
- `+5V_LED` — 5V from M1 pin 4; powers WS2812 chain (via J1), U3 VCC, U6 VCC, D2 anode
- `+3V3` — direct from M1 pin 1 (no LDO on this PCB); powers ESP32 (DevKit), pullups, OLED via J_PANEL
- `GND` — ground
- `BAT` — raw battery from M1 pin 6, only goes to R14 (battery monitor)

**Matrix interface (to J1 = J_MAIN):**
- `S0..S7` — row sense, ESP32 inputs (pulled up by R1..R8)
- `CA_PWR..CH_PWR` — column power, from U6 outputs
- `LED_DATA_5V` — WS2812 chain data input (post U3 + R11)

**Controller-internal:**
- `LED_DATA` — 3.3V WS2812 data from ESP32 GPIO32 to U3 input
- `COL_DRV_A..COL_DRV_H` — 3.3V column-drive signals from ESP32 to U6 inputs
- `VBAT_MON` — analog battery voltage at the R14/R15/C12 junction → ESP32 GPIO34 ADC

**Panel interface (to J_PANEL):**
- `I2C_SDA` — ESP32 GPIO1 ↔ OLED
- `I2C_SCL` — ESP32 GPIO3 → OLED
- `BTN_SELECT` — ESP32 GPIO2 ← panel SELECT button
- `BTN_POWER` — ESP32 GPIO36 ← panel POWER button (pullup R36)
- `BTN_MODE` — ESP32 GPIO39 ← panel MODE button (pullup R37)
- `PANEL_SPARE`, `PANEL_SPARE2` — reserved (single-pin nets, ERC warning expected)

Any other label is a typo.

---

## 3. Section A — Power

### A.1 Components

| Ref | Symbol | Value | Footprint |
|---|---|---|---|
| M1 | `Connector_Generic:Conn_01x08` | Lipo Rider Plus | `LipoRiderPlus:MODULE_106990290` |
| D2 | `Device:D_Schottky` | SS14 or BAT60A | `Diode_SMD:D_SMA` |
| C1 | `Device:C` | 10µF | `Capacitor_SMD:C_0805_2012Metric` |
| C2 | `Device:C` | 10µF | `Capacitor_SMD:C_0805_2012Metric` |
| R14 | `Device:R` | 220k | `Resistor_SMD:R_0603_1608Metric` |
| R15 | `Device:R` | 100k | `Resistor_SMD:R_0603_1608Metric` |
| C12 | `Device:C` | 100nF | `Capacitor_SMD:C_0603_1608Metric` |
| BT1 | `Device:Battery_Cell` | LiPo 1S 3.7V (protected) | — *(off-board, `(in_bom no)`)* |

**Important M1 footprint/symbol note:** the symbol is a **generic** `Conn_01x08`, **not** SnapEDA's `106990290.kicad_sym`. SnapEDA's symbol has reversed pin-number-to-name mapping vs. the silkscreen; using the generic with manual pin labels is required to keep the schematic and PCB matched to the physical module.

### A.2 M1 pin-by-pin

M1 has 8 labeled solder pads in a single row. Pin numbers match the silkscreen (left-to-right, JST side first).

| M1 pin | Module pad | Net | Notes |
|---:|---|---|---|
| 1 | `3V3` | `+3V3` | Always-on 250 mA; this is the board's `+3V3` source. |
| 2 | `EN` | NC | We use M1's onboard slide switch instead; leave EN floating with a no-connect flag. |
| 3 | `GND` | `GND` | |
| 4 | `5V` | `+5V_LED` | Regulated 5V/2.4A boost output. |
| 5 | `GND` | `GND` | |
| 6 | `BAT` | wire to R14 pin 1 | Raw battery (3.0–4.2 V). Goes only to the battery monitor divider. |
| 7 | `GND` | `GND` | |
| 8 | `USB` | NC | Raw USB-C VBUS test pad. No-connect flag. |

M1's onboard slide switch must be in the **ON** position during assembly.

### A.3 D2 — Schottky for ESP32 power path

| Pin | Net |
|---|---|
| Anode | `+5V_LED` |
| Cathode | Wire to DevKit pin 19 (U2 module pin labeled `5V`) |

Allows current `+5V_LED → DevKit pin 19` (forward, ~0.3 V drop → ~4.8 V → DevKit's AMS1117 → ESP32 internal 3V3). Blocks backfeed when DevKit USB and M1 USB-C are both plugged.

### A.4 Battery monitor (R14, R15, C12)

| Component | Pin 1 | Pin 2 |
|---|---|---|
| R14 (220k) | wire from M1 pin 6 (`BAT`) | junction `VBAT_MON` |
| R15 (100k) | junction `VBAT_MON` | `GND` |
| C12 (100nF) | junction `VBAT_MON` | `GND` |

Net label `VBAT_MON` at the 3-way junction → ESP32 module pin 5 (DevKit physical pin 5 = GPIO34, ADC1_CH6).

Divider math: `VBAT_MON = BAT × 0.3125`. Range: 0.94 V (empty) to 1.31 V (full).

**Place C12 physically next to GPIO34** (the ADC input), not next to R14/R15 — C12 is the filter at the ADC, not at the divider.

### A.5 +5V_LED bulk caps (C1, C2)

| Pin | Net |
|---|---|
| 1 | `+5V_LED` |
| 2 | `GND` |

Place C1 within 5 mm of M1 pin 4. Place C2 downstream where `+5V_LED` enters the U3/U6/J1 zone.

---

## 4. Section B — J_MAIN (`J1`) — to matrix

### B.1 Component

| Ref | Symbol | Value | Footprint |
|---|---|---|---|
| J1 | `Connector_Generic:Conn_02x13_Odd_Even` | J_MAIN 2x13 | `Connector_PinHeader_2.54mm:PinHeader_2x13_P2.54mm_Vertical` |

**2×13 male pin header on the controller PCB's top face, board-to-board stacking.** Mates with the matrix board's 2×13 female socket (J_CTRL) on the matrix's back face. No ribbon cable. Mark Pin 1 with silkscreen dot.

The mating depth of the pin+socket combo sets the standoff height (~11 mm).

### B.2 Pin-by-pin

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

Must mirror the matrix's J_CTRL pinout exactly (matrix PCB documents the same table in its own guide).

---

## 5. Section C — Row pullups (`R1..R8`)

### C.1 Components (all 8 identical)

| Ref | Symbol | Value | Footprint |
|---|---|---|---|
| R1..R8 | `Device:R` | 10k | `Resistor_SMD:R_0805_2012Metric` |

### C.2 Wiring

For each `R{k}` (k = 1..8):

| Pin | Net |
|---|---|
| 1 | `+3V3` |
| 2 | `S{k-1}` (so R1→S0, R2→S1, …, R8→S7) |

These hold the open-collector matrix row outputs HIGH by default.

PCB placement: within ~5 mm of the corresponding ESP32 GPIO that reads `S0..S7`.

---

## 6. Section D — ESP32-DevKitC sockets (`J3`, `J4`)

U2 represents the ESP32-DevKitC v4 module plugged into two 1×19 female sockets at 25.4 mm row pitch. The schematic draws them as two separate symbols.

### D.1 Components

| Ref | Symbol | Value | Footprint |
|---|---|---|---|
| J3 (DevKit left) | `Connector_Generic:Conn_01x19` | DevKit left strip | `Connector_PinSocket_2.54mm:PinSocket_1x19_P2.54mm_Vertical` |
| J4 (DevKit right) | `Connector_Generic:Conn_01x19` | DevKit right strip | `Connector_PinSocket_2.54mm:PinSocket_1x19_P2.54mm_Vertical` |

J3 pins 1..19 correspond to DevKit physical pins 1..19. J4 pins 1..19 correspond to DevKit physical pins 20..38.

> Note: this `J3` (DevKit left socket) and the **panel `J3` (J_PANEL)** in §8 are two distinct components that happen to share the same human-facing name during the hand-draw. Annotate uniquely (e.g. rename DevKit socket to `J5`) before generating netlist.

### D.2 J3 (left strip, DevKit pins 1–19)

| J3 pin | DevKit | GPIO / function | Net or flag |
|---:|---:|---|---|
| 1 | 1 | 3V3 out (DevKit onboard LDO) | **NC** (we source +3V3 from M1, not from here) |
| 2 | 2 | EN / CHIP_PU | NC |
| 3 | 3 | GPIO36 / SVP (input-only) | `BTN_POWER` |
| 4 | 4 | GPIO39 / SVN (input-only) | `BTN_MODE` |
| 5 | 5 | GPIO34 / ADC1_CH6 (input-only) | `VBAT_MON` |
| 6 | 6 | GPIO35 (input-only) | `PANEL_SPARE` |
| 7 | 7 | GPIO32 | `LED_DATA` |
| 8 | 8 | GPIO33 | `COL_DRV_F` |
| 9 | 9 | GPIO25 | `COL_DRV_E` |
| 10 | 10 | GPIO26 | `COL_DRV_D` |
| 11 | 11 | GPIO27 | `COL_DRV_C` |
| 12 | 12 | GPIO14 | `COL_DRV_B` |
| 13 | 13 | GPIO12 (MTDI strap — avoid HIGH at boot) | NC |
| 14 | 14 | GND | `GND` |
| 15 | 15 | GPIO13 | `COL_DRV_A` |
| 16 | 16 | GPIO9 / SD2 (flash) | NC |
| 17 | 17 | GPIO10 / SD3 (flash) | NC |
| 18 | 18 | GPIO11 / CMD (flash) | NC |
| 19 | 19 | 5V (DevKit USB VBUS input) | **D2 cathode** (from `+5V_LED` via D2) |

### D.3 J4 (right strip, DevKit pins 20–38)

| J4 pin | DevKit | GPIO / function | Net or flag |
|---:|---:|---|---|
| 1 | 20 | GPIO6 / CLK (flash) | NC |
| 2 | 21 | GPIO7 / SD0 (flash) | NC |
| 3 | 22 | GPIO8 / SD1 (flash) | NC |
| 4 | 23 | GPIO15 (boot strap HIGH) | `COL_DRV_H` |
| 5 | 24 | GPIO2 (boot strap LOW) | `BTN_SELECT` |
| 6 | 25 | GPIO0 (boot strap HIGH) | NC |
| 7 | 26 | GPIO4 | `S0` |
| 8 | 27 | GPIO16 | `S1` |
| 9 | 28 | GPIO17 | `S2` |
| 10 | 29 | GPIO5 (boot strap HIGH) | `COL_DRV_G` |
| 11 | 30 | GPIO18 | `S3` |
| 12 | 31 | GPIO19 | `S4` |
| 13 | 32 | GND | `GND` |
| 14 | 33 | GPIO21 | `S5` |
| 15 | 34 | GPIO3 / RXD0 (repurposed) | `I2C_SCL` |
| 16 | 35 | GPIO1 / TXD0 (repurposed) | `I2C_SDA` |
| 17 | 36 | GPIO22 | `S6` |
| 18 | 37 | GPIO23 | `S7` |
| 19 | 38 | GND | `GND` |

**UART0 (GPIO1/3) is repurposed as the I²C bus.** No serial debug on DevKit USB during normal operation.

---

## 7. Section E — LED level shifter (`U3` 74AHCT125)

74AHCT125 is a quad bus buffer. KiCad represents it as **5 units** (4 gates + 1 power unit) — all part of one physical chip.

### E.1 Components

| Ref | Symbol | Value | Footprint |
|---|---|---|---|
| U3 | `74xx:74AHCT125` | 74AHCT125 | `Package_SO:SOIC-14_3.9x8.7mm_P1.27mm` |
| R11 | `Device:R` | 33Ω | `Resistor_SMD:R_0603_1608Metric` |
| C5 | `Device:C` | 100nF | `Capacitor_SMD:C_0603_1608Metric` |

### E.2 U3 unit-by-unit

| Unit | Pin | Function | Net or flag |
|---|---:|---|---|
| A (live) | 1 | ~OE | `GND` (enable always on) |
| A (live) | 2 | A (input) | `LED_DATA` |
| A (live) | 3 | Y (output) | wire to R11 pin 1 |
| B (unused) | 4 | ~OE | `GND` |
| B (unused) | 5 | A | `GND` |
| B (unused) | 6 | Y | NC |
| C (unused) | 8 | Y | NC |
| C (unused) | 9 | A | `GND` |
| C (unused) | 10 | ~OE | `GND` |
| D (unused) | 11 | Y | NC |
| D (unused) | 12 | A | `GND` |
| D (unused) | 13 | ~OE | `GND` |
| E (power) | 7 | GND | `GND` |
| E (power) | 14 | VCC | `+5V_LED` |

### E.3 R11 (series damping)

| Pin | Net |
|---|---|
| 1 | wire from U3 pin 3 |
| 2 | `LED_DATA_5V` |

Place R11 immediately at U3's output pin.

### E.4 C5 (decoupling)

| Pin | Net |
|---|---|
| 1 | `+5V_LED` |
| 2 | `GND` |

Place within 3 mm of U3 pin 14 (VCC).

---

## 8. Section F — Column driver (`U6` TBD62783A)

8-channel high-side switch. Active-high inputs: ESP32 drives `COL_DRV_X` HIGH → internal PMOS connects output `CX_PWR` to `+5V_LED`.

### F.1 Components

| Ref | Symbol | Value | Footprint |
|---|---|---|---|
| U6 | `Transistor_Array:TBD62783A` | TBD62783A | `Package_DIP:DIP-18_W7.62mm` *or* `Package_SO:SOIC-18W_7.5x11.55mm_P1.27mm` |
| C11 | `Device:C` | 100nF | `Capacitor_SMD:C_0603_1608Metric` |

Pick DIP or SOIC variant before fab; same KiCad symbol works for both.

### F.2 U6 pin-by-pin (DIP-18 numbering)

| Pin | Name | Net |
|---:|---|---|
| 1 | I1 | `COL_DRV_A` |
| 2 | I2 | `COL_DRV_B` |
| 3 | I3 | `COL_DRV_C` |
| 4 | I4 | `COL_DRV_D` |
| 5 | I5 | `COL_DRV_E` |
| 6 | I6 | `COL_DRV_F` |
| 7 | I7 | `COL_DRV_G` |
| 8 | I8 | `COL_DRV_H` |
| 9 | VCC | `+5V_LED` |
| 10 | GND | `GND` |
| 11 | O8 | `CH_PWR` |
| 12 | O7 | `CG_PWR` |
| 13 | O6 | `CF_PWR` |
| 14 | O5 | `CE_PWR` |
| 15 | O4 | `CD_PWR` |
| 16 | O3 | `CC_PWR` |
| 17 | O2 | `CB_PWR` |
| 18 | O1 | `CA_PWR` |

### F.3 C11 (decoupling)

| Pin | Net |
|---|---|
| 1 | `+5V_LED` |
| 2 | `GND` |

Place within 3 mm of U6 pin 9 (VCC).

---

## 9. Section G — J_PANEL + button pullups

### G.1 Components

| Ref | Symbol | Value | Footprint |
|---|---|---|---|
| J3 (panel) | `Connector_Generic:Conn_01x10` | J_PANEL XH-10 | `Connector_JST:JST_XH_B10B-XH-A_1x10_P2.50mm_Vertical` |
| R36 | `Device:R` | 10k | `Resistor_SMD:R_0603_1608Metric` |
| R37 | `Device:R` | 10k | `Resistor_SMD:R_0603_1608Metric` |

(Disambiguate from DevKit socket `J3` during annotation.)

### G.2 J_PANEL pin-by-pin

| Pin | Net | ESP32 GPIO |
|---:|---|---|
| 1 | `+3V3` | — (powers OLED + R36/R37) |
| 2 | `GND` | — |
| 3 | `I2C_SDA` | GPIO1 |
| 4 | `I2C_SCL` | GPIO3 |
| 5 | `BTN_SELECT` | GPIO2 |
| 6 | `BTN_POWER` | GPIO36 (input-only) |
| 7 | `BTN_MODE` | GPIO39 (input-only) |
| 8 | `PANEL_SPARE` | (reserved, GPIO35) |
| 9 | `PANEL_SPARE2` | (reserved) |
| 10 | `GND` | — |

`PANEL_SPARE` / `PANEL_SPARE2` terminate at a single pin here → ERC single-pin-net warning is intentional.

### G.3 R36, R37 (button pullups)

| Ref | Pin 1 | Pin 2 |
|---|---|---|
| R36 | `+3V3` | `BTN_POWER` |
| R37 | `+3V3` | `BTN_MODE` |

`BTN_SELECT` is on GPIO2 which has an internal pullup (firmware-enabled); no external pullup needed.

PCB placement: R36/R37 within ~5 mm of the ESP32 GPIO36/39 pins on the DevKit socket.

---

## 10. Section H — Test points, mounting, fiducials

### H.1 Test points (rails only — minimum useful set)

| Ref | Net |
|---|---|
| TP1 | `+5V_LED` |
| TP2 | `+3V3` |
| TP3 | `GND` |

Symbol `Connector:TestPoint`, footprint `TestPoint:TestPoint_Pad_D1.5mm`. Other signals are accessible at chip pads or connector pins.

### H.2 Mechanical (no electrical connection)

| Ref | Symbol | Footprint |
|---|---|---|
| MH1..MH4 | `Mechanical:MountingHole` | `MountingHole:MountingHole_3.2mm_M3` |
| FID1, FID2 | `Mechanical:Fiducial` | `Fiducial:Fiducial_1mm_Mask2mm` |

MH1..MH4 must align with the matrix PCB's MH1..MH4 — M3 standoffs thread through both boards.

### H.3 PWR_FLAGs

Add `power:PWR_FLAG` on these nets so ERC sees a driver:
- `+5V_LED` (sourced externally by M1's boost — PWR_FLAG required)
- `+3V3` (sourced externally by M1's LDO — PWR_FLAG required)
- `GND`

---

## 11. Schematic validation rules

These should all hold after wiring. Useful for review.

1. Every `+3V3` consumer (R1..R8, R36, R37, J_PANEL pin 1, ESP32 socket 3V3 pin) is on the net sourced **only** from M1 pin 1. **DevKit's own 3V3 out (J3 pin 1) is NC**.
2. Every `+5V_LED` consumer (U3 VCC, U6 VCC, D2 anode, C1/C2, J1 pins 1/3/5/25) is on the net sourced **only** from M1 pin 4.
3. `BAT` net touches **only** M1 pin 6 and R14 pin 1. No other consumer.
4. `VBAT_MON` is a 3-way junction: R14 pin 2 + R15 pin 1 + C12 pin 1 + (wire to) DevKit pin 5 (GPIO34).
5. `LED_DATA` (3.3V) touches ESP32 GPIO32 and U3 unit A pin 2 (only).
6. `LED_DATA_5V` touches R11 pin 2 and J1 pin 7 (only).
7. `R11` sits in series between U3 unit A pin 3 (output) and J1 pin 7.
8. `D2` anode is on `+5V_LED`; cathode is wired **directly** to DevKit pin 19 (no shared net beyond that one wire).
9. Each `COL_DRV_X` net touches **exactly** one ESP32 GPIO pin and **exactly** one U6 input pin (I1..I8).
10. Each `CX_PWR` net touches **exactly** one U6 output pin (O1..O8) and **exactly** one J1 column-power pin.
11. Each `S0..S7` net touches **exactly** one ESP32 GPIO, **exactly** one row pullup (R1..R8) pin 2, and **exactly** one J1 row pin.
12. `BTN_POWER`, `BTN_MODE` each touch their ESP32 GPIO, their pullup (R36 or R37) pin 2, and J_PANEL pin 6 or 7.
13. `BTN_SELECT` touches DevKit GPIO2 pin and J_PANEL pin 5 only — no external pullup.
14. `I2C_SDA` touches DevKit GPIO1 pin and J_PANEL pin 3 only.
15. `I2C_SCL` touches DevKit GPIO3 pin and J_PANEL pin 4 only.
16. All flash pins (DevKit pins 16, 17, 18 on J3-left and pins 1, 2, 3 on J4-right) carry no-connect flags.
17. Both DevKit J3-left pin 1 (3V3 out) and pin 2 (EN) carry no-connect flags.
18. `PWR_FLAG` symbols exist on `+5V_LED`, `+3V3`, `GND`.
19. Two separate connectors share the human-name "J3" — DevKit socket and panel JST. Annotation must rename one (recommend DevKit socket → `J5`).

If any of the above fails, the schematic has an error.
