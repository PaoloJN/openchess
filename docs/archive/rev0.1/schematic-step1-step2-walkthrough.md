# Schematic cleanup — KiCad GUI walkthrough

> Companion to `docs/schematic-review-rev0.1.md` (the plan) and
> `docs/schematic-audit-rev0.1.md` (what we actually found). Do this in the
> KiCad 9 schematic editor. Backups already taken — see
> `.backups/master/*.20260603_161138.*`.

The Tech Explorations KiCad 9 video (`references/KiCad 9: Design & assemble Guide.md`)
shows the same workflow we'll use here. Reference timestamps from that doc are
called out where they apply.

---

## Pre-flight

1. **Close any running KiCad windows.** The kicad-skip script + GUI must not race.
2. Make a fresh snapshot of where we are right now (after the `+BAT` PWR_FLAG fix):
   `/backup` from a Claude session, **or**:
   ```bash
   TS=$(date +%Y%m%d_%H%M%S)
   cp ~/Projects/openchess/hardware/openchess.kicad_sch \
      ~/Projects/openchess/.backups/master/openchess.kicad_sch.${TS}
   cp ~/Projects/openchess/hardware/led_chain.kicad_sch \
      ~/Projects/openchess/.backups/master/led_chain.kicad_sch.${TS}
   ```
3. Open `hardware/openchess.kicad_pro`.
4. **Settings → Common → Project Backup**: set "Automatically backup projects" to
   every 5 min, max 10 per day (per video, 53:13). KiCad's own backups live in
   `_autosave-*` next to the project — separate from our `.backups/master/`.

---

## Step 1 — Correctness on the single root sheet

Goal: fix the five remaining fab-blockers before the sheet split, so each is
verifiable in isolation. After each numbered task, run **Inspect → Electrical
Rules Checker** (or `kicad-cli sch erc`) — should stay at 0 errors / 0 warnings.

### 1.1 — Move C2 onto the ESP32 EN pin (CHIP_PU)

**Why:** C2 (2.2 µF) is currently floating at `(311.15, 40.64)`. Its wires
don't reach the EN/CHIP_PU pin of U1, which sits at `(317.5, 101.6)`. Without
this cap, USB programming will glitch — CLAUDE.md flags this as the canonical
fix.

1. Click C2 to select. Press `M` and drop it next to U1's CHIP_PU pin (left side
   of the ESP32 module, second pin from the top). Place it so one terminal sits
   directly on the EN pin and the other terminal points down.
2. Delete the orphan wires that used to sit at y=40.64. Select each, press
   `Delete`.
3. From C2's lower terminal, run a wire (`W`) down to a GND power symbol (`P`
   → search "GND" → place). The wire goes EN-pin → C2 → GND.
4. Add a local label `EN` (`L`) on the wire between C2 and the EN pin so it's
   visually obvious in the schematic.

> Pro-feel tip from the guide (1:00:50): tantalum/electrolytic caps go physically
> closest to the load pin in layout; ceramic decoupling next. C2 here is ceramic
> X7R for EN debouncing — placement priority in PCB layout is "right next to the
> ESP32 module".

### 1.2 — Add a level shifter on LED_DATA

**Why:** ESP32 GPIO32 drives WS2812 DIN at 3.3 V. WS2812B wants
≥ 0.7 × VDD ≈ 3.5 V. Chain will work intermittently at room temp, fail at low
temp / high VDD.

Two ways. Pick one.

**Option A — TXS0104E (auto-direction-sense level translator)**
1. Add part (`A`): library `Logic_LevelTranslator`, symbol `TXS0104E`. Place
   between U1's GPIO32 output net and the BATT_LED1 DIN net.
2. Wiring:
   - `VCCA` → `+3V3`
   - `VCCB` → `+5V`
   - `GND` → `GND`
   - `OE` → `+3V3` (always-on)
   - `A1` → `LED_DATA` (existing label from U1 GPIO32)
   - `B1` → new label `LED_DATA_5V` — re-label the wire going into
     BATT_LED1 DIN from `LED_DATA` to `LED_DATA_5V`.
   - A2..A4 / B2..B4: leave unused with No-Connect flags (`Q`).
3. Add a 100 nF decoupling cap from `VCCA` to GND and another from `VCCB` to GND,
   placed next to the part (per data sheet).

**Option B — 74AHCT125 (single buffer)**
- Simpler footprint, fewer pins, but no auto-direction sense. Use one of the
  four gates. Wire `OE` low to enable, `1A` ← `LED_DATA`, `1Y` → new
  `LED_DATA_5V`. Same decoupling caps. `VCC = +5V`.

**Recommended:** Option B if you want to minimize new BOM lines. Option A if
you want extra channels for future use (e.g., bringing UART out).

### 1.3 — Bulk caps near the ESP32 module

**Why:** the existing module has its own LDO + caps, but those caps are on the
*module*, not on the board. When the module sources a current spike (Wi-Fi TX),
the board-level rail dips unless we have a local reservoir.

1. Add `Device:C` near U1, value `10µF`, polarized (`Device:CP`) ok. Wire
   between `+5V` (top of U1, near pin 19) and `GND`. Place physically close to
   the module pins.
2. Add `Device:C`, value `10µF`. Wire between `+3V3` (pin 1) and `GND`. Same
   placement constraint.
3. Add 100 nF ceramic ` Device:C` next to each of the above (combo bulk + HF
   filter pair — see video 1:01:22 onwards).

### 1.4 — WS2812 decoupling caps

**Why:** 81 chips on a chain with zero bypass = guaranteed flicker, possibly
cascading brownout failures. Minimum: 1× 100 nF per 2-4 LEDs + ~10 µF row-bulk.

Open `led_chain.kicad_sch`.

Two-pass approach to keep this sane:

**Pass A — row bulk caps (9 total):**
1. For each LED row (row 1 = D2..D10, row 2 = D11..D19, …, row 9 = D74..D82):
   - Add a 10 µF cap (`Device:C` or `Device:CP`) near the leftmost LED of the
     row.
   - Wire one terminal to `+5V`, other to `GND`.
2. These are your row-tap bulk caps. They handle low-frequency current draw.

**Pass B — per-LED 100 nF (81 total) — optional but recommended:**
1. Place a single 100 nF cap next to D2, wire `+5V` ↔ `GND` (just place power
   symbols on each terminal — KiCad joins them by net).
2. Select the cap + its two power symbols, copy (`Ctrl+C`), paste 80 times next
   to each remaining LED. KiCad auto-increments the reference.

**Visual cleanup (video 13:50, "ground zone" idea, applied to schematic):**
- Instead of 81× `+5V` + 81× `GND` power symbols stamped per LED, draw a
  horizontal `+5V` rail and a horizontal `GND` rail per row. Each LED gets two
  short stubs (1 grid up to +5V, 1 grid down to GND). Re-reads as a power rail
  instead of a snowstorm. This is the big readability win in this sub-sheet.
- Save this for a third pass; doesn't change ERC.

### 1.5 — Verify

```bash
cd ~/Projects/openchess/hardware
/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli sch erc \
  --severity-all openchess.kicad_sch
```

Expect 0 / 0. If not, fix before moving to Step 2.

Update `hardware/errata/rev0.1.md` "Resolved" table with what you did + date.

---

## Step 2 — Hierarchical sheet split

Goal: convert the one-page root sheet into a 5-sheet hierarchy so each block
maps 1:1 to a physical region of the PCB and a section of the firmware. This
matches the pro video's structure (12:25–13:21, then 1:08:00 for the actual
mechanic of adding a sub-sheet).

### Target structure

```
openchess.kicad_sch              ← root: only sheet symbols + power tree + title block
├── 01_power.kicad_sch           ← USB-C / TP4056 / SW1 / MT3608 / bulk caps / PWR_FLAGs
├── 02_controller.kicad_sch      ← ESP32 + EN cap + decoupling + level shifter
├── 03_column_driver.kicad_sch   ← 74HC595 + 8× Q + base R + pull-ups
├── 04_hall_matrix.kicad_sch     ← 64× hall sensors (A3144) in 8×8 grid
└── led_chain.kicad_sch          ← rename if you want consistency (already exists)
```

### 2.1 — Decide on renumbering first

The audit and CLAUDE.md both note that the current `U3..U66` formula for hall
sensors (`U(3 + file*8 + rank)`) interleaves with logic ICs. The review proposes
renumbering to `U1=ESP32, U2=74HC595, U3=level shifter, U100..U163=hall
sensors`.

**Choose:**
- [ ] **Keep current numbering** — simpler, but CLAUDE.md formula stays as is and
  schematic still reads weird.
- [ ] **Renumber** — cleaner, but you must also update:
  - `CLAUDE.md` "Component reference mapping" section
  - `docs/gpio-map.md` if it references any U#
  - Firmware `board_driver.h` if it has any sensor-index → component-ref mapping

If you renumber: use **Schematic Editor → Tools → Annotate Schematic** with
"Reset existing annotation" + custom starting number per type (see KiCad's
annotation dialog). Do it BEFORE the sheet split — annotation diffs are hard to
read across sheet moves.

### 2.2 — Create the four new sub-sheets

KiCad GUI flow (mirrors video 1:08:00):

For each sheet (start with `01_power`):

1. Click **Place Hierarchical Sheet** (toolbar) or press `S`.
2. Draw a rectangle anywhere on the root sheet. KiCad pops a dialog:
   - Sheet name: `01_power`
   - File name: `01_power.kicad_sch`
3. Click OK. KiCad creates the empty file.
4. Repeat for `02_controller`, `03_column_driver`, `04_hall_matrix`.

You now have 4 empty sheets + the existing `led_chain` + your old root content.

### 2.3 — Move components into their sub-sheets

KiCad doesn't have a "cut from this sheet, paste into another" — the trick is:

1. **On the root sheet**, select all components belonging to one block (say,
   the power block: USB-C, TP4056 connector, SW1, BOOST connector, bulk caps,
   PWR_FLAGs on +BAT/+5V/+3V3, GND symbols in that area).
2. Copy (`Ctrl+C`).
3. Double-click the `01_power` sheet symbol to enter it.
4. Paste (`Ctrl+V`). KiCad asks about reference designators — choose **keep**.
5. Return to root (`Alt+Backspace`).
6. Delete the originals on the root sheet.

Do this per block. Order I'd go in:
1. **Power → `01_power`** (smallest delta, easiest to verify ERC)
2. **Hall matrix → `04_hall_matrix`** (just 64 connectors; isolated)
3. **Column driver → `03_column_driver`** (74HC595 + 8× transistor + R-pack)
4. **Controller → `02_controller`** (ESP32 + EN cap + bulk caps + level
   shifter)

After each block move: **save**, then re-run ERC. Fix any "label only appears
once" errors immediately (those mean a label is no longer connected because its
counterpart moved).

### 2.4 — Promote local labels to hierarchical labels

Each inter-sheet net needs a **hierarchical label** on each side and a
**sheet pin** on the parent's sheet symbol.

Translations to apply:

| Current local label | Becomes | Lives on |
|---|---|---|
| `S0..S7` | hierarchical labels at `04_hall_matrix` row ends AND at `03_column_driver` | both |
| `CA_PWR..CH_PWR` | hierarchical at column tops of `04_hall_matrix`, column drivers of `03_column_driver` | both |
| `SR_CLK / SR_DATA / SR_LATCH` | hierarchical | `02_controller` ↔ `03_column_driver` |
| `LED_DATA` | hierarchical, renamed `LED_DATA_3V3` | `02_controller` source |
| `LED_DATA_5V` (new from level shifter) | hierarchical | `02_controller` → `led_chain` |
| `+BAT` | **global power symbol** (custom) | crosses all sheets |
| `BAT_SW` | hierarchical | `01_power` → `02_controller` |

How to convert a label in KiCad:
1. Click the local label → press `E` (edit properties).
2. In the dialog, change "Label Type" from `Local label` to
   `Hierarchical label`. Click OK.
3. KiCad redraws the label with a pointed tab on one side.
4. On the parent (root) sheet, double-click the sheet symbol and add a matching
   sheet pin (right-click → **Add hierarchical pin**, choose the same name).

For `+BAT` → global power symbol:
1. Create a custom power symbol: **Symbol Editor → File → New Symbol** in your
   `lib/` project library (currently empty). Name `+BAT`. Set "Define as power
   symbol". Add one pin named `+BAT` of type "Power input". Save.
2. Back in schematic, delete the `+BAT` local labels, replace each with your new
   `+BAT` power symbol (`P` → search "+BAT").
3. Move the PWR_FLAG you added today onto the new `+BAT` power symbol's pin.

### 2.5 — Bus labels for S[0..7] and SR_Q[0..7]

Where eight parallel lines cross a long page, use bus syntax — KiCad reads it
exactly like a label group but draws one fat line instead of eight.

1. Click **Place Bus** (`B`) and draw a thick line spanning the page.
2. Click **Place Bus Entry** (`Z`) at each branch point.
3. Label the bus: at one end of the bus, place a label `S[0..7]`. At each entry
   point, place its corresponding `S0`, `S1`, … label. KiCad auto-resolves.
4. Repeat for `SR_Q[0..7]`.

Apply this on `03_column_driver` (where the 8 lines fan out to 8 transistors)
and on `04_hall_matrix` (where 8 lines fan into 8 rows of sensors).

### 2.6 — Functional block boxes + titles

Per video 1:00:28 — every block gets a rectangle + a 14 pt title.

On each sub-sheet:
1. **Place Text Box** (toolbar) — draw a rectangle around the functional block.
2. Style: no fill, 0.15 mm line. Optional light tint (15% opacity) per video
   1:11:30.
3. Add a **Text** label inside, e.g.:
   - `02_controller` → "ESP32 + USB-PROGRAM BUFFER + LEVEL SHIFTER"
   - `03_column_driver` → "COLUMN SCAN — 74HC595 + PNP HIGH-SIDE DRIVERS"
   - `04_hall_matrix` → "HALL SENSOR MATRIX (8×8)"
   - `led_chain` → "WS2812B LED CHAIN (9×9 GRID)"
   - `01_power` → "POWER — USB-C / CHARGER / SWITCH / BOOST"

Fill the title block per sheet: **File → Page Settings** — Rev, Sheet X of Y,
date, sheet-specific subtitle.

### 2.7 — Optional: hall sensor symbol swap

Currently every sensor is `Connector_Generic:Conn_01x03` valued "A3144". To
turn them into a proper A3144:

1. Open Symbol Editor → your `lib/` project library.
2. Either **import** an existing A3144 from `Sensor_Magnetic` (KiCad ships one
   for SS49E; can be adapted), or **derive** one:
   - 3-pin symbol with pins 1=VCC (power input), 2=GND (power input), 3=OUT
     (open-collector).
   - Add an open-collector marker on pin 3.
   - Set the footprint filter to `Package_TO_SOT_THT:TO-92*`.
3. Back in schematic: **Tools → Update Symbols from Library**, mapping
   `Connector_Generic:Conn_01x03` → your new `A3144`. KiCad asks which fields
   to update — leave Reference and net-attached pin numbers alone.
4. Confirm pins 1/2/3 stay numbered the same (else nets break).

### 2.8 — Final verification

```bash
cd ~/Projects/openchess/hardware
/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli sch erc \
  --severity-all openchess.kicad_sch
```

Expect 0 errors, 0 warnings. Any "label only appears once" means a hierarchical
label is connected on one side but not the other — find and fix.

Update `STATUS.md` with the new structure, and bump `hardware/errata/rev0.1.md`
"Resolved" table.

---

## After Step 2 — what's next

- Re-sync `openchess.kicad_pcb` against the cleaned schematic: in PCB Editor,
  **Tools → Update PCB from Schematic** (`F8`). Expect zero net changes; if
  any nets show up as changed, investigate before accepting.
- The hierarchical structure makes `pcb-reviewer` agent much more useful — it
  can now reason about blocks instead of one giant page.
- Re-export Gerbers only after PCB sync is clean: `/run-script export_gerbers`.

If anything goes wrong at any point, restore from the master snapshot taken
2026-06-03 16:11:38:

```bash
cp ~/Projects/openchess/.backups/master/openchess.kicad_sch.20260603_161138 \
   ~/Projects/openchess/hardware/openchess.kicad_sch
cp ~/Projects/openchess/.backups/master/led_chain.kicad_sch.20260603_161138 \
   ~/Projects/openchess/hardware/led_chain.kicad_sch
cp ~/Projects/openchess/.backups/master/openchess.kicad_pcb.20260603_161138 \
   ~/Projects/openchess/hardware/openchess.kicad_pcb
```
