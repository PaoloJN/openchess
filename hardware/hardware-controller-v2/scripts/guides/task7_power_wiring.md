# Task 7 — Power Chain Wiring Guide

**Goal:** Wire the complete power path: BQ24074RGT charger (U9), TPS61022 boost (U10),
AMS1117-3.3 LDO (U11), slide-switch power control (SW1), 2-pin battery JST connector (J5),
charge LED (D4), and power LED (D5) with their series resistors. When done the board has
a proper battery-backed power path: charge from USB via U9, switch boost via SW1, generate
+5V_LED from VSYS, regulate +3.3V from +5V_LED.

**Before you start:**
- Tasks 5 and 6 must already be complete (WROOM core, USB-C/CH340C/auto-program all on sheet).
- Net `VBUS` must already exist on the schematic.
- Net `+5V_LED` must already exist (it feeds U3 level-shifter and J1 matrix connector — do not create a new net; reuse the existing one).
- Net `+3.3V` must already exist (it feeds U2 WROOM-32E and pullups).
- Delete BT1 and D3 before placing any new symbols (see Step 0 below).

---

## Symbol Confirmation (grepped from installed KiCad 10 library)

| Symbol | Library:Name | Package | Confirmed lib file |
|---|---|---|---|
| LiPo charger | `Battery_Management:BQ24074RGT` | QFN-16-EP (note: KiCad symbol is "RGT" not "RGTR") | Battery_Management.kicad_sym line 6820 |
| 5V boost | `Converter_DCDC:TPS61022` | VQFN-7 2×2mm | Converter_DCDC.kicad_sym line 108329 |
| 3.3V LDO | `Regulator_Linear:AMS1117-3.3` | SOT-223 | Regulator_Linear.kicad_sym line 2602 |
| Slide switch | `Switch:SW_SPDT` | (use MSK12C02 footprint) | Switch.kicad_sym line 23618 |
| Battery connector | `Connector_Generic:Conn_01x02` | TH P=2.5mm (B2B-XH-A) | Connector_Generic.kicad_sym line 134 |
| Inductor | `Device:L` | SMD 4.4×4.2mm (APH0420T1R0M) | Device.kicad_sym line 52588 |
| LED | `Device:LED` | 0603 | Device.kicad_sym line 52766 |
| Resistor | `Device:R` | 0603 | (already used throughout) |

> **BQ24074RGT vs BQ24074RGTR:** The sourced part (LCSC C54313) is the RGTR (tape-and-reel)
> variant, which is electrically identical to BQ24074RGT. Use `Battery_Management:BQ24074RGT`
> as the schematic symbol. Set the Value field to `BQ24074RGTR` to match the BOM MPN.

---

## Pin Maps (grepped verbatim from installed symbol files)

### BQ24074RGT — Battery_Management.kicad_sym lines 6820–7229

| Pin # | Name | Function | Connect to |
|---|---|---|---|
| 1 | TS | Thermistor sense | R_TS (10kΩ to GND) |
| 2 | BAT | Battery positive (power out) | net VBAT |
| 3 | BAT | Battery positive (dup) | net VBAT (tied to pin 2 internally; wire both) |
| 4 | ~{CE} | Charge enable (active-low) | GND (always-enable) |
| 5 | EN2 | Input-limit mode select bit 2 | +3.3V (high) |
| 6 | EN1 | Input-limit mode select bit 1 | GND (low) |
| 7 | ~{PGOOD} | Power-good open-collector | leave unconnected (no-connect flag) |
| 8 | VSS | Ground | GND |
| 9 | ~{CHG} | Charge-status open-drain | CHG LED circuit |
| 10 | OUT | System output (power path out) | net VSYS |
| 11 | OUT | System output (dup) | net VSYS (tied to pin 10 internally) |
| 12 | ILIM | Input current limit set | R_ILIM (1.1kΩ to GND) |
| 13 | IN | Input from USB rail | net VBUS |
| 14 | TMR | Safety timer | GND (timer disabled) |
| 15 | ITERM | Termination current | leave unconnected (no-connect flag) — default behaviour |
| 16 | ISET | Charge current set | R_ISET (910Ω to GND) |
| 17 | VSS | Ground (dup) | GND |

> Pin 17 is a second VSS pad (exposed pad / thermal pad region). Wire it to GND.
> Pins 2 and 3 both say "BAT" — both must be on net VBAT in KiCad.
> Pins 10 and 11 both say "OUT" — both must be on net VSYS in KiCad.

### TPS61022 — Converter_DCDC.kicad_sym line 108329

| Pin # | Name | Function | Connect to |
|---|---|---|---|
| 1 | GND | Ground | GND |
| 2 | SW | Switch node | one end of inductor L1 |
| 3 | VOUT | Output | net +5V_LED |
| 4 | FB | Feedback | FB divider tap (R28 top, R29 bottom) |
| 5 | EN | Enable | SW1 common → VSYS (when ON); R26 100kΩ to GND |
| 6 | MODE | PWM/PFM mode select | GND (force PWM for stable frequency) |
| 7 | VIN | Input | net VSYS |

> VIN (pin 7) and SW (pin 2) are at the top of the symbol box; GND (pin 1) at the bottom.
> VOUT (pin 3) and FB (pin 4) are on the right; EN (pin 5) and MODE (pin 6) are on the left.

### AMS1117-3.3 — Regulator_Linear.kicad_sym line 2602 (extends AP1117-15)

| Pin # | Name | Function | Connect to |
|---|---|---|---|
| 1 | GND | Ground / Adjust | GND |
| 2 | VO | Output | net +3.3V |
| 3 | VI | Input | net +5V_LED |

> SOT-223 footprint. Tab (pin 2, exposed pad) is the output — already tied to VO internally.

### Switch:SW_SPDT — Switch.kicad_sym line 23618

| Pin # | Name | Function |
|---|---|---|
| 1 | A | Pole position 1 (ON contact) |
| 2 | B | Common (the wiper / blade) |
| 3 | C | Pole position 2 (OFF contact) |

> For our use: B (pin 2) = VSYS input; A (pin 1) = output to TPS61022 EN; C (pin 3) = leave unconnected (no-connect flag).
> The physical MSK12C02 slides between B→A (ON) and B→C (OFF).

### Connector_Generic:Conn_01x02 — Connector_Generic.kicad_sym line 134

| Pin # | Name | Connect to |
|---|---|---|
| 1 | Pin_1 | VBAT (battery positive) |
| 2 | Pin_2 | GND (battery negative) |

### Device:L — Device.kicad_sym line 52588

| Pin # | Name | Connect to |
|---|---|---|
| 1 | 1 | TPS61022 SW (pin 2) |
| 2 | 2 | +5V_LED (VOUT rail) |

### Device:LED — Device.kicad_sym line 52766

| Pin # | Name | Notes |
|---|---|---|
| 1 | K | Cathode |
| 2 | A | Anode |

---

## Step 0 — Delete v1 Leftovers BT1 and D3

The schematic carries two v1 symbols that no longer belong in v2:

- **BT1** (`Device:Battery_Cell`) — the v1 battery placeholder. In v2 the battery connects via
  the JST connector J5. BT1 is currently wired to the local wire labeled `BAT` at schematic
  coordinates ~(509, 89). Its positive pin is on net `BAT` which connects to the top of
  the R14/R15 battery divider.
- **D3** — described in the old design notes as a Schottky diode but is NOT present in the
  current v2 schematic file (confirmed by grep — no D_Schottky or "D3" reference found).
  The original instruction to delete D3 was proactive; skip this action if you do not find D3 on screen.

**How to delete BT1:**
1. Click BT1 to select it.
2. Press Delete (or right-click → Delete).
3. The dangling wire stub labeled `BAT` near where BT1 was will remain — **do not delete it yet**.
   You will relabel it `VBAT` in Step 1 below.

> If D3 appears on your screen: select it and press Delete. If it is absent, move on.

---

## Step 1 — Re-label BAT → VBAT and Update R14/R15 Divider

The battery divider R14 (220kΩ) and R15 (100kΩ) already exist. Their top node (where BT1
was connected) is currently labeled `BAT`. Rename it to `VBAT` to match the v2 net contract.

**Steps:**
1. Double-click the local label `BAT` (near the top of R14). The label editor opens.
2. Change the text from `BAT` to `VBAT`. Press OK.
3. Verify: R14 pin 1 should now be on net `VBAT`, R14 pin 2 → `VBAT_MON`, R15 pin 1 →
   `VBAT_MON`, R15 pin 2 → GND. No rewiring needed — only the label name changes.

```
VBAT ──── R14 (220k) ──── VBAT_MON ──── R15 (100k) ──── GND
```

> This net name change is what the check script verifies: R14 pin 1 must be on VBAT,
> not BAT.

---

## Cluster 1 — Battery Connector J5

Place the 2-pin JST-XH connector that the physical battery plugs into.

### Steps

1. **Place symbol** — Add Symbol → search `Conn_01x02` (library: Connector_Generic).
   - Reference: `J5`
   - Value: `B2B-XH-A`
   - Footprint: `Connector_JST:JST_XH_B2B-XH-A_1x02_P2.50mm_Vertical` (set later)

2. **Pin 1 → VBAT:**
   Wire J5 pin 1 (Pin_1) to net label `VBAT`. This connects the battery positive terminal
   to the VBAT net (and to U9 BAT and to R14 divider top, all via the same net).

3. **Pin 2 → GND:**
   Wire J5 pin 2 (Pin_2) to a `GND` power symbol.

```
J5 pin 1 (Pin_1) ──── VBAT
J5 pin 2 (Pin_2) ──── GND
```

---

## Cluster 2 — BQ24074RGT Charger U9

This is the power-path charger. USB power comes in via VBUS, the battery connects to VBAT,
and the regulated system output goes to VSYS.

### Steps

1. **Place symbol** — Add Symbol → search `BQ24074RGT` (library: Battery_Management).
   - Reference: `U9`
   - Value: `BQ24074RGTR`
   - Footprint: `Package_DFN_QFN:QFN-16-1EP_3x3mm_P0.5mm_EP1.45x1.45mm` (set later)

2. **IN pin (pin 13) → VBUS:**
   Wire pin 13 to net label `VBUS`.
   Place decoupling capacitor `C20` (value `10µF`, note: 10V X5R 0805 or 1206) between VBUS
   and GND, close to pin 13.

   ```
   VBUS ──+── U9 pin 13 (IN)
          |
         [C20 10µF]
          |
         GND
   ```

3. **OUT pins (pins 10, 11) → VSYS:**
   Wire both pin 10 and pin 11 to net label `VSYS`.
   Place decoupling capacitor `C21` (value `10µF`, 10V X5R 0805) between VSYS and GND.
   Add `PWR_FLAG` power symbol on net VSYS (Add Power Port → search `PWR_FLAG`) to suppress
   ERC "power pin not driven" warning on the new net.

   ```
   U9 pin 10 (OUT) ──+── VSYS
   U9 pin 11 (OUT) ──'
                      |
                     [C21 10µF]
                      |
                     GND
   ```

4. **BAT pins (pins 2, 3) → VBAT:**
   Wire both pin 2 and pin 3 to net label `VBAT`.
   Add `PWR_FLAG` power symbol on net VBAT to suppress ERC warning.

   ```
   U9 pin 2 (BAT) ──+── VBAT
   U9 pin 3 (BAT) ──'
   ```

5. **VSS pins (pins 8, 17) → GND:**
   Wire both pin 8 and pin 17 to `GND` power symbols.

6. **~{CE} pin (pin 4) → GND:**
   Tie pin 4 directly to GND. This holds the charge-enable signal low (active-low),
   meaning the charger is always enabled when USB is present and battery is connected.

   ```
   U9 pin 4 (~{CE}) ──── GND
   ```

7. **EN1 / EN2 strapping — external ILIM mode:**
   Per SOURCING.md: EN1=L (GND), EN2=H (+3.3V) → selects the external ILIM resistor mode.
   - Wire pin 6 (EN1) to `GND`.
   - Wire pin 5 (EN2) to the existing `+3.3V` power net.

   > Warning: +3.3V comes from U11 (LDO), which you are placing in Step 4 of this guide.
   > You can place the +3.3V power symbol on EN2 now; it will connect automatically once
   > U11 is wired. KiCad does not require components to be placed in power-flow order.

   ```
   U9 pin 6 (EN1) ──── GND
   U9 pin 5 (EN2) ──── +3.3V
   ```

8. **ISET pin (pin 16) → 910Ω → GND:**
   Place resistor `R28` (value `910Ω` 1% 0603).
   - Pin 1 of R28 → U9 pin 16 (ISET)
   - Pin 2 of R28 → GND

   This sets charge current = 890/910 ≈ 0.978A (≈2% below 1A target — acceptable).

   ```
   U9 pin 16 (ISET) ──── R28 (910Ω) ──── GND
   ```

   > BOM note: 910Ω is an E24 value. Use LCSC C21190-family 0603 or equivalent Extended
   > 1% part. Verify at BOM stage. See SOURCING.md §Additional Resistors.

9. **ILIM pin (pin 12) → 1.1kΩ → GND:**
   Place resistor `R29` (value `1.1kΩ`, LCSC C22764, Basic).
   - Pin 1 of R29 → U9 pin 12 (ILIM)
   - Pin 2 of R29 → GND

   This sets input current limit = 1610/1100 = 1.46A (within spec; 1.0kΩ would be out-of-spec).

   ```
   U9 pin 12 (ILIM) ──── R29 (1.1kΩ) ──── GND
   ```

10. **TS pin (pin 1) → 10kΩ → GND:**
    The battery has no NTC thermistor. A fixed 10kΩ keeps the TS pin in the "normal
    temperature" window, preventing a spurious temperature fault.
    Place resistor `R30` (value `10kΩ`, LCSC C25804, Basic).
    - Pin 1 of R30 → U9 pin 1 (TS)
    - Pin 2 of R30 → GND

    ```
    U9 pin 1 (TS) ──── R30 (10kΩ) ──── GND
    ```

11. **TMR pin (pin 14) → GND:**
    Tie pin 14 directly to GND to disable the safety timer.

    ```
    U9 pin 14 (TMR) ──── GND
    ```

12. **ITERM pin (pin 15) → no-connect:**
    Place a no-connect (X) flag on pin 15. The default termination current behaviour is used.

13. **~{PGOOD} pin (pin 7) → no-connect:**
    Place a no-connect (X) flag on pin 7. Power-good is not monitored in v2.

14. **~{CHG} pin (pin 9) → CHG LED circuit:**
    The CHG pin is open-drain. It pulls LOW when the battery is charging.
    The pull-up comes from OUT (VSYS, ~4.0–4.4V) through a 1kΩ resistor and red LED.

    Place resistor `R25` (value `1kΩ`, LCSC C21190, Basic):
    - R25 pin 1 → net `VSYS` (the OUT rail, ~4.4V — this is the pull-up supply)
    - R25 pin 2 → D4 pin 2 (Anode)

    Place LED `D4` (Device:LED, value `KT-0603R`, Basic LCSC C2286 — red 0603):
    - D4 pin 2 (A, Anode) → R25 pin 2
    - D4 pin 1 (K, Cathode) → U9 pin 9 (~{CHG})

    When charging: U9 pulls CHG low → current flows VSYS→R25→D4→GND through U9 open-drain → LED lights RED.
    When not charging: CHG floats high → LED off.

    ```
    VSYS ──── R25 (1kΩ) ──── D4 Anode (pin 2)
                               D4 Cathode (pin 1) ──── U9 pin 9 (~{CHG})
    ```

    > Note: The datasheet says pull-up from OUT pin, which in KiCad's symbol is named OUT
    > but is on net VSYS. Use the VSYS net label — do NOT connect to the +5V_LED or +3.3V rail.

---

## Cluster 3 — TPS61022 Boost Converter U10 + Inductor L1

The boost converts VSYS (battery-level ~3.0–4.2V) up to +5V_LED for the WS2812B LEDs.
SW1 (slide switch) controls the EN pin — OFF = boost disabled, ON = boost enabled.

### Steps

1. **Place symbol** — Add Symbol → search `TPS61022` (library: Converter_DCDC).
   - Reference: `U10`
   - Value: `TPS61022RWUR`
   - Footprint: `Package_DFN_QFN:Texas_RWU0007A_VQFN-7_2x2mm_P0.5mm` (already set in symbol)

2. **VIN (pin 7) → VSYS:**
   Wire pin 7 to net label `VSYS`.
   Place input decoupling capacitor `C22` (value `10µF`, 10V X5R 0805) between VSYS and GND,
   placed physically close to pin 7.

   ```
   VSYS ──+── U10 pin 7 (VIN)
          |
         [C22 10µF]
          |
         GND
   ```

3. **GND (pin 1) → GND:**
   Wire pin 1 to `GND`.

4. **MODE (pin 6) → GND:**
   Tie pin 6 to GND to force PWM mode (stable switching frequency — better for EMC and
   predictable inductor behaviour).

   ```
   U10 pin 6 (MODE) ──── GND
   ```

5. **Inductor L1:**
   Place symbol `Device:L` with:
   - Reference: `L1`
   - Value: `1µH APH0420T1R0M`
   - Footprint: an SMD 4.4×4.2mm footprint matching APH0420T1R0M (set later)

   Wire the inductor between SW and VOUT:
   - L1 pin 1 → U10 pin 2 (SW)
   - L1 pin 2 → net +5V_LED

   ```
   U10 pin 2 (SW) ──── L1 pin 1
                        L1 pin 2 ──── +5V_LED
   ```

6. **VOUT (pin 3) → +5V_LED:**
   Wire pin 3 to the existing net `+5V_LED`.
   Place output capacitors:
   - `C23` (value `100µF`, 10V SMD electrolytic or polymer): between +5V_LED and GND
   - `C24` (value `22µF`, 10V X5R 0805): between +5V_LED and GND
   - `C25` (value `22µF`, 10V X5R 0805): between +5V_LED and GND

   Place all three close together on the +5V_LED net.

   ```
   +5V_LED ──+── U10 pin 3 (VOUT)
             ├── L1 pin 2 (inductor output end)
             ├──[C23 100µF]── GND
             ├──[C24 22µF]──  GND
             └──[C25 22µF]──  GND
   ```

7. **FB voltage divider (pins 4):**
   The feedback divider sets VOUT = 5.10V (VREF=600mV).
   Formula: VOUT = 0.600 × (1 + R1/R2), with R1=750kΩ, R2=100kΩ → VOUT = 5.10V.

   Place R31 (R1, value `750kΩ`, LCSC C23240 Extended — only 6 in stock, order pre-emptively):
   - R31 pin 1 → +5V_LED
   - R31 pin 2 → U10 pin 4 (FB)

   Place R32 (R2, value `100kΩ`, LCSC C25803 Basic):
   - R32 pin 1 → U10 pin 4 (FB)
   - R32 pin 2 → GND

   The junction of R31 and R32 is the FB node (same net as pin 4).

   ```
   +5V_LED ──── R31 (750kΩ) ──+── U10 pin 4 (FB)
                               |
                              R32 (100kΩ)
                               |
                              GND
   ```

   > Stock warning: C23240 (750kΩ) shows only 6 in stock at JLCPCB. If out of stock,
   > use 732kΩ E96 instead → VOUT = 4.99V (equally acceptable). See SOURCING.md.

8. **EN (pin 5) — power switch SW1:**
   The slide switch SW1 connects VSYS to U10 EN when ON. A 100kΩ pulldown holds EN low
   when the switch is OFF.

   **Place slide switch SW1:**
   - Add Symbol → search `SW_SPDT` (library: Switch)
   - Reference: `SW1`
   - Value: `MSK12C02`
   - Footprint: an SMD SPDT slide switch footprint matching MSK12C02 8×2.8mm (set later)

   Wire SW1:
   - SW1 pin 2 (B, common/wiper) → net `VSYS`
   - SW1 pin 1 (A, ON contact) → a short wire that connects to both U10 pin 5 (EN) and
     to pulldown resistor R26 pin 1
   - SW1 pin 3 (C, OFF contact) → no-connect flag

   Place R26 (value `100kΩ`, LCSC C25803 Basic, same part as R32):
   - R26 pin 1 → SW1 pin 1 / U10 pin 5 (EN) junction
   - R26 pin 2 → GND

   ```
   VSYS ──── SW1 pin 2 (B)
             SW1 pin 1 (A) ──+── U10 pin 5 (EN)
                             |
                            R26 (100kΩ) ──── GND

   SW1 pin 3 (C) ──── (no-connect X)
   ```

   > When SW1 is ON: VSYS (~3.6V) drives EN → VIH ≥ 1.2V satisfied → boost runs.
   > When SW1 is OFF: EN is held at 0V by R26 → boost disabled.

---

## Cluster 4 — AMS1117-3.3 LDO U11 + PWR LED

The LDO takes +5V_LED and produces +3.3V for the ESP32, CH340C, and digital logic.

### Steps

1. **Place symbol** — Add Symbol → search `AMS1117-3.3` (library: Regulator_Linear).
   - Reference: `U11`
   - Value: `AMS1117-3.3`
   - Footprint: `Package_TO_SOT_SMD:SOT-223-3_TabPin2` (already set in symbol)

2. **VI (pin 3, input) → +5V_LED:**
   Wire pin 3 to net `+5V_LED`.
   Place input capacitor `C17` (value `10µF`, 10V X5R 0805) between +5V_LED and GND,
   close to pin 3.

   ```
   +5V_LED ──+── U11 pin 3 (VI)
             |
            [C17 10µF]
             |
            GND
   ```

3. **VO (pin 2, output) → +3.3V:**
   Wire pin 2 to the existing net `+3.3V`.
   Place output capacitor `C18` (value `10µF`, 10V X5R 0805) between +3.3V and GND.

   ```
   U11 pin 2 (VO) ──── +3.3V
                        |
                       [C18 10µF]
                        |
                       GND
   ```

4. **GND (pin 1) → GND:**
   Wire pin 1 to `GND`.

5. **PWR LED D5 + R27:**
   D5 is a green LED: lit = board is powered (LDO is running). It goes from +3.3V through
   a 1kΩ series resistor to GND.

   Place LED `D5` (Device:LED, value `KT-0603G`, Extended LCSC C12624 — green 0603):
   - D5 pin 2 (A, Anode) → R27 pin 2

   Place resistor `R27` (value `1kΩ`, LCSC C21190, Basic):
   - R27 pin 1 → net `+3.3V`
   - R27 pin 2 → D5 pin 2 (Anode)

   Wire D5 pin 1 (K, Cathode) → GND.

   ```
   +3.3V ──── R27 (1kΩ) ──── D5 Anode (pin 2)
                               D5 Cathode (pin 1) ──── GND
   ```

   At 3.3V with a green LED (Vf ≈ 2.1V): I = (3.3−2.1)/1000 ≈ 1.2mA — suitable for
   a low-brightness always-on indicator.

---

## New Component Reference Summary

| Ref | Symbol | Value | LCSC # | Notes |
|---|---|---|---|---|
| U9 | Battery_Management:BQ24074RGT | BQ24074RGTR | C54313 | Charger, QFN-16-EP |
| U10 | Converter_DCDC:TPS61022 | TPS61022RWUR | C915088 | Boost, VQFN-7 |
| U11 | Regulator_Linear:AMS1117-3.3 | AMS1117-3.3 | C6186 | LDO, SOT-223 |
| J5 | Connector_Generic:Conn_01x02 | B2B-XH-A | C158012 | Battery JST-XH 2-pin |
| SW1 | Switch:SW_SPDT | MSK12C02 | C431540 | Power slide switch |
| L1 | Device:L | 1µH APH0420T1R0M | C5349664 | Boost inductor |
| D4 | Device:LED | KT-0603R | C2286 | CHG LED, red, Basic |
| D5 | Device:LED | KT-0603G | C12624 | PWR LED, green |
| R25 | Device:R | 1kΩ | C21190 | CHG LED series R |
| R26 | Device:R | 100kΩ | C25803 | EN pulldown |
| R27 | Device:R | 1kΩ | C21190 | PWR LED series R |
| R28 | Device:R | 910Ω 1% | — | ISET (0.978A); verify E96 stock |
| R29 | Device:R | 1.1kΩ | C22764 | ILIM (1.46A), Basic |
| R30 | Device:R | 10kΩ | C25804 | TS disable, Basic |
| R31 | Device:R | 750kΩ | C23240 | FB R1 (VOUT=5.10V), ⚠ 6 stock |
| R32 | Device:R | 100kΩ | C25803 | FB R2, Basic |
| C17 | Device:C | 10µF 10V X5R | — | U11 input cap |
| C18 | Device:C | 10µF 10V X5R | — | U11 output cap |
| C20 | Device:C | 10µF 10V X5R | — | U9 IN decoupling |
| C21 | Device:C | 10µF 10V X5R | — | U9 OUT (VSYS) decoupling |
| C22 | Device:C | 10µF 10V X5R | — | U10 VIN decoupling |
| C23 | Device:C | 100µF 10V | — | U10 VOUT bulk cap |
| C24 | Device:C | 22µF 10V X5R | — | U10 VOUT ceramic |
| C25 | Device:C | 22µF 10V X5R | — | U10 VOUT ceramic |

> C17 and C18 (the task brief refs) are assigned as U11 in/out caps. C20–C25 are the next
> free caps after C19 (already used by CH340C V3 cap in Task 6).

---

## Net Contract Summary

After wiring, these nets must connect these components:

| Net | Must touch |
|---|---|
| `VBUS` | J4 (existing), U7 (existing), U9 pin 13 (IN) |
| `VSYS` | U9 pins 10+11 (OUT), U10 pin 7 (VIN), SW1 pin 2 (B), R25 pin 1 (CHG LED pull-up) |
| `VBAT` | U9 pins 2+3 (BAT), J5 pin 1, R14 pin 1 (divider top — after relabeling from BAT) |
| `+5V_LED` | U10 pin 3 (VOUT), L1 pin 2, R31 pin 1, C23/C24/C25, U11 pin 3 (VI), (existing: U3, J1) |
| `+3.3V` | U11 pin 2 (VO), R27 pin 1, U9 pin 5 (EN2), (existing: U2, pullups) |
| `GND` | All GND pins |

---

## Summary Checklist

Work through each item top-to-bottom. Tick when done in KiCad.

**Pre-wiring cleanup:**
- [ ] BT1 deleted from schematic
- [ ] D3 absent or deleted (was not found in current v2 schematic — verify visually)
- [ ] Label `BAT` renamed to `VBAT` on top of R14

**J5 — Battery connector:**
- [ ] J5 placed (Connector_Generic:Conn_01x02), ref J5, value B2B-XH-A
- [ ] J5 pin 1 → VBAT
- [ ] J5 pin 2 → GND

**U9 — BQ24074RGT charger:**
- [ ] U9 placed (Battery_Management:BQ24074RGT), ref U9, value BQ24074RGTR
- [ ] U9 pin 13 (IN) → VBUS; C20 10µF decoupling to GND
- [ ] U9 pins 10+11 (OUT) → VSYS; C21 10µF to GND; PWR_FLAG on VSYS
- [ ] U9 pins 2+3 (BAT) → VBAT; PWR_FLAG on VBAT
- [ ] U9 pins 8+17 (VSS) → GND
- [ ] U9 pin 4 (~{CE}) → GND (always enable)
- [ ] U9 pin 6 (EN1) → GND; U9 pin 5 (EN2) → +3.3V
- [ ] U9 pin 16 (ISET) → R28 (910Ω) → GND
- [ ] U9 pin 12 (ILIM) → R29 (1.1kΩ) → GND
- [ ] U9 pin 1 (TS) → R30 (10kΩ) → GND
- [ ] U9 pin 14 (TMR) → GND
- [ ] U9 pin 15 (ITERM) → no-connect X
- [ ] U9 pin 7 (~{PGOOD}) → no-connect X
- [ ] U9 pin 9 (~{CHG}) → D4 cathode; D4 anode → R25 (1kΩ) → VSYS

**SW1 + U10 — Boost converter:**
- [ ] SW1 placed (Switch:SW_SPDT), ref SW1, value MSK12C02
- [ ] SW1 pin 2 (B) → VSYS
- [ ] SW1 pin 1 (A) → U10 pin 5 (EN); R26 (100kΩ) to GND on same node
- [ ] SW1 pin 3 (C) → no-connect X
- [ ] U10 placed (Converter_DCDC:TPS61022), ref U10, value TPS61022RWUR
- [ ] U10 pin 7 (VIN) → VSYS; C22 10µF decoupling to GND
- [ ] U10 pin 1 (GND) → GND
- [ ] U10 pin 6 (MODE) → GND
- [ ] U10 pin 2 (SW) → L1 pin 1; L1 pin 2 → +5V_LED
- [ ] U10 pin 3 (VOUT) → +5V_LED; C23 100µF + C24 22µF + C25 22µF to GND
- [ ] U10 pin 4 (FB) → R31 (750kΩ) to +5V_LED; R32 (100kΩ) to GND

**U11 — AMS1117-3.3 LDO:**
- [ ] U11 placed (Regulator_Linear:AMS1117-3.3), ref U11, value AMS1117-3.3
- [ ] U11 pin 3 (VI) → +5V_LED; C17 10µF to GND
- [ ] U11 pin 2 (VO) → +3.3V; C18 10µF to GND
- [ ] U11 pin 1 (GND) → GND
- [ ] D5 (Device:LED, KT-0603G green) placed; Anode → R27 (1kΩ) → +3.3V; Cathode → GND

---

## Global Labels Used / Reused

| Label | Direction | Notes |
|---|---|---|
| VBUS | power | Existing from Task 6 — reuse |
| +5V_LED | power | Existing — connects to U3 and J1 — reuse, do NOT rename |
| +3.3V | power | Existing — connects to U2 pullups — reuse |
| VSYS | power | New — add PWR_FLAG |
| VBAT | power | Re-labeled from BAT — add PWR_FLAG |

---

## After Wiring: Run the Netlist Check

```bash
python3 hardware/hardware-controller-v2/scripts/check_task7.py
```

All checks should print `OK`. If any print `FAIL`, re-read the net label for that item.

The script auto-exports the netlist from the schematic using kicad-cli, then checks every
connection listed in this guide.
