# Board Connector Contracts

Current hardware has three boards:

- `hardware-board`: matrix board
- `hardware-controller`: controller/power/driver board
- `hardware-control-panel`: cable-mounted controls/status board

## Matrix Connector: `J_CTRL` / `J_MAIN`

The matrix board connector is `J_CTRL`; the controller-side mate is `J_MAIN`.
Both share the same 2×13 pinout below, but use different **footprints**
because the boards stack directly (no ribbon cable):

- **Matrix `J_CTRL`**: 2×13 **female socket**, vertical, on the matrix
  PCB's back side (`Connector_PinSocket_2.54mm:PinSocket_2x13_P2.54mm_Vertical`)
- **Controller `J_MAIN`**: 2×13 **male pin header**, vertical, on the
  controller PCB's top side (`Connector_PinHeader_2.54mm:PinHeader_2x13_P2.54mm_Vertical`)

The two boards mate via the pin-header-into-socket connection. M3
brass standoffs (~11 mm) at the controller's corners provide
mechanical support.

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

`J_PANEL` is the 10-pin connector on the controller (`J3`) that
terminates at a **flying-lead harness** going to discrete panel
components in the enclosure — there is no panel PCB. Wires from the
harness land at:

- An SSD1306 0.96" I²C OLED module (4 wires: VCC, GND, SDA, SCL)
- 3× panel-mount momentary pushbuttons (each: signal + GND lead)

**Recommended controller-side connector**: JST XH 10-pin (polarized,
latching). Crimp pins on the harness end.

The 10-pin net contract has been stable since the panel was redesigned
to OLED + 3 buttons on 2026-06-05. The earlier "3 status LEDs +
BTN_RESET" version is archived under `delete/`.

| Pin | Net | Direction |
|----:|-----|-----------|
| 1 | `+3V3` | controller -> panel (OLED + button pullup supply) |
| 2 | `GND` | both |
| 3 | `I2C_SDA` | bidirectional (ESP32 GPIO1 ↔ OLED SDA) |
| 4 | `I2C_SCL` | controller -> panel (ESP32 GPIO3 → OLED SCL) |
| 5 | `BTN_SELECT` | panel -> controller (GPIO2) |
| 6 | `BTN_POWER` | panel -> controller (GPIO36) |
| 7 | `BTN_MODE` | panel -> controller (GPIO39) |
| 8 | `PANEL_SPARE` | reserved (was BTN_RESET) |
| 9 | `PANEL_SPARE2` | reserved (was PANEL_SPARE) |
| 10 | `GND` | both |

Buttons short their signal net to `GND`. BTN_POWER and BTN_MODE use
external 10kΩ pullups on the controller (R36, R37) because their ESP32
pins (GPIO36, GPIO39) are input-only with no internal pullups.
BTN_SELECT uses the ESP32's internal pullup on GPIO2.

I²C pullups (4.7kΩ × 2) typically live on the OLED module itself.
Verify with a multimeter — if absent, add inline pullups on the
harness (SDA→+3V3, SCL→+3V3).

The two `PANEL_SPARE*` wires can be omitted from the harness entirely
if you want fewer wires; they're reserved for future expansion (e.g.
adding a rotary encoder, buzzer, or extra button).
