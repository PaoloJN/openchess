# Board Connector Contracts

Current hardware (v2) has two PCBs and one panel harness:

- `hardware-board` or `hardware-board-3x3`: matrix board
- `hardware-controller-v2`: controller, power, and driver board
- Panel harness: SSD1306 OLED and 3 buttons wired to controller `J_OLED` and `J_BTN`

All active 2x13 matrix/controller `J1` connectors are intended to use
`PinSocket_2x13` footprints.

## Matrix Connector: `J1` (matrix board ⇄ controller)

The matrix board connector and controller-side mate share the same 2x13 net
contract, **identical v1 ⇄ v2**. The matrix board carries Hall row-sense nets, column power rails, LED
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

## J_OLED — JST-XH 4-pin (controller ⇄ panel OLED)

| Pin | Net | Matches SSD1306 module order |
|---|---|---|
| 1 | GND | GND |
| 2 | +3.3V | VCC |
| 3 | I2C_SCL | SCL |
| 4 | I2C_SDA | SDA |

Straight-through cable; I2C pullups live on the OLED module (as in v1 — the
controller adds none).

## J_BTN — JST-XH 5-pin (controller ⇄ panel buttons)

| Pin | Net | Note |
|---|---|---|
| 1 | GND | common for all buttons |
| 2 | BTN_POWER | GPIO36, ext pullup R36 |
| 3 | BTN_MODE | GPIO39, ext pullup R37 |
| 4 | BTN_SELECT | GPIO2, internal pullup only |
| 5 | (spare) | not connected, reserved |

Buttons short their signal to GND. The v1 J3 XH-10 harness is retired;
re-crimp the panel harness into these two cables.
