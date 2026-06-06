# Schematic audit (rev 0.1 review verification)

Date: 2026-06-03
Author: Claude (hardware session, schematic-cleanup pass)
Source: `hardware/openchess.kicad_sch` + `hardware/led_chain.kicad_sch`
Master backup taken before any edits: `.backups/master/*.20260603_161138.*`

This document re-verifies each correctness claim in `docs/schematic-review-rev0.1.md`
against the actual file contents (read via `kicad-skip` + raw S-expr inspection) before
acting on it. Use it as the source of truth for what's actually wrong.

## Symbol inventory (root sheet, openchess.kicad_sch)

| lib_id | count | refs (sample) |
|---|---|---|
| `Espressif_Official:ESP32-DevKitC` | 1 | `U1` |
| `74xx:74HC595` | 1 | `U2` |
| `Connector_Generic:Conn_01x03` | 64 | `U3..U66` (hall sensors) |
| `Transistor_BJT:2N3906` | 8 | `Q1..Q8` |
| `Device:R` | 16 | `R1..R16` |
| `Device:C` | **2** | `C1`, `C2` |
| `LED:WS2812B` | 1 | `BATT_LED1` (= D1) |
| `Connector_Generic:Conn_01x02` | 1 | `BAT_IN1` |
| `Connector_Generic:Conn_01x04` | 1 | `BOOST_MODULE1` |
| `Switch:SW_SPST` | 1 | `PWR_SW1` |
| `power:+5V` | 14 | various #PWR |
| `power:+3.3V` | 9 | various #PWR |
| `power:GND` | 73 | various #PWR |
| `power:PWR_FLAG` | **3** | `#FLG01..03` |

`led_chain.kicad_sch`: 81 × `LED:WS2812B`, 81 × `power:+5V`, 81 × `power:GND`,
**0 × `Device:C`**.

## Review claim ↔ actual state

### 1. Level shifter on LED_DATA — CONFIRMED MISSING
No `TXS0104E`, `74AHCT125`, or any level-shift symbol in either sheet. ESP32 GPIO drives
WS2812 DIN at 3.3 V directly. **Fab-blocker.**

### 2. WS2812 decoupling caps — CONFIRMED MISSING
`led_chain.kicad_sch` has zero capacitors. Every LED has its own per-LED `+5V` and `GND`
power symbol but no bypass. **Fab-blocker.**

### 3. C(EN) = 2.2 µF on ESP32 EN — **ALREADY DONE** (audit was wrong)

`C2 = 2.2 µF` is correctly wired to EN via **label coupling**: C2's top
terminal has an `EN` local label, U1's CHIP_PU pin has the matching `EN` label.
The two labels join the nets across the page even though the symbols aren't
physically adjacent. My initial coordinate-based search missed this because I
only looked for labels within a few mm of C2.

→ No action needed. The original review-rev0.1 doc was wrong about this; the
audit propagated the error.

### 4. PWR_FLAG coverage — PARTIALLY MISSING

Three PWR_FLAGs exist:
| Position | Attached to |
|---|---|
| `(177.8, 71.1)` | `+5V` (next to `#PWR04`) |
| `(177.8, 90.2)` | `GND` (next to a nearby GND symbol) |
| `(353.1, 31.8)` | `+3.3V` (next to `#PWR087`) |

Missing PWR_FLAGs on:
- **`+BAT`** — currently a *local label* at `(196.8, 48.3)`. Per the review, it should
  become a global power symbol AND get a PWR_FLAG so ERC sees it as a real source.
- **USB-V+ input** (`BAT_SW` net, or whatever the upstream of `PWR_SW1` is called) —
  no flag.

### 5. Hall sensors as generic `Conn_01x03` — CONFIRMED

64 × `Connector_Generic:Conn_01x03`. Functionally OK (pin 1/2/3 → VCC/GND/OUT),
but the value field reads `Conn_01x03`, not `A3144`. Search/select friendliness is
poor and the schematic doesn't visually communicate "hall sensor".

## Additional things noticed (not in review)

- **`+BAT` is a local label, not a global / power symbol.** That means `+BAT` exists
  only on this page; any future hierarchical sheet split would break that net unless
  it's promoted to a global power symbol or a hierarchical label.
- **`BAT_SW` is a local label** carrying the post-switch battery rail into the boost
  module connector. Same hierarchical-split caveat.
- **Local labels for inter-block signals:** `S0..S7`, `SR_Q0..SR_Q7`, `SR_CLK / DATA /
  LATCH`, `CA_PWR..CH_PWR`, `LED_DATA`. These all need to become **hierarchical
  labels** when we split into sheets. `S0..S7` and `SR_Q0..SR_Q7` are perfect bus
  candidates (`S[0..7]`, `SR_Q[0..7]`).
- **No global labels in either sheet.** Sub-sheet `led_chain` already uses
  `LED_DATA_OUT_1` as a hierarchical pin — that's the right pattern, the rest of the
  inter-block signals should follow it.
- **No functional block boxes / titles** — confirmed, only 2 text annotations on the
  whole root page.

## What the script will do (safe, additive)

`hardware/scripts/sch_step1_pwr_flag_bat.py`:
- Add **one** `power:PWR_FLAG` symbol attached to the `+BAT` local label at
  `(196.8, 48.3)`. Idempotent — looks for an existing flag within 5 mm of that
  position and bails if present.

That's the only change I trust to apply blindly with no user verification of layout.
Everything else (moving C2, adding the level shifter, adding LED decoupling, splitting
sheets) is done by you in the KiCad GUI from
`docs/schematic-step1-step2-walkthrough.md`.

## What's intentionally NOT in the script

| Change | Why GUI not script |
|---|---|
| Move/rewire C2 onto ESP32 EN | Two wires to redraw + verify pin landing; KiCad GUI is faster & visually verifiable |
| Add level shifter (TXS0104E / 74AHCT125) | 8-pin part with VCCA/VCCB/OE/GND + 4 channels, library symbol must be picked, wiring is non-trivial |
| 10 µF bulk on +5V and +3V3 near U1 | Position matters (must be physically next to module in layout); two new symbols + 2 GND + wires |
| 81 × WS2812 decoupling (100 nF per LED) | Position matters; cleanest done with KiCad's "place + repeat" muscle memory |
| Promote `+BAT` local label → global `power` symbol | One-click in GUI, error-prone via text edit (custom power symbol definition + global flag) |
| Hall sensor `Conn_01x03` → `A3144` symbol | Library swap; touches all 64 sensors; net assignments depend on pin numbers staying 1/2/3 |
| 5-sheet hierarchical split | Pure GUI workflow — KiCad's "save selection as sheet" is the supported path |
