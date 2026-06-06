# OpenChess Hardware Design Notes

**Source of truth.** This document captures the current, agreed-upon
design for the OpenChess hardware. Per-board build sheets live in each
board's `SCHEMATIC_GUIDE.md`; pin-level assignments live in
`docs/gpio-map.md`; cross-board cable contracts live in
`docs/inter-board-connector.md`. This file is the index and the
authoritative reference for the *design itself*.

Last meaningful revision: **2026-06-05** (panel PCB dropped; panel
components now on flying leads).

---

## 1. What we're building

A physical chess board with magnetic piece detection and visual
feedback. Plays online via Lichess and offline against Stockfish.
Magnetic Hall sensors detect pieces; corner WS2812B LEDs indicate
moves. UI is an SSD1306 OLED + 3 panel-mount buttons. Powered by a
LiPo battery with USB-C charging.

**This is a one-off personal project**, not a product. The goal is:

- Learn through hands-on PCB design.
- Build **one** board that works first try.
- Optimize for first-build reliability over BOM cost.
- When it works on Paolo's desk, the project is done.

Design choices reflect this: we prefer well-tested daughterboard
modules over discrete switching regulators, accept higher unit cost in
exchange for lower risk, and skip "production" concerns like
manufacturability for volume, certification, or supply-chain
resilience.

**Core sensing**: 8×8 grid of A3144 Hall-effect sensors detects which
squares have a magnet under them (every chess piece carries one).

**Core display**: 9×9 grid of WS2812B RGB LEDs at the corners of the
squares; firmware lights them to indicate legal moves, threats, last
move, etc.

**Compute**: an ESP32-DevKitC v4 module (the off-the-shelf dev board)
plugged into the controller PCB via headers, runs WiFi/Bluetooth +
chess logic + UI.

---

## 2. Hardware split

**Two PCBs** + one cable-mounted component group:

```text
hardware/
├── hardware-board/         # passive matrix: 64 Halls + 81 WS2812 LEDs
└── hardware-controller/    # ESP32 socket, power, scan/driver ICs

(Panel components, no PCB)  # OLED + 3 panel-mount buttons on flying
                             # leads, mounted on the side of the enclosure
```

**Assembly layout** (decided 2026-06-05 from the user's mockup):

- Matrix PCB is the entire chessboard. Halls + LEDs on the **top face**;
  the back face is clean except for the J_CTRL stacking socket.
- Controller PCB **mounts directly underneath the matrix board** via
  board-to-board stacking pin headers (J_MAIN ↔ J_CTRL) and 4× M3 corner
  standoffs (~11 mm tall). No ribbon cable between them.
- The LiPo battery sits **alongside the controller**, in the space
  between the matrix PCB's back and the enclosure floor.
- The panel components (OLED + 3 buttons + panel-mount USB-C) mount on
  **one side wall of the enclosure** via flying leads from J3 on the
  controller PCB.

**Why this split**:
- **Matrix board** is large (chess board sized) and has only passive
  parts → cheap 2-layer fab, optimized for sensor placement.
- **Controller board** has the active ICs (Lipo Rider Plus power module,
  level shifter, column driver IC, ESP32 socket) → small dense PCB.
- **Panel components live in the enclosure on flying leads** — the
  OLED module is mounted via standoffs or a 3D-printed bezel; the 3
  buttons are panel-mount pushbuttons through enclosure holes. All
  wired back to the controller's `J3` (J_PANEL) connector. No separate
  PCB.

The boards talk through two cable contracts (§3): a 26-wire ribbon
between matrix and controller, and a 10-wire harness from the
controller to the panel-mount components.

The original `hardware-control-panel/` PCB design was dropped on
2026-06-05 (panel components moved to flying leads) and archived to
`delete/hardware-control-panel-2026-06-05/`.

The older monolithic single-PCB design was archived to
`delete/old-hardware-2026-06-04/`. Do not reference that work.

---

## 3. Cross-board connector contracts

### 3.1 Matrix ↔ Controller — `J_CTRL` (matrix) ↔ `J_MAIN` (controller)

**Board-to-board stacking, 2×13 at 2.54 mm pitch. No ribbon cable.**
The controller PCB mounts directly below the matrix PCB via mating
pin header + socket:

- **Controller side (`J_MAIN`)**: 2×13 **male pin header** on the
  controller PCB's top face, pointing up toward the matrix.
  Footprint: `Connector_PinHeader_2.54mm:PinHeader_2x13_P2.54mm_Vertical`
- **Matrix side (`J_CTRL`)**: 2×13 **female socket** on the matrix
  PCB's back face, pointing down toward the controller.
  Footprint: `Connector_PinSocket_2.54mm:PinSocket_2x13_P2.54mm_Vertical`

The two connectors mate naturally — different connector types prevent
mis-orientation. Still mark pin 1 with a silkscreen dot on both boards
for assembly clarity.

Mechanical: 4× M3 brass standoffs (~11 mm tall — matches the mating
depth of the pin+socket combo) at the controller PCB's corners hold
it rigidly to the matrix PCB's back side. The board-to-board connector
provides electrical connection; the standoffs provide mechanical
support.

| Pin | Net | Direction |
|----:|-----|-----------|
| 1 | `+5V_LED` | controller → matrix |
| 2 | `GND` | both |
| 3 | `+5V_LED` | controller → matrix |
| 4 | `GND` | both |
| 5 | `+5V_LED` | controller → matrix |
| 6 | `GND` | both |
| 7 | `LED_DATA_5V` | controller → matrix |
| 8 | `GND` | both |
| 9 | `S0` | matrix → controller |
| 10 | `S1` | matrix → controller |
| 11 | `S2` | matrix → controller |
| 12 | `S3` | matrix → controller |
| 13 | `S4` | matrix → controller |
| 14 | `S5` | matrix → controller |
| 15 | `S6` | matrix → controller |
| 16 | `S7` | matrix → controller |
| 17 | `CA_PWR` | controller → matrix |
| 18 | `CB_PWR` | controller → matrix |
| 19 | `CC_PWR` | controller → matrix |
| 20 | `CD_PWR` | controller → matrix |
| 21 | `CE_PWR` | controller → matrix |
| 22 | `CF_PWR` | controller → matrix |
| 23 | `CG_PWR` | controller → matrix |
| 24 | `CH_PWR` | controller → matrix |
| 25 | `+5V_LED` | controller → matrix |
| 26 | `GND` | both |

Counts: 4× `+5V_LED`, 5× `GND`, 1× `LED_DATA_5V`, 8× row-sense,
8× column-power. Cable: 26-wire IDC ribbon, ≤ 20 cm preferred to limit
IR drop on `+5V_LED` and edge degradation on `LED_DATA_5V`.

### 3.2 Controller ↔ Panel components — `J_PANEL`

**1×10 polarized connector on the controller side** (recommended:
**JST XH 10-pin**). The other end of the cable terminates at the
discrete panel components (OLED module 4-wire pigtail, 3× panel-mount
button leads). There is no PCB on the panel side — see §6.

JST XH is the right pick because:
- Polarized (mechanically can't be plugged in backwards)
- Latching (won't pop out from cable flex)
- Crimp terminals for individual wires (flexible cable harness)
- Cheap (~$0.30 for the receptacle on the controller PCB)

| Pin | Net | Direction |
|----:|-----|-----------|
| 1 | `+3V3` | controller → panel (OLED + button pullup supply) |
| 2 | `GND` | both |
| 3 | `I2C_SDA` | bidirectional (ESP32 GPIO1 ↔ OLED) |
| 4 | `I2C_SCL` | controller → panel (ESP32 GPIO3) |
| 5 | `BTN_SELECT` | panel → controller (GPIO2, internal pullup) |
| 6 | `BTN_POWER` | panel → controller (GPIO36, external pullup on controller) |
| 7 | `BTN_MODE` | panel → controller (GPIO39, external pullup on controller) |
| 8 | `PANEL_SPARE` | reserved (was BTN_RESET — dropped) |
| 9 | `PANEL_SPARE2` | reserved |
| 10 | `GND` | both |

Buttons short their signal net to GND when pressed. `PANEL_SPARE*` pins
terminate at a single pin on the panel side — ERC will flag them as
single-pin nets; that's intentional (reserved for future expansion).

Reset is via the DevKitC's onboard EN button — no panel reset.

---

## 4. Matrix board (`hardware-board/`)

### 4.1 Scope (236 components total)

| Group | Refdes range | Notes |
|---|---|---|
| Hall sensors | `U1..U64` | A3144 TO-92, file-major: U1=A1, U64=H8 |
| WS2812B LEDs | `D1..D81` | Row-major top-down: D1=top-left, D81=bottom-right |
| Per-LED decoupling caps (100 nF) | `C10..C90` | Number-matched to LEDs |
| Row bulk caps (47 µF) | `C1..C9` | One per row of LEDs |
| `+5V_LED` entry cap (470 µF) | `C91` | Polarized electrolytic at J_CTRL |
| Matrix connector | `J1` (= J_CTRL) | 2×13 keyed IDC box header |
| Test points | `TP1..TP4` | `+5V_LED`, `GND`, `LED_DATA_5V`, `LED_DOUT_END` |
| Mounting holes | `MH1..MH4` | M3 |
| Fiducials | `FID1..FID3` | |

### 4.2 Key decisions

- **A3144 over Hall ICs in SOT-23**: cheaper, hand-solderable, known to
  work in similar projects. Open-collector outputs; pullups live on the
  controller, not on this board.
- **WS2812B 5050 in row-major chain**: standard part, well-supported
  firmware libraries. Spec the exact variant (`WS2812B-2020` etc.)
  in the BOM — color order varies between sub-types (most are GRB).
- **Matrix board kept passive**: no power management, no logic. Every
  active part lives on the controller. Makes this PCB simple, robust,
  and unlikely to need revisions independent of the controller.
- **Mechanical mounting**: 4× M3 holes for chassis attach; 3× fiducials
  for assembly machine alignment if going JLCPCBA.

### 4.3 Maintenance approach

The matrix board's schematic is currently **script-generated** (see
`hardware-board/scripts/sch/`). Hand-drawing 236 components is
impractical and the scripts are ERC-clean. **Keep using the scripts
for this board.** The `hardware-board/SCHEMATIC_GUIDE.md` documents
every component for reference or as a hand-draw fallback.

---

## 5. Controller board (`hardware-controller/`)

### 5.1 Scope

| Group | Refdes | Notes |
|---|---|---|
| ESP32 socket | `U2` | `Espressif_Official:ESP32-DevKitC` module symbol; mates to the 38-pin DevKitC v4 plugged into female headers |
| Matrix connector | `J1` (= J_MAIN) | 2×13 keyed IDC, mirrors J_CTRL |
| Row pullups (10 k) | `R1..R8` | `S0..S7` to `+3V3` |
| LED data series resistor (33 Ω) | `R11` | Damping on `LED_DATA_5V` output |
| Level shifter | `U3` | 74AHCT125 SOIC-14; gate A active, B/C/D tied off |
| 74AHCT125 decoupling | `C5` | 100 nF |
| Column driver IC | `U6` | **TBD62783A** 8-channel high-side P-MOSFET array, DIP-18 or SOIC-18W |
| Column driver bypass | `C11` | 100 nF |
| **Power module** | **M1** | **Seeed Lipo Rider Plus (Charger/Booster) — product 106990290** ($4 on DigiKey/Mouser). USB-C input, charges 1S LiPo, outputs 5V/2.4A and 3.3V/250mA simultaneously. Mounted as a daughterboard via 1×8 pin header on the controller PCB. Symbol: stock `Connector_Generic:Conn_01x08` with manually-labeled pin nets per the silkscreen (1=3V3, 2=EN, 3=GND, 4=5V, 5=GND, 6=BAT, 7=GND, 8=USB). Footprint: `LipoRiderPlus:MODULE_106990290` (SnapEDA model installed locally at `hardware-controller/lib/LipoRiderPlus.pretty/`). The SnapEDA symbol file is intentionally NOT installed because its pin-number-to-name mapping is reversed from the silkscreen. LiPo plugs into M1's onboard JST 2.0; USB-C charges via M1's USB-C jack. |
| ESP32 power path | `D2` | **Schottky diode (SS14 or BAT60A)** between `+5V_LED` and DevKit pin 19 — lets the battery power the DevKit's onboard AMS1117 → ESP32 internal 3V3. Anode on `+5V_LED`, cathode on DevKit pin 19 (forward direction). Protects against backfeed when both USB-C and DevKit USB are plugged in simultaneously. |
| Battery monitor | `R14` (220 k), `R15` (100 k), `C12` (100 nF) | Voltage divider on M1 pin 6 (`BAT` raw battery pad). Junction at ~0.94 V (empty) to 1.31 V (full) → `VBAT_MON` → ESP32 GPIO34 (ADC1_CH6). |
| +5V_LED bulk caps | `C1, C2` | 10 µF each — at M1's 5V output entering our `+5V_LED` rail |
| Panel connector | `J3` (= J_PANEL) | 1×10 JST XH |
| Panel button pullups | `R36, R37` | 10 k for BTN_POWER, BTN_MODE (input-only GPIOs) |
| Test points | `TP1..TPn` | See `hardware-controller/SCHEMATIC_GUIDE.md` §H |
| Mounting + fiducials | `MH1..MH4`, `FID1..FID3` | |

**Parts dropped** from earlier discrete power designs (BQ24074, TPS63060,
F1/D1/Q1, USB-C connector, LiPo connector, all their passives) AND from
the brief PowerBoost 1000C plan (M1 + the AP2112K LDO + C3 + C4): now
all consolidated into M1 (Lipo Rider Plus) + D2 (Schottky). Lipo Rider
Plus's 3V3 output replaces the AP2112K LDO entirely.

### 5.2 Maintenance approach

The controller schematic is being **hand-drawn in KiCad GUI**. Scripts
are archived under `scripts/sch.archived/`. Every component is
documented in `hardware-controller/SCHEMATIC_GUIDE.md` with exact
pin-by-pin connections.

---

## 6. Panel components (no PCB — flying leads)

The panel is **not a PCB**. It's three discrete components wired
directly back to the controller via the `J3` (J_PANEL) connector.
Each component is physically mounted in the enclosure wherever the
user-facing layout requires.

### 6.1 Bill of components (≈ 5 items)

| Component | Quantity | What | Mounting |
|---|---:|---|---|
| SSD1306 0.96" 128×64 I²C OLED module | 1 | Display (mode, battery, game state, menu) | M2 standoffs through the module's 4 mounting holes, OR a 3D-printed bezel with snap-fit, OR double-sided tape behind a transparent enclosure window |
| Panel-mount momentary pushbutton (12 mm tactile, e.g. PBS-110) | 3 | POWER, MODE/NAV, SELECT | Threaded shaft through a 12 mm hole in the enclosure; nut on the back. Solder leads to the two terminals on each. |
| 10-conductor stranded wire harness | 1 length (~30 cm) | Connects all panel components back to controller `J3` | Crimped JST XH receptacle on the controller end; bare leads tinned and soldered to OLED pads + button terminals on the panel end |
| JST XH 2.54 mm 10-pin housing + crimp pins | 1 set | Connector to plug into controller's `J3` | Already on hand — crimp tool not needed to buy |
| Optional: 4.7 kΩ I²C pullup resistors | 2 | If the OLED module's onboard pullups aren't enough for the 30 cm cable | Solder inline on the harness OR on the OLED's solder pads to `+3V3` |

### 6.2 Wiring map

| `J3` pin | Net | Wire goes to |
|---:|---|---|
| 1 | `+3V3` | OLED VCC pin |
| 2 | `GND` | OLED GND pin + button COM lead (if buttons share a common ground line) |
| 3 | `I2C_SDA` | OLED SDA pin |
| 4 | `I2C_SCL` | OLED SCL pin |
| 5 | `BTN_SELECT` | SW3 (SELECT) — one terminal |
| 6 | `BTN_POWER` | SW1 (POWER) — one terminal |
| 7 | `BTN_MODE` | SW2 (MODE) — one terminal |
| 8 | `PANEL_SPARE` | _(unused; leave wire unterminated or omit)_ |
| 9 | `PANEL_SPARE2` | _(unused; leave wire unterminated or omit)_ |
| 10 | `GND` | Button common (other terminal of each button shorts to this) |

In practice, each button is wired with one lead to its signal pin
(`BTN_*` on the harness) and the other lead to GND. You can chain
the GND lead between buttons or use individual GND wires; either
works.

### 6.3 UX direction

Three buttons + the OLED. The OLED shows:
- Current mode (Lichess / Stockfish / Solo / Demo)
- Game state (whose move, opponent name, clock if applicable)
- Battery state-of-charge percentage (from `VBAT_MON` ADC reading via M1 pin 6 → R14/R15 divider → GPIO34)
- WiFi / connection status
- Last move notation, menu items during navigation

Buttons:
- **POWER**: long-press toggles power state (firmware-defined)
- **MODE/NAV**: short-press cycles modes, long-press = back/cancel
- **SELECT**: confirms a menu choice

Reset is via the DevKitC's onboard EN button. The enclosure can expose
this as a recessed pinhole if needed.

### 6.4 Assembly notes

- The wire harness is the most labor-intensive part of the build —
  ~30 min to crimp 10 JST XH terminals, solder OLED pigtail, solder
  button leads. Worth it: no panel PCB to design or fab.
- Use **panel-mount buttons** (PBS-110 or similar 12 mm tactile with
  threaded shaft + nut), not SMD/THT tactile buttons. They're designed
  to mount through an enclosure hole with screw retention.
- The OLED module has a fixed pin order on its 4-pin header. **Verify
  the module's pin order before wiring** — cheap modules ship as
  `VCC/GND/SCL/SDA` or `GND/VCC/SCL/SDA`. A 1-minute multimeter check
  saves a debugging session.
- The two `PANEL_SPARE*` wires can be omitted from the harness if you
  want fewer wires; they were reserved for future expansion (rotary
  encoder, buzzer, haptic motor).

---

## 7. Power architecture

### 7.1 Block diagram

```
                                 ┌──────────────────────────────────────┐
USB-C  ──────→                    │                                      │
                                  │   Seeed Lipo Rider Plus (M1)         │
LiPo (JST 2.0) ←───→              │   ──────────────────────────────────  │
                                  │   - USB-C charger (up to 2 A)         │
                                  │   - 5V/2.4A boost out (USB-A + pad)   │
                                  │   - 3.3V/250 mA always-on rail        │
                                  │   - Slide switch: OFF / 5V / ON       │
                                  └─┬────────┬────────┬────────┬────────┬──────┘
                                    │        │        │        │        │
                                    ▼        ▼        ▼        ▼        ▼
                                 5V (4)  3V3 (1)   GND      BAT (6)  (other pads NC)
                                                              │
                                                              ▼
                                                         R14 (220k) ── R15 (100k) ── GND
                                                                    │
                                                                    └─→ VBAT_MON → ESP32 GPIO34 (ADC1_CH6)
                                    │        │
                                    │        ▼
                                    │      +3V3 → ESP32 (via DevKit), panel rail, pullups, OLED via cable
                                    │
                                    ▼
                                +5V_LED  (regulated ~5.1 V)
                                    │
              ┌─────────────────────┼─────────────────────┬───────────────┐
              │                     │                     │               │
              ▼                     ▼                     ▼               ▼
           C1, C2                D2 Schottky            TBD62783A      74AHCT125
         (10µF bulk)         (anode at +5V_LED,         (U6) VCC      (U3) VCC
                              cathode to DevKit pin 19)
                                    │
                                    ▼
                              DevKit pin 19 (5V input)
                                    │
                                    └─→ DevKit's onboard AMS1117 → ESP32 +3V3 (DevKit-internal only)
```

### 7.2 Behavior

- **USB-C plugged in**: M1 charges the LiPo (up to 2 A) AND sources the 5V/3V3 outputs simultaneously. Our `+5V_LED` rail sees ~5.1 V; `+3V3` net sees 3.3 V from M1's internal LDO.
- **USB-C unplugged**: M1 sources 5V and 3V3 from the LiPo via internal boost + LDO. Board runs from battery until M1's UVLO or the LiPo's BMS cuts off.
- **Battery dead, USB-C plugged in**: M1 powers all rails from USB while charging the battery in parallel. Board boots immediately.
- **5V output enable**: M1 has a physical OFF / 5V / ON slide switch + an EN pin in the header. We use the slide switch in the "ON" position and leave the EN pin floating. The 5V rail is on whenever the module has power (USB or battery).
- **ESP32 powering**: D2 (Schottky) connects `+5V_LED` to the DevKit's pin 19 (5V input). The DevKit's onboard AMS1117 regulator then produces 3V3 internally for the ESP32. D2 blocks backfeed when the DevKit's own USB micro-B is also plugged in (e.g. during programming).
- **Battery state-of-charge monitoring**: a 220 k / 100 k voltage divider taps M1's pin 6 (raw battery `BAT`) and feeds the scaled voltage to ESP32 GPIO34 (ADC1_CH6) as `VBAT_MON`. Firmware reads this with `esp_adc_cal_*` for accurate SOC and shows battery % on the OLED. (M1 also has a 4-segment LED indicator on the daughterboard itself for at-a-glance status, though it requires an enclosure cutout.)
- **Battery polarity**: M1's JST 2.0 connector is mechanically polarized; a reputable LiPo's pre-attached JST 2.0 cable will plug in correctly.

### 7.3 Current budget (estimated)

| Load | Typical | Peak |
|---|---:|---:|
| ESP32 with WiFi | 80 mA | 300 mA |
| 81 WS2812B LEDs (firmware-limited brightness) | 100–500 mA | 5 A (white-flood) — **do not allow in firmware** |
| 8 active Hall sensors per scan column | 50 mA | 80 mA |
| 74AHCT125 + TBD62783A logic | 10 mA | 30 mA |
| OLED panel | 15 mA | 25 mA |
| **Total** | **~250–700 mA** | **bounded by M1's 2.4 A boost output + USB-C input current** |

Firmware MUST cap simultaneous LED brightness. The Lipo Rider Plus is
rated for **5V/2.4A** continuous on its 5V output, which sets the
ceiling — comfortably above our worst case.

### 7.4 Protected battery requirement

The LiPo cell should be a **protected cell** (built-in BMS PCB attached
to the cell) for safety:

- The Lipo Rider Plus has internal UVLO that cuts off below ~3.0 V —
  this prevents over-discharge during normal operation.
- But a *protected* cell adds a hard BMS that also catches short-
  circuit conditions, over-charge if the module fails, and
  over-discharge below the module's UVLO if the cell self-discharges
  while disconnected.
- Cheap unprotected cells from AliExpress will work but carry a small
  risk of thermal runaway under fault. Pay the $2 extra for a
  protected pack.

**Battery format**: 1S LiPo, 1000–2000 mAh, with JST PH 2-pin cable
pre-attached. Available from Adafruit, SparkFun, Pimoroni, Pololu,
and reputable AliExpress sellers.

---

## 8. GPIO map (summary)

Full table is in `docs/gpio-map.md` — that file is also a source of
truth for pin assignments. Highlights:

| Function | ESP32 GPIO | DevKitC pin |
|---|---:|---:|
| WS2812 data (3V3, pre-level-shift) | 32 | 7 |
| Row sense `S0..S7` | 4, 16, 17, 18, 19, 21, 22, 23 | 26..37 |
| Column drive `COL_DRV_A..H` (to TBD62783A) | 13, 14, 27, 26, 25, 33, 5, 15 | 15..29 |
| I²C SDA (to OLED) | 1 (TX0 repurposed) | 35 |
| I²C SCL (to OLED) | 3 (RX0 repurposed) | 34 |
| BTN_SELECT | 2 | 24 |
| BTN_POWER (input-only) | 36 (SVP) | 3 |
| BTN_MODE (input-only) | 39 (SVN) | 4 |
| `VBAT_MON` (analog) | 34 (input-only, ADC1_CH6) | 5 |
| EN (reset, DevKit onboard button) | EN | 2 |
| Reserved | 35 (input-only, = PANEL_SPARE) | 6 |

> Note: `VBAT_MON` is the analog battery monitor signal. A voltage
> divider (R14 220k + R15 100k + C12 100nF filter) on M1's pin 6
> (raw `BAT` pad) feeds GPIO34. Firmware uses `esp_adc_cal_*` for
> accurate readings — multiply the calibrated ADC mV by 3.2 to recover
> battery voltage.

**Pin usage notes:**

- Flash pins (GPIO 6–11) are explicit `no_connect`.
- DevKitC pins 1 (3V3 out) and 19 (5V out) are `no_connect` to avoid
  LDO contention with our AP2112K.
- UART0 (GPIO1/3) is **sacrificed** for the I²C bus — no serial debug
  on the DevKitC's onboard USB-UART during normal operation. Flashing
  still works because the bootloader uses UART0 only during reset.
- Boot-strap pins in use: GPIO5, GPIO15 (column drives — must be HIGH
  at boot; brief boot HIGH harmlessly turns columns G/H on for ~10 ms
  before firmware runs), GPIO2 (BTN_SELECT — must be LOW or floating
  at boot; button released = floating high through internal pullup is
  fine), GPIO12 NC (must be LOW at boot — NC satisfies this).

---

## 9. Key BOM (controller-side highlights)

| Part | Purpose | Approx unit cost |
|---|---|---:|
| **Seeed Lipo Rider Plus (Charger/Booster)** | USB-C charging + 5V boost + 3V3 rail, all-in-one daughterboard | $4 (DigiKey) |
| Schottky diode (SS14 or BAT60A) | D2 — DevKit pin 19 ← +5V_LED protection | $0.10 |
| 74AHCT125 (SOIC-14) | WS2812 level shifter | $0.50 |
| TBD62783A (DIP-18 or SOIC-18W) | 8-ch column driver | $1.00 |
| SSD1306 0.96" OLED module | Panel display | $2.00 |
| Protected LiPo 1500 mAh | Battery | $6.00 |
| ESP32-DevKitC v4 | Main compute | $8.00 |
| A3144 Hall × 64 | Matrix sensing | $0.20 each, $13 total |
| WS2812B × 81 | Matrix display | $0.05 each, $4 total |
| Female headers (controller sockets + module sockets) | Module + DevKit mounting | ~$3 total |
| **USB-C panel-mount extension cable** | Routes M1's onboard USB-C jack to the enclosure wall — plug into M1, screw the panel-mount end into the enclosure | $3–8 (AliExpress/Amazon) |

The Lipo Rider Plus is hand-soldered onto the controller PCB via
through-hole headers — JLCPCB does NOT assemble modules, only
individual components. The controller PCB itself can still be
JLC-assembled for the components around the module.

Per-board fab on JLCPCB: ~$5/board × 3 designs × min 5 boards each =
~$75. Consider **panelizing the three designs onto one panel** to cut
fab cost.

---

## 10. Mechanical and cabling

### 10.1 Connectors

| Connector | Function | Pick |
|---|---|---|
| J1 (controller J_MAIN) | Board-to-board to matrix (mating face up) | 2×13 **male pin header**, vertical (`PinHeader_2x13_P2.54mm_Vertical`) |
| J1 (matrix J_CTRL) | Board-to-board to controller (back side of matrix, mating face down) | 2×13 **female socket**, vertical (`PinSocket_2x13_P2.54mm_Vertical`) |
| J3 (controller J_PANEL) | 10-wire harness to panel components | **JST XH 10-pin** receptacle |
| M1 (Lipo Rider Plus module header on controller) | Mounts the Seeed Lipo Rider Plus | 1×8 female header, 2.54 mm pitch (matches module's edge pads) |
| Battery → Lipo Rider Plus | LiPo cable | JST 2.0 2-pin (on the module itself; not on controller PCB) |
| USB-C charging access | Routes M1's onboard USB-C to enclosure wall | Panel-mount USB-C extension cable (~$5) |
| DevKitC sockets (controller) | ESP32 plug-in | 2× 1×19 female header, 25.4 mm row pitch |

USB-C, the LiPo JST 2.0 connector, and the 4-segment battery LED
indicator all live on the Lipo Rider Plus daughterboard (M1), not on
the controller PCB itself. The USB-C is routed to the enclosure wall
via the panel-mount extension cable.

### 10.2 Cables

- **No ribbon cable between matrix and controller** — they stack
  directly via mating pin header + socket. Zero IR drop on `+5V_LED`,
  zero signal-integrity issues on `LED_DATA_5V`.
- **Panel harness**: 10-wire stranded multi-conductor (24 AWG, ribbon
  or just bundled), ~15–20 cm. Twist the I²C pair with GND for noise
  immunity. The cable is the weak link for I²C reliability — keep
  speed at 100 kHz, not 400 kHz. Crimp JST XH receptacle on the
  controller end; bare leads solder to OLED + buttons on the panel
  end.
- **Battery cable**: pre-attached on protected LiPo packs; plugs into
  the Lipo Rider Plus module's JST 2.0 socket.
- **USB-C panel-mount cable**: ~15–30 cm internal, with male USB-C on
  one end (into M1's onboard USB-C jack) and panel-mount female USB-C
  on the other (into the enclosure wall).

### 10.3 Enclosure considerations

**Internal layout** (from the user's mockup, locked 2026-06-05):

- The matrix PCB is the chessboard top surface. The enclosure has a
  frame around the matrix PCB edges; the matrix PCB itself is exposed
  on the top face for the chess pieces to sit on.
- The controller PCB mounts directly underneath the matrix, offset
  toward one edge (the same edge as the side panel). Held by 4× M3
  brass standoffs (~11 mm tall) between the matrix's back and the
  controller, plus the J_MAIN/J_CTRL stacking connector providing both
  electrical connection and additional mechanical support.
- The LiPo battery sits **alongside the controller** in the empty
  space between the matrix PCB's back and the enclosure floor. Reserve
  ~50 × 50 mm × 8 mm floor area, attached via double-sided tape or a
  3D-printed battery cradle. **Don't sandwich it between the matrix
  and controller PCBs** — heat dissipation + swelling-safety reasons.
- The user-facing panel mounts on one side wall of the enclosure (the
  same side as the controller's offset). The panel contains: OLED
  window, 3 button holes, USB-C panel-mount port.

**Enclosure cutouts and access**:

- DevKitC's onboard EN (reset) button needs to be accessible — leave
  a pinhole in the bottom of the enclosure aligned with the button.
- DevKitC's onboard USB micro-B is used for programming — needs a
  cutout or removable bottom panel. Easiest for a one-off build: a
  removable bottom plate so you can plug in for programming.
- **USB-C charging port**: routed from M1's onboard USB-C jack via
  the panel-mount extension cable to the side panel. Plan a ~10 mm ×
  8 mm rectangular cutout on the side panel for the cable's flange +
  2 small screw holes (~M2) to mount it.
- **OLED window**: module is ~27 × 27 mm; needs a transparent (or
  open) cutout in the side panel. Module mounts behind the cutout via
  M2 standoffs or a 3D-printed bezel.
- **3 button holes**: 12 mm clearance each (for the panel-mount
  pushbuttons' threaded shafts), evenly spaced on the side panel
  alongside the OLED.
- **Matrix PCB**: 4 M3 mounting holes at its corners attach to
  enclosure standoffs holding it flush with the enclosure top frame.
- **Controller PCB**: 4 M3 mounting holes at its corners attach to
  M3 brass standoffs reaching up to the matrix PCB's back.

**Vertical stack from bottom to top of enclosure**:

```
Enclosure floor
    ↑ (any vertical space for cable routing)
LiPo battery (8 mm thick, alongside controller)        Controller PCB
                                                            ↑ (~11 mm standoffs)
                                                       J_MAIN ↔ J_CTRL mating
                                                            ↑
                                                       Matrix PCB (chessboard)
                                                            ↑
                                                       Enclosure top frame
```

---

## 11. Known issues and verification items

These are things we know about but haven't fully resolved. None block
fab, but they need attention during bring-up:

1. **A3144 Hall settling delay**: After a column is energized, the
   sensor output takes ~5 µs to stabilize. Firmware must wait between
   "set column HIGH" and "read row" — ~10 µs is safe.
2. **A3144 unidirectional sensitivity**: Senses only one magnet
   polarity. Spec the magnet orientation in piece assembly. Test a
   small 4×4 board before committing the full 8×8.
3. **WS2812B variant**: BOM must say `WS2812B-2020` (or whichever
   exact part). Color order varies (most are GRB). Firmware must
   match.
4. **ESP32 ADC nonlinearity** at low voltages: battery monitor at 3.0 V
   gives 0.94 V at ADC — near the noisy end. Use `esp_adc_cal_*` APIs
   for calibrated readings (~50 mV accuracy instead of 200 mV).
5. **PowerBoost switching EMI**: the PowerBoost 1000C contains a
   synchronous boost converter (TPS61090) that switches at ~700 kHz.
   Generally well-filtered on the module itself, but if WiFi RX
   sensitivity is poor in testing, add a ferrite bead + cap on the
   `+5V_LED` line where it leaves the module.
6. **I²C over panel cable**: 30 cm flying lead with default 4.7 kΩ
   pullups may be slow. If OLED writes are unreliable, drop pullups
   to 2.2 kΩ on the panel board.
7. **SSD1306 module pinout variability**: cheap modules ship as
   `VCC/GND/SCL/SDA`, `GND/VCC/SCL/SDA`, or with SDA/SCL swapped.
   Buy 5 from one seller; verify with a multimeter before committing
   PCB.
8. **Inter-board cable IR drop**: at peak LED current the 26-wire
   ribbon to the matrix can drop 100–500 mV on the +5V_LED rail.
   Mitigation: short cable, firmware brightness limit. Already designed
   in but worth checking with the scope.
9. **BTN_SELECT held during reset**: GPIO2 must be LOW/floating at
   boot. Pressing SELECT during DevKitC EN-button reset could confuse
   the bootloader. Workaround: just don't hold SELECT during reset.
   Not a hardware fix.
10. **Lipo Rider Plus single-point-of-failure**: if M1 dies, charging,
    +5V_LED, and +3V3 all go away — board is dead. Mitigation: M1
    is a separate daughterboard, so replacing it is easy (desolder
    headers, swap in a new $4 board). Cheaper than diagnosing a
    discrete power chain.
11. **Boot-time column glitch**: GPIO5 and GPIO15 must be HIGH at boot
    (strapping). They drive `COL_DRV_G` / `COL_DRV_H` into TBD62783A
    → columns G/H are briefly powered ~10 ms during boot. Electrically
    harmless (no firmware scanning yet). Plan for a ~50 mA boot blip.

---

## 12. Firmware-side caveats (heads-up for the firmware author)

- **No serial debug on DevKitC USB**: UART0 (GPIO1/3) is now the I²C
  bus. Use JTAG, or pick alternative GPIOs for a separate UART, if
  you need printf-style debug.
- **Matrix scan timing**: ~5 µs Hall settling between column energize
  and row read. Don't scan faster than ~1 kHz.
- **Limit LED brightness**: at full white, 81 WS2812Bs draw ~5 A,
  blow the polyfuse, brown out the system. Hard-cap brightness in
  firmware (e.g., max 30% white or rate-limit total Watts).
- **Battery state-of-charge** is an analog ADC reading on GPIO34
  (`VBAT_MON` net). The R14/R15 divider scales raw battery voltage
  (3.0–4.2 V) to 0.94–1.31 V at the ADC. Use `esp_adc_cal_*` APIs
  to calibrate (eFuse-stored values give ~50 mV accuracy). Multiply
  the calibrated mV reading by 3.2 to recover battery voltage.
  Suggested firmware thresholds: warn at 3.5 V, force shutdown at 3.2 V.
  M1's internal UVLO catches things at ~3.0 V as a hardware backstop.
- **WS2812 color order**: spec the exact part variant in BOM; configure
  firmware accordingly (most likely GRB for WS2812B).
- **Boot strap awareness**: don't drive GPIO12 HIGH at boot; don't
  hold BTN_SELECT during reset; GPIO5/15 boot HIGH is expected and
  fine.
- **Battery low cut-off**: even though the protected LiPo's BMS will
  ultimately cut at ~3.0 V, firmware should warn the user via OLED
  at ~3.4 V and force a safe shutdown at ~3.2 V.

---

## 13. Open questions / future work

- **Production connectors**: 2.54 mm pin headers are rated for ~200
  mating cycles. Locking connectors (Molex Pico-Lock, JST GH) are
  better for a finished product.
- **Panelize the 3 board designs** on one JLCPCB panel to cut fab cost
  ~3×.
- **Replacing DevKitC with a bare ESP32-WROOM**: smaller board, no
  redundant USB connectors, but adds USB-UART + boot-button circuit
  to our PCB. Defer to a v2 revision.
- **Wireless firmware update**: OTA over WiFi after first flash. Frees
  us from needing DevKitC USB access in the final enclosure.
- **EMI testing**: scope WiFi RSSI vs LED activity. May need ferrite
  on `+5V_LED` cable.
- **Magnet selection**: pick a magnet strength that triggers A3144
  reliably across the full 8 mm board-to-piece distance. Test with the
  4×4 prototype before committing the full 8×8.
- **Chess piece assembly**: how do magnets attach to standard pieces?
  Drill, press-fit, glue? Affects the magnet form factor we should
  spec.
- **4×4 mini matrix prototype**: a smaller PCB that uses the same
  controller / panel / firmware to validate the scan + LED + sensor
  approach before paying for the full 8×8 fab.

---

## 14. Per-board guides and detailed references

- `hardware/hardware-board/SCHEMATIC_GUIDE.md` — matrix board build/reference
- `hardware/hardware-controller/SCHEMATIC_GUIDE.md` — controller hand-draw build sheet
- (No panel guide — panel components are off-the-shelf modules wired to the controller's `J3`. See §6 above for the wiring table.)
- `docs/inter-board-connector.md` — formal cable contracts
- `docs/gpio-map.md` — ESP32 pin assignments
- `STATUS.md` — chronological project status

---

## 15. Change log (design-affecting decisions)

| Date | Change |
|------|--------|
| 2026-06-04 | Old single-PCB design archived. Split into 3 boards. |
| 2026-06-05 (early) | Locked initial controller decisions: USB-C only, AP2112K LDO, ESP32-DevKitC on sockets, 74AHCT125 level shifter, AO3401A+MMBT3904 column drivers, finalized GPIO map. |
| 2026-06-05 (mid) | Switched to battery-backed power: BQ24074 power-path + MT3608 boost + 1S LiPo via JST PH. Consolidated column drivers into a single TBD62783A 8-channel IC. Added `VBAT_MON` ADC monitor on GPIO34. Hand-drawing the controller in KiCad GUI; scripts archived. |
| 2026-06-05 (mid) | Redesigned control panel: SSD1306 OLED replaces 3 status LEDs. BTN_SELECT replaces BTN_RESET. J_PANEL pin contract reassigned (I²C on pins 3/4, BTN_SELECT on pin 5). GPIO1/3 (UART0) repurposed as I²C bus. |
| 2026-06-05 (late) | Pre-fab protection block added: F1 polyfuse on USB VBUS, D1 PRTR5V0U2X ESD array, Q1 reverse-polarity P-MOSFET on battery +. Swapped MT3608 pure-boost → TPS63060 buck-boost (handles 3–5 V SYS cleanly). Specced protected LiPo cell. Switched J_MAIN/J_CTRL footprint to shrouded/keyed IDC. |
| 2026-06-05 (latest) | **Power section consolidated to a daughterboard module.** Replaced the entire discrete power chain (BQ24074 + TPS63060 + F1/D1/Q1 + J2 USB-C + J4 LiPo + ~25 components) with one **Adafruit PowerBoost 1000 Charger** module (M1). M1 handles USB charging, LiPo management, and 5 V boost internally. Battery monitor changed from analog `VBAT_MON` divider (GPIO34 ADC) to digital `BATT_LOW` signal from M1's open-drain `LBO` output (still GPIO34, now digital). Rationale: one-shot build with no iteration; minimize risk and complexity by trusting a known-good $20 module instead of designing two new switchers from scratch. |
| 2026-06-05 (final) | **Dropped the control panel PCB.** Moved to discrete panel-mount components (OLED module + 3 panel-mount buttons) on flying leads. The `J3` connector on the controller stays (same 10-pin contract) but now plugs into a wire harness, not a panel PCB. `hardware-control-panel/` archived to `delete/hardware-control-panel-2026-06-05/`. Recommended controller-side connector changed from plain 1×10 pin header to **JST XH 10-pin** for polarity + latching. Rebrandled project intent in `CLAUDE.md` and §1 to reflect that this is a one-off learning project, not for sale. |
| 2026-06-05 (really final) | **Power module switched from Adafruit PowerBoost 1000C ($20, micro-USB) to Seeed Lipo Rider Plus ($4 on DigiKey, USB-C).** Also dropped the AP2112K LDO + C3 + C4 (–3 components) since the Lipo Rider Plus's 3V3/250mA pin header output covers our +3V3 load directly. Added D2 (SS14 Schottky) between `+5V_LED` and DevKit pin 19 to let the battery power the ESP32 via the DevKit's onboard AMS1117 (this also fixes a previously-missed bug where the ESP32 had no battery power path). |
| 2026-06-05 (post-cleanup) | Added analog battery monitor: R14 (220 k) + R15 (100 k) + C12 (100 nF) voltage divider on M1's pin 6 (raw `BAT` pad) → `VBAT_MON` → ESP32 GPIO34 (ADC1_CH6). Firmware reads battery voltage with `esp_adc_cal_*` and shows percentage on the OLED. Wired to M1 pin 6 instead of DevKit pin 19 because DevKit pin 19 is downstream of M1's boost (always ~5 V regardless of battery state) — only the raw battery pin gives real SOC. Cleaned up unused PowerBoost 1000C lib files from `hardware-controller/lib/` and removed the corresponding `sym-lib-table`/`fp-lib-table` entries. |
| 2026-06-05 (lib install) | Installed SnapEDA's Lipo Rider Plus **footprint only** at `hardware-controller/lib/LipoRiderPlus.pretty/MODULE_106990290.kicad_mod`. Created `fp-lib-table` registering the new library. **Intentionally did NOT install SnapEDA's symbol** (`106990290.kicad_sym`) — its pin-number-to-name mapping is reversed from the module's silkscreen, which would cause the wrong nets to be routed to the wrong physical pads. Schematic uses generic `Connector_Generic:Conn_01x08` with manually-labeled pin nets per the silkscreen instead. |
| 2026-06-05 (assembly layout) | **Switched J_MAIN ↔ J_CTRL from shrouded IDC + ribbon to board-to-board stacking** based on the user's enclosure mockup. Controller PCB now stacks directly underneath the matrix PCB via mating 2×13 pin header (controller J_MAIN, male, vertical) + 2×13 socket (matrix J_CTRL, female, vertical), with 4× M3 corner standoffs (~11 mm tall) for mechanical support. No ribbon cable. Battery sits alongside the controller PCB in the space between the matrix's back and the enclosure floor. Panel components (OLED + 3 buttons + USB-C panel-mount) mount on one side wall of the enclosure. Updated DESIGN_NOTES §2, §3.1, §10.1, §10.2, §10.3. |
