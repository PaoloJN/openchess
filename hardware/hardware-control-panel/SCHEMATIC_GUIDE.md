# Control Panel Schematic — Hand-Drawing Guide

This is the build sheet for the OpenChess control-panel schematic. The
panel is the side-mounted board with 3 status LEDs (PWR / CONN / BATT)
and 3 pushbuttons (POWER / MODE / RESET) connected to the controller
through a single 10-pin cable.

The panel has ~14 electrical components — it's small enough that
hand-drawing it is quick and gives you a clean schematic without any
script dependency.

---

## 0. Setup

### Back up and start fresh

```bash
cd /Users/paolonessim/Projects/openchess/hardware/hardware-control-panel
cp openchess-control-panel.kicad_sch openchess-control-panel.kicad_sch.scripted_backup
```

Open `openchess-control-panel.kicad_sch` in KiCad. You have two options:

1. **Nuke and rebuild (recommended)** — Edit → Select All → Delete.
   Keeps page setup + title block + `lib_symbols` cache. Draw everything
   from this guide.
2. **Salvage as-is** — the scripted schematic is already ERC-clean. Just
   verify against this guide and skip placement. Useful as reference.

If you choose option 1, also archive the script so it doesn't wipe your work:

```bash
mv scripts/sch scripts/sch.archived
mkdir -p scripts/sch
echo "Scripts archived 2026-06-05 — panel maintained by hand in KiCad GUI." > scripts/sch/README.md
```

---

## 1. Conventions used in this guide

### Power vs net labels

- **Power port** (KiCad shortcut `P`) → `+3V3` and `GND` (the rails
  coming in from the controller through J1).
- **Net label** (KiCad shortcut `L`) → every signal name (`LED_PWR_N`,
  `LED_CONN_N`, `LED_BATT_N`, `BTN_POWER`, `BTN_MODE`, `BTN_RESET`,
  `PANEL_SPARE`, plus the internal LED anode mid-nets `LED_PWR_A`, etc.).
- **No-Connection flag** (`Q`) → not needed on this board; no IC pins
  to flag.

### KiCad shortcuts

| Key | Action |
|---|---|
| `A` | Add symbol |
| `W` | Wire |
| `L` | Net label |
| `P` | Power port |
| `R` | Rotate (during placement) |
| `M` | Move |
| `G` | Drag (keeps wires attached) |
| `E` | Edit properties |

### Reference designators

| Range | Section |
|---|---|
| J1 | J_PANEL connector |
| D1, D2, D3 | Status LEDs (PWR, CONN, BATT) |
| R1, R2, R3 | LED series resistors |
| SW1, SW2, SW3 | Pushbuttons |
| TP1.. | Test points |
| MH1.. | Mounting holes |
| FID1.. | Fiducials |

### Page layout zones (rough)

```
A4 page, top-left origin

   ┌────────────────────────┐ ┌────────────────────────┐
   │ Sec A — STATUS LEDs    │ │ Sec C — J_PANEL        │
   │ D1 PWR  + R1           │ │ J1 (1x10 connector)    │
   │ D2 CONN + R2           │ │ Cable to controller    │
   │ D3 BATT + R3           │ │                        │
   └────────────────────────┘ └────────────────────────┘
   ┌────────────────────────┐ ┌────────────────────────┐
   │ Sec B — BUTTONS        │ │ Sec D — TEST + MECH    │
   │ SW1 POWER              │ │ TP1..TP7  MH1..MH4     │
   │ SW2 MODE               │ │ FID1..FID3             │
   │ SW3 RESET              │ │                        │
   └────────────────────────┘ └────────────────────────┘
```

If you want the box outlines back as visual guides, you can re-run
`python3 scripts/sch.archived/sch/01_skeleton.py` **once**, then never
again on this board.

---

## Section A — Status LEDs (3 channels, active-low)

The controller sinks each `LED_X_N` net to turn the LED on. From the
panel's perspective: `+3V3` → series resistor → LED anode → LED cathode
→ `LED_X_N` (and the controller pulls it low to light the LED).

### A.1 Components

Three identical channels. The LED "value" is the visible label; the
ref is the part designator.

| Ref | Symbol | Value | Footprint |
|---|---|---|---|
| R1 | `Device:R` | 1k | `Resistor_SMD:R_0805_2012Metric` |
| D1 | `Device:LED` | PWR | `LED_SMD:LED_0805_2012Metric` |
| R2 | `Device:R` | 1k | `Resistor_SMD:R_0805_2012Metric` |
| D2 | `Device:LED` | CONN | `LED_SMD:LED_0805_2012Metric` |
| R3 | `Device:R` | 1k | `Resistor_SMD:R_0805_2012Metric` |
| D3 | `Device:LED` | BATT | `LED_SMD:LED_0805_2012Metric` |

> **About the resistor value:** the scripted version uses 1 kΩ, which
> gives ~1.3 mA through a typical 2 V Vf LED. That's quite dim in
> ambient light. If you're noticing the LEDs are hard to see, drop to
> 220 Ω or 330 Ω (10–6 mA, clearly visible). Change the value in
> KiCad's properties panel — no footprint change needed.

### A.2 Wiring — one channel, repeat for all three

Pattern for channel "PWR" (D1, R1, sink net `LED_PWR_N`):

**R1** (vertical orientation, pin 1 at top):
- Pin 1 → `+3V3` power port
- Pin 2 → Wire to **D1 pin 2 (anode)**; optionally drop a net label
  `LED_PWR_A` here (handy for ERC clarity but optional)

**D1** (LED, pin 1 = cathode, pin 2 = anode):
- Pin 1 (cathode) → Net label `LED_PWR_N`
- Pin 2 (anode) ← wire from R1 pin 2

For the other two channels:
- **CONN**: R2 + D2 with sink net `LED_CONN_N`
- **BATT**: R3 + D3 with sink net `LED_BATT_N`

### A.3 Visual tips

- Stack the 3 channels vertically with the `+3V3` rail along the top
  (place a single `+3V3` power port at the top of each resistor — KiCad
  resolves them as the same net by symbol type).
- The 3 `LED_X_N` labels exit on the right side of each LED, pointing
  toward where J1 lives in the next column.

---

## Section B — Pushbuttons (3, short to GND)

Each button shorts a `BTN_X` signal net to GND when pressed. Pullups for
these nets live on the **controller**, not here.

### B.1 Components

| Ref | Symbol | Value | Footprint |
|---|---|---|---|
| SW1 | `Switch:SW_Push` | POWER | `Button_Switch_SMD:SW_SPST_TL3342` |
| SW2 | `Switch:SW_Push` | MODE | `Button_Switch_SMD:SW_SPST_TL3342` |
| SW3 | `Switch:SW_Push` | RESET | `Button_Switch_SMD:SW_SPST_TL3342` |

> The TL3342 is a through-hole tactile. Fine for prototype hand
> assembly. If you're doing JLCPCB assembly, swap to an SMD equivalent
> (e.g. `Button_Switch_SMD:SW_SPST_SKQG_WithoutStem`) and update the
> footprint field — no schematic change otherwise.

### B.2 Wiring — one button, repeat for all three

**SW1** (POWER):
- Pin 1 → Net label `BTN_POWER`
- Pin 2 → `GND` power port

**SW2** (MODE):
- Pin 1 → Net label `BTN_MODE`
- Pin 2 → `GND` power port

**SW3** (RESET):
- Pin 1 → Net label `BTN_RESET`
- Pin 2 → `GND` power port

That's it — no resistors, no pullups (those live on the controller).

---

## Section C — J_PANEL Connector

The single 10-pin cable connector linking back to the controller.

### C.1 Component

| Ref | Symbol | Value | Footprint |
|---|---|---|---|
| J1 | `Connector_Generic:Conn_01x10` | J_PANEL 1x10 | `Connector_PinHeader_2.54mm:PinHeader_1x10_P2.54mm_Vertical` |

### C.2 Pin-by-pin

This must exactly mirror the controller's J5. Each net flows between the
two boards through the cable.

| J1 pin | Net | How | Direction |
|---:|---|---|---|
| 1 | `+3V3` | Power port | controller → panel |
| 2 | GND | Power port | both |
| 3 | `LED_PWR_N` | Net label | controller sinks |
| 4 | `LED_CONN_N` | Net label | controller sinks |
| 5 | `LED_BATT_N` | Net label | controller sinks |
| 6 | `BTN_POWER` | Net label | panel → controller |
| 7 | `BTN_MODE` | Net label | panel → controller |
| 8 | `BTN_RESET` | Net label | panel → controller |
| 9 | `PANEL_SPARE` | Net label | reserved (see note) |
| 10 | GND | Power port | both |

### C.3 PANEL_SPARE note

`PANEL_SPARE` only appears on this one pin on the panel board. ERC may
warn that the net has only one connection. Options:

- **Leave as-is** — accept the ERC warning as expected for a reserved
  pin. (Recommended for prototype.)
- **Add a placeholder test point** — drop a TP on `PANEL_SPARE` so it
  has two connections and ERC is happy. Also lets you scope it.
- **Add `(no_connect)` flag** — tells ERC "intentionally unused" but
  also means the pin is electrically dead. Don't do this if you want to
  use the spare later.

The scripted version uses option 1.

---

## Section D — Test Points, Mounting Holes, Fiducials

### D.1 Recommended test points

One TP per net so you can scope every line during bring-up.

| TP | Net |
|---|---|
| TP1 | `+3V3` |
| TP2 | `GND` |
| TP3 | `LED_PWR_N` |
| TP4 | `LED_CONN_N` |
| TP5 | `LED_BATT_N` |
| TP6 | `BTN_POWER` |
| TP7 | `BTN_MODE` |
| TP8 | `BTN_RESET` |
| TP9 | `PANEL_SPARE` (optional) |

Each TP uses `Connector:TestPoint` / `TestPoint:TestPoint_Pad_D1.5mm`.
Wire its single pin to a short stub and label/power-port the stub end.

### D.2 Mechanical

| Ref | Symbol | Footprint |
|---|---|---|
| MH1..MH4 | `Mechanical:MountingHole` | `MountingHole:MountingHole_3.2mm_M3` |
| FID1..FID3 | `Mechanical:Fiducial` | `Fiducial:Fiducial_1mm_Mask2mm` |

Place anywhere in the bottom strip. No pins.

### D.3 PWR_FLAG symbols

Add one `power:PWR_FLAG` symbol on each rail so ERC knows where the
rail is sourced. The panel **consumes** `+3V3` and `GND` from the
controller, so technically the source is the controller's LDO and
USB-C. But ERC on the panel board alone can't see that — drop a
PWR_FLAG on `+3V3` and `GND` so ERC stops complaining.

- `PWR_FLAG` on `+3V3` (attach to a `+3V3` power port or label)
- `PWR_FLAG` on `GND` (attach to a `GND` power port)

---

## Section E — Final Checks

### E.1 ERC

Inspect → **Electrical Rules Checker** → Run. Expected: 0 violations,
or 1 warning on `PANEL_SPARE` if you chose to leave it as a single-pin
net.

If you see "pin not driven by any Net" on `+3V3` or `GND`, you forgot a
PWR_FLAG.

### E.2 Annotate

Tools → **Annotate Schematic**. Confirm refs are sequential and
unique.

### E.3 Commit

```bash
git add openchess-control-panel.kicad_sch
git commit -m "panel schematic: hand-drawn rev0.1 — 3 LEDs + 3 buttons + J_PANEL"
```

---

## Quick-reference: every net on this board

For sanity-checking your labels.

**Power rails (from controller):**
- `+3V3` — logic rail used by R1/R2/R3
- `GND` — ground

**LED sink nets (to controller):**
- `LED_PWR_N`, `LED_CONN_N`, `LED_BATT_N` — active-low; controller
  sinks to turn LED on

**Button nets (to controller):**
- `BTN_POWER`, `BTN_MODE`, `BTN_RESET` — open when released, GND when
  pressed; pullup on controller

**Reserved:**
- `PANEL_SPARE` — terminates only at J1 pin 9 on this board

If a label in your schematic isn't in this list, you've introduced a
typo and ERC will catch it as a one-pin net.

---

## Order of attack

1. Section C (J_PANEL) — defines the contract; everything connects to it
2. Section A (Status LEDs) — small repeatable pattern
3. Section B (Buttons) — easiest section
4. Section D (TPs + mech + PWR_FLAG)
5. ERC sweep
6. Annotate + commit

Realistic time: under an hour for a clean schematic.
