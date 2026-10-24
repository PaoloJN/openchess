# OpenChess Hardware Design — Spec Sheet

Authoritative current-state spec for the OpenChess hardware. Per-board
build sheets are in each board's `SCHEMATIC_GUIDE.md`; cross-board cable
contracts in §3.

---

## 1. What the system is

Physical chess board with magnetic piece detection and visual feedback.
Plays online via Lichess and offline against Stockfish.

- **Sensing**: 8×8 grid of A3144 Hall sensors (each chess piece carries a magnet)
- **Display**: 9×9 grid of WS2812B RGB LEDs at square corners
- **Compute**: ESP32-DevKitC v4 module on socketed headers
- **UI**: SSD1306 0.96" I²C OLED + 3 panel-mount pushbuttons
- **Power**: 1S protected LiPo, USB-C charging, all via Seeed Lipo Rider Plus daughterboard

One-off, hand-soldered + JLC SMT-assembled, no v2 planned.

---

## 2. Hardware split

```
hardware/
├── hardware-board/         Matrix PCB: 64 Halls + 81 WS2812 LEDs (passive only)
└── hardware-controller/    Controller PCB: ESP32 socket, power module, ICs

(No panel PCB — OLED + 3 buttons on a flying-lead harness from controller J3)
```

**Assembly stack** (top → bottom):

```
   Matrix PCB              ← chessboard top surface, halls + LEDs on F.Cu
   J_CTRL female socket    ← back face of matrix, 2×13 vertical
       ↕ mates
   J_MAIN male pin header  ← top face of controller, 2×13 vertical
   Controller PCB
   4× M3 corner standoffs (~11 mm tall)
   LiPo battery (alongside controller)
   Enclosure floor
```

- No ribbon cable between matrix and controller.
- Battery sits **alongside** the controller, not sandwiched between PCBs.
- Panel components (OLED + buttons + USB-C) mount on one side wall of the enclosure on flying leads from controller J3.

---

## 3. Cross-board connector contracts

### 3.1 J_MAIN (controller) ↔ J_CTRL (matrix) — 2×13 board-to-board

| Side | Ref | Footprint |
|---|---|---|
| Controller | `J1` (J_MAIN) | `Connector_PinHeader_2.54mm:PinHeader_2x13_P2.54mm_Vertical` (male, top face) |
| Matrix | `J1` (J_CTRL) | `Connector_PinSocket_2.54mm:PinSocket_2x13_P2.54mm_Vertical` (female, back face) |

Pin 1 marked with silkscreen dot on both sides.

**Pinout (both sides identical by pin number):**

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

Counts: 4× `+5V_LED`, 5× `GND`, 1× `LED_DATA_5V`, 8× row-sense, 8× column-power.

### 3.2 J_PANEL — JST XH 10-pin (controller J3 → panel harness)

Ref `J3` on the controller. Footprint: `Connector_JST:JST_XH_B10B-XH-A_1x10_P2.50mm_Vertical`.

| Pin | Net | Direction |
|----:|-----|-----------|
| 1 | `+3V3` | controller → panel (OLED VCC + button-pullup supply) |
| 2 | `GND` | both |
| 3 | `I2C_SDA` | bidirectional (ESP32 GPIO1 ↔ OLED) |
| 4 | `I2C_SCL` | controller → panel (ESP32 GPIO3) |
| 5 | `BTN_SELECT` | panel → controller (GPIO2, internal pullup) |
| 6 | `BTN_POWER` | panel → controller (GPIO36, external pullup `R36` on controller) |
| 7 | `BTN_MODE` | panel → controller (GPIO39, external pullup `R37` on controller) |
| 8 | `PANEL_SPARE` | reserved (single-pin net) |
| 9 | `PANEL_SPARE2` | reserved (single-pin net) |
| 10 | `GND` | both |

Buttons short their signal net to GND when pressed. `PANEL_SPARE*` are intentionally single-pin nets — ERC warning expected.

Reset is the DevKitC's onboard EN button. No panel reset.

---

## 4. Matrix board BOM (`hardware-board/`)

**236 components total, all passive. F.Cu has halls + LEDs. B.Cu has J_CTRL socket + GND pour.**

| Group | Refdes range | Count | Symbol | Footprint | Value |
|---|---|---:|---|---|---|
| Hall sensors | `U1..U64` | 64 | `openchess:A3144` | `Package_TO_SOT_THT:TO-92_Inline` | A3144 |
| WS2812B LEDs | `D1..D81` | 81 | `LED:WS2812B` | `LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm` | WS2812B |
| Per-LED decoupling | `C10..C90` | 81 | `Device:C` | `Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder` | 100nF |
| Row bulk caps | `C1..C9` | 9 | `Device:C` | `Capacitor_SMD:C_1206_3216Metric` | 47µF |
| Entry cap | `C91` | 1 | `Device:C_Polarized` | `Capacitor_THT:CP_Radial_D10.0mm_P5.00mm` | 470µF |
| Matrix connector | `J1` (J_CTRL) | 1 | `Connector_Generic:Conn_02x13_Odd_Even` | `Connector_PinSocket_2.54mm:PinSocket_2x13_P2.54mm_Vertical` | — |
| Test points | `TP1..TP4` | 4 | `Connector:TestPoint` | `TestPoint:TestPoint_Pad_D1.5mm` | rails + data nets |
| Mounting holes | `MH1..MH4` | 4 | `Mechanical:MountingHole` | `MountingHole:MountingHole_3.2mm_M3` | M3 |
| Fiducials | `FID1..FID3` | 3 | `Mechanical:Fiducial` | `Fiducial:Fiducial_1mm_Mask2mm` | — |

**Ref mapping rules** (firmware contract):
- Hall: `U{1 + file_idx * 8 + rank_idx}`. `U1 = A1`, `U64 = H8`. File 0..7 = A..H, rank 0..7 = 1..8.
- LED: row-major. `D1 = top-left`, `D9 = top-right`, `D10..D18 = row 2`, …, `D81 = bottom-right`.
- Per-LED cap: `C{led_idx + 9}`. `C10` pairs with `D1`, `C90` pairs with `D81`.

**Nets used (every label):** `+5V_LED`, `GND`, `LED_DATA_5V`, `LED_DOUT_END` (TP only), `S0..S7`, `CA_PWR..CH_PWR`.

**Per-component pin → net rules:**
- A3144 Pin 1 (VCC) → `C{file}_PWR`; Pin 2 (GND) → `GND`; Pin 3 (OUT) → `S{rank}`.
- WS2812B Pin 1 (VDD) → `+5V_LED`; Pin 2 (DOUT) → next LED Pin 4 (DIN), or `LED_DOUT_END` for D81; Pin 3 (VSS) → `GND`; Pin 4 (DIN) → previous LED Pin 2 (DOUT), or `LED_DATA_5V` for D1.
- 100nF/47µF/470µF caps → Pin 1 to `+5V_LED`, Pin 2 to `GND`. C91 is polarized: Pin 1 = + (anode).

PWR_FLAG required on `+5V_LED` and `GND` (this board only consumes; ERC needs the source flag).

---

## 5. Controller board BOM (`hardware-controller/`)

| Group | Refdes | Symbol | Footprint | Value |
|---|---|---|---|---|
| ESP32 socket (left strip) | `J3` | `Connector_Generic:Conn_01x19` | `Connector_PinSocket_2.54mm:PinSocket_1x19_P2.54mm_Vertical` | DevKitC left |
| ESP32 socket (right strip) | `J4` | `Connector_Generic:Conn_01x19` | `Connector_PinSocket_2.54mm:PinSocket_1x19_P2.54mm_Vertical` | DevKitC right |
| Matrix connector | `J1` (J_MAIN) | `Connector_Generic:Conn_02x13_Odd_Even` | `PinHeader_2x13_P2.54mm_Vertical` | 2×13 male, top face |
| Panel connector | `J3` (J_PANEL — *separate from DevKit J3*, distinct net) | `Connector_Generic:Conn_01x10` | `JST_XH_B10B-XH-A_1x10_P2.50mm_Vertical` | JST XH 10-pin |
| Power module | `M1` | `Connector_Generic:Conn_01x08` | `LipoRiderPlus:MODULE_106990290` | Seeed Lipo Rider Plus |
| Schottky diode | `D2` | `Device:D_Schottky` | `Diode_SMD:D_SMA` | SS14 or BAT60A |
| Level shifter | `U3` | `74xx:74AHCT125` | `Package_SO:SOIC-14_3.9x8.7mm_P1.27mm` | 74AHCT125 |
| Column driver | `U6` | `Transistor_Array:TBD62783A` | `Package_DIP:DIP-18_W7.62mm` *or* `Package_SO:SOIC-18W_7.5x11.55mm_P1.27mm` | TBD62783A |
| Row pullups | `R1..R8` | `Device:R` | `Resistor_SMD:R_0805_2012Metric` | 10k |
| LED data series | `R11` | `Device:R` | `Resistor_SMD:R_0603_1608Metric` | 33Ω |
| Battery monitor (top) | `R14` | `Device:R` | `Resistor_SMD:R_0603_1608Metric` | 220k |
| Battery monitor (bottom) | `R15` | `Device:R` | `Resistor_SMD:R_0603_1608Metric` | 100k |
| Button pullups | `R36, R37` | `Device:R` | `Resistor_SMD:R_0603_1608Metric` | 10k |
| +5V_LED bulk | `C1, C2` | `Device:C` | `Capacitor_SMD:C_0805_2012Metric` | 10µF |
| U3 decoupling | `C5` | `Device:C` | `Capacitor_SMD:C_0603_1608Metric` | 100nF |
| U6 decoupling | `C11` | `Device:C` | `Capacitor_SMD:C_0603_1608Metric` | 100nF |
| ADC filter | `C12` | `Device:C` | `Capacitor_SMD:C_0603_1608Metric` | 100nF |
| Test points | `TP1..TP3` | `Connector:TestPoint` | `TestPoint:TestPoint_Pad_D1.5mm` | rails only |
| Mounting holes | `MH1..MH4` | `Mechanical:MountingHole` | `MountingHole_3.2mm_M3` | M3 corners |
| Fiducials | `FID1, FID2` | `Mechanical:Fiducial` | `Fiducial_1mm_Mask2mm` | — |

**Notes on M1 (Lipo Rider Plus):**
- Footprint installed locally at `lib/LipoRiderPlus.pretty/MODULE_106990290.kicad_mod` (SnapEDA model).
- **Symbol uses generic `Conn_01x08`, NOT SnapEDA's `106990290.kicad_sym`** — SnapEDA's symbol has reversed pin-number-to-name mapping vs. the module silkscreen. Using the generic connector with manual pin labels matches the silkscreen.
- M1 pin mapping (matches silkscreen, left-to-right with JST side first): 1=`3V3` out, 2=`EN` (NC), 3=`GND`, 4=`5V` out, 5=`GND`, 6=`BAT` raw, 7=`GND`, 8=`USB` VBUS test pad (NC).

**No on-PCB LDO.** `+3V3` comes directly from M1 pin 1.

---

## 6. Panel components (no PCB)

| Component | Qty | Notes |
|---|---:|---|
| SSD1306 0.96" 128×64 I²C OLED module | 1 | Pinout varies by vendor — verify with multimeter before wiring. |
| Panel-mount 12 mm tactile pushbutton | 3 | POWER, MODE/NAV, SELECT. Threaded shaft + nut. |
| 10-conductor stranded harness (~30 cm) | 1 | JST XH receptacle on controller end, bare leads on panel end |
| 4.7 kΩ I²C pullups (optional) | 2 | Add inline if OLED's onboard pullups don't reach across the 30 cm cable |

Wiring per J_PANEL pinout in §3.2. Buttons short signal-pin → GND when pressed.

---

## 7. Power architecture

```
USB-C   ────────→ ┌──────────────────────┐
                  │  M1 Lipo Rider Plus  │
LiPo ────────→ ───┤                      │
                  │  - USB-C charger     │
                  │  - 5V/2.4A boost     │
                  │  - 3.3V/250mA LDO    │
                  │  - OFF/5V/ON switch  │
                  └─┬───┬───┬───┬───┬────┘
                    │   │   │   │   │
                Pin 4   1   3,5,7  6 (8=NC)
                  5V  3V3  GND   BAT-raw
                    │   │         │
                    │   │      R14(220k)
                    │   │         │
                    │   │      ┌──┴──┐
                    │   │      R15  C12   → VBAT_MON → GPIO34 (ADC1_CH6)
                    │   │      (100k)(100nF)
                    │   │         │
                    │   │        GND
                    │   │
                    │   └→ +3V3 rail → ESP32, R1..R8, R36, R37, OLED via J_PANEL
                    │
                    └→ +5V_LED rail
                        ├→ C1, C2 (10µF bulk)
                        ├→ U3 VCC (74AHCT125)
                        ├→ U6 VCC (TBD62783A)
                        ├→ J1 pins 1, 3, 5, 25 → matrix
                        └→ D2 anode → DevKit pin 19 (ESP32 5V in)
                                       │
                                       └→ DevKit's onboard AMS1117 → ESP32 internal 3V3
```

**Behavior:**
- USB-C plugged: M1 charges LiPo (up to 2A) AND powers both rails.
- USB-C unplugged: M1 boosts from LiPo until UVLO (~3.0V) or BMS cuts.
- DevKit's USB micro-B also plugged: D2 blocks backfeed between USB sources.
- M1's slide switch MUST be set to "ON" (5V output enabled).

**Current budget:**

| Load | Typical | Peak |
|---|---:|---:|
| ESP32 + WiFi | 80 mA | 300 mA |
| 81 WS2812B (firmware-limited) | 100–500 mA | 5 A unbounded — **firmware MUST cap** |
| 8 active Hall sensors per scan column | 50 mA | 80 mA |
| U3 + U6 logic | 10 mA | 30 mA |
| OLED | 15 mA | 25 mA |
| **Total** | **~250–700 mA** | bounded by M1's **2.4 A** ceiling |

**Battery monitor math:** VBAT_MON = BAT × 100k / (220k + 100k) = BAT × 0.3125. At 4.2V → 1.31V at ADC. At 3.0V → 0.94V at ADC. Firmware multiplies calibrated ADC mV by 3.2 to recover BAT voltage.

---

## 8. GPIO map

Full table in `docs/gpio-map.md`. Key assignments:

| Function | ESP32 GPIO | DevKitC pin | Net |
|---|---:|---:|---|
| WS2812 data (3V3 pre-shift) | 32 | 7 | `LED_DATA` |
| Row sense | 4, 16, 17, 18, 19, 21, 22, 23 | 26..37 | `S0..S7` |
| Column drive | 13, 14, 27, 26, 25, 33, 5, 15 | 15..29 | `COL_DRV_A..H` |
| I²C SDA | 1 (TX0 repurposed) | 35 | `I2C_SDA` |
| I²C SCL | 3 (RX0 repurposed) | 34 | `I2C_SCL` |
| BTN_SELECT | 2 | 24 | `BTN_SELECT` |
| BTN_POWER | 36 (input-only) | 3 | `BTN_POWER` |
| BTN_MODE | 39 (input-only) | 4 | `BTN_MODE` |
| VBAT_MON (analog) | 34 (input-only, ADC1_CH6) | 5 | `VBAT_MON` |
| Reserved | 35 (input-only) | 6 | `PANEL_SPARE` |

**Pin constraints:**
- Flash pins (GPIO 6–11) → no-connect on DevKit socket.
- DevKit pin 1 (3V3) → no-connect (M1 sources 3V3).
- DevKit pin 19 (5V) → cathode of D2.
- UART0 (GPIO1/3) repurposed as I²C → no serial debug on DevKit USB during normal operation.
- Boot-strap pins: GPIO5/15 driven HIGH at boot (acceptable: columns G/H briefly on); GPIO2 floating/LOW at boot; GPIO12 NC at boot.

---

## 9. Mechanical & enclosure constraints

### 9.1 Stack

- Matrix PCB mounting holes (MH1..MH4) align with controller PCB mounting holes (MH1..MH4) — when the boards stack, M3 standoffs thread through both.
- Standoff height: **~11 mm** (matches the mating depth of the 2×13 pin header + socket combo).
- M1 (Lipo Rider Plus) is the tallest component on the controller. **Confirm M1 + 1.6 mm PCB thickness ≤ 11 mm headroom** before locking standoff length.

### 9.2 Controller PCB layout zones

| Zone | What |
|---|---|
| Top edge | M1 (USB-C jack + slide switch face the enclosure side wall) |
| Bottom edge | J1 (J_MAIN) — top face male pin header for stacking |
| One side edge | J3 (J_PANEL) — JST XH facing the panel side of the enclosure |
| Center | U2 (ESP32 socket) |
| Between U2 and J1 | U3 (level shifter), U6 (column driver), R11 (LED series), C5, C11 |
| Near M1 | C1, C2 (bulk), R14, R15, C12 (battery monitor) |
| Near U2 GPIOs | R1..R8 (row pullups), R36, R37 (button pullups), D2 (Schottky) |
| All 4 corners | MH1..MH4 (M3 mounting, must align with matrix MH1..MH4) |

### 9.3 Enclosure cutouts

| Cutout | Location | Size |
|---|---|---|
| OLED window | Side panel | ~27 × 27 mm |
| 3× button holes | Side panel (alongside OLED) | 12 mm diameter each |
| USB-C panel-mount | Side panel | ~10 × 8 mm rectangular + 2× M2 screw holes |
| DevKit EN button pinhole | Bottom | ~3 mm |
| DevKit micro-B access | Bottom (removable plate ideal) | enough to reach USB-B |

USB-C from M1 is routed to the side panel via a USB-C panel-mount extension cable (~$5, hand-soldered). The M1 module itself sits inside the enclosure, not at the wall.

### 9.4 Cables

- **No ribbon** between matrix and controller (board-to-board stack).
- **Panel harness**: 10-wire, ~15–20 cm. Twist I²C pair with GND if possible. Use 100 kHz I²C, not 400 kHz.
- **Battery**: pre-attached on a protected LiPo with JST 2.0 — plugs into M1's onboard JST.
- **USB-C panel cable**: ~15–30 cm, male USB-C into M1, female panel-mount on the enclosure wall.

---

## 10. First-build verification checklist

These are the things most likely to brick the build. Verify before fab.

1. **DevKitC socket pitch**: `Conn_01x19` × 2 strips at 25.4 mm row pitch. Most DevKitC modules are 2×15, not 2×19 — confirm the exact module variant before locking footprint.
2. **M1 footprint vs module**: 8 pads at 2.54 mm pitch + 4 corner M2 mounting holes (3 mm drill). Verify against the actual Seeed Lipo Rider Plus you'll receive.
3. **TBD62783A package**: pick DIP-18 *or* SOIC-18W *before* fab — both share the same KiCad symbol.
4. **WS2812B variant**: BOM must say `WS2812B-2020` or equivalent 5050 PLCC4. Color order varies (most are GRB) — firmware must match.
5. **A3144 pinout**: Pin 1 = VCC, Pin 2 = GND, Pin 3 = OUT. Order varies between datasheet sources — verify against the specific part you'll buy.
6. **J_MAIN ↔ J_CTRL alignment**: when the boards stack, controller pin 1 must mate with matrix pin 1. Mark with silkscreen dots on both.
7. **11 mm standoff clearance**: M1 height + 1.6 mm PCB ≤ 11 mm.
8. **Polarity**: C91 (+) toward `+5V_LED`; D2 anode = `+5V_LED`, cathode = DevKit pin 19; LiPo JST 2.0 (mechanically keyed).
9. **M1 slide switch in ON position** when board is assembled.
10. **3V3 budget**: M1 supplies only 250 mA on 3V3. Sum ESP32 (~150 mA burst) + OLED (~20 mA) + R1..R8 + R36/R37 pullups → fits but verify.
11. **No serial debug on DevKit USB during normal op** — UART0 is the I²C bus. Plan bring-up around the OLED first.

---

## 11. Known issues to confirm during bring-up

1. **A3144 settling**: ~5 µs after column energize before reading rows. Firmware must wait. Scan ≤ 1 kHz.
2. **A3144 polarity sensitivity**: senses one magnet polarity only. Spec piece magnet orientation.
3. **ESP32 ADC nonlinearity at low V**: VBAT_MON @ 3.0V → 0.94V ADC = noisy end. Use `esp_adc_cal_*` APIs.
4. **I²C over 30 cm panel cable**: stay at 100 kHz; if writes unreliable, drop pullups to 2.2 kΩ.
5. **Stacking-connector IR drop on +5V_LED**: at peak LED current the 2×13 stack can drop 100–500 mV. Mitigation: firmware brightness cap. Already designed in.
6. **Boot-time column glitch**: GPIO5/15 (`COL_DRV_G/H`) HIGH at boot strap → columns G/H briefly on for ~10 ms. Electrically harmless.
7. **BTN_SELECT held during reset**: GPIO2 must be LOW/floating at boot. Don't hold SELECT during EN-reset.
8. **M1 single-point-of-failure**: if M1 dies, all rails dead. Mitigation: M1 is a swappable $4 daughterboard.

---

## 12. Per-board guides

- `hardware-board/SCHEMATIC_GUIDE.md` — matrix board build sheet
- `hardware-controller/SCHEMATIC_GUIDE.md` — controller build sheet
- `hardware-controller/PCB_LAYOUT_GUIDE.md` — controller layout spec
- `docs/inter-board-connector.md` — cable contracts (matches §3 above)
- `docs/gpio-map.md` — full ESP32 pin assignments
