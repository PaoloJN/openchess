# Board Connector Contracts

Current hardware has three boards:

- `hardware-board`: matrix board
- `hardware-controller`: controller/power/driver board
- `hardware-control-panel`: cable-mounted controls/status board

## Matrix Connector: `J_CTRL` / `J_MAIN`

The matrix board connector is `J_CTRL`; the controller-side mate is `J_MAIN`.
Both use the same 2x13, 2.54 mm pinout.

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

Matrix board does not consume `+3V3`, `+BAT`, `BAT_SW`, or plain `+5V`.
Row pullups live on the controller board.

## Control Panel Connector: `J_PANEL`

`J_PANEL` is currently scripted on the control panel as a 1x10 connector.
The controller needs a matching connector chunk.

| Pin | Net | Direction |
|----:|-----|-----------|
| 1 | `+3V3` | controller -> panel |
| 2 | `GND` | both |
| 3 | `LED_PWR_N` | controller sinks |
| 4 | `LED_CONN_N` | controller sinks |
| 5 | `LED_BATT_N` | controller sinks |
| 6 | `BTN_POWER` | panel -> controller |
| 7 | `BTN_MODE` | panel -> controller |
| 8 | `BTN_RESET` | panel -> controller |
| 9 | `PANEL_SPARE` | spare GPIO |
| 10 | `GND` | both |

Panel LEDs are active-low. Buttons short their signal net to `GND`; pullups
belong on the controller.
