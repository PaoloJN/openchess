# OpenChess Hardware Design Notes

**Source of truth.** This document captures the current, agreed-upon
design for the OpenChess hardware. Per-board build sheets live in each
board's `SCHEMATIC_GUIDE.md`; pin-level assignments live in
`docs/gpio-map.md`; cross-board cable contracts live in
`docs/inter-board-connector.md`. This file is the index and the
authoritative reference for the *design itself*.

Last meaningful revision: **2026-06-09** (paper-fit test surfaced three
issues that need addressing: 8×8 board oversized vs enclosure inner
frame, J_MAIN/J_CTRL pin-1 mirroring under board-flip, and ESP32
footprint mismatch — see §11 items 12–14).

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

**Core sensing**: 8×8 grid of DRV5032FC Hall-effect switches
(SOT-23, omnipolar) detects which squares have a magnet under them
(every chess piece carries one).

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
- Controller PCB **mounts inverted directly underneath the matrix board**
  via board-to-board stacking pin headers (J_MAIN ↔ J_CTRL). The
  controller's components (M1, U2 DevKit, U3, U6, etc.) face the
  enclosure floor; its **bare B.Cu back face faces up toward the
  matrix's B.Cu back face**. J_MAIN sits on the controller's B.Cu so
  its pins point up into the matrix's J_CTRL socket. No ribbon cable
  between them, and **no corner standoffs** — the controller hangs from
  the J_MAIN/J_CTRL mating alone, and the matrix's own mounting to the
  enclosure top frame carries the assembled weight.
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
The controller PCB mounts **inverted** below the matrix PCB (components
facing the enclosure floor, bare B.Cu facing up). J_MAIN sits on the
controller's B.Cu, J_CTRL on the matrix's B.Cu, and they mate back-
to-back:

- **Controller side (`J_MAIN`)**: 2×13 **male pin header** on the
  controller PCB's **B.Cu (back)** face. When the controller is mounted
  upside-down under the matrix, those pins point up toward the matrix.
  Footprint: `Connector_PinHeader_2.54mm:PinHeader_2x13_P2.54mm_Vertical`
- **Matrix side (`J_CTRL`)**: 2×13 **female socket** on the matrix
  PCB's back face (B.Cu), pointing down toward the controller.
  Footprint: `Connector_PinSocket_2.54mm:PinSocket_2x13_P2.54mm_Vertical`

The two connectors mate naturally — different connector types prevent
mis-orientation. Still mark pin 1 with a silkscreen dot on both boards
for assembly clarity.

> **Matrix-side J1 pin numbering is mirrored relative to the controller's
> J1 contract.** The controller mounts **inverted** under the matrix
> (B.Cu-to-B.Cu mating), which mirrors each board's coordinate frame
> relative to the other. To keep electrical mating correct, the matrix's
> J1 footprint was manually mirrored in KiCad's PCB editor after the
> 3×3 layout script placed it (right-click J1 → Mirror → Mirror Around
> X Axis). The result: matrix J1's *pad numbers* are swapped within
> each odd-even pair vs the contract table below — e.g. matrix pin 2
> physically carries `+5V_LED`, matrix pin 1 carries `GND`, etc. The
> **nets at each physical pad position still mate correctly** with the
> controller's pin contract (controller pin 1 = `+5V_LED` after the
> flip lands on matrix pin 2 = `+5V_LED`, etc.).
>
> When reading the contract below, treat pin numbers as the controller's
> J_MAIN numbering. The matrix's J_CTRL pads carry the same nets but
> under swapped pin numbers; verify against the physical net at each
> pad in KiCad, not the pin number printed on the silkscreen.

Mechanical: **no mounting holes on either PCB and no corner standoffs**.
The board-to-board connector pair carries both signal and mechanical
load — the controller hangs from J_MAIN/J_CTRL alone. The matrix PCB
is what's actually bolted to the enclosure top frame; it supports the
controller's weight through the connector. This is acceptable because
the board pair is mated once and never unplugged in normal use, and
the controller weighs essentially nothing once the LiPo is moved
alongside it.

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

### 4.1 Scope (244 components total — 8×8; smaller scaled variant is 3×3)

| Group | Refdes range (8×8) | Refdes range (3×3) | Notes |
|---|---|---|---|
| Hall sensors | `U1..U64` | `U1..U9` | **DRV5032FC SOT-23** (TI, JLC Basic C527532). File-major: U1=A1, U_max=top-right corner. |
| WS2812B LEDs | `D1..D81` | `D1..D16` | Row-major top-down: D1=top-left, D_max=bottom-right |
| Per-LED decoupling caps (100 nF) | `C10..C90` | `C10..C25` | Number-matched to LEDs (D1↔C10, etc.) |
| Row bulk caps (47 µF) | `C1..C9` | `C1..C4` | One per row of LEDs, placed in **left margin** Y-aligned with each LED row |
| Matrix connector | `J1` (= J_CTRL) | `J1` | 2×13 female socket, board-to-board stacking on B.Cu; pin contract in §3.1 |
| Test points | `TP1..TP4` | `TP1..TP4` | `+5V_LED`, `GND`, `LED_DATA_5V`, `LED_DOUT_END` (manually placed) |
| Mounting holes | `MH1..MH4` | `MH1..MH4` | M3, four corners (manually placed) |
| Fiducials | `FID1..FID3` | `FID1..FID3` | Manually placed |

**C91 entry cap (470 µF) dropped 2026-06-08.** Row bulks provide enough capacitance — no more THT parts on the matrix board.

### 4.2 Board dimensions

`SQUARE_SIZE = 32 mm` (matches Paolo's folding chess board model — the
inner-frame cavity has 32 mm wood squares). `BOARD_MARGIN = 18 mm` from
the outermost chess-square corner to the PCB edge, intentionally 2 mm
under the model's 20 mm inner-frame margin so the PCB slides freely
inside the cavity with ~2 mm wiggle per side.

| Variant | Chess area | + 2× 18 mm margin | **Total PCB outline** | JLC tier |
|---|---|---|---|---|
| 3×3 test | 96 mm | + 36 mm | **132 × 132 mm** | ≤150×150 (~$10) |
| 8×8 full | 256 mm | + 36 mm | **292 × 292 mm** | ≤300×300 (~$30) |

The 10 mm outer fold/decorative edge of the folding board model is NOT
part of the PCB — the PCB sits inside the inner frame only.

### 4.3 Key decisions

- **DRV5032FC Hall switches** (TI, SOT-23, omnipolar, **open-drain**, 1.65–5.5 V):
  selected over the originally-planned A3144 because (a) omnipolar means
  the magnet orientation in chess pieces doesn't matter — either pole
  triggers the sensor; (b) SOT-23 is small and JLCPCBA-assembleable
  whereas A3144 in TO-92 is through-hole; (c) the pinout
  (1=VDD, 2=GND, 3=OUT) is identical to A3144, so the rest of the
  matrix routing is unchanged. The open-drain output mates correctly
  with the controller's R1..R8 pull-ups to +3V3 — sensor's 1 mA sink
  rating handles 3.3 V / 10 kΩ = 330 µA load.
- **WS2812B 5050 in row-major chain**: standard part, well-supported
  firmware libraries. Spec the exact variant (`WS2812B-2020` etc.)
  in the BOM — color order varies between sub-types (most are GRB).
- **Matrix board kept passive**: no power management, no logic. Every
  active part lives on the controller. Makes this PCB simple, robust,
  and unlikely to need revisions independent of the controller.
- **Mechanical mounting**: 4× M3 holes for chassis attach; 3× fiducials
  for assembly machine alignment if going JLCPCBA.

### 4.4 Layout conventions (PCB)

Set by `scripts/01_chess_grid.py`:

- **Hall sensors** (DRV5032FC SOT-23): at chess square centers (file × rank × 32 mm)
- **LEDs** (WS2812B): at the corners of the chess squares (LED_COLS × LED_ROWS grid)
- **LED decoupling caps** (100 nF 0805): 6 mm to the RIGHT of each LED's center (no overlap with the 5×5 mm WS2812B body)
- **Row bulks** (47 µF 1206): in the **LEFT margin**, 8 mm left of the chess area, Y-aligned with each LED row
- **J1 (J_CTRL)**: on **B.Cu** (back face), center of the bottom edge, rotated 90° (~33 mm wide × 5 mm tall), anchor shifted left by 15.24 mm so the BODY's geometric center lands at the board's X centerline

### 4.5 Maintenance approach

The matrix board's schematic is **script-generated** for halls + LEDs
+ LED decoupling caps only (see `hardware-board/scripts/sch/02_halls.py`
and `03_leds.py`). The `99_assemble.py` is a **merger** that preserves
manual additions (J1 connector, MH, FID, TP, PWR_FLAGs, row bulks) by
UUID prefix — so running scripts after editing in KiCad GUI is safe.
The PCB layout (`scripts/01_chess_grid.py`) positions halls, LEDs,
LED decoupling caps, row bulks, and J1; everything else stays where
the user dragged it.

The 3×3 test board (`hardware-board-3x3/`) is a parameterised clone
of the 8×8 with `MATRIX_COLS = MATRIX_ROWS = 3`. Use it as the
first-fab validation board before committing to the 8×8.

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
| ESP32 power path | `D2` | **Schottky diode (SS14)** in `D_SMA` between `+5V_LED` and DevKit pin 19 — lets the battery power the DevKit's onboard AMS1117 → ESP32 internal 3V3. Pad 2 (anode) on `+5V_LED`, pad 1 (cathode, stripe) on DevKit pin 19 (forward direction). Protects against backfeed when both USB-C and DevKit USB are plugged in simultaneously. |
| Battery monitor | `R14` (220 k), `R15` (100 k), `C12` (100 nF) | Voltage divider on M1 pin 6 (`BAT` raw battery pad). Junction at ~0.94 V (empty) to 1.31 V (full) → `VBAT_MON` → ESP32 GPIO34 (ADC1_CH6). |
| +5V_LED bulk caps | `C1, C2` | 10 µF each — at M1's 5V output entering our `+5V_LED` rail |
| Panel connector | `J3` (= J_PANEL) | 1×10 JST XH |
| Panel button pullups | `R36, R37` | 10 k for BTN_POWER, BTN_MODE (input-only GPIOs) |
| Test points | _(none placed)_ | Probe the controller's component pads or pin headers directly for bringup. M1 itself exposes 3V3/5V/GND/BAT/USB/EN on its silkscreen-labeled pads. |
| Fiducials | `FID1..FID3` | For JLCPCBA. **No mounting holes** — controller is held by J_MAIN/J_CTRL mating + matrix's enclosure mount; see §3.1 and §10.3. |

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
| DRV5032FC Hall × 64 (SOT-23, omnipolar) | Matrix sensing | $0.50 each, ~$32 total |
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
| J1 (controller J_MAIN) | Board-to-board to matrix (placed on controller B.Cu; mating face points up because the controller mounts inverted) | 2×13 **male pin header**, vertical (`PinHeader_2x13_P2.54mm_Vertical`) |
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
- The controller PCB mounts **inverted** directly underneath the matrix
  (components facing the enclosure floor; bare B.Cu facing up toward
  the matrix's B.Cu), offset toward one edge (the same edge as the
  side panel). It is held in place **only** by the J_MAIN/J_CTRL
  stacking connector — no standoffs, no mounting holes. The matrix's
  enclosure-frame mount carries the assembled weight.
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
- **Matrix PCB**: planned 4 M3 mounting holes at its corners attach to
  enclosure standoffs holding it flush with the enclosure top frame.
  _(Not yet present on the 3×3 prototype PCB; required on the full 8×8.)_
- **Controller PCB**: **no mounting holes by design**. It hangs from
  J_MAIN/J_CTRL onto the matrix's B.Cu side. The matrix is what's
  bolted to the enclosure; the controller comes along for the ride.

**Vertical stack from bottom to top of enclosure**:

```
Enclosure floor
    ↑ (any vertical space for cable routing)
LiPo battery (8 mm thick, alongside controller)
                                                       Controller PCB (inverted)
                                                       components face DOWN
                                                       bare B.Cu face UP
                                                            ↑
                                                       J_MAIN ↔ J_CTRL mating
                                                       (only point of contact)
                                                            ↑
                                                       Matrix PCB (chessboard)
                                                       components face UP
                                                            ↑
                                                       Enclosure top frame
                                                       (matrix bolts here)
```

---

## 11. Known issues and verification items

These are things we know about but haven't fully resolved. None block
fab, but they need attention during bring-up:

1. **DRV5032FC Hall settling delay**: After a column is energized, the
   sensor output needs a few µs to stabilize. Firmware must wait between
   "set column HIGH" and "read row" — ~10 µs is safe (DRV5032FC's
   typical output response time is ≤ 1 µs at 5 V; 10 µs gives slack
   for column-rail charging through the TBD62783A).
2. ~~A3144 unidirectional sensitivity~~ — **no longer an issue.**
   DRV5032FC is omnipolar, so chess pieces can carry either magnet
   pole and they trigger the same way. No need to spec piece magnet
   orientation.
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

### Paper-fit test findings (2026-06-09)

Discovered when printing the controller, 3×3, and 8×8 PCBs at 1:1 on
paper and physically checking fit + alignment against real parts and
the target folding chess board.

12. **8×8 matrix doesn't fit the chess board's inner frame.** At
    292 × 292 mm (8 × SQUARE_SIZE 32 mm + 2 × BOARD_MARGIN 18 mm)
    the printed outline overhangs the inner cavity of Paolo's
    physical folding board. **Fix later** (before ordering the 8×8
    fab): either (a) shrink SQUARE_SIZE to fit, (b) shrink
    BOARD_MARGIN below 18 mm, or (c) re-measure the inner frame and
    confirm exact cavity dimensions, then re-derive board size in
    `scripts/lib_layout.py`. The 3×3 (132 × 132 mm) is unaffected —
    it fits inside the cavity with room to spare and is fine to fab
    as-is. Update STATUS.md §"Matrix board dimensions" once
    re-measured.

13. ~~J_MAIN/J_CTRL pin-1 mirroring under board-flip.~~ **Resolved
    2026-06-09.** When the controller mounts inverted (B.Cu facing up)
    to mate with the matrix's B.Cu, each board's coordinate frame is
    mirrored relative to the other — pin 1 of the controller J1 lands
    on the opposite corner from pin 1 of the matrix J1, scrambling
    net assignments per physical pad. **Fix applied:** the matrix's
    J1 footprint was manually mirrored in KiCad PCB editor (select J1
    → right-click → Mirror → Mirror Around X Axis). This swaps the
    row assignment so each net flows to the physically-correct pad
    after the controller flip. Side effect: matrix J1 pad numbering
    is now swapped within each odd-even pair vs the contract in §3.1
    (matrix pin 1 = GND, matrix pin 2 = +5V_LED, etc.) — but nets at
    each physical pad position match the controller correctly.
    Documented in §3.1. Same fix must be re-applied to the 8×8 matrix
    after its layout script runs (the script doesn't auto-mirror J1).

14. **ESP32 footprint doesn't match the physical DevKitC on hand.**
    The `Espressif:ESP32-DevKitC` footprint used on the controller
    PCB does not line up with the actual ESP32 module Paolo bought.
    Two paths forward, neither great:
    - **(a) Buy a different ESP32-DevKitC** whose pinout/dimensions
      match the existing footprint. Cheap (~$8), no PCB rework.
    - **(b) Swap the footprint** in KiCad to one matching the
      module Paolo has. Free in BOM but **requires re-routing every
      trace into U2** — a lot of unwanted rework.
    **Preferred:** path (a). Document the exact DevKitC variant
    (manufacturer + version) that fits the current footprint in the
    controller's `SCHEMATIC_GUIDE.md` so a future order can't get it
    wrong again. Re-verify against the printed footprint before
    ordering.

15. **DRV5032FC SOT-23 package looks tiny — is that a problem?**
    Short answer: **no, not for sensing.** Hall-sensitivity is set
    by the silicon die's specified Bop/Brp thresholds (per the
    DRV5032FC datasheet), **not by the physical package size**. A
    SOT-23 with the same die as a larger package detects magnets
    the same way over the same range. The bigger A3144 TO-92 we
    originally specced wasn't more sensitive — just more
    hand-handleable.
    What the small package **does** mean in practice:
    - **Easy to lose / hard to place by hand.** Buy 2× the quantity
      you need (~$10 extra on AliExpress) so a dropped part isn't a
      blocker. Already on the 3×3 PCBA so JLC handles placement —
      this only matters for any future hand-builds.
    - **Tighter placement tolerance.** The sensor's active area is
      smaller than the chess square. If JLC's pick-and-place drifts
      by 1–2 mm relative to the silkscreen, the sensor still ends
      up well inside the square's footprint. Not a concern.
    - **The real sensing question** is whether the magnet you pick
      generates enough field at the board-to-piece distance to clear
      the DRV5032FC threshold. This is the open question in §13 —
      will be answered empirically once the 3×3 is in hand and Paolo
      can test magnets against actual sensors. **Don't pre-commit to
      a magnet size before that test.**

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
- **Magnet selection**: pick a magnet strength that triggers DRV5032FC
  reliably across the full 8 mm board-to-piece distance. DRV5032FC
  typ. BOP ≈ 4.9 mT — neodymium discs in 3–6 mm dia × 1–2 mm thick
  range should comfortably clear that. Omnipolar means either pole
  works, so press-fit doesn't need orientation control. Test with the
  3×3 (or a small bench rig) before committing the full 8×8.
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
| 2026-06-07 (Hall sensor swap) | **Replaced A3144 (TO-92, unipolar, open-collector) with DRV5032FC (SOT-23, omnipolar, push-pull).** Identical pinout (1=VDD, 2=GND, 3=OUT), so matrix routing is unchanged. Drivers: (a) omnipolar removes the magnet-orientation constraint in chess pieces; (b) SOT-23 is JLCPCBA-assembleable, A3144 TO-92 isn't. Controller-side row pullups (R1–R8) are now electrically redundant but kept as-is. The 3×3 prototype PCB is built around this part. Updated §4.1, §4.2, §9, §11, §13. |
| 2026-06-07 (inverted controller) | **Controller PCB mounts inverted under the matrix.** J_MAIN is on the controller's **B.Cu** face, not F.Cu — components (M1, U2, U3, U6, J3, etc.) face the enclosure floor, the bare B.Cu face mates with the matrix's B.Cu. No mounting holes on the controller and no corner standoffs: the J_MAIN/J_CTRL connector pair is the only mechanical join, with the matrix's enclosure-frame mount carrying the assembled weight. Test points on the controller schematic were also dropped (probe component pads/pin headers directly during bringup). Updated §2, §3.1, §5.1, §10.1, §10.3. |
| 2026-06-09 (paper-fit test) | Printed all three PCBs at 1:1 and physically checked fit. Four observations logged in §11 items 12–15: **(12)** 8×8 outline at 292 × 292 mm overhangs Paolo's folding board's inner cavity — needs SQUARE_SIZE / BOARD_MARGIN re-derivation before fab. 3×3 (132 × 132 mm) is unaffected. **(13)** J_MAIN/J_CTRL pin-1 mirrors across the board-flip — pins line up mechanically but nets don't match per-pin between the two boards as soldered. Fix by rotating/renumbering J1 on one side before the 8×8 fab. **(14)** ESP32 footprint on the controller PCB doesn't match Paolo's physical DevKitC — preferred fix is to buy a matching DevKitC variant rather than re-route U2. **(15)** DRV5032FC SOT-23 visually small — verified not a sensing concern (die threshold sets sensitivity, not package), only a handling concern. None of the four blocks the **3×3 + controller** order that's already in flight. |
| 2026-06-09 (J1 mirror fix) | **Resolved §11 item 13** (J_MAIN/J_CTRL pin-1 mirror under board-flip). The matrix's J1 footprint was manually mirrored in KiCad's PCB editor (select J1 → right-click → Mirror → Mirror Around X Axis). Rows swap, nets at each physical pad position now match the controller's flipped pin contract. Side effect: matrix J1 pad numbering is now swapped within each odd-even pair vs the §3.1 contract table (matrix pin 1 = GND, pin 2 = +5V_LED, etc.) — see the callout in §3.1 explaining how to read the contract correctly. Same mirror needs to be re-applied to the 8×8 matrix J1 after its layout script runs. |
| 2026-06-08 (matrix board dimensions) | **Matrix board outline sized to fit Paolo's folding chess board model.** `SQUARE_SIZE = 32 mm` (matches the model's chess squares); `BOARD_MARGIN = 18 mm` from outermost chess square corner to PCB edge. Total PCB outlines: **3×3 = 132×132 mm**, **8×8 = 292×292 mm**. The physical model has a 20 mm inner-frame margin (the notation A–H / 1–8 strip), so 18 mm leaves ~2 mm wiggle per side for the PCB to slide inside the cavity. Both PCBs sit INSIDE the folding board's inner frame (not replacing the wood); the model's 10 mm outer fold/decorative edge is not part of the PCB. 8×8 stays comfortably in JLC's ≤300 mm pricing tier. |
| 2026-06-08 (DRV5032FC swap finalized) | **Swapped A3144 (TO-92, hand-solder) → DRV5032FC (SOT-23, JLC Basic Part C527532) in both matrix boards' schematic generators.** Open-drain output (compatible with controller R1..R8 pull-ups to +3V3 — sensor's 1 mA sink rating handles 3.3 V / 10 kΩ = 330 µA), omnipolar (no magnet orientation worries), VCC 1.65–5.5 V (works at 5 V or 3.3 V), B_OP threshold ±4.8 mT (proven safe for 32 mm chess pitch with N35 magnets). `openchess:A3144` symbol kept by name for backwards compatibility (pin 1=VCC, 2=GND, 3=OUT is identical between A3144 and DRV5032FC). 64× hall instances in 8×8 and 9× in 3×3 now use the SMD footprint — both boards fully JLC-PCBA-assemblable. Controller schematic unchanged (R1..R8 pull-ups still match the new sensor's open-drain output). |
| 2026-06-08 (C91 entry cap dropped) | **Removed C91 (470 µF THT polarized electrolytic).** Distributed row bulks (9× 47 µF in 8×8, 4× 47 µF in 3×3) provide 423 µF and 188 µF respectively — comfortably enough for the +5V_LED rail. C91 was the only through-hole part on the matrix board; removing it makes both boards fully JLC-SMT-assemblable. |
| 2026-06-08 (3×3 test board created) | **New `hardware-board-3x3/` directory** with full schematic + PCB layout pipeline, cloned from `hardware-board/` and parameterised for `MATRIX_COLS = MATRIX_ROWS = 3`. Identical design to the 8×8 (DRV5032FC, WS2812B, same connectors/bulks/decoupling); only the matrix dimensions are scaled. Purpose: validate the entire design — power flow, level shifter, column driver, hall scan, LED chain, J_CTRL/J_MAIN mating — on a cheap 132×132 mm board (~$15 JLC fab) before paying for the 292×292 mm 8×8 fab + PCBA. Supersedes the previously-planned 4×4 prototype. |
| 2026-06-08 (script architecture: merger not replacer) | **`scripts/sch/99_assemble.py` rewritten as a MERGER, not a REPLACER.** It now reads the existing `.kicad_sch`, removes only top-level items whose UUID prefix matches a script-owned prefix (`ba11` halls, `1ed0` LEDs, `1ed5` LED decoupling caps), then inserts fresh chunk content. Everything else — user-added components (J1 connector, MH, FID, TP, row bulks, PWR_FLAGs), manual wires/labels, decorative items — is preserved untouched. Previously the assembler overwrote the whole schematic on every run and wiped manual edits. Side effect: the chunk set was trimmed to only `02_halls.py` + `03_leds.py`; `01_skeleton.py` and `04_bulks.py` were archived under `scripts/sch/_archived/` because the user prefers to add the skeleton box and row bulks by hand in KiCad. |
| 2026-06-08 (matrix PCB layout: bulks left, J1 bottom) | **Updated `scripts/01_chess_grid.py` placement rules** to match user's chosen topology: row bulk caps (47 µF) live in the **LEFT margin**, Y-aligned with each LED row (so each bulk physically sits next to the row it decouples) — 8 mm left of `CHESS_X_LEFT`, all at the same X. The **J_CTRL connector (J1)** is placed at the **center of the bottom edge on B.Cu**, rotated 90° (long axis along X, ~33 mm wide × 5 mm tall), with the anchor shifted left by half the body length (15.24 mm) so the geometric center of the connector body — not pin 1 — sits at the board's X centerline. Both placements are mirrored between the 3×3 and 8×8 scripts so the design stays test→production identical. |
