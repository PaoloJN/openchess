# Schematic review — rev 0.1

Date: 2026-06-03
Reviewer: Claude (session: schematic-design)
Scope: `hardware/openchess.kicad_sch` + `hardware/led_chain.kicad_sch`

## What's in the schematic today

One A3 root sheet (96 symbols) + one LED sub-sheet (81× WS2812 + 81× +5V + 81× GND).

Root sheet contains, all on one page:
- ESP32-DevKitC (U1) top-right
- 74HC595 shift register
- 8× 2N3906 PNP column drivers (Q-column at X≈40)
- 8× base resistors (X≈52), 8× pull-up resistors (X≈99)
- 64× hall sensors as `Connector_Generic:Conn_01x03` in an 8×8 grid (X 101.6→367.03, Y 148.59→237.49)
- BATT_LED (D1) + 100 nF
- Power input strip along the top: BAT_IN1, PWR_SW1, BOOST_MODULE1, charger connectors
- All inter-section nets are **local labels** (`S0–S7`, `CA_PWR–CH_PWR`, `SR_CLK/DATA/LATCH`, `LED_DATA`, `+BAT`, `BAT_SW`)
- Only 2 text annotations on the whole page (no functional block titles)
- Only 2 capacitor symbols in the whole design

## Correctness issues (block fab)

These should be fixed before sending anything to a board house.

1. **No level shifter on `LED_DATA`.**
   ESP32 GPIO32 = 3.3 V. WS2812B DIN wants ≥ 0.7·VDD ≈ 3.5 V. joojoooo's reference uses a TXS0104E (or 74AHCT125). Not present in current schematic. Add it between GPIO32 and the chain DIN (BATT_LED's DIN, since the chain starts there).

2. **No WS2812 decoupling caps.**
   81 chips, zero 100 nF bypass. Minimum: 1× 100 nF per 2–4 LEDs, plus a 10–100 µF bulk cap at each row tap on the +5V rail. Without this you'll get rail bounce and flicker — possibly cascading failures if the chain browns out mid-frame.

3. **Missing C2 (2.2 µF on ESP32 EN).**
   CLAUDE.md calls this out as the standard USB-upload-glitch fix. Only 2× `Device:C` exist in the file and both look tied to BATT_LED. Add:
   - C(EN) = 2.2 µF, ESP32 EN → GND
   - 10 µF bulk on +3V3 near the module
   - 10 µF bulk on +5V near the module's VIN

4. **No PWR_FLAG on `+BAT` or USB-in.**
   Only 3 PWR_FLAGs total — ERC should flag the battery rail as unconnected source. Add flags on `+BAT` and the USB-C V+ input.

5. **Hall sensors are generic 3-pin connectors.**
   Functionally OK but unreadable. Make a proper A3144 symbol (Reference=U, Value=A3144, pins named `VCC/GND/OUT`, open-collector marker). Existing `Sensor_Magnetic` library has candidates. Net assignments survive the swap as long as pin numbers stay 1/2/3.

## Organization: how to make it read like a pro design

Split the single root page into 5 hierarchical sheets. Root sheet becomes **just sheet symbols + the global power tree** — no actual components.

```
openchess.kicad_sch              ← root: sheet blocks + power flags + title
├── 01_power.kicad_sch           ← USB-C / TP4056 / SW1 / MT3608 / bulk caps / PWR_FLAGs
├── 02_controller.kicad_sch      ← ESP32 + EN cap + decoupling + boot strap pins + level shifter
├── 03_column_driver.kicad_sch   ← 74HC595 + 8× Q + 8× base R + 8× pull-up R
├── 04_hall_matrix.kicad_sch     ← 64× A3144 in an 8×8 grid (proper symbol)
└── 05_led_chain.kicad_sch       ← 81× WS2812 + per-LED decoupling + row bulk caps
```

Each sheet maps to one physical function on the PCB and one section of the firmware. When a row of sensors stops working, you open one sheet, not scroll a wall.

## Signal hygiene

- Promote inter-sheet nets to **hierarchical labels** at sheet pins: `S0..S7`, `CA_PWR..CH_PWR`, `SR_CLK/DATA/LATCH`, `LED_DATA_3V3` (pre-shifter), `LED_DATA_5V` (post-shifter), `BATT_VSENSE`.
- Make `+BAT` a **global power symbol** (matches existing `+5V` / `+3V3` / `GND` treatment).
- Bundle `S0..S7` into a **bus** (`S[0..7]`) where it crosses the page. Same for `SR_Q[0..7]`. Big readability win.
- On the hall matrix sheet, put `CA_PWR..CH_PWR` only at column tops and `S0..S7` only at row ends — don't repeat per-sensor.

## Visual cleanup ("pro feel")

- Add `text_box` rectangles around each functional block with a 14 pt title (e.g. **"COLUMN SCAN — 74HC595 + PNP HIGH-SIDE DRIVERS"**). Currently: zero section labels.
- Fill in the title block per sub-sheet: `Rev`, `Sheet X of Y`, function description.
- On `led_chain`: drop the 81 individual `+5V` / `GND` power symbols, route a horizontal `+5V` and `GND` rail per row with short stubs to each LED. Reads as a rail, not a snowstorm.
- Place decoupling caps **next to** the chip they bypass, not on a separate row.

## Component renumber (optional but nice)

Current numbering interleaves logic ICs and sensor connectors (U1=ESP32, U3..U66=sensors, others scattered). Cleaner scheme:

| Range | Function |
|---|---|
| U1 | ESP32-DevKitC |
| U2 | 74HC595 |
| U3 | TXS0104E (new — level shifter) |
| U100..U163 | hall sensors A3144 (preserve file-major order so U100=A1, U163=H8) |
| Q1..Q8 | column drivers |
| D1 | BATT_LED |
| D2..D82 | LED matrix |

This breaks the `U(3 + file*8 + rank)` formula in CLAUDE.md. If we renumber, update CLAUDE.md and `docs/gpio-map.md` to match.

## Suggested next move

Two-step, so each change is verifiable in isolation:

**Step 1 — correctness on the current single sheet:**
- Add TXS0104E (or 74AHCT125) on `LED_DATA`.
- Add C(EN), bulk caps on +3V3 and +5V, WS2812 decoupling caps, PWR_FLAGs on `+BAT` / USB-in.
- Re-run ERC, capture in `hardware/errata/rev0.1.md`.

**Step 2 — split into 5 hierarchical sheets** and promote labels to hierarchical / global / bus form.

Decide on renumbering before or during step 2 (annotator change affects netlist diffs).
