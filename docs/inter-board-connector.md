# Board Connector Contracts

Current hardware (v0.1, built) has two PCBs and one panel harness:

- `hardware-board`: matrix board
- `hardware-controller`: controller, power, and driver board
- Panel harness: SSD1306 OLED and 3 buttons wired to controller `J3`

The shelved controller v2 design kept the same matrix contract and split the
panel into four XH plugs; that pinout is kept at the end for reference.

All active 2x13 matrix/controller `J1` connectors are intended to use
`PinSocket_2x13` footprints.

## Matrix Connector: `J1` (matrix board ⇄ controller)

The matrix board connector and controller-side mate share the same 2x13 net
contract (identical on the shelved v2 design). The matrix board carries Hall row-sense nets, column power rails, LED
data, LED power, and ground. The controller drives or receives those nets.

| Pin | Net | Direction |
|----:|-----|-----------|
| 1 | `+5V_LED` | controller -> matrix |
| 2 | `GND` | both |
| 3 | `+5V_LED` | controller -> matrix |
| 4 | `GND` | both |
| 5 | `+5V_LED` | controller -> matrix |
| 6 | `GND` | both |
| 7 | `LED_DATA_5V` | controller -> matrix |
| 8 | `GND` | both |
| 9 | `S0` | matrix -> controller |
| 10 | `S1` | matrix -> controller |
| 11 | `S2` | matrix -> controller |
| 12 | `S3` | matrix -> controller |
| 13 | `S4` | matrix -> controller |
| 14 | `S5` | matrix -> controller |
| 15 | `S6` | matrix -> controller |
| 16 | `S7` | matrix -> controller |
| 17 | `CA_PWR` | controller -> matrix |
| 18 | `CB_PWR` | controller -> matrix |
| 19 | `CC_PWR` | controller -> matrix |
| 20 | `CD_PWR` | controller -> matrix |
| 21 | `CE_PWR` | controller -> matrix |
| 22 | `CF_PWR` | controller -> matrix |
| 23 | `CG_PWR` | controller -> matrix |
| 24 | `CH_PWR` | controller -> matrix |
| 25 | `+5V_LED` | controller -> matrix |
| 26 | `GND` | both |

Counts: 4x `+5V_LED`, 5x `GND`, 1x `LED_DATA_5V`, 8x row-sense nets,
8x column-power nets.

The matrix board does not consume the 3.3 V rail. Row pullups live on the
controller.

## Panel Connector: Controller `J3`

`J3` is the 10-pin connector on the controller that terminates in a
flying-lead harness to the 0.91" SSD1306 OLED and the three panel buttons.
There is no panel PCB.

| Pin | Net | Direction | Firmware name |
|----:|-----|-----------|---------------|
| 1 | `+3.3V` | controller -> panel | |
| 2 | `GND` | both | |
| 3 | `I2C_SDA` | bidirectional | GPIO1 |
| 4 | `I2C_SCL` | controller -> panel | GPIO3 |
| 5 | `BTN_SELECT` | panel -> controller | OK, GPIO2 |
| 6 | `BTN_POWER` | panel -> controller | DOWN, GPIO36 |
| 7 | `BTN_MODE` | panel -> controller | UP, GPIO39 |
| 8 | `PANEL_SPARE` | reserved | GPIO35 |
| 9 | `PANEL_SPARE2` | reserved | |
| 10 | `GND` | both | |

Buttons short their signal net to `GND`. GPIO36 and GPIO39 are input-only and
use the controller-side pullups R36/R37. GPIO2 uses the ESP32 internal pullup
only; an external pullup there breaks USB download mode.

Check the OLED module before wiring; most modules include I2C pullups.

## Shelved: Controller v2 Panel Connectors

Reference only. Controller v2 was not built.

### J6 — JST-XH 4-pin B4B-XH-A (controller ⇄ panel OLED)

| Pin | Net | Matches SSD1306 module order |
|---|---|---|
| 1 | GND | GND |
| 2 | +3.3V | VCC |
| 3 | I2C_SCL | SCL |
| 4 | I2C_SDA | SDA |

Straight-through cable; I2C pullups live on the OLED module (as in v1 — the
controller adds none).

### J7 / J8 / J9 — JST-XH 2-pin B2B-XH-A (controller ⇄ panel buttons)

Three separate identical 2-pin XH plugs, one per button. Silkscreen labels on
the controller PCB identify which is which. The plugs are physically
interchangeable — label/polarity decides orientation.

| Pin | Net | Note |
|---|---|---|
| 1 | Signal | BTN_UP (J7, GPIO39) / BTN_DOWN (J8, GPIO36) / BTN_OK (J9, GPIO2) |
| 2 | GND | button return |

Buttons short signal pin to GND when pressed. GPIO39/36 have external pullups
R37/R36 on the controller. GPIO2 uses internal pullup only (no external
pullup — would break USB download mode).

v2 would have retired the J3 harness in favour of these four cables.
