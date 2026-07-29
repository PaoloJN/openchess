# Board Connector Contracts

Current hardware (v2) has two PCBs and one panel harness:

- `hardware-board` or `hardware-board-3x3`: matrix board
- `hardware-controller-v2`: controller, power, and driver board
- Panel harness: SSD1306 OLED and 3 buttons wired to controller `J6` (OLED) and `J7`/`J8`/`J9` (buttons)

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

## J6 — JST-XH 4-pin B4B-XH-A (controller ⇄ panel OLED)

| Pin | Net | Matches SSD1306 module order |
|---|---|---|
| 1 | GND | GND |
| 2 | +3.3V | VCC |
| 3 | I2C_SCL | SCL |
| 4 | I2C_SDA | SDA |

Straight-through cable; I2C pullups live on the OLED module (as in v1 — the
controller adds none).

## J7 / J8 / J9 — JST-XH 2-pin B2B-XH-A (controller ⇄ panel buttons)

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

The v1 J3 XH-10 harness is retired; re-crimp into four separate cables
(one B4B-XH-A for OLED, three B2B-XH-A for buttons).
