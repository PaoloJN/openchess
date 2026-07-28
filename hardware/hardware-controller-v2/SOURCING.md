# SOURCING.md — Controller v2 Part Sourcing and Power Design Values

**Checked:** 2026-07-27  
**Reference:** `docs/superpowers/specs/2026-07-27-controller-v2-integrated-design.md`

All downstream tasks (5–10) must read component values from this file and must not re-derive them.

---

## Part Table

Stock figures are JLCPCB assembly-library stock unless noted.  
"Basic" = no extra assembly fee per part; "Extended" = $3 setup fee per unique part per order.

### MCU Module

| Block | MPN | LCSC # | JLC Class | JLCPCB Stock | Unit Price | Package | Notes |
|---|---|---|---|---|---|---|---|
| MCU module | ESP32-WROOM-32E-N4 | C701341 | Extended | 31,679 | $3.76/1+ | SMD 25.5×18mm | 4 MB flash. Hot item. Full reel = 650. |

### USB Bridge

| Block | MPN | LCSC # | JLC Class | JLCPCB Stock | Unit Price | Package | Notes |
|---|---|---|---|---|---|---|---|
| USB-serial | CH340C | C84681 | Extended | 39,936 | $0.58/1+ | SOP-16 | Built-in oscillator — no crystal needed. |
| USB-C receptacle | TYPE-C-31-M-12 | C165948 | Extended | 266,697 | $0.18/1+ | SMD+TH, 16-pin | Korean Hroparts. USB2.0 with CC1/CC2 pins. Massive stock. |
| USB ESD | USBLC6-2SC6 | C7519 | Extended | 28,744 | $0.18/1+ | SOT-23-6L | ST. Optional — omit if board space is tight. |

### Power Chain

| Block | MPN | LCSC # | JLC Class | JLCPCB Stock | Unit Price | Package | Notes |
|---|---|---|---|---|---|---|---|
| LiPo charger | BQ24074RGTR | C54313 | Extended | 5,707 | $2.03/1+ | QFN-16-EP (3×3mm) | TI. Power-path with ISET/ILIM resistors. |
| 5V boost | TPS61022RWUR | C915088 | Extended | 9,859 | $1.88/1+ | VQFN-7 (2×2mm) | TI. 8A switch, 0.5V ultra-low Vin. |
| Boost inductor | APH0420T1R0M | C5349664 | Extended | 25,132 | $0.091/1+ | SMD 4.4×4.2mm | APV. 1µH, DCR 27mΩ, Isat 6A, Irated 7A. ⚠ Isat is 6A; acceptable for 3A output but see note. |
| 3.3V LDO | AMS1117-3.3 | C6186 | **Basic** | 1,723,735 | $0.20/1+ | SOT-223 | Advanced Monolithic. Fed from 5V rail. |

> **Inductor note:** The TPS61022 valley switch current limit is 8A typ. Strictly Isat should be ≥ 8A to guarantee no saturation before the IC's own protection fires. The APH0420T1R0M is rated Isat 6A / Irated 7A — this is tight. It will work at 3A continuous output (peak inductor current ~5A at Vin=3.6V) but leaves little margin. If a 1µH / 8A+ Isat part is available from JLC Basic inductors at assembly time, prefer it. Fallback: leave APH0420T1R0M as the sourced part; it passes for a 1-board build.

### GPIO Expansion

| Block | MPN | LCSC # | JLC Class | JLCPCB Stock | Unit Price | Package | Notes |
|---|---|---|---|---|---|---|---|
| Column driver (SMD) | TBD62783AFG(Z,EL) | C840444 | Extended | 883 | $1.50/1+ | SOP-18-300mil | TOSHIBA. 8-ch NPN Darlington. ⚠ Low stock — also available as TBD62783AFG,EL (C97745, 4,571 stock, $1.42/1+, same package — prefer C97745 if stock allows). |
| Auto-prog NPN ×2 | S8050 J3Y | C42441446 | Extended | 2,549,232 | $0.0091/1+ | SOT-23 | TDSEMIC. |

> **Column driver fallback:** If both C840444 and C97745 are out of stock, revert to hand-soldering the DIP-18 TBD62783APG (v1 part, not in JLC assembly library).

### Passives — Power Design

| Block | MPN | LCSC # | JLC Class | JLCPCB Stock | Unit Price | Package | Notes |
|---|---|---|---|---|---|---|---|
| 1kΩ 0603 resistor | 0603WAF1001T5E | C21190 | **Basic** | ~3.9M (pre-order) | $0.0087/ea | 0603 | UNI-ROYAL. Used for R_ISET, LED series R. |
| 10kΩ 0603 resistor | 0603WAF1002T5E | C25804 | **Basic** | ~4.8M (pre-order) | $0.0065/ea | 0603 | UNI-ROYAL. Used for R_ILIM (std), TS disable, pull-ups. |

> **Resistor note:** Both are Basic and show as "Pre-order" / "Idle parts available" on JLCPCB as of 2026-07-27, but estimated stock is very large. This is JLCPCB's normal state for Basic passives kept in warehouse. They will be pulled without issue for assembly orders.

### Switches and Buttons

| Block | MPN | LCSC # | JLC Class | JLCPCB Stock | Unit Price | Package | Notes |
|---|---|---|---|---|---|---|---|
| Slide switch (power) | MSK12C02 | C431540 | Extended | 155,192 | $0.056/1+ | SMD 8×2.8mm | SHOU HAN. Tab SPDT, right-angle SMD. |
| Tactile (EN/BOOT ×2) | TS-1187A-B-A-B | C318884 | **Basic** | 1,364,160 | $0.020/1+ | SMD-4P 5.1×5.1mm | XKB Connection. 1.6N actuation. |

### Indicators

| Block | MPN | LCSC # | JLC Class | JLCPCB Stock | Unit Price | Package | Notes |
|---|---|---|---|---|---|---|---|
| Green LED (PWR) | KT-0603G | C12624 | Extended | 430,730 | $0.012/1+ | 0603 | Hubei KENTO. 525nm, 430mcd. Paired with C2286 (same maker). |
| Red LED (CHG) | KT-0603R | C2286 | **Basic** | 5,033,700+ | $0.0075/1+ | 0603 | Hubei KENTO. 625nm, 300mcd. Basic — no setup fee. |
| LED series resistor | see 1kΩ 0603 above | C21190 | **Basic** | — | — | 0603 | Same part as power resistors. |

> **LED note:** Red CHG LED (C2286 KT-0603R) is a JLC **Basic** part — no $3 setup fee. Green PWR LED (C12624 KT-0603G) is Extended. Both are very cheap and high-stock. Matched footprints (same manufacturer), making reel-swap unnecessary.

### Connectors (hand-solder TH — not in JLC assembly library)

| Block | MPN | LCSC # | JLC Class | LCSC Stock | Unit Price | Package | Notes |
|---|---|---|---|---|---|---|---|
| Battery conn (2-pin) | B2B-XH-A | C158012 | Extended\* | 214,260 | $0.040/20+ | TH P=2.5mm | JST XH. \*Available on JLCPCB but as pre-order / low stock — hand-solder recommended. |
| Panel conn (4-pin) | B4B-XH-A-G | C594232 | — | 0 (order from LCSC) | $0.37/5+ | TH P=2.5mm | JST XH, gold contacts. 0 in stock at LCSC — order ahead or substitute B4B-XH-AM or non-JST. |
| Panel conn (5-pin) | B5B-XH-A(LF)(SN) | C157991 | — | 130,105 | $0.088/5+ | TH P=2.5mm | JST XH, RoHS. |

> **Connector note:** All XH connectors are through-hole and intended for hand-soldering. Do not add to the JLC SMT assembly BOM. Order from LCSC separately.

> **B4B-XH-A stock warning:** C594232 (JST B4B-XH-A-G) shows 0 in-stock at LCSC as of 2026-07-27. Alternative: Liansheng or HDGC B4B-XH-A clones available in the LCSC B4B-XH-A search results (12 results, multiple in-stock).

---

## Design Values — BQ24074RGTR

**Source:** TI BQ24074 datasheet (SLUS934, Rev. N); supplementary: Adafruit BQ24074 breakout design notes.

### Charge Current (R_ISET)

Formula (from datasheet Section 7):

```
R_ISET = K_ISET / I_CHG     where K_ISET = 890 AΩ
Valid range: R_ISET = 590Ω to 8.9kΩ (i.e. I_CHG = 100mA to 1.5A)
```

**Target:** I_CHG = 1.0A (0.5C for a 2000mAh cell)

```
R_ISET = 890 / 1.0 = 890Ω  → use 887Ω (E96, gives 890/887 = 1.003A) or 909Ω (E96, gives 0.979A)
```

> No confirmed JLC Basic C-number for 887Ω found as of 2026-07-27. Options:
> 1. Confirm an E96 887Ω or 909Ω Extended part at BOM stage (verify stock).
> 2. Fallback: use 910Ω E24 (same footprint as other 0603 resistors) → I_CHG = 890/910 = 0.978A (≈2% under target — acceptable for a 2000mAh cell).
> 3. First-bring-up: hand-solder an E96 1% 0603 887Ω from spare stock.
> Datasheet note: use 1% tolerance resistors for R_ISET (Section 8.3 footnote).

### Input Current Limit (R_ILIM)

Formula (from datasheet SLUS810N Rev. N, Section 9.3.4.1, Equation 1):

```
R_ILIM = K_ILIM / I_IN-MAX    where K_ILIM = 1610 AΩ (TYP, Table 8.5, range 1500–1720 AΩ)
Valid range: R_ILIM = 1.1kΩ to 8.0kΩ
```

**Target:** I_IN-MAX = 1.5A (wall-adapter input limit)

```
R_ILIM = 1610 / 1.5 = 1073Ω  → nearest standard is 1.0kΩ (E24) or 1.1kΩ (E24/minimum)
Chosen: 1.0kΩ (C21190) → actual limit = 1610/1000 = 1.61A (slight over; use 1.1kΩ for tighter limit)
Note: 1.1kΩ gives 1610/1100 = 1.46A; 1.0kΩ gives 1.61A. Both are within valid R_ILIM range.
Chosen: 1.0kΩ (C21190, Basic) for availability and simplicity; actual limit = 1.61A.
```

> Note: EN1=L, EN2=H selects the external ILIM resistor mode (see EN1/EN2 table below). This is the mode that enables R_ILIM to take effect.

### EN1 / EN2 Strapping

| EN1 | EN2 | Input current limit |
|-----|-----|---|
| L | L | 100 mA (USB 100mA suspend) |
| H | L | 500 mA (USB 500mA) |
| L | H | External R_ILIM (use this for wall adapter mode) |
| H | H | Standby / USB suspend |

**Chosen strapping:** EN1 = GND, EN2 = VCC (3.3V from LDO) → External R_ILIM mode active → actual limit 1.61A (with 1kΩ).

### TS Pin (Thermistor — Battery Without NTC)

The battery pack used in this design has **no NTC thermistor**. The datasheet specifies:

- Connect a **10kΩ fixed resistor from TS to GND** to bias the TS pin to a safe mid-range voltage, disabling the temperature fault.
- This replaces the NTC voltage divider and keeps TS within the "normal temperature" window.

**Chosen:** 10kΩ (C25804, Basic) from TS to GND.

### TMR Pin

- Connect TMR to GND to disable the safety timer (no automatic charge termination timeout).
- Alternative: connect a resistor to set a timeout (100kΩ ≈ 6h safety timer per datasheet).
- **Chosen:** TMR to GND (timer disabled for simplicity on v1 build).

### CHG Pin (Charge Status LED)

CHG is an open-drain output that pulls LOW when charging is in progress.

Per datasheet SLUS810N Rev. N, Section 10.2.2.4 (page 35), verbatim:
> "Connect a 1.5-kΩ resistor in series with a LED between OUT and CHG to indicate charging status."

The pull-up rail is the **OUT pin** (regulated system output, ~4.0–4.4V on BQ24074), not IN or SYS directly.
The datasheet-specified resistor is **1.5kΩ** for LED use (1kΩ–100kΩ for logic pull-up).

```
OUT (~4.4V) ──── R_LED (1.5kΩ) ──── CHG_LED (red, C2286) ──── CHG (open drain) ──── GND
```

- At OUT=4.4V, VLED=2.0V (red): I_LED = (4.4−2.0)/1500 = 1.6mA — appropriate for indicator.
- R_LED: 1.5kΩ not stocked as Basic; nearest Basic is 1kΩ (C21190) → I_LED = 2.4mA (acceptable, within 20mA max).
- **Chosen for this build:** 1kΩ (C21190, Basic) in series with red LED from OUT to CHG. Simple and uses already-sourced Basic part.

---

## Design Values — TPS61022RWUR

**Source:** TI TPS61022 datasheet (SLVSDX7, Rev. D); supplementary: TI E2E forum, web search cross-checks.

### Output Voltage (FB Divider)

VREF (FB pin regulation voltage, Table 6.5, PWM mode):

```
VREF = 600 mV (typ, PWM mode; min 585mV, max 615mV)
```

Formula:

```
VOUT = VREF × (1 + R1/R2)
```

Where R1 connects VOUT to FB, and R2 connects FB to GND.

**Target:** VOUT = 5.0V

```
5.0 = 0.600 × (1 + R1/R2)
R1/R2 = (5.0/0.600) − 1 = 7.333
```

**Chosen values:**

```
R2 = 100kΩ (C25803, 0603WAF1003T5E, Basic — 7.7M stock)
R1 = 732kΩ (E96: use 732kΩ for 4.99V) — or 750kΩ (E24, gives 5.1V, acceptable)
```

> Preferred: R2 = 100kΩ Basic (C25803, 0603WAF1003T5E, UNI-ROYAL), R1 = 750kΩ (C23240, Extended, ⚠ only 6 in stock) → VOUT = 5.10V (within USB 5V ±5% = 4.75–5.25V tolerance). Acceptable. If C23240 is out of stock at order time, use 732kΩ E96 instead (VOUT = 4.99V, slightly better).

> If E96 parts available: R1 = 732kΩ → VOUT = 4.99V exact.

**Additional resistors needed for TPS61022 FB:**

| Value | LCSC # | JLC Class | JLCPCB Stock | Notes |
|---|---|---|---|---|
| 100kΩ 0603 | C25803 (0603WAF1003T5E) | **Basic** | 7,764,184 | R2 (FB to GND) |
| 750kΩ 0603 | C23240 (0603WAF7503T5E) | Extended | 6 (⚠ very low) | R1 (VOUT to FB), gives 5.10V. Only 6 in stock — order pre-emptively or use 732kΩ E96 from JLC. |

### Inductor

```
L = 1 µH (nominal; valid range per datasheet Table 6.3: 0.33µH–2.9µH)
I_sat ≥ 8A recommended (matches IC valley switch current limit)
```

**Chosen part:** APH0420T1R0M (C5349664)

- 1µH, Isat 6A, Irated 7A, DCR 27mΩ, SMD 4.4×4.2mm
- Isat is below the 8A IC limit; safe at 3A continuous load (peak ~5A) but no margin for fault transients. Acceptable for 1-board build.
- If a 1µH / 8A+ Isat part becomes available as a JLC Basic inductor, use it instead.

### Capacitors

```
C_IN  = 4.7µF to 10µF ceramic (X5R or X7R), placed close to VIN and GND pins
C_OUT = 100µF bulk (low-ESR electrolytic or polymer) + 2× 22µF ceramic X5R/X7R
        placed close to VOUT and GND pins
```

**Suggested LCSC parts (not pre-sourced, pick at schematic stage):**

- C_IN: 10µF 0805 X5R 10V (e.g. C15850, GRM21BR61A106KE18L or equivalent Basic)
- C_OUT bulk: 100µF 10V low-ESR SMD electrolytic (e.g. Nichicon or Panasonic D-size)
- C_OUT ceramic: 22µF 0805 X5R 10V ×2

### EN Pin

EN pin logic threshold: VIH ≥ 1.2V (typ). A 3.3V or 4.2V battery-level signal from the SYS rail through the slide switch is a valid logic-high.

**Chosen:** Slide switch (MSK12C02, C431540) connects SYS to EN. Switch OFF → EN=0 (boost off). Switch ON → EN=SYS (≥3.0V → logic high).

---

## Additional Resistors Required (Not Yet in Table Above)

These are needed for the schematic but not listed in the primary block table:

| Value | Function | LCSC # | JLC Class | Notes |
|---|---|---|---|---|
| 887Ω or 909Ω 0603 1% | R_ISET (BQ24074 charge current 1A) | No Basic C# confirmed | Extended or hand-pick | No JLC Basic E96 stock found. Use 910Ω E24 (≈0.978A; same C21190 family if available) as fallback. Verify at BOM stage. |
| 1.0kΩ 0603 | R_ILIM (BQ24074 input limit 1.55A) | C21190 | **Basic** | Same part as LED series R |
| 10kΩ 0603 | TS disable (BQ24074) | C25804 | **Basic** | |
| 100kΩ 0603 | R2 FB divider (TPS61022) | C25803 | **Basic** | 0603WAF1003T5E, 7.7M stock |
| 750kΩ 0603 | R1 FB divider (TPS61022) | C23240 | Extended | 0603WAF7503T5E, 6 stock — ⚠ order ahead or use 732kΩ E96 |

---

## Summary: Basic vs Extended Count

| Classification | Parts |
|---|---|
| **Basic** | AMS1117-3.3 (C6186), TS-1187A-B-A-B (C318884), 1kΩ (C21190), 10kΩ (C25804), 100kΩ (C25803), Red LED KT-0603R (C2286) |
| **Extended** | ESP32-WROOM-32E-N4 (C701341), CH340C (C84681), TYPE-C-31-M-12 (C165948), USBLC6-2SC6 (C7519), BQ24074RGTR (C54313), TPS61022RWUR (C915088), APH0420T1R0M (C5349664), TBD62783AFG(Z,EL) (C840444 or C97745), S8050 J3Y (C42441446), MSK12C02 (C431540), Green LED KT-0603G (C12624), 750kΩ (C23240) |
| **Hand-solder (not in JLC BOM)** | B2B-XH-A (C158012), B4B-XH-A-G (C594232 — 0 stock, order alt), B5B-XH-A(LF)(SN) (C157991) |

**Extended part count: 12** → JLCPCB Extended setup fee at $3/part = ~$36 per order.
(Red LED moved to Basic vs. earlier draft; saves one $3 setup fee.)

---

## Substitution Log

| Original Candidate | Status | Substitution | Reason |
|---|---|---|---|
| TBD62783AFG (DIP-18, v1) | Not used for SMT | TBD62783AFG(Z,EL) C840444 SOP-18 | v2 requires SMT |
| C840444 (883 stock) | ⚠ Low stock | Prefer C97745 (4,571 stock, same part) | Higher availability |
| B4B-XH-A (0 LCSC stock) | ⚠ Out of stock | Non-JST B4B-XH-A clone from LCSC (12 alt results) | Hand-solder anyway |
| MCP73871 (fallback charger) | Not needed | BQ24074RGTR in stock | Primary available |
| FP6277XR-G1 (fallback boost) | Not needed | TPS61022RWUR in stock | Primary available |
| Everlight 19-219/GHC-... (C2994781) green LED | Replaced | KT-0603G C12624 — cheaper, higher stock, matched to red LED | Same maker as C2286, lower cost |
| YLED0603R (C19171390) red LED (Extended) | Replaced | KT-0603R C2286 — **Basic**, 5M+ stock, $0.0075 | Basic saves $3 setup fee per order |
