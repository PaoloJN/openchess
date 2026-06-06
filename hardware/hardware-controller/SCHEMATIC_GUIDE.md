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
  `I2C_SDA`, `I2C_SCL`, `BTN_*`, `COL_DRV_*`, `PANEL_SPARE`,
  `PANEL_SPARE2`, `LED_DATA`, `VBAT_MON`).
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

| Range     | Section                                                                                                                                                                                                                                                                                           |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| J1        | J_MAIN (matrix connector — **shrouded/keyed IDC footprint**)                                                                                                                                                                                                                                      |
| J3        | J_PANEL (control panel connector)                                                                                                                                                                                                                                                                 |
| **M1**    | **Seeed Lipo Rider Plus** (product 106990290) — USB-C in, 5V/2.4A boost + 3V3/250mA out, $4 on DigiKey. Schematic uses `Connector_Generic:Conn_01x08` (generic — see §A.7 for why we don't use SnapEDA's symbol). Footprint: `LipoRiderPlus:MODULE_106990290` (SnapEDA model, installed locally). |
| **D2**    | **Schottky diode (SS14 or BAT60A)** — between `+5V_LED` and DevKit pin 19. Lets the battery power the ESP32 via DevKit's onboard AMS1117. Anode on `+5V_LED`, cathode on DevKit pin 19.                                                                                                           |
| BT1       | LiPo battery symbol (off-board, documentation only; battery plugs into M1's onboard JST 2.0)                                                                                                                                                                                                      |
| U2        | ESP32-DevKitC module                                                                                                                                                                                                                                                                              |
| U3        | 74AHCT125 LED data level shifter                                                                                                                                                                                                                                                                  |
| U6        | TBD62783A — 8-channel high-side column driver IC                                                                                                                                                                                                                                                  |
| R1–R8     | Matrix row pullups (10k)                                                                                                                                                                                                                                                                          |
| R11       | LED data series resistor (33Ω)                                                                                                                                                                                                                                                                    |
| R36, R37  | Panel button pullups (10k)                                                                                                                                                                                                                                                                        |
| R14, R15  | Battery monitor divider (220 k top, 100 k bottom) on M1 pin 6 → VBAT_MON                                                                                                                                                                                                                          |
| C1, C2    | Bulk caps on +5V_LED (10µF) — at the entry to our rail from M1                                                                                                                                                                                                                                    |
| C5        | 74AHCT125 decoupling (100nF)                                                                                                                                                                                                                                                                      |
| C11       | TBD62783A bypass cap (100nF)                                                                                                                                                                                                                                                                      |
| C12       | Battery-monitor ADC filter cap (100nF)                                                                                                                                                                                                                                                            |
| TP1, TP2… | Test points (section H)                                                                                                                                                                                                                                                                           |
| MH1–MH4   | Mounting holes                                                                                                                                                                                                                                                                                    |
| FID1–FID3 | Fiducials                                                                                                                                                                                                                                                                                         |

**Refdes ranges no longer used** (parts dropped when switching to the
Lipo Rider Plus + dropping the LDO): `J2` (USB-C), `J4` (LiPo connector), `F1`, `D1`,
`U1` (AP2112K LDO — Lipo Rider's 3V3 output replaces it), `C3`, `C4` (LDO caps),
`Q1`, `U4`, `U5`, `L1`, `R9, R10`, `R12, R13, R16, R17`,
`C6–C10`, `C13`. (R14, R15, C12 are _back_ in use — repurposed as the
battery monitor divider on the Lipo Rider Plus's raw BAT pad.)

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
           │ U6 TBD62783A          │ │ U3 74AHCT125    │ │ J3 J_PANEL (JST XH)  │
           │ + C11 bypass          │ │ + C5            │ │ R36, R37 pullups     │
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

## Section A — Power (Seeed Lipo Rider Plus + ESP32 power path)

> **Revised 2026-06-05 (really final).** Section A is now ~5
> components: a 1×8 header for the Lipo Rider Plus daughterboard, two
> bulk caps on `+5V_LED`, and one Schottky diode (D2) routing
> `+5V_LED` to the DevKit's 5V input pin so the ESP32 can run from
> battery. The Lipo Rider Plus produces both `+5V_LED` (5V/2.4A) and
> `+3V3` (250 mA) directly — no LDO needed on our PCB.

Inside the POWER box (440..566, 50..150 world mm).

### A.1 Components

| Ref | Symbol                         | Value                    | Footprint                         | Notes                                                                                                                                                                                                                                                                                                                                                                                                                                |
| --- | ------------------------------ | ------------------------ | --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| M1  | `Connector_Generic:Conn_01x08` | Lipo Rider Plus          | `LipoRiderPlus:MODULE_106990290`  | 8 through-holes at 2.54 mm pitch + 4 corner M2 mounting holes (3 mm drill) + silkscreen outline. SnapEDA model, installed locally at `lib/LipoRiderPlus.pretty/`. **Symbol intentionally uses generic `Conn_01x08` instead of SnapEDA's `106990290.kicad_sym`** — SnapEDA's symbol has reversed pin-number-to-name mapping vs. the board silkscreen; using the generic connector with manual pin labels keeps everything consistent. |
| BT1 | `Device:Battery_Cell`          | LiPo 1S 3.7V (protected) | _(no footprint — off-board)_      | Documentation symbol; mark `(in_bom no)`. Battery plugs into M1's onboard JST 2.0 connector, not into our PCB.                                                                                                                                                                                                                                                                                                                       |
| D2  | `Device:D_Schottky`            | SS14 (or BAT60A)         | `Diode_SMD:D_SMA`                 | Anode on `+5V_LED`, cathode on DevKit pin 19. Lets the battery power the ESP32 via the DevKit's onboard AMS1117. Backfeed protection.                                                                                                                                                                                                                                                                                                |
| C1  | `Device:C`                     | 10µF                     | `Capacitor_SMD:C_0805_2012Metric` | Bulk cap on +5V_LED at M1's 5V output                                                                                                                                                                                                                                                                                                                                                                                                |
| C2  | `Device:C`                     | 10µF                     | `Capacitor_SMD:C_0805_2012Metric` | Bulk cap on +5V_LED                                                                                                                                                                                                                                                                                                                                                                                                                  |
| R14 | `Device:R`                     | 220k                     | `Resistor_SMD:R_0603_1608Metric`  | Battery monitor divider — top resistor                                                                                                                                                                                                                                                                                                                                                                                               |
| R15 | `Device:R`                     | 100k                     | `Resistor_SMD:R_0603_1608Metric`  | Battery monitor divider — bottom resistor                                                                                                                                                                                                                                                                                                                                                                                            |
| C12 | `Device:C`                     | 100nF                    | `Capacitor_SMD:C_0603_1608Metric` | ADC filter on VBAT_MON                                                                                                                                                                                                                                                                                                                                                                                                               |

That's it. **Five items.** Compare to the original discrete power
design (~30 components) or the brief PowerBoost+LDO plan (7 items).

### A.2 M1 (Lipo Rider Plus) pin-by-pin

The Lipo Rider Plus has 8 labeled solder pads in a single row along
one edge. Pin numbers below match the order in the datasheet (from
the side closest to the JST connector).

| M1 pin | Module pad label | Connect to            | Notes                                                                                                     |
| -----: | ---------------- | --------------------- | --------------------------------------------------------------------------------------------------------- |
|      1 | `3V3`            | Net label `+3V3`      | Always-on 250 mA. **This is our +3V3 source** — no LDO needed.                                            |
|      2 | `EN`             | No-Connection flag    | Enables the 5V output. We use the module's onboard slide switch instead (set to "ON"). Leave EN floating. |
|      3 | `GND`            | `GND` power port      |                                                                                                           |
|      4 | `5V`             | Net label `+5V_LED`   | The regulated 5V/2.4A boost output. Powers WS2812s, Halls (via TBD62783A), TBD62783A VCC, 74AHCT125 VCC.  |
|      5 | `GND`            | `GND` power port      |                                                                                                           |
|      6 | `BAT`            | Wire to **R14 pin 1** | Raw battery + (3.0–4.2 V depending on SOC). Goes to the battery monitor voltage divider — see §A.4 below. |
|      7 | `GND`            | `GND` power port      |                                                                                                           |
|      8 | `USB`            | No-Connection flag    | Raw USB-C VBUS access. Test-pad only.                                                                     |

**6 of the 8 pins are electrically wired** on the controller PCB:
3V3, GND (×3), 5V, and BAT (for the battery monitor). The remaining
2 pads (EN, USB) get no_connect flags — they're test pads on the
daughterboard but aren't routed anywhere on our PCB.

> **Important: set M1's onboard slide switch to "ON"** when you
> assemble the board. The slide switch controls whether the 5V output
> is enabled. If left in "OFF" or "5V" position with floating EN, the
> 5V rail won't come up.

### A.3 D2 — Schottky for ESP32 power

Note: Don't know if i did this step correctly — might need to double check

The DevKit's ESP32 needs power. The DevKit's onboard AMS1117 LDO
generates 3V3 for the ESP32 internally, but only if its input pin
(DevKit pin 19, labeled `5V`) sees a voltage source. We route
`+5V_LED` to DevKit pin 19 through a Schottky diode for backfeed
protection.

**D2** (SS14 Schottky in SMA, or BAT60A in SOD-123):

- Anode → Net label `+5V_LED`
- Cathode → Wire to DevKit module pin 19 (the "5V" pin on the J4 right strip, labeled "5V" on the DevKitC silkscreen)

The diode allows current to flow `+5V_LED → DevKit pin 19` (forward
direction, ~0.3 V drop → DevKit sees ~4.8 V → AMS1117 produces clean
3V3 → ESP32 runs). It blocks current in the reverse direction, so
if you have both the DevKit's USB micro-B and the controller's USB-C
plugged in simultaneously, neither USB source backfeeds the other.

### A.4 Battery state-of-charge monitor (VBAT_MON)

A simple voltage divider taps the raw battery voltage from M1's pin 6
(`BAT`) and feeds a scaled-down version into the ESP32 ADC. Firmware
reads this and shows battery percentage on the OLED.

**Why tap M1 pin 6 (raw battery), not DevKit pin 19 (post-boost)?**
M1's boost regulates `+5V_LED` to a constant ~5.0 V regardless of
battery state. Monitoring downstream of the boost would tell you "the
boost is working" but not the battery charge level. The raw battery
voltage swings from 4.2 V (full) to 3.0 V (empty), which is what we
actually want to measure.

**R14** (220 kΩ, top resistor):

- Pin 1 ← wire from M1 pin 6 (`BAT`)
- Pin 2 → wire to R15 pin 1 / C12 pin 1 / Net label `VBAT_MON` (3-way junction)

**R15** (100 kΩ, bottom resistor):

- Pin 1 → junction with R14 pin 2 / C12 pin 1 / `VBAT_MON` label
- Pin 2 → `GND` power port

**C12** (100 nF, filter cap):

- Pin 1 → same junction (`VBAT_MON`)
- Pin 2 → `GND` power port

**Net label `VBAT_MON`** at the junction → wire to ESP32 module pin 5
(DevKit pin 5 = GPIO34, ADC1_CH6).

**Divider math**:

- VBAT_MON = BAT × 100k / (220k + 100k) = BAT × 0.3125
- At full charge (BAT = 4.2 V): VBAT_MON ≈ 1.31 V
- At empty (BAT = 3.0 V): VBAT_MON ≈ 0.94 V
- Both within ESP32 ADC range (0–3.3 V); use `esp_adc_cal_*` APIs for
  accurate readings. Firmware multiplies the calibrated mV reading by
  3.2 to recover the battery voltage.

### A.5 +5V_LED bulk caps

**C1, C2** (10 µF each) — between `+5V_LED` and `GND`, placed close
to where `+5V_LED` enters the rest of the board (near the TBD62783A
column driver and the 74AHCT125 level shifter):

- Pin 1 (top) → Net label `+5V_LED`
- Pin 2 (bottom) → `GND` power port

These smooth out current transients from the LED chain when many
WS2812Bs change brightness simultaneously.

### A.6 BT1 documentation symbol

**BT1** (`Device:Battery_Cell`, `(in_bom no)`):

- `+` terminal → no electrical connection on our PCB (battery plugs into M1's onboard JST)
- `–` terminal → no electrical connection on our PCB

BT1 is a documentation symbol only. It tells the reader where the
battery lives in the system. Mark its `in_bom` property to "no" so
it doesn't show up on the PCB BOM (the battery is bought separately,
not assembled).

### A.7 Footprint + symbol notes for M1

**Footprint** (`LipoRiderPlus:MODULE_106990290`, installed at
`lib/LipoRiderPlus.pretty/`): SnapEDA model. Provides 8 through-hole
pads at 2.54 mm pitch (matching the Lipo Rider Plus's pin header) +
4 corner non-plated mounting holes (3.0 mm drill, for M2 screws with
some clearance) + silkscreen outline (~38 × 23 mm body) + pin-1
indicator dot near the leftmost pad.

**Symbol**: use stock `Connector_Generic:Conn_01x08`. **Do not use
SnapEDA's `106990290.kicad_sym`** — it has a bug. SnapEDA's symbol
labels its pins `VBUS`/`GND`/`BAT`/`GND`/`5V`/`GND`/`EN`/`3V3` with
pin numbers 1–8 in that order, but the **actual Lipo Rider Plus
silkscreen numbers its pads** `1=3V3, 2=EN, 3=GND, 4=5V, 5=GND, 6=BAT,
7=GND, 8=USB` (left to right, JST side first). KiCad maps symbol pin N
→ footprint pad N → physical silkscreen pad N, so using SnapEDA's
symbol would connect the wrong nets to the wrong pads — for example,
routing our `+3V3` net to the module's USB-VBUS output (≈5 V) and
frying the ESP32.

Using a generic 8-pin connector with **silkscreen-matched pin
labels** (pin 1 = `+3V3`, pin 8 = USB no-connect, etc., per §A.2)
keeps the schematic and PCB layout consistent with what's printed
on the daughterboard.

**Mechanical**: place the SnapEDA footprint on the controller PCB,
orient so the pin-1 silkscreen dot is on the JST side of the module's
intended position. The 4 mounting holes in the footprint will appear
on the controller PCB and let you bolt the module down with M2 + 5 mm
standoffs.

### A.8 Migration from the previous PowerBoost-based design

If your schematic has the brief PowerBoost 1000C + AP2112K LDO version:

1. **Delete** M1 (PowerBoost) and replace with a fresh `Conn_01x08` symbol labeled "Lipo Rider Plus". Re-wire pins per §A.2 above.
2. **Delete** U1 (AP2112K LDO) + C3 + C4 (LDO caps).
3. **Wire** Lipo Rider's pin 1 (`3V3`) → existing `+3V3` net.
4. **Wire** Lipo Rider's pin 4 (`5V`) → existing `+5V_LED` net.
5. **Add** D2 (Schottky) between `+5V_LED` and DevKit module's pin 19
   (the "5V" pin on the right header strip).
6. **Drop the `BATT_LOW` net** — the Lipo Rider Plus has no LBO-style signal.
7. **Add R14 + R15 + C12** (battery monitor voltage divider) from M1 pin 6 (`BAT`) to GND, with the junction labeled `VBAT_MON`. Wire `VBAT_MON` to DevKit pin 5 (GPIO34). See §A.4 for details.

If your schematic still has the older discrete power design (BQ24074,
TPS63060, etc.), see DESIGN_NOTES §15 for the full history. Easiest
path: delete the whole Section A area and rebuild from §A.1 above.

### A.9 Visual tips

- POWER box layout (left → right): M1 header (~25 × 41 mm area for the
  module to sit), D2 Schottky next to where the wire crosses over to
  the ESP32 socket pin 19, C1 + C2 bulk caps near where `+5V_LED`
  enters the rest of the rails.
- Orient M1's USB-C connector and slide switch toward the enclosure
  edge so they're accessible without disassembly.
- Battery is off-board; route the battery wire externally, not through
  the PCB.

---

## Section B — J_MAIN (Board-to-Board to Matrix)

Inside the J_MAIN box (28..135, 50..150). The 2×13 stacking connector
between the controller and the matrix board.

> **Revised 2026-06-05.** Switched from a shrouded IDC ribbon to a
> **board-to-board stacking pin header**. The controller PCB now mounts
> directly underneath the matrix PCB; J_MAIN's male pins on the
> controller's top face mate with J_CTRL's female socket on the matrix's
> back face. No ribbon cable. ~11 mm M3 standoffs at the controller's
> corners hold the stack mechanically.

### B.1 Components

| Ref | Symbol                                  | Value       | Footprint                                                           |
| --- | --------------------------------------- | ----------- | ------------------------------------------------------------------- |
| J1  | `Connector_Generic:Conn_02x13_Odd_Even` | J_MAIN 2x13 | `Connector_PinHeader_2.54mm:PinHeader_2x13_P2.54mm_Vertical` (male) |

**Footprint pick**: standard 2×13 vertical pin header, 2.54 mm pitch.
The male pins point UP (out of the controller PCB's top face) to mate
with the matrix board's female socket pointing down. No keying needed
— mating a male pin header with a female socket only fits one way at
the connector level (you can't physically push pins through closed
socket housing in the wrong orientation). Still mark **pin 1 with a
silkscreen dot** on both boards for assembly clarity.

The corresponding matrix-side J_CTRL footprint must be a 2×13 female
socket (`PinSocket_2x13_P2.54mm_Vertical`) on the matrix PCB's back
side. Both connector footprints share the same `Conn_02x13_Odd_Even`
symbol — only the PCB footprint differs.

**Mechanical**: place 4 M3 mounting holes at the controller PCB's
corners. M3 brass standoffs (~11 mm tall — matching the mating depth
of the pin+socket combo) thread between the matrix's back-side
mounting holes and the controller's mounting holes.

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
| -----: | ---------: | ----------------------------------------------- | ----------------------- | -------------------------------------------------------------------- |
|      1 |          1 | 3V3 (DevKit's onboard LDO output)               | No-Connection flag      |
|      2 |          2 | EN (CHIP_PU)                                    | No-Connection flag      | Reset comes from DevKit's onboard EN button; panel reset was removed |
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

| J4 pin | DevKit pin | GPIO / function                                      | Attach                 |
| -----: | ---------: | ---------------------------------------------------- | ---------------------- |
|      1 |         20 | GPIO6 / CLK (flash)                                  | No-Connection flag     |
|      2 |         21 | GPIO7 / SD0 (flash)                                  | No-Connection flag     |
|      3 |         22 | GPIO8 / SD1 (flash)                                  | No-Connection flag     |
|      4 |         23 | GPIO15 (boot strap HIGH)                             | Net label `COL_DRV_H`  |
|      5 |         24 | GPIO2 (boot strap LOW)                               | Net label `BTN_SELECT` |
|      6 |         25 | GPIO0 (boot strap HIGH)                              | No-Connection flag     |
|      7 |         26 | GPIO4                                                | Net label `S0`         |
|      8 |         27 | GPIO16                                               | Net label `S1`         |
|      9 |         28 | GPIO17                                               | Net label `S2`         |
|     10 |         29 | GPIO5 (boot strap HIGH)                              | Net label `COL_DRV_G`  |
|     11 |         30 | GPIO18                                               | Net label `S3`         |
|     12 |         31 | GPIO19                                               | Net label `S4`         |
|     13 |         32 | GND                                                  | `GND` power port       |
|     14 |         33 | GPIO21                                               | Net label `S5`         |
|     15 |         34 | GPIO3 / RXD0 (repurposed as I²C SCL — no UART debug) | Net label `I2C_SCL`    |
|     16 |         35 | GPIO1 / TXD0 (repurposed as I²C SDA — no UART debug) | Net label `I2C_SDA`    |
|     17 |         36 | GPIO22                                               | Net label `S6`         |
|     18 |         37 | GPIO23                                               | Net label `S7`         |
|     19 |         38 | GND                                                  | `GND` power port       |

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

| Ref | Symbol                       | Value     | Footprint                                                                   | Notes                                 |
| --- | ---------------------------- | --------- | --------------------------------------------------------------------------- | ------------------------------------- |
| U6  | `Transistor_Array:TBD62783A` | TBD62783A | `Package_DIP:DIP-18_W7.62mm` _or_ `Package_SO:SOIC-18W_7.5x11.55mm_P1.27mm` | 18-pin; pick DIP or HSOP/SOIC variant |
| C11 | `Device:C`                   | 100nF     | `Capacitor_SMD:C_0603_1608Metric`                                           | VCC decoupling                        |

> **Footprint variants**:
>
> - **DIP-18** — hand-soldering friendly, breadboard-compatible, ~$1
>   per chip. Choose if you're hand-stuffing the board.
> - **SOIC-18W / HSOP-18** — smaller, JLCPCB-assembly friendly. Choose
>   if you're sending the PCB out for assembly.
>
> The KiCad symbol `TBD62783A` works for both — only the footprint
> assignment differs.

### F.3 Pin-by-pin wiring

| U6 pin | Name | What to attach        |
| -----: | ---- | --------------------- |
|      1 | I1   | Net label `COL_DRV_A` |
|      2 | I2   | Net label `COL_DRV_B` |
|      3 | I3   | Net label `COL_DRV_C` |
|      4 | I4   | Net label `COL_DRV_D` |
|      5 | I5   | Net label `COL_DRV_E` |
|      6 | I6   | Net label `COL_DRV_F` |
|      7 | I7   | Net label `COL_DRV_G` |
|      8 | I8   | Net label `COL_DRV_H` |
|      9 | VCC  | Net label `+5V_LED`   |
|     10 | GND  | `GND` power port      |
|     11 | O8   | Net label `CH_PWR`    |
|     12 | O7   | Net label `CG_PWR`    |
|     13 | O6   | Net label `CF_PWR`    |
|     14 | O5   | Net label `CE_PWR`    |
|     15 | O4   | Net label `CD_PWR`    |
|     16 | O3   | Net label `CC_PWR`    |
|     17 | O2   | Net label `CB_PWR`    |
|     18 | O1   | Net label `CA_PWR`    |

**C11** (100nF decoupling): pin 1 → Net label `+5V_LED`; pin 2 → `GND`
power port. Place close to U6 pin 9.

### F.4 Visual tips

- Place U6 horizontally with inputs (I1–I8) on the left, outputs
  (O1–O8) on the right. The column rails (`CA..CH_PWR`) flow out the
  right side of the box toward J_MAIN.
- The 8 input net labels can stack vertically on the left edge.
- C11 sits just above U6 pin 9 (VCC).

### F.5 Why this is better than the discrete version

|                     | Discrete (PMOS+NPN+3R per channel)        | TBD62783A IC                             |
| ------------------- | ----------------------------------------- | ---------------------------------------- |
| Components          | 40 (8 PMOS + 8 NPN + 24 R)                | 2 (1 IC + 1 cap)                         |
| Board area          | ~6 cm²                                    | ~1 cm² (SOIC) or ~2 cm² (DIP)            |
| Schematic clarity   | 40 symbols × 8 columns of repetition      | 1 chip, one glance                       |
| Output voltage drop | ~50 mV at 50 mA (PMOS Rds_on)             | ~250 mV at 50 mA (datasheet typ)         |
| Cost (qty 10)       | ~$2                                       | ~$1                                      |
| Failure modes       | One bad PMOS → 1 dead column (repairable) | One bad IC → 8 dead columns (replace IC) |

The voltage drop is the only real tradeoff. At 50 mA per column, ~250 mV
drop means the Hall sensors see ~4.75 V instead of 5.0 V. Datasheet
minimum for A3144 is 4.5 V — still within spec.

---

## Section G — J_PANEL Connector + Button Pullups

> **Revised 2026-06-05 (twice).** First revision moved the panel from
> 3 LEDs to an OLED + 3 buttons (pin contract reassigned: pins 3/4 =
> I²C SDA/SCL, pin 5 = BTN_SELECT). Second revision **dropped the
> panel PCB entirely** — the panel is now discrete OLED module + 3
> panel-mount buttons on a flying-lead harness, plugging into J3 on
> the controller. The 10-pin J3 contract is unchanged, but the
> connector type changed from a plain 1×10 pin header to a **JST XH
> 10-pin** (polarized + latching) for a cleaner harness-to-board
> interface.

Inside the USER UI CONNECTOR box (380..566, 170..285).

### G.1 Components

| Ref | Symbol                         | Value         | Footprint                                              | Notes                                                                                                        |
| --- | ------------------------------ | ------------- | ------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------ |
| J3  | `Connector_Generic:Conn_01x10` | J_PANEL XH-10 | `Connector_JST:JST_XH_B10B-XH-A_1x10_P2.50mm_Vertical` | **JST XH 10-pin**, polarized + latching. Plugs into the flying-lead harness — there is no panel PCB anymore. |
| R36 | `Device:R`                     | 10k           | `Resistor_SMD:R_0603_1608Metric`                       | BTN_POWER pullup (GPIO36 input-only, no internal pullup)                                                     |
| R37 | `Device:R`                     | 10k           | `Resistor_SMD:R_0603_1608Metric`                       | BTN_MODE pullup (GPIO39 input-only)                                                                          |

### G.2 J3 pin-by-pin

| Pin | Net            | How        | ESP32 pin                |
| --: | -------------- | ---------- | ------------------------ |
|   1 | `+3V3`         | Power port | (powers OLED + pullups)  |
|   2 | `GND`          | Power port | —                        |
|   3 | `I2C_SDA`      | Net label  | GPIO1 (was TX0)          |
|   4 | `I2C_SCL`      | Net label  | GPIO3 (was RX0)          |
|   5 | `BTN_SELECT`   | Net label  | GPIO2                    |
|   6 | `BTN_POWER`    | Net label  | GPIO36 (input-only)      |
|   7 | `BTN_MODE`     | Net label  | GPIO39 (input-only)      |
|   8 | `PANEL_SPARE`  | Net label  | reserved (was BTN_RESET) |
|   9 | `PANEL_SPARE2` | Net label  | reserved                 |
|  10 | `GND`          | Power port | —                        |

> The two `PANEL_SPARE*` nets terminate at a single pin on this side.
> ERC will flag them as "single-pin net." That's intentional — they're
> reserved for future expansion (e.g. a rotary encoder, a buzzer
> driver, more buttons). Don't no-connect-flag them; just live with
> the ERC warnings.

### G.3 Button pullups + BTN_SELECT note

**GPIO36 (BTN_POWER) and GPIO39 (BTN_MODE)** are input-only and have
**no internal pullup**. They need external pullups on the controller:

**R36** (pullup for BTN_POWER, 10kΩ):

- Pin 1 → `+3V3` power port
- Pin 2 → Net label `BTN_POWER`

**R37** (pullup for BTN_MODE, 10kΩ):

- Pin 1 → `+3V3` power port
- Pin 2 → Net label `BTN_MODE`

**GPIO2 (BTN_SELECT)** is bidirectional and HAS an internal pullup that
firmware can enable (`gpio_pullup_en(GPIO_NUM_2)`). No external pullup
required on the controller. If you want belt-and-suspenders, add one
on the panel board instead.

### G.4 ESP32 module pin connections — what to re-wire on your schematic

Your current schematic has these connections to U2 (ESP32-DevKitC) that
need to be **changed**:

| Module pin (GPIO) | Old net label | New net label                                                                                        |
| ----------------- | ------------- | ---------------------------------------------------------------------------------------------------- |
| GPIO1 (TX0)       | `LED_PWR_N`   | `I2C_SDA`                                                                                            |
| GPIO3 (RX0)       | `LED_CONN_N`  | `I2C_SCL`                                                                                            |
| GPIO2             | `LED_BATT_N`  | `BTN_SELECT`                                                                                         |
| EN (CHIP_PU)      | `BTN_RESET`   | No-Connection flag (the DevKit's onboard reset network drives EN itself; we removed the panel reset) |

Find each label in your schematic and double-click to rename. The
ESP32 pin itself doesn't change — only the net it carries.

Place R36 and R37 immediately next to J3 pins 6 and 7 to keep the
pullup intent visually obvious.

---

## Section H — Test Points, Mounting Holes, Fiducials

Inside the TEST + MECHANICAL box (28..566, 305..400). If you kept the
scripted versions (TP1..TPn, MH1..MH4, FID1..FID3), just verify and add
any missing nets below.

### H.1 Recommended test points

One TP per net listed below. Each TP uses
`Connector:TestPoint` / footprint `TestPoint:TestPoint_Pad_D1.5mm`.

| TP   | Net to attach (net label)                      |
| ---- | ---------------------------------------------- |
| TP1  | `+5V_LED`                                      |
| TP2  | `+3V3` (use power port pin connection)         |
| TP3  | `GND` (power port)                             |
| TP4  | `LED_DATA`                                     |
| TP5  | `LED_DATA_5V`                                  |
| TP6  | `S0`                                           |
| TP7  | `S1`                                           |
| TP8  | `S2`                                           |
| TP9  | `S3`                                           |
| TP10 | `S4`                                           |
| TP11 | `S5`                                           |
| TP12 | `S6`                                           |
| TP13 | `S7`                                           |
| TP14 | `CA_PWR`                                       |
| TP15 | `CB_PWR`                                       |
| TP16 | `CC_PWR`                                       |
| TP17 | `CD_PWR`                                       |
| TP18 | `CE_PWR`                                       |
| TP19 | `CF_PWR`                                       |
| TP20 | `CG_PWR`                                       |
| TP21 | `CH_PWR`                                       |
| TP22 | `COL_DRV_A` (optional — handy for debugging)   |
| TP23 | `BTN_POWER` (optional)                         |
| TP24 | `BTN_MODE` (optional)                          |
| TP25 | `I2C_SDA` (optional, useful for OLED bring-up) |
| TP26 | `I2C_SCL` (optional)                           |

> The Lipo Rider Plus module already exposes 3V3, 5V, GND, BAT, USB,
> EN as labeled solder pads on the daughterboard itself. Probe them
> directly on the module — no need to duplicate as TPs on the
> controller PCB.

TPs 22–26 are nice-to-haves; skip if board space is tight.

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

- `+5V_LED` — regulated 5 V from the PowerBoost module's 5V output; powers WS2812s, TBD62783A VCC, AP2112K LDO input
- `+3V3` — from AP2112K LDO; powers ESP32, pullups, panel logic
- `GND` — ground

**Matrix interface (to J_MAIN / J1):**

- `S0..S7` — row sense, ESP32 inputs with pullups (R1–R8)
- `CA_PWR..CH_PWR` — column power rails, from TBD62783A outputs
- `LED_DATA_5V` — WS2812 chain data input

**Controller-internal:**

- `LED_DATA` — 3V3 from ESP32 GPIO32 to 74AHCT125
- `COL_DRV_A..COL_DRV_H` — 3V3 ESP32 GPIOs to TBD62783A inputs
- `VBAT_MON` — analog battery voltage at the R14/R15 divider junction. Goes to ESP32 GPIO34 (ADC1_CH6). 0.94 V (empty) to 1.31 V (full) at the ADC.

**Panel interface (to J_PANEL / J3):**

- `I2C_SDA`, `I2C_SCL` — I²C bus from ESP32 (GPIO1/3) to SSD1306 OLED on the panel
- `BTN_POWER`, `BTN_MODE`, `BTN_SELECT` — three buttons; reset is via the DevKit's onboard EN button (no panel reset)
- `PANEL_SPARE`, `PANEL_SPARE2` — reserved (single-pin nets on the panel side)

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
