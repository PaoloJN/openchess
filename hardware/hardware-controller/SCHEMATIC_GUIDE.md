# Controller Schematic — Hand-Drawing Guide

This is the build sheet for the OpenChess controller schematic. Every
component, every pin, every net is listed below. Work through the
sections in order; you can ERC-check after each one to keep errors
short.

The Python schematic generators under `scripts/sch/` are **archived** —
do not run them on this board anymore. They stay in the repo as
reference for the matrix and control-panel boards.

---

## 0. Setup

### Back up and start fresh

Before anything else:

```bash
cd /Users/paolonessim/Projects/openchess/hardware/hardware-controller
cp openchess-controller.kicad_sch openchess-controller.kicad_sch.scripted_backup
```

Open `openchess-controller.kicad_sch` in KiCad. You have three options:

1. **Nuke and rebuild (recommended)** — Edit → Select All → Delete. Keeps page setup + title block + lib_symbols cache. Draw everything from this guide.
2. **Salvage the easy bits** — keep J1 (J_MAIN), R1–R8 (row pullups), the
   PWR_FLAG symbols, the test points + mounting holes. Delete everything
   else (the bad chunk-06 placement). Then add new sections from this
   guide starting at Section D.
3. **Burn it down** — delete the `.kicad_sch` file, create new with
   File → New Schematic. Recreate title block manually.

Recommend option 1.

### Disable the script pipeline

So you don't accidentally re-assemble over your work:

```bash
mv scripts/sch scripts/sch.archived
mkdir -p scripts/sch
echo "Scripts archived 2026-06-05 — controller maintained by hand in KiCad GUI." > scripts/sch/README.md
```

(Optional but strongly suggested. Otherwise a stray `python3 scripts/sch/...` wipes your work.)

---

## 1. Conventions used in this guide

### Power vs net labels

- **Power port** symbol (KiCad shortcut `P`) → used for `+3V3` and `GND`.
  These are standard rails; the power-port symbol is visually distinct
  and tells the reader "this is a rail."
- **Net label** (KiCad shortcut `L`) → used for everything else
  (`+5V_LED`, `LED_DATA_5V`, `S0..S7`, `CA_PWR..CH_PWR`, `BTN_*`,
  `LED_*_N`, `COL_DRV_*`, `PANEL_SPARE`, `LED_DATA`, `BTN_RESET`).
- **No-Connection flag** (shortcut `Q`) → on any IC pin you do not
  intend to use. ERC complains about unflagged unused pins.

### Power port library names

In KiCad's symbol picker (`A`), the `power` library has these standard
symbols you'll use:

- `GND` — the only ground symbol you need
- `+3V3` — the 3.3 V rail from our LDO
- (Do **not** use `+5V` — our 5 V rail has a custom name `+5V_LED` and
  must be a net label, not a power port.)

### KiCad shortcuts you'll use constantly

| Key      | Action                      |
| -------- | --------------------------- |
| `A`      | Add symbol                  |
| `W`      | Add wire                    |
| `L`      | Add net label               |
| `P`      | Add power port              |
| `Q`      | No-connection flag          |
| `R`      | Rotate (during placement)   |
| `Y`      | Mirror across Y axis        |
| `M`      | Move (click first)          |
| `G`      | Drag (keeps wires attached) |
| `E`      | Edit properties             |
| `Esc`    | Cancel current action       |
| `Delete` | Delete selection            |

### Reference designator scheme

Reserved across sections so refs don't collide:

| Range     | Section                                                     |
| --------- | ----------------------------------------------------------- |
| J1        | J_MAIN (matrix connector)                                   |
| J2        | USB-C receptacle (charging + power)                         |
| J3        | J_PANEL (control panel connector)                           |
| J4        | LiPo battery connector (JST PH 2-pin)                       |
| BT1       | LiPo battery symbol (off-board, documentation only)         |
| U1        | AP2112K-3.3 LDO (+3V3 rail)                                 |
| U2        | ESP32-DevKitC module                                        |
| U3        | 74AHCT125 LED data level shifter                            |
| U4        | BQ24074RGT — USB power-path + LiPo charger                  |
| U5        | MT3608 boost converter (battery → 5V)                       |
| U6        | TBD62783A — 8-channel high-side column driver IC            |
| L1        | Boost converter inductor (4.7–10µH)                         |
| R1–R8     | Matrix row pullups (10k)                                    |
| R9, R10   | USB-C CC1/CC2 pulldowns (5.1k)                              |
| R11       | LED data series resistor (33Ω)                              |
| R12, R13  | MT3608 feedback divider (75k top, 10k bottom → ~5.1V)       |
| R14, R15  | Battery monitor divider (220k top, 100k bottom)             |
| R16       | BQ24074 ISET — fast-charge current set (1.2k → 500mA)       |
| R17       | BQ24074 TS resistor (10k for "no thermistor" mode)          |
| R36, R37  | Panel button pullups (10k)                                  |
| C1, C2    | Bulk caps on +5V_LED (10µF)                                 |
| C3        | LDO input cap (1µF)                                         |
| C4        | LDO output cap (1µF)                                        |
| C5        | 74AHCT125 decoupling (100nF)                                |
| C6        | BQ24074 IN cap (10µF)                                       |
| C7        | BQ24074 BAT cap (10µF)                                      |
| C8        | BQ24074 OUT/SYS cap (10µF)                                  |
| C9        | MT3608 input cap (10µF)                                     |
| C10       | MT3608 output cap (22µF)                                    |
| C11       | TBD62783A bypass cap (100nF)                                |
| C12       | Battery-monitor ADC filter cap (100nF)                      |
| TP1, TP2… | Test points (section H)                                     |
| MH1–MH4   | Mounting holes                                              |
| FID1–FID3 | Fiducials                                                   |

### Page layout zones (matches the chunk-01 boxes)

```
A2 page (594×420 mm), top-left origin

           28          135  145          285  295         430  440         566
           ┌───────────────┐ ┌───────────────┐ ┌──────────────┐ ┌──────────────┐
        50 │  Sec B        │ │  Sec C        │ │  Sec D       │ │  Sec A       │
           │  J_MAIN       │ │  ROW PULLUPS  │ │  ESP32 / LOG │ │  POWER       │
           │  (2x13)       │ │  R1–R8        │ │  J3 + J4     │ │  USB-C + LDO │
       150 │               │ │               │ │              │ │              │
           └───────────────┘ └───────────────┘ └──────────────┘ └──────────────┘
           ┌───────────────────────┐ ┌─────────────────┐ ┌──────────────────────┐
       170 │ Sec F                 │ │ Sec E           │ │ Sec G                │
           │ COLUMN DRIVERS        │ │ LED LEVEL SHIFT │ │ USER UI CONNECTOR    │
           │ Q1..Q8, Q9..Q16,      │ │ U3 74AHCT125    │ │ J5 (J_PANEL 1x10)    │
           │ R12..R35  (8 channels)│ │                 │ │ R36, R37 pullups     │
       285 │                       │ │                 │ │                      │
           └───────────────────────┘ └─────────────────┘ └──────────────────────┘
           ┌──────────────────────────────────────────────────────────────────┐
       305 │ Sec H                                                            │
           │ TEST + MECHANICAL                                                │
           │ TP1..TPn   MH1..MH4   FID1..FID3                                 │
       400 │                                                                  │
           └──────────────────────────────────────────────────────────────────┘
```

If you nuked the schematic, you may want the boxes back as visual
guides. Easiest: re-run `python3 scripts/sch.archived/sch/01_skeleton.py`
once to regenerate them, then **never run anything else from
scripts/sch.archived**.

---

## Section A — Power (USB-C charger + LiPo battery + boost + LDO)

> **Revised 2026-06-05.** The original "USB-C → LDO" power section has
> been replaced with a battery-backed architecture. USB-C charges a
> single LiPo cell through a BQ24074 power-path charger; an MT3608
> boost steps the battery up to a regulated 5V rail; the AP2112K LDO
> produces +3V3 from that 5V. Result: board runs from USB or battery
> seamlessly. See "Migration from previous Section A" at the bottom.

Inside the POWER box (440..566, 50..150 world mm). Suggested layout:

```
USB-C (J2)  ──→  BQ24074 (U4)  ──→  SYS  ──→  MT3608 (U5) + L1  ──→  +5V_LED
                     │   │                                              │
                     │   ↓                                               ├─→ +5V_LED bulk caps (C1, C2)
                     │   BAT ←→ LiPo (J4) ──→ R14/R15 divider ──→ VBAT_MON
                     │                                               (to GPIO34 ADC)
                     │
                     R16 (ISET), R17 (TS), CHG/PGOOD options
                                                                        │
                                                                        ├─→ to TBD62783A VBB
                                                                        ├─→ to 74AHCT125 VCC + C5
                                                                        └─→ AP2112K (U1) ──→ +3V3
                                                                                                │
                                                                                                └─→ C3, C4
```

### A.1 Components

| Ref     | Symbol                                  | Value           | Footprint                                            | Notes                                       |
| ------- | --------------------------------------- | --------------- | ---------------------------------------------------- | ------------------------------------------- |
| J2      | `Connector:USB_C_Receptacle_USB2.0_16P` | USB-C 5V        | `Connector_USB:USB_C_Receptacle_GCT_USB4085`         | Power-only USB-C input                       |
| R9      | `Device:R`                              | 5.1k            | `Resistor_SMD:R_0603_1608Metric`                     | CC1 pulldown (USB-C sink config)            |
| R10     | `Device:R`                              | 5.1k            | `Resistor_SMD:R_0603_1608Metric`                     | CC2 pulldown                                |
| U4      | `Battery_Management:BQ24074RGT`         | BQ24074         | `Package_DFN_QFN:QFN-16-1EP_3x3mm_P0.5mm_EP1.6x1.6mm` | Power-path charger, QFN-16                  |
| R16     | `Device:R`                              | 1.2k            | `Resistor_SMD:R_0603_1608Metric`                     | ISET — sets fast-charge current to ~500 mA  |
| R17     | `Device:R`                              | 10k             | `Resistor_SMD:R_0603_1608Metric`                     | TS — fake thermistor (no-temp-sense mode)   |
| C6      | `Device:C`                              | 10µF            | `Capacitor_SMD:C_0805_2012Metric`                    | BQ24074 IN cap                              |
| C7      | `Device:C`                              | 10µF            | `Capacitor_SMD:C_0805_2012Metric`                    | BQ24074 BAT cap                             |
| C8      | `Device:C`                              | 10µF            | `Capacitor_SMD:C_0805_2012Metric`                    | BQ24074 OUT (SYS) cap                       |
| J4      | `Connector_Generic:Conn_01x02`          | LiPo            | `Connector_JST:JST_PH_S2B-PH-K_1x02_P2.00mm_Horizontal` | LiPo battery, 2-pin JST PH                 |
| BT1     | `Device:Battery_Cell`                   | LiPo 1S 3.7V    | _(no footprint — off-board)_                         | Documentation symbol; mark `(in_bom no)`    |
| R14     | `Device:R`                              | 220k            | `Resistor_SMD:R_0603_1608Metric`                     | Battery monitor top resistor                |
| R15     | `Device:R`                              | 100k            | `Resistor_SMD:R_0603_1608Metric`                     | Battery monitor bottom resistor             |
| C12     | `Device:C`                              | 100nF           | `Capacitor_SMD:C_0603_1608Metric`                    | ADC filter on VBAT_MON                      |
| U5      | `Regulator_Switching:MT3608`            | MT3608          | `Package_TO_SOT_SMD:SOT-23-6`                        | Boost converter                             |
| L1      | `Device:L`                              | 4.7µH           | `Inductor_SMD:L_Sunlord_MWSA0602S-4R7MT`             | Boost inductor (≥1.5A Isat, any 4.7-10µH OK)|
| R12     | `Device:R`                              | 75k             | `Resistor_SMD:R_0603_1608Metric`                     | MT3608 FB top                               |
| R13     | `Device:R`                              | 10k             | `Resistor_SMD:R_0603_1608Metric`                     | MT3608 FB bottom (V_out ≈ 5.1V)             |
| C9      | `Device:C`                              | 10µF            | `Capacitor_SMD:C_0805_2012Metric`                    | MT3608 input cap                            |
| C10     | `Device:C`                              | 22µF            | `Capacitor_SMD:C_0805_2012Metric`                    | MT3608 output cap                           |
| C1, C2  | `Device:C`                              | 10µF            | `Capacitor_SMD:C_0805_2012Metric`                    | +5V_LED bulk (existing)                     |
| U1      | `Regulator_Linear:AP2112K-3.3`          | AP2112K-3.3     | `Package_TO_SOT_SMD:SOT-23-5`                        | LDO +3V3                                    |
| C3      | `Device:C`                              | 1µF             | `Capacitor_SMD:C_0603_1608Metric`                    | LDO input cap                               |
| C4      | `Device:C`                              | 1µF             | `Capacitor_SMD:C_0603_1608Metric`                    | LDO output cap                              |

### A.2 J2 (USB-C) pin-by-pin

| J2 pin             | What to attach                           | Notes                                                  |
| ------------------ | ---------------------------------------- | ------------------------------------------------------ |
| A4 (VBUS, visible) | Net label `USB_VBUS`                     | **No longer ties to +5V_LED.** Goes to BQ24074 IN.     |
| A1 (GND, visible)  | `GND` power port                         |                                                        |
| A5 (CC1)           | Wire to **R9 pin 1** (label this `CC1`)  | Sink config                                            |
| B5 (CC2)           | Wire to **R10 pin 1** (label this `CC2`) |                                                        |
| A6, A7, B6, B7     | No-Connection flag (`Q`)                 | D+/D- — power-only USB                                 |
| A8, B8             | No-Connection flag                       | SBU1/SBU2                                              |
| SH (SHIELD)        | `GND` power port                         |                                                        |

**R9, R10**: pin 1 ← USB-C CC; pin 2 → `GND` power port. (Unchanged.)

### A.3 U4 (BQ24074RGT) pin-by-pin

| U4 pin | Name      | What to attach                                                    |
| -----: | --------- | ----------------------------------------------------------------- |
|      1 | TS        | Wire to **R17 pin 1**; R17 pin 2 → `GND` (fakes a 10k thermistor) |
|      2 | BAT       | Net label `BAT` (battery + node)                                  |
|      3 | BAT       | Same — also `BAT` (KiCad merges them)                             |
|      4 | ~CE       | `GND` power port (chip always enabled)                            |
|      5 | EN2       | `GND` power port (EN1=H, EN2=L → 500 mA USB current limit)        |
|      6 | EN1       | Net label `USB_VBUS` (tied high through R-less direct wire OK)    |
|      7 | ~PGOOD    | No-Connection flag (or wire to a spare GPIO if you want USB-present detection in firmware) |
|      8 | VSS       | `GND` power port                                                  |
|      9 | ~CHG      | No-Connection flag (or wire to a spare GPIO for "charging" status)|
|     10 | OUT       | Net label `SYS` (system-load output)                              |
|     11 | OUT       | Same — `SYS`                                                      |
|     12 | ILIM      | No-Connection flag (no ISYS limit set)                            |
|     13 | IN        | Net label `USB_VBUS`                                              |
|     14 | TMR       | `GND` power port (disables safety timer; OK for prototype)        |
|     15 | ITERM     | Wire to **R16 pin 2** (shares the ISET resistor — see datasheet — actually attach to GND via 10k for default termination); simpler: tie to GND with a 10k resistor (call it R18 if you want to track it) — but datasheet recommends ITERM via its own resistor. **Simplest**: tie ITERM to GND directly through R16's path. **Cleanest**: drop a separate 10k from ITERM to GND. |
|     16 | ISET      | Wire to **R16 pin 1**; R16 pin 2 → `GND` (sets 500 mA fast-charge)|
|     17 | VSS (EPAD)| `GND` power port — this is the thermal pad on the QFN              |

> **Note on pins 12, 15**: BQ24074 datasheet — ILIM (pin 12) sets system
> current limit (leave floating = no limit, that's fine for our use).
> ITERM (pin 15) sets the end-of-charge termination current; KISET / R
> = I_term. For a 100 mA termination at K_TERM ≈ 100, R = 1k. Easiest
> path: tie ITERM to GND through a 1k resistor (call it R18 if you want
> a refdes). If unsure, leave ITERM = NC and the chip uses an internal
> default — works fine for the prototype.

**Decoupling caps** (place close to U4):
- C6 → between U4 pin 13 (IN, net `USB_VBUS`) and `GND`
- C7 → between U4 pin 2 (BAT, net `BAT`) and `GND`
- C8 → between U4 pin 10 (OUT, net `SYS`) and `GND`

### A.4 J4 (LiPo battery connector) + BT1 (battery symbol)

**J4** (2-pin JST PH for the battery cable):
- Pin 1 → Net label `BAT`
- Pin 2 → `GND` power port

**BT1** (`Device:Battery_Cell`, marked `(in_bom no)` so it doesn't end
up on the BOM — it's documentation):
- `+` terminal → Net label `BAT`
- `–` terminal → `GND` power port

### A.5 Battery monitor

A simple voltage divider on `BAT` brings the 0–4.2V battery voltage
into the ESP32 ADC range. We'll route the divider output to GPIO34
(DevKit pin 5).

- **R14** (220k): pin 1 → Net label `BAT`; pin 2 → wire to R15 pin 1
- **R15** (100k): pin 1 ← wire from R14; pin 2 → `GND` power port
- **C12** (100nF, filter): pin 1 → same node as R14↔R15 junction; pin 2 → `GND`
- **Net label `VBAT_MON`** → at the R14↔R15 junction (same node as C12 pin 1)

At 4.2V battery, VBAT_MON ≈ 4.2 × 100/(220+100) = 1.31V. At 3.0V, ≈ 0.94V.
Both within ESP32 ADC range (0–3.3V). Firmware multiplies by 3.2 to get
battery voltage.

### A.6 U5 (MT3608 boost) — battery → +5V_LED

| U5 pin | Name | What to attach                                              |
| -----: | ---- | ----------------------------------------------------------- |
|      1 | SW   | Wire to **L1 pin 1**; L1 pin 2 → Net label `SYS`            |
|      2 | GND  | `GND` power port                                            |
|      3 | FB   | Wire to junction between **R12 pin 2** and **R13 pin 1**     |
|      4 | EN   | Wire to Net label `SYS` (always-on whenever SYS is alive)   |
|      5 | IN   | Net label `SYS`                                             |
|      6 | NC   | No-Connection flag                                          |

**Inductor L1** (4.7µH, ≥1.5A Isat):
- Pin 1 ← wire from U5 pin 1 (SW)
- Pin 2 → Net label `SYS` (the "before-switch" side connects directly to SYS) — wait, **re-check**: typical MT3608 topology has L between SYS and SW, so L1 pin 1 = SYS side and L1 pin 2 = SW side. Either pin labels work for an inductor (symmetric). Use:
  - L1 pin 1 → `SYS` net label
  - L1 pin 2 → wire to U5 pin 1 (SW)

**Feedback divider R12, R13** (sets boost output voltage):
- R12 (75k): pin 1 → Net label `+5V_LED`; pin 2 → wire to U5 pin 3 (FB)
- R13 (10k): pin 1 → wire to U5 pin 3 (FB, same node as R12 pin 2); pin 2 → `GND` power port

**Caps**:
- C9 (10µF) — between `SYS` and `GND` close to U5 pin 5
- C10 (22µF) — between `+5V_LED` and `GND` at the boost output (this is the boost output cap; C1/C2 are the additional bulk caps further down the rail)

**Output node**: the cathode of MT3608's internal Schottky (not on the
symbol — it's internal) emerges from the same node as L1 pin 2 / U5
pin 1. Wait — actually MT3608's SW is just the switch node. The
external diode (or internal — depends on the part variant) puts the
inductor's other side at the output. Re-check: MT3608 has internal
Schottky and integrated MOSFET. Standard topology:

```
  SYS ─── L1 ──── SW (pin 1)
                    │
                    └─── internal diode anode
                          internal diode cathode ──── +5V_LED (output)
```

So:
- L1 pin 1 = `SYS` net label
- L1 pin 2 → wire to U5 pin 1 (SW) — **and that node is also where +5V_LED comes from** through the internal diode. So you must also wire that node to net label `+5V_LED` via an extra wire, OR — easier — wire L1 pin 2 to the SW pin, and separately wire C10 + R12 + downstream loads to a labeled `+5V_LED` net. The internal diode handles the rectification.

If you find this confusing in the GUI, the rule of thumb is:
1. Draw `SYS` → L1 → SW (one continuous chain)
2. Draw `+5V_LED` → C10, R12, all downstream loads (separate chain)
3. The MT3608's internal diode bridges SW to +5V_LED inside the chip

The datasheet's reference schematic shows it clearly. The KiCad symbol
may also have an output pin labeled — verify with the symbol once
placed.

### A.7 +5V_LED bulk caps + AP2112K LDO

This part is mostly unchanged from your existing schematic — the
sources upstream just changed.

**C1, C2** (10µF bulk on `+5V_LED`):
- Pin 1 → Net label `+5V_LED`
- Pin 2 → `GND` power port

**U1** (AP2112K-3.3):
- Pin 1 (VIN) → Net label `+5V_LED`
- Pin 2 (GND) → `GND` power port
- Pin 3 (EN) → Net label `+5V_LED`
- Pin 4 (NC) → No-Connection flag
- Pin 5 (VOUT) → `+3V3` power port

**C3, C4**: unchanged. C3 (1µF) between `+5V_LED` and `GND` at LDO
input; C4 (1µF) between `+3V3` and `GND` at LDO output.

### A.8 Migration from previous Section A

If you already have the old "USB-C → +5V_LED → LDO" version drawn:

1. **Delete** the net label `+5V_LED` currently on USB-C pin A4. Replace with `USB_VBUS`.
2. **Add** U4 (BQ24074) and its 5 resistors/caps (R16, R17, C6, C7, C8) plus ITERM resistor if you want it.
3. **Add** J4 (battery connector) and BT1 (battery symbol, in_bom=no).
4. **Add** R14, R15, C12 (battery monitor divider) — output net `VBAT_MON`.
5. **Add** U5 (MT3608) + L1 + R12 + R13 + C9 + C10.
6. **Re-wire** the existing C1, C2, C3, U1, C4 to draw `+5V_LED` from the boost output (you may not need to change anything — the label network handles it automatically once the boost is wired).

### A.9 Visual tips

- POWER box order left → right: USB-C, BQ24074 (with its 3 caps + 2 resistors), J4 + battery symbol, battery monitor, MT3608 (with L1 + C9 + C10 + R12 + R13), AP2112K (with C3 + C4), C1 + C2 bulk.
- It's tight. If POWER box runs out of room, extend slightly into the J_MAIN row or move C1/C2 closer to where they're consumed (next to the TBD62783A).
- Battery connector J4 can sit in any corner of POWER — it's an off-board cable, not part of the chip topology.

---

## Section B — J_MAIN (Matrix Connector)

Inside the J_MAIN box (28..135, 50..150). If you kept the scripted J1,
you can skip placement and just verify the labels match. Otherwise:

### B.1 Components

| Ref | Symbol                                  | Value       | Footprint                                                    |
| --- | --------------------------------------- | ----------- | ------------------------------------------------------------ |
| J1  | `Connector_Generic:Conn_02x13_Odd_Even` | J_MAIN 2x13 | `Connector_PinHeader_2.54mm:PinHeader_2x13_P2.54mm_Vertical` |

### B.2 Pin-by-pin wiring

| Pin | Net           | How        |
| --: | ------------- | ---------- |
|   1 | `+5V_LED`     | Net label  |
|   2 | GND           | Power port |
|   3 | `+5V_LED`     | Net label  |
|   4 | GND           | Power port |
|   5 | `+5V_LED`     | Net label  |
|   6 | GND           | Power port |
|   7 | `LED_DATA_5V` | Net label  |
|   8 | GND           | Power port |
|   9 | `S0`          | Net label  |
|  10 | `S1`          | Net label  |
|  11 | `S2`          | Net label  |
|  12 | `S3`          | Net label  |
|  13 | `S4`          | Net label  |
|  14 | `S5`          | Net label  |
|  15 | `S6`          | Net label  |
|  16 | `S7`          | Net label  |
|  17 | `CA_PWR`      | Net label  |
|  18 | `CB_PWR`      | Net label  |
|  19 | `CC_PWR`      | Net label  |
|  20 | `CD_PWR`      | Net label  |
|  21 | `CE_PWR`      | Net label  |
|  22 | `CF_PWR`      | Net label  |
|  23 | `CG_PWR`      | Net label  |
|  24 | `CH_PWR`      | Net label  |
|  25 | `+5V_LED`     | Net label  |
|  26 | GND           | Power port |

---

## Section C — Row Pullups

Inside the ROW PULLUPS box (145..285, 50..150). If you kept the scripted
R1–R8, verify and skip placement.

### C.1 Components — 8 identical, R1 through R8

| Ref    | Symbol     | Value | Footprint                        |
| ------ | ---------- | ----- | -------------------------------- |
| R1..R8 | `Device:R` | 10k   | `Resistor_SMD:R_0805_2012Metric` |

### C.2 Pin-by-pin (one row, repeat for each)

For each `Rk` where k = 1..8, the row sense net `S(k-1)`:

- Pin 1 → `+3V3` power port
- Pin 2 → Net label `S0` for R1, `S1` for R2, …, `S7` for R8

Place them in a vertical column with `+3V3` rail at top, `S0..S7` labels
at bottom. Visually they form a clean ladder.

---

## Section D — ESP32 DevKitC Sockets

Note: Updated to use the available 38-pin ESP32 DevKitC symbol in KiCad's library, which has two 1x19 headers instead of one 1x38. The pin mapping and wiring remain the same. footprint is now the actual esp32 devkitc footprint, which has two 1x19

Inside the ESP32 / LOGIC box (295..430, 50..150). Two 1x19 female header
strips sit 25.4 mm apart on the PCB; in the schematic we draw them as
two separate symbols side by side.

### D.1 Components

| Ref | Symbol                         | Value           | Footprint                                                    |
| --- | ------------------------------ | --------------- | ------------------------------------------------------------ |
| J3  | `Connector_Generic:Conn_01x19` | DevKit J3 left  | `Connector_PinSocket_2.54mm:PinSocket_1x19_P2.54mm_Vertical` |
| J4  | `Connector_Generic:Conn_01x19` | DevKit J4 right | `Connector_PinSocket_2.54mm:PinSocket_1x19_P2.54mm_Vertical` |

Place J3 on the left (pins 1–19 correspond to DevKit physical pins
1–19), J4 on the right (pins 1–19 correspond to DevKit physical pins
20–38). Optional: add a `(text)` annotation between them saying
"ESP32-DevKitC v4 (top view, USB at top)" for orientation clarity.

### D.2 Pin map — J3 (left strip, DevKit pins 1–19)

| J3 pin | DevKit pin | GPIO / function                                 | Attach                  |
| -----: | ---------: | ----------------------------------------------- | ----------------------- | ------------------------- |
|      1 |          1 | 3V3 (DevKit's onboard LDO output)               | No-Connection flag      |
|      2 |          2 | EN (reset)                                      | Net label `BTN_RESET`   | Note used the CHIP_PU pin |
|      3 |          3 | GPIO36 / SVP (input-only)                       | Net label `BTN_POWER`   |
|      4 |          4 | GPIO39 / SVN (input-only)                       | Net label `BTN_MODE`    |
|      5 |          5 | GPIO34 / ADC1_CH6 (input-only)                  | Net label `VBAT_MON`    |
|      6 |          6 | GPIO35 (input-only)                             | Net label `PANEL_SPARE` |
|      7 |          7 | GPIO32                                          | Net label `LED_DATA`    |
|      8 |          8 | GPIO33                                          | Net label `COL_DRV_F`   |
|      9 |          9 | GPIO25                                          | Net label `COL_DRV_E`   |
|     10 |         10 | GPIO26                                          | Net label `COL_DRV_D`   |
|     11 |         11 | GPIO27                                          | Net label `COL_DRV_C`   |
|     12 |         12 | GPIO14                                          | Net label `COL_DRV_B`   |
|     13 |         13 | GPIO12 (MTDI strap; avoid driving HIGH at boot) | No-Connection flag      |
|     14 |         14 | GND                                             | `GND` power port        |
|     15 |         15 | GPIO13                                          | Net label `COL_DRV_A`   |
|     16 |         16 | GPIO9 / SD2 (flash)                             | No-Connection flag      |
|     17 |         17 | GPIO10 / SD3 (flash)                            | No-Connection flag      |
|     18 |         18 | GPIO11 / CMD (flash)                            | No-Connection flag      |
|     19 |         19 | 5V (DevKit USB VBUS)                            | No-Connection flag      |

### D.3 Pin map — J4 (right strip, DevKit pins 20–38)

| J4 pin | DevKit pin | GPIO / function                                   | Attach                 |
| -----: | ---------: | ------------------------------------------------- | ---------------------- |
|      1 |         20 | GPIO6 / CLK (flash)                               | No-Connection flag     |
|      2 |         21 | GPIO7 / SD0 (flash)                               | No-Connection flag     |
|      3 |         22 | GPIO8 / SD1 (flash)                               | No-Connection flag     |
|      4 |         23 | GPIO15 (boot strap HIGH)                          | Net label `COL_DRV_H`  |
|      5 |         24 | GPIO2 (boot strap LOW)                            | Net label `LED_BATT_N` |
|      6 |         25 | GPIO0 (boot strap HIGH)                           | No-Connection flag     |
|      7 |         26 | GPIO4                                             | Net label `S0`         |
|      8 |         27 | GPIO16                                            | Net label `S1`         |
|      9 |         28 | GPIO17                                            | Net label `S2`         |
|     10 |         29 | GPIO5 (boot strap HIGH)                           | Net label `COL_DRV_G`  |
|     11 |         30 | GPIO18                                            | Net label `S3`         |
|     12 |         31 | GPIO19                                            | Net label `S4`         |
|     13 |         32 | GND                                               | `GND` power port       |
|     14 |         33 | GPIO21                                            | Net label `S5`         |
|     15 |         34 | GPIO3 / RXD0 (reused as LED sink — no UART debug) | Net label `LED_CONN_N` |
|     16 |         35 | GPIO1 / TXD0 (reused as LED sink — no UART debug) | Net label `LED_PWR_N`  |
|     17 |         36 | GPIO22                                            | Net label `S6`         |
|     18 |         37 | GPIO23                                            | Net label `S7`         |
|     19 |         38 | GND                                               | `GND` power port       |

> **Heads-up:** GPIO1/3 (UART0) are being used as LED sinks. This means
> the DevKitC's USB-UART will not give you serial debug during normal
> operation. Reserve a JTAG/UART adapter on the DevKit's other GPIOs
> if you need it during bring-up.

### D.4 Visual tips

- Add a small text annotation (`Place → Add Text`) next to each pin like
  "GPIO13" so future-you doesn't have to cross-check with this table.
- Place J3 and J4 with their pin numbers visible on the inside — that
  matches how you'd physically look at the DevKit.

Note: Are we not using any of the power from the esp ?? why? wound't that make things easier?

---

## Section E — WS2812 Level Shifter (74AHCT125)

Inside the LED LEVEL SHIFT box (220..370, 170..285). This is the only
multi-unit symbol on the schematic — slightly more involved.

### E.1 Components

| Ref | Symbol           | Value     | Footprint                              |
| --- | ---------------- | --------- | -------------------------------------- |
| U3  | `74xx:74AHCT125` | 74AHCT125 | `Package_SO:SOIC-14_3.9x8.7mm_P1.27mm` |
| R11 | `Device:R`       | 33Ω       | `Resistor_SMD:R_0603_1608Metric`       |
| C5  | `Device:C`       | 100nF     | `Capacitor_SMD:C_0603_1608Metric`      |

### E.2 Placing U3's 5 units

74AHCT125 is a 14-pin quad bus buffer in KiCad's library — it appears as
**5 units** of the same package:

- **Unit A** — gate A (pins 1=~OE, 2=A, 3=Y)
- **Unit B** — gate B (pins 4=~OE, 5=A, 6=Y)
- **Unit C** — gate C (pins 8=Y, 9=A, 10=~OE)
- **Unit D** — gate D (pins 11=Y, 12=A, 13=~OE)
- **Unit E** — power (pin 7=GND, pin 14=VCC)

When you press `A` and pick `74AHCT125`, KiCad prompts for a unit. Place
**all 5 units** (gates A, B, C, D, and power) — each is part of the same
physical chip. They all share Reference "U3"; KiCad annotates each
instance with its unit letter automatically.

### E.3 Pin-by-pin wiring

**U3 Unit A** (the live channel):

- Pin 1 (~OE) → `GND` power port
- Pin 2 (A, input) → Net label `LED_DATA`
- Pin 3 (Y, output) → Wire to **R11 pin 1**

**U3 Unit B** (unused):

- Pin 4 (~OE) → `GND` power port
- Pin 5 (A) → `GND` power port
- Pin 6 (Y) → No-Connection flag

**U3 Unit C** (unused):

- Pin 8 (Y) → No-Connection flag
- Pin 9 (A) → `GND` power port
- Pin 10 (~OE) → `GND` power port

**U3 Unit D** (unused):

- Pin 11 (Y) → No-Connection flag
- Pin 12 (A) → `GND` power port
- Pin 13 (~OE) → `GND` power port

**U3 Unit E** (power):

- Pin 7 (GND) → `GND` power port
- Pin 14 (VCC) → Net label `+5V_LED`

**R11** (series resistor, 33Ω):

- Pin 1 ← wire from U3 Unit A pin 3
- Pin 2 → Net label `LED_DATA_5V`

**C5** (decoupling, 100nF) — place next to U3 Unit E:

- Pin 1 → Net label `+5V_LED`
- Pin 2 → `GND` power port

### E.4 Visual tips

- Place Unit A prominently (this is the working gate). Put Units B/C/D
  off to one side in a column — they're visually noise but ERC-required.
- Put Unit E (power) directly above Unit A so VCC and GND are clearly
  shown on the live channel.
- C5 hugs Unit E.

---

## Section F — Column Drivers (TBD62783A 8-channel high-side IC)

> **Revised 2026-06-05.** The original 40-discrete-component design
> (8× PMOS + 8× NPN + 24 resistors) has been replaced with a single
> integrated 8-channel high-side driver. Two parts (one IC + one cap)
> do the job. The TBD62783A is a Toshiba P-channel MOSFET array with
> 3V3-logic-level inputs, perfect for switching 5V column rails from
> ESP32 GPIOs.

Inside the COLUMN DRIVERS box (28..210, 170..285).

### F.1 How it works

```
              VCC (pin 9) = +5V_LED
                   │
COL_DRV_A → I1 ────┤
COL_DRV_B → I2     │   TBD62783A
COL_DRV_C → I3     │   (internal PMOS
COL_DRV_D → I4     │    array with
COL_DRV_E → I5     │    level-shift
COL_DRV_F → I6     │    inputs)
COL_DRV_G → I7     │
COL_DRV_H → I8 ────┤
                   │
              GND (pin 10) = GND
                   
              O1..O8 (pins 18..11)
                   │
                   ├─→ CA_PWR (O1, pin 18)
                   ├─→ CB_PWR (O2, pin 17)
                   ├─→ CC_PWR (O3, pin 16)
                   ├─→ CD_PWR (O4, pin 15)
                   ├─→ CE_PWR (O5, pin 14)
                   ├─→ CF_PWR (O6, pin 13)
                   ├─→ CG_PWR (O7, pin 12)
                   └─→ CH_PWR (O8, pin 11)
```

Active-high logic: ESP32 drives `COL_DRV_X` HIGH → internal PMOS
switches → `+5V_LED` appears on output pin `CX_PWR`. When `COL_DRV_X` is
LOW or floating, the output is pulled high-Z (column off).

### F.2 Components

| Ref | Symbol                       | Value     | Footprint                         | Notes                          |
| --- | ---------------------------- | --------- | --------------------------------- | ------------------------------ |
| U6  | `Transistor_Array:TBD62783A` | TBD62783A | `Package_DIP:DIP-18_W7.62mm` *or* `Package_SO:SOIC-18W_7.5x11.55mm_P1.27mm` | 18-pin; pick DIP or HSOP/SOIC variant |
| C11 | `Device:C`                   | 100nF     | `Capacitor_SMD:C_0603_1608Metric` | VCC decoupling                 |

> **Footprint variants**:
> - **DIP-18** — hand-soldering friendly, breadboard-compatible, ~$1
>   per chip. Choose if you're hand-stuffing the board.
> - **SOIC-18W / HSOP-18** — smaller, JLCPCB-assembly friendly. Choose
>   if you're sending the PCB out for assembly.
>
> The KiCad symbol `TBD62783A` works for both — only the footprint
> assignment differs.

### F.3 Pin-by-pin wiring

| U6 pin | Name | What to attach            |
| -----: | ---- | ------------------------- |
|      1 | I1   | Net label `COL_DRV_A`     |
|      2 | I2   | Net label `COL_DRV_B`     |
|      3 | I3   | Net label `COL_DRV_C`     |
|      4 | I4   | Net label `COL_DRV_D`     |
|      5 | I5   | Net label `COL_DRV_E`     |
|      6 | I6   | Net label `COL_DRV_F`     |
|      7 | I7   | Net label `COL_DRV_G`     |
|      8 | I8   | Net label `COL_DRV_H`     |
|      9 | VCC  | Net label `+5V_LED`       |
|     10 | GND  | `GND` power port          |
|     11 | O8   | Net label `CH_PWR`        |
|     12 | O7   | Net label `CG_PWR`        |
|     13 | O6   | Net label `CF_PWR`        |
|     14 | O5   | Net label `CE_PWR`        |
|     15 | O4   | Net label `CD_PWR`        |
|     16 | O3   | Net label `CC_PWR`        |
|     17 | O2   | Net label `CB_PWR`        |
|     18 | O1   | Net label `CA_PWR`        |

**C11** (100nF decoupling): pin 1 → Net label `+5V_LED`; pin 2 → `GND`
power port. Place close to U6 pin 9.

### F.4 Visual tips

- Place U6 horizontally with inputs (I1–I8) on the left, outputs
  (O1–O8) on the right. The column rails (`CA..CH_PWR`) flow out the
  right side of the box toward J_MAIN.
- The 8 input net labels can stack vertically on the left edge.
- C11 sits just above U6 pin 9 (VCC).

### F.5 Why this is better than the discrete version

| | Discrete (PMOS+NPN+3R per channel) | TBD62783A IC |
|---|---|---|
| Components | 40 (8 PMOS + 8 NPN + 24 R) | 2 (1 IC + 1 cap) |
| Board area | ~6 cm² | ~1 cm² (SOIC) or ~2 cm² (DIP) |
| Schematic clarity | 40 symbols × 8 columns of repetition | 1 chip, one glance |
| Output voltage drop | ~50 mV at 50 mA (PMOS Rds_on) | ~250 mV at 50 mA (datasheet typ) |
| Cost (qty 10) | ~$2 | ~$1 |
| Failure modes | One bad PMOS → 1 dead column (repairable) | One bad IC → 8 dead columns (replace IC) |

The voltage drop is the only real tradeoff. At 50 mA per column, ~250 mV
drop means the Hall sensors see ~4.75 V instead of 5.0 V. Datasheet
minimum for A3144 is 4.5 V — still within spec.

---

## Section G — J_PANEL Connector + Button Pullups

Inside the USER UI CONNECTOR box (380..566, 170..285).

### G.1 Components

| Ref | Symbol                         | Value        | Footprint                                                    |
| --- | ------------------------------ | ------------ | ------------------------------------------------------------ | --------------------------------------------------------------- |
| J5  | `Connector_Generic:Conn_01x10` | J_PANEL 1x10 | `Connector_PinHeader_2.54mm:PinHeader_1x10_P2.54mm_Vertical` | Note: this is now J3 Because J3/J4 are not used for the esp32.. |
| R36 | `Device:R`                     | 10k          | `Resistor_SMD:R_0603_1608Metric`                             |
| R37 | `Device:R`                     | 10k          | `Resistor_SMD:R_0603_1608Metric`                             |

### G.2 J5 pin-by-pin

| Pin | Net           | How        |
| --: | ------------- | ---------- |
|   1 | `+3V3`        | Power port |
|   2 | GND           | Power port |
|   3 | `LED_PWR_N`   | Net label  |
|   4 | `LED_CONN_N`  | Net label  |
|   5 | `LED_BATT_N`  | Net label  |
|   6 | `BTN_POWER`   | Net label  |
|   7 | `BTN_MODE`    | Net label  |
|   8 | `BTN_RESET`   | Net label  |
|   9 | `PANEL_SPARE` | Net label  |
|  10 | GND           | Power port |

### G.3 Button pullups

GPIO36 (BTN_POWER) and GPIO39 (BTN_MODE) are input-only and have **no
internal pullup**. They need external pullups so the inputs aren't
floating when the buttons are released.

- BTN_RESET goes to EN — DevKitC already has a pullup on EN; no
  additional pullup needed.
- PANEL_SPARE is reserved; leave it as just a label for now.

**R36 (pullup for BTN_POWER, 10k)**:

- Pin 1 → `+3V3` power port
- Pin 2 → Net label `BTN_POWER`

**R37 (pullup for BTN_MODE, 10k)**:

- Pin 1 → `+3V3` power port
- Pin 2 → Net label `BTN_MODE`

Place R36 and R37 immediately next to the J5 connector pins 6 and 7 to
keep the pullup intent visually obvious.

---

## Section H — Test Points, Mounting Holes, Fiducials

Inside the TEST + MECHANICAL box (28..566, 305..400). If you kept the
scripted versions (TP1..TPn, MH1..MH4, FID1..FID3), just verify and add
any missing nets below.

### H.1 Recommended test points

One TP per net listed below. Each TP uses
`Connector:TestPoint` / footprint `TestPoint:TestPoint_Pad_D1.5mm`.

| TP   | Net to attach (net label)                    |
| ---- | -------------------------------------------- |
| TP1  | `+5V_LED`                                    |
| TP2  | `+3V3` (use power port pin connection)       |
| TP3  | `GND` (power port)                           |
| TP4  | `LED_DATA`                                   |
| TP5  | `LED_DATA_5V`                                |
| TP6  | `S0`                                         |
| TP7  | `S1`                                         |
| TP8  | `S2`                                         |
| TP9  | `S3`                                         |
| TP10 | `S4`                                         |
| TP11 | `S5`                                         |
| TP12 | `S6`                                         |
| TP13 | `S7`                                         |
| TP14 | `CA_PWR`                                     |
| TP15 | `CB_PWR`                                     |
| TP16 | `CC_PWR`                                     |
| TP17 | `CD_PWR`                                     |
| TP18 | `CE_PWR`                                     |
| TP19 | `CF_PWR`                                     |
| TP20 | `CG_PWR`                                     |
| TP21 | `CH_PWR`                                     |
| TP22 | `USB_VBUS` (USB-C input, for charge debugging) |
| TP23 | `BAT` (LiPo + terminal)                      |
| TP24 | `SYS` (BQ24074 output / boost input)         |
| TP25 | `VBAT_MON` (ADC monitor net)                 |
| TP26 | `COL_DRV_A` (optional — handy for debugging) |
| TP27 | `BTN_POWER` (optional)                       |
| TP28 | `BTN_MODE` (optional)                        |
| TP29 | `LED_PWR_N` (optional)                       |

TPs 22–25 are battery-system debug points — strongly recommended.
TPs 26–29 are nice-to-haves; skip if board space is tight.

For each TP:

- Place the symbol
- Wire its single pin to a stub
- Attach the appropriate net label or power port at the stub end

### H.2 Mechanical (no electrical connection)

| Ref        | Symbol                    | Footprint                            |
| ---------- | ------------------------- | ------------------------------------ |
| MH1..MH4   | `Mechanical:MountingHole` | `MountingHole:MountingHole_3.2mm_M3` |
| FID1..FID3 | `Mechanical:Fiducial`     | `Fiducial:Fiducial_1mm_Mask2mm`      |

Place them anywhere in the bottom strip. They have no pins.

Note: I'll let you do this secction with a script too..

---

## Section I — Final Checks

### I.1 ERC checklist

Inspect → **Electrical Rules Checker** → Run. Expected: 0 violations.

Likely false-alarms you can resolve:

- **"Pin not driven by any Net"** on `+5V_LED` — this means ERC can't
  see who's sourcing the rail. The PWR_FLAG you kept on `+5V_LED` (or
  the USB VBUS path) should clear this. If still flagged, drag a
  `PWR_FLAG` symbol onto a `+5V_LED` label or wire.
- **"Pin not driven by any Net"** on `+3V3` — same; the LDO VOUT (or a
  PWR_FLAG) should be the source.
- **"Pin not connected"** on a 74AHCT125 unit — check that every pin of
  every unit (A, B, C, D, E) has either a connection or a no-connect
  flag.
- **"Conflict between input pin and input pin"** — usually means you've
  labeled two different signals with the same name. Audit labels.

### I.2 Power flag sanity

Make sure there's exactly **one** of each:

- `PWR_FLAG` symbol on `+5V_LED` (or rely on the USB VBUS source)
- `PWR_FLAG` symbol on `+3V3` (or rely on LDO VOUT — but adding one
  PWR_FLAG is the safer reflex)
- `PWR_FLAG` symbol on `GND`

The chunk-04 power flags (kept from the script pipeline) already cover
this. If you nuked the schematic and started fresh, drop three
`power:PWR_FLAG` symbols and attach to the rails.

### I.3 Annotate

Tools → **Annotate Schematic** → "Use first free number" → Annotate.
This locks every refdes to a unique number. Do this after all components
are placed.

### I.4 Generate netlist / commit

```bash
git add openchess-controller.kicad_sch
git commit -m "controller schematic: hand-drawn rev0.1 — power+ESP32+drivers+panel"
```

You can also export a PDF of the schematic (File → Print) and put it in
`docs/archive/` if you want a paper review.

---

## Quick-reference: every net used on this board

For sanity-checking your labels match what other sections reference.

**Power rails:**

- `USB_VBUS` — raw 5 V from USB-C, feeds BQ24074 IN
- `BAT` — LiPo battery + terminal, between BQ24074 BAT pins and J4
- `SYS` — BQ24074 system output (auto-switches USB vs battery); feeds MT3608 boost
- `+5V_LED` — regulated 5 V from MT3608 boost; powers WS2812s, TBD62783A VBB, LDO input
- `+3V3` — from AP2112K LDO; powers ESP32, pullups, panel logic
- `GND` — ground

**Matrix interface (to J_MAIN / J1):**

- `S0..S7` — row sense, ESP32 inputs with pullups (R1–R8)
- `CA_PWR..CH_PWR` — column power rails, from TBD62783A outputs
- `LED_DATA_5V` — WS2812 chain data input

**Controller-internal:**

- `LED_DATA` — 3V3 from ESP32 GPIO32 to 74AHCT125
- `COL_DRV_A..COL_DRV_H` — 3V3 ESP32 GPIOs to TBD62783A inputs
- `VBAT_MON` — battery monitor divider output (0–1.3 V) → ESP32 GPIO34 ADC
- `CC1`, `CC2` — USB-C CC pin local nets (between USB-C and pulldown resistors)

**Panel interface (to J_PANEL / J3):**

- `LED_PWR_N`, `LED_CONN_N`, `LED_BATT_N` — active-low LED sinks
- `BTN_POWER`, `BTN_MODE`, `BTN_RESET` — buttons (BTN_RESET goes to EN)
- `PANEL_SPARE` — reserved

If a label in your schematic doesn't appear in this list, you've
introduced a typo and ERC will catch it as a one-pin net.

---

## Order of attack (suggested)

1. Section A (Power) — get rails alive on paper first
2. Section B (J_MAIN) + Section C (Row Pullups) — easy wins
3. Section H (Test points) — drop placeholders so you don't forget
4. Section D (ESP32 sockets) — the biggest chunk; take your time
5. Section E (Level shifter) — small and self-contained
6. Section G (J_PANEL + button pullups) — small
7. Section F (Column drivers) — repetitive; copy-paste channel A 7 times
8. **ERC sweep**, fix, **ERC clean**
9. Annotate, commit

Each section is small enough to do in a sitting; you don't have to
finish in one go. Save frequently — KiCad's autosave is per-session, not
permanent.
