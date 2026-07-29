# Task 6 — USB-C + CH340C + Auto-Program Wiring Guide

**Goal:** Wire the USB-C receptacle (J4), CH340C USB-serial bridge (U7), two S8050 NPN
transistors (Q1, Q2), and their supporting passives. When done, plugging a USB-C cable
into J4 lets your computer flash the ESP32 automatically — no button presses needed.

**Before you start:** Make sure the WROOM core (Task 5) is already pasted into the
schematic. You need the global labels `EN`, `IO0`, `U0TXD`, and `U0RXD` already present.

---

## Symbol Confirmation (grepped from installed KiCad libraries)

The following symbols exist in the installed KiCad 10 library:

| Symbol | Library:Name | Package | Confirmed pins |
|---|---|---|---|
| USB-C receptacle | `Connector:USB_C_Receptacle_USB2.0_16P` | 16-pin USB2 C | See cluster 1 below |
| CH340C | `Interface_USB:CH340C` | SOP-16 | See cluster 2 below |
| NPN transistor | `Transistor_BJT:SS8050` | SOT-23 | B=pin1, E=pin2, C=pin3 |
| ESD protection | `Power_Protection:USBLC6-2SC6` | SOT-23-6L | I/O1=1, GND=2, I/O2=3, I/O2=4, VBUS=5, I/O1=6 |

> **Why SS8050 not S8050?** The physical part sourced is S8050 J3Y in SOT-23 (LCSC C42441446).
> The KiCad symbol `Transistor_BJT:S8050` has a TO-92 through-hole footprint.
> `Transistor_BJT:SS8050` is the SOT-23 version of the same NPN with an identical circuit
> symbol — same pin names (B/E/C), same schematic use. Use SS8050 as the symbol; set the
> Value field to "S8050 J3Y" to match the BOM MPN.

---

## Cluster 1 — USB-C Receptacle J4

### Pin map (from `Connector.kicad_sym` lines 359746–360058)

| KiCad pin | Name | Notes |
|---|---|---|
| A1 | GND | Visible GND pin |
| A4 | VBUS | Visible VBUS pin |
| A5 | CC1 | Visible CC pin |
| A6 | D+ | Visible D+ (side A) |
| A7 | D- | Visible D- (side A) |
| A8 | SBU1 | Leave unconnected (no_connect flag) |
| A9 | VBUS | Hidden — internally tied to A4 |
| A12 | GND | Hidden — internally tied to A1 |
| B1 | GND | Hidden |
| B4 | VBUS | Hidden |
| B5 | CC2 | Visible CC2 pin |
| B6 | D+ | Visible D+ (side B) |
| B7 | D- | Visible D- (side B) |
| B8 | SBU2 | Leave unconnected (no_connect flag) |
| B9 | VBUS | Hidden |
| B12 | GND | Hidden |
| SH | SHIELD | Visible shield pin |

The hidden pins (A9, A12, B1, B4, B9, B12) are **stacked** on the same visual pin stub
as A4/A1 in KiCad's 16P symbol — the symbol already ties them internally. You only need
to wire the **visible** pins (A1/A4/A5/A6/A7/B5/B6/B7/SH).

### Steps

1. **Place symbol** — Add Symbol → search `USB_C_Receptacle_USB2.0_16P` (library: Connector).
   - Reference: `J4`
   - Value: `TYPE-C-31-M-12` (the Hroparts MPN from SOURCING.md)
   - Footprint: `Connector_USB:USB_C_Receptacle_Hroparts_TYPE-C-31-M-12` (or set later)

2. **VBUS net** — Wire pin A4 to a new `VBUS` power flag or net label. The hidden pins A9,
   B4, B9 are already shorted to it inside the symbol — no extra wiring needed.

3. **GND** — Wire pin A1 to `GND` power symbol. Pins A12, B1, B12 are hidden/shorted
   internally. Wire pin SH (SHIELD) also to `GND`.

4. **CC pull-downs** — Two 5.1 kΩ resistors, one per CC pin:
   - Place resistor `R21` (value `5.1k`). Wire one end to pin A5 (CC1), other end to `GND`.
   - Place resistor `R22` (value `5.1k`). Wire one end to pin B5 (CC2), other end to `GND`.

   ```
   A5 CC1 ----[R21 5.1k]---- GND
   B5 CC2 ----[R22 5.1k]---- GND
   ```

5. **Data lines** — Wire the A/B pairs together, then label the junction:
   - Pin A6 (D+) and pin B6 (D+): draw a short wire from each, join with a junction dot.
     Place net label `USB_DP` on the junction.
   - Pin A7 (D-) and pin B7 (D-): same treatment — junction + net label `USB_DM`.

   ```
   A6 D+ --+-- USB_DP
   B6 D+ --'

   A7 D- --+-- USB_DM
   B7 D- --'
   ```

6. **No-connect flags** — Place X no-connect flags on pin A8 (SBU1) and pin B8 (SBU2).

---

## Cluster 2 — CH340C USB-Serial Bridge U7

### Pin map (from `Interface_USB.kicad_sym` lines 5422–5728)

| Pin # | Name | Direction | Connect to |
|---|---|---|---|
| 1 | GND | PWR in | GND |
| 2 | TXD | output | → `U0RXD` global label (ESP32 RX) |
| 3 | RXD | input | ← `U0TXD` global label (ESP32 TX) |
| 4 | V3 | PWR out | 100 nF cap (C19) to GND |
| 5 | UD+ | bidir | `USB_DP` |
| 6 | UD- | bidir | `USB_DM` |
| 7 | NC | — | no-connect flag |
| 8 | NC | — | no-connect flag |
| 9 | ~{CTS} | input | no-connect flag |
| 10 | ~{DSR} | output | no-connect flag |
| 11 | ~{RI} | output | no-connect flag |
| 12 | ~{DCD} | output | no-connect flag |
| 13 | ~{DTR} | output | → auto-program circuit (Q1 base via R23) |
| 14 | ~{RTS} | output | → auto-program circuit (Q2 base via R24) |
| 15 | R232 | — | no-connect flag |
| 16 | VCC | PWR in | VBUS (5V), with C16 100 nF to GND |

> **CRITICAL — TXD/RXD crossover:**
> CH340C pin 2 is named **TXD** (the CH340 transmits on this pin).
> This pin must connect to the ESP32's **RX** input — which in our schematic is net **`U0RXD`**.
>
> CH340C pin 3 is named **RXD** (the CH340 receives on this pin).
> This pin must connect to the ESP32's **TX** output — net **`U0TXD`**.
>
> In plain English: the chip that transmits (`TXD`) wires to the receiver (`RXD`) on the other end.
> The most common wiring mistake is connecting TXD→TXD and RXD→RXD. Do NOT do this.

### Steps

1. **Place symbol** — Add Symbol → search `CH340C` (library: Interface_USB).
   - Reference: `U7`
   - Value: `CH340C`
   - Footprint: `Package_SO:SOP-16_3.9x9.9mm_P1.27mm` (or update later)

2. **VCC power (pin 16):**
   - Wire pin 16 (VCC) to net `VBUS`.
   - Place capacitor `C16` (value `100nF`): one end to the VBUS wire near pin 16, other end to `GND`.
     Place this cap physically close to pin 16 on the schematic.

   ```
   VBUS ---+--- U7 pin 16 (VCC)
           |
          [C16 100nF]
           |
          GND
   ```

3. **V3 bypass (pin 4):**
   - CH340C running at 5V uses its internal 3.3V regulator. The V3 pin is the regulator output.
     You must NOT connect V3 to any supply rail — only a 100 nF bypass cap to GND.
   - Place capacitor `C19` (value `100nF`): one end to pin 4 (V3), other end to `GND`.

   ```
   U7 pin 4 (V3) ---[C19 100nF]--- GND
   ```

4. **GND (pin 1):**
   - Wire pin 1 (GND) to `GND` power symbol.

5. **USB data (pins 5/6):**
   - Wire pin 5 (UD+) to net label `USB_DP`.
   - Wire pin 6 (UD-) to net label `USB_DM`.

6. **Serial crossover — READ CAREFULLY:**
   - Wire pin 2 (TXD) to global label `U0RXD` (ESP32 receive).
   - Wire pin 3 (RXD) to global label `U0TXD` (ESP32 transmit).

   ```
   CH340C TXD (pin 2) -----> U0RXD  (goes TO ESP32 RX pin 34)
   CH340C RXD (pin 3) <----- U0TXD  (comes FROM ESP32 TX pin 35)
   ```

7. **No-connect flags** on: pins 7, 8, 9 (~{CTS}), 10 (~{DSR}), 11 (~{RI}),
   12 (~{DCD}), 15 (R232).

   > Do NOT put no-connect on pins 13 (~{DTR}) and 14 (~{RTS}) — they wire to the auto-program circuit below.

---

## Cluster 3 — Auto-Program Circuit (Q1, Q2, R23, R24)

This copies the DevKitC v4 auto-reset circuit exactly. It lets your computer's USB driver
automatically put the ESP32 into download mode by toggling DTR and RTS — no button presses.

### How it works (conceptual)

The USB driver wiggles DTR and RTS in a specific sequence. Two cross-coupled NPN transistors
convert those signals into the EN pulse and IO0 low that the ESP32 needs to enter boot mode.
You wire them as described by Espressif's DevKitC v4 schematic.

### Symbol: SS8050 pin map (from `Transistor_BJT.kicad_sym`, inherits `Q_NPN_EBC`)

Wait — S8050 in KiCad (Q_NPN_EBC) has: pin 1=E, pin 2=B, pin 3=C.
But SS8050 (Q_NPN_BEC) has: pin 1=B, pin 2=E, pin 3=C.

Since we're using the **SS8050 symbol** (SOT-23 footprint), the pin numbering is:
- Pin 1 = **B** (Base)
- Pin 2 = **E** (Emitter)
- Pin 3 = **C** (Collector)

### Steps

**Place Q1 (SS8050, ref Q1, value "S8050 J3Y"):**
- Pin 3 (C, Collector) → net `EN` (global label — reuse the one from the WROOM core)
- Pin 2 (E, Emitter) → this node becomes an intermediate net; call it `DTR_N`
  (you will wire from here to CH340C ~{RTS} pin 14 and to Q2 emitter)
- Pin 1 (B, Base) → connects to one end of R23

```
                         [Q1 SS8050]
EN <--- Collector (pin3) |
                         | --- Emitter (pin2) ---> DTR_N
         R23 10k         |
CH340 ~{DTR}(pin13) ---[R23]--- Base (pin1)
```

Wait — re-read the task brief:
- Q1: base ← R23 ← CH340C DTR; collector → EN; emitter → CH340C RTS
- Q2: base ← R24 ← CH340C RTS; collector → IO0; emitter → CH340C DTR

The emitter of Q1 connects directly to the ~{RTS} line of CH340C (pin 14).
The emitter of Q2 connects directly to the ~{DTR} line of CH340C (pin 13).
This creates the cross-coupling.

**Place R23 (10 kΩ):**
- One end → CH340C pin 13 (~{DTR})
- Other end → Q1 pin 1 (B, Base)

**Wire Q1:**
- Q1 pin 1 (B) → R23
- Q1 pin 2 (E, Emitter) → CH340C pin 14 (~{RTS})
- Q1 pin 3 (C, Collector) → net label `EN`

**Place Q2 (SS8050, ref Q2, value "S8050 J3Y"):**

**Place R24 (10 kΩ):**
- One end → CH340C pin 14 (~{RTS})
- Other end → Q2 pin 1 (B, Base)

**Wire Q2:**
- Q2 pin 1 (B) → R24
- Q2 pin 2 (E, Emitter) → CH340C pin 13 (~{DTR})
- Q2 pin 3 (C, Collector) → net label `IO0`

### ASCII sketch of the full auto-program circuit

```
CH340C                         Q1 (SS8050)
~{DTR} pin 13 ---+---[R23 10k]--- B(1)
                 |                  |C(3)---> EN
                 |            E(2)--+
                 |                  |
                 +<-----------------+  (Q1 emitter = Q2 base side, ties back to ~{RTS} line)
                 |
CH340C           |              Q2 (SS8050)
~{RTS} pin 14 --++---[R24 10k]--- B(1)
                 |                  |C(3)---> IO0
                 |            E(2)--+
                 |                  |
                 +<-----------------+  (Q2 emitter ties back to ~{DTR} line)
```

More precisely (exact wire connections):

```
DTR(pin13) ---+---[R23]--- Q1.B
              |
              +--- Q2.E
              (same wire node)

RTS(pin14) ---+---[R24]--- Q2.B
              |
              +--- Q1.E
              (same wire node)

Q1.C ---> EN
Q2.C ---> IO0
```

In KiCad, wire it like this:

1. Draw a wire from CH340C pin 13 (~{DTR}). Place a junction.
   - From junction: one branch goes right to R23 pin 1.
   - R23 pin 2 → Q1 pin 1 (Base).
   - From same junction: another branch goes up/down to Q2 pin 2 (Emitter).

2. Q1 pin 3 (Collector) → place global label `EN`.
   Q1 pin 2 (Emitter) → junction that ties to CH340C pin 14.

3. Draw a wire from CH340C pin 14 (~{RTS}). Place a junction.
   - From junction: one branch goes right to R24 pin 1.
   - R24 pin 2 → Q2 pin 1 (Base).
   - From same junction: another branch ties to Q1 pin 2 (Emitter).

4. Q2 pin 3 (Collector) → place global label `IO0`.
   Q2 pin 2 (Emitter) → junction that ties to CH340C pin 13.

---

## Cluster 4 — ESD Protection (Optional but Recommended)

SOURCING.md lists USBLC6-2SC6 as "optional — omit if board space is tight."
If you include it, place it between the USB connector and the CH340C.

**Symbol:** `Power_Protection:USBLC6-2SC6` (SOT-23-6L)
- Reference: `U8` (next unused U ref)
- Value: `USBLC6-2SC6`

**Pin map** (inherits from `USBLC6-2P6`, lines 36016–36478):
| Pin | Name | Connect to |
|---|---|---|
| 1 | I/O1 | USB_DP |
| 2 | GND | GND |
| 3 | I/O2 | USB_DM |
| 4 | I/O2 | USB_DM (internally tied to pin 3) |
| 5 | VBUS | VBUS |
| 6 | I/O1 | USB_DP (internally tied to pin 1) |

Place U8 so its I/O1 pins land on the `USB_DP` wire and I/O2 pins land on `USB_DM`.
Wire pin 2 to GND and pin 5 to VBUS. The component sits "inline" across the data lines.

---

## Summary Checklist

After placing all symbols, verify each item before running the netlist check:

- [ ] J4 placed (Connector:USB_C_Receptacle_USB2.0_16P), ref J4
- [ ] J4 pin A4 (VBUS) wired to net VBUS
- [ ] J4 pins A1, SH (SHIELD) wired to GND
- [ ] R21 5.1k: A5 (CC1) to GND
- [ ] R22 5.1k: B5 (CC2) to GND
- [ ] J4 pins A6+B6 (D+) joined, labeled USB_DP
- [ ] J4 pins A7+B7 (D-) joined, labeled USB_DM
- [ ] J4 pins A8 (SBU1), B8 (SBU2) — no-connect flags
- [ ] U7 placed (Interface_USB:CH340C), ref U7
- [ ] U7 pin 16 (VCC) → VBUS; C16 100nF nearby to GND
- [ ] U7 pin 4 (V3) → C19 100nF → GND (no supply connection)
- [ ] U7 pin 1 (GND) → GND
- [ ] U7 pin 5 (UD+) → USB_DP; pin 6 (UD-) → USB_DM
- [ ] U7 pin 2 (TXD) → global label U0RXD  ← DO NOT SWAP
- [ ] U7 pin 3 (RXD) → global label U0TXD  ← DO NOT SWAP
- [ ] U7 pins 7, 8, 9, 10, 11, 12, 15 — no-connect flags
- [ ] Q1 (SS8050) ref Q1, value S8050 J3Y; C → EN, E → RTS line, B via R23 to DTR line
- [ ] Q2 (SS8050) ref Q2, value S8050 J3Y; C → IO0, E → DTR line, B via R24 to RTS line
- [ ] R23 10k, R24 10k placed and wired
- [ ] (Optional) U8 USBLC6-2SC6: I/O1→USB_DP, I/O2→USB_DM, VBUS→VBUS, GND→GND

---

## Global Labels Used / Reused

| Label | Direction | Source task |
|---|---|---|
| EN | bidir | Task 5 (WROOM core) — reuse |
| IO0 | bidir | Task 5 (WROOM core) — reuse |
| U0TXD | output | Task 5 (WROOM core) — reuse |
| U0RXD | input | Task 5 (WROOM core) — reuse |
| VBUS | power | New — place a Power:PWR_FLAG on it |
| USB_DP | bidir | New |
| USB_DM | bidir | New |

---

## After Wiring: Run the Netlist Check

```bash
KICAD=/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli
$KICAD sch export netlist \
  hardware/hardware-controller-v2/openchess-controller.kicad_sch \
  --output /tmp/v2.net

python3 hardware/hardware-controller-v2/scripts/check_task6.py
```

All checks should print `OK`. If any print `FAIL`, re-read the net label for that item.
