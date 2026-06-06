# OpenChess hardware design notes

This is the active hardware layout for OpenChess. The old integrated hardware
projects were archived to:

`../delete/old-hardware-2026-06-04/`

Current split:

```text
hardware/
├── hardware-board/         # passive matrix board: Hall sensors + WS2812 LEDs
├── hardware-controller/    # ESP32, power, scan drivers, panel connector
└── hardware-control-panel/ # cable-mounted buttons + status LEDs
```

## Current Decisions

- Matrix, controller, and control-panel boards are separate KiCad projects.
- Each board should use the same script pattern: `config.py`, `geometry.py`,
  `parts.py`, chunk scripts, assembler, ERC.
- Matrix board uses A3144 TO-92 Hall sensors for the first prototype because
  they are cheap, hand-solderable, and known to work in similar projects.
- Matrix LEDs are WS2812B 5050 parts with PCBA for LEDs, caps, and resistors.
- Row pullups live on the controller board at `+3V3`, not on the matrix board.
- Status LEDs and buttons live on `hardware-control-panel`, not on the matrix
  board.
- The control panel connects by cable so it can mount wherever the enclosure
  needs.
- First physical test target should be a smaller 4x4 matrix PCB variant using
  the same generated schematic structure.

## Matrix Board Scope

The generated matrix schematic currently contains:

- 64x A3144 Hall sensors, `U1..U64`
- 81x WS2812B LEDs, `D1..D81`
- 81x 100nF LED decoupling caps, `C10..C90`
- 9x 47uF row bulk caps, `C1..C9`
- 1x 470uF `+5V_LED` entry cap, `C91`
- `J_CTRL` 2x13 matrix/controller connector
- Testpoints on `+5V_LED`, `GND`, `LED_DATA_5V`, `LED_DOUT_END`
- M3 mounting holes and fiducials

The matrix schematic generated cleanly and passed KiCad ERC with 0 violations.

## Matrix Connector Contract

`J_CTRL` on the matrix board and `J_MAIN` on the controller board should share
this 2x13 pinout:

| Pin | Net |
|----:|-----|
| 1 | `+5V_LED` |
| 2 | `GND` |
| 3 | `+5V_LED` |
| 4 | `GND` |
| 5 | `+5V_LED` |
| 6 | `GND` |
| 7 | `LED_DATA_5V` |
| 8 | `GND` |
| 9 | `S0` |
| 10 | `S1` |
| 11 | `S2` |
| 12 | `S3` |
| 13 | `S4` |
| 14 | `S5` |
| 15 | `S6` |
| 16 | `S7` |
| 17 | `CA_PWR` |
| 18 | `CB_PWR` |
| 19 | `CC_PWR` |
| 20 | `CD_PWR` |
| 21 | `CE_PWR` |
| 22 | `CF_PWR` |
| 23 | `CG_PWR` |
| 24 | `CH_PWR` |
| 25 | `+5V_LED` |
| 26 | `GND` |

Counts: 4x `+5V_LED`, 5x `GND`, 1x `LED_DATA_5V`, 8x `S0..S7`,
8x `CA_PWR..CH_PWR`.

## Control Panel Contract

`J_PANEL` is a simple 1x10 cable connector:

| Pin | Net |
|----:|-----|
| 1 | `+3V3` |
| 2 | `GND` |
| 3 | `LED_PWR_N` |
| 4 | `LED_CONN_N` |
| 5 | `LED_BATT_N` |
| 6 | `BTN_POWER` |
| 7 | `BTN_MODE` |
| 8 | `BTN_RESET` |
| 9 | `PANEL_SPARE` |
| 10 | `GND` |

LEDs are active-low: the controller sinks `LED_*_N`. Buttons short `BTN_*`
to GND; pullups live on the controller.

## Controller Board Scope

The controller board contains:

- ESP32-DevKitC v4 on 2x 1x19 female header sockets, 25.4 mm row pitch
  (the user's actual schematic uses the `Espressif_Official:ESP32-DevKitC`
  module symbol — functionally equivalent, just a single 38-pin symbol
  instead of two 1x19s)
- USB-C 5V input → BQ24074RGT power-path charger → MT3608 boost → `+5V_LED`
- AP2112K-3.3 LDO from `+5V_LED` → `+3V3`
- LiPo battery (1S) via JST PH connector, with battery monitor divider
  feeding ESP32 ADC (GPIO34)
- Row pullups for `S0..S7`
- Column drive: TBD62783A 8-channel high-side driver IC (replaces previous
  discrete PMOS+NPN design)
- 74AHCT125 WS2812 data level shifter to `LED_DATA_5V`
- `J_MAIN` connector matching matrix `J_CTRL`
- `J_PANEL` connector matching `hardware-control-panel` (renumbered to `J3`
  because `J3`/`J4` are no longer used as ESP32 sockets — the module
  symbol replaces them)
- Testpoints/fiducials/mounting holes

### Power Architecture

Prototype #1 is **battery-backed with USB-C charging**. Path:

```
USB-C VBUS → BQ24074RGT (charger + power-path) → SYS pin
                          ↓
                       BAT pin ←→ LiPo cell (1S)
SYS → MT3608 boost (with 4.7 µH inductor) → +5V_LED
+5V_LED → AP2112K-3.3 LDO → +3V3
BAT → 220k/100k divider → VBAT_MON → GPIO34 (ADC1_CH6)
```

The BQ24074 autonomously switches between USB and battery: when USB is
plugged in, SYS is sourced from USB and the battery charges in parallel
(power-path); when USB is unplugged, the battery takes over with no
brownout. USB-C charging is set to 500 mA (R_ISET = 1.2 kΩ). CC1/CC2 carry
5.1 kΩ pulldowns making the board a USB-C sink; D+/D-/SBU pins are
no_connect; SHIELD ties to GND. The DevKitC's onboard USB still works
for programming but is not used as a power source — both DevKitC `3V3`
(pin 1) and `5V` (pin 19) are `no_connect` on the controller schematic
to avoid LDO contention.

## Controller Decisions (locked)

- **Power input:** USB-C 5V charges a 1S LiPo through BQ24074RGT
  (TI's MCP73871 equivalent). MT3608 boost generates `+5V_LED` from
  battery/USB SYS. AP2112K-3.3 LDO produces `+3V3` from `+5V_LED`.
- **Battery:** 1S LiPo via JST PH 2-pin connector (off-board cable).
  Recommended 1000–2000 mAh. Battery monitor divider into GPIO34 ADC.
- **ESP32 form factor:** ESP32-DevKitC v4 on 2x 1x19 sockets, 25.4 mm row
  pitch (schematic uses the Espressif_Official module symbol). DevKitC
  flash pins (GPIO6-11) are explicit `no_connect`. DevKitC 3V3 and 5V
  pins are NC (don't share rails with our LDO).
- **WS2812 level shifter:** 74AHCT125 SOIC-14. Gate A drives the
  `LED_DATA` 3V3 -> `LED_DATA_5V` 5V translation, `~OE` low. Unused gates
  B/C/D have inputs tied to GND, `~OE` tied to GND, outputs `no_connect`.
  33 Ω series resistor on `LED_DATA_5V` output, 100 nF Vcc decoupling.
- **Column drivers (8 channels):** TBD62783A 8-channel high-side P-MOSFET
  source driver (DIP-18 or SOIC-18W). Inputs I1-I8 = `COL_DRV_A..H` from
  ESP32 GPIOs (3V3 logic). Outputs O1-O8 = `CA_PWR..CH_PWR` switched
  from `+5V_LED`. Active-high enable. 100 nF Vcc bypass.
- **GPIO assignments:** finalized — see `docs/gpio-map.md`.
