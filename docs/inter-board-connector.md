# Board Connector Contracts

Current hardware has two PCBs and one panel harness:

- `hardware-board` or `hardware-board-3x3`: matrix board
- `hardware-controller`: controller, power, and driver board
- Panel harness: SSD1306 OLED and 3 buttons wired to controller `J3`

All active 2x13 matrix/controller `J` connectors are intended to use
`PinSocket_2x13` footprints.

## Matrix Connector: `J1` / `J1`

The matrix board connector and controller-side mate share the same 2x13 net
contract. The matrix board carries Hall row-sense nets, column power rails, LED
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
flying-lead harness. The harness lands at:

- SSD1306 0.96 inch I2C OLED module
- POWER panel button
- MODE panel button
- SELECT panel button

There is no active panel PCB.

| Pin | Net | Direction |
|----:|-----|-----------|
| 1 | `+3.3V` | controller -> panel |
| 2 | `GND` | both |
| 3 | `I2C_SDA` | bidirectional |
| 4 | `I2C_SCL` | controller -> panel |
| 5 | `BTN_SELECT` | panel -> controller |
| 6 | `BTN_POWER` | panel -> controller |
| 7 | `BTN_MODE` | panel -> controller |
| 8 | `PANEL_SPARE` | reserved |
| 9 | `PANEL_SPARE2` | reserved |
| 10 | `GND` | both |

Buttons short their signal net to `GND`. `BTN_POWER` and `BTN_MODE` use
external controller-side pullups because their ESP32 pins are input-only.
`BTN_SELECT` uses the ESP32 internal pullup in firmware.

Check the OLED module before wiring; many modules already include I2C pullups.
