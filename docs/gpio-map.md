# ESP32 GPIO Map

Current controller-board GPIO plan for ESP32-DevKitC v4. This map still needs
real-hardware validation during 3x3/controller bring-up.

The controller PCB net name is `+3.3V`; some prose may refer to the same rail
as 3V3.

Last updated: 2026-06-12.

## Nets To Support

| Group | Nets | Notes |
|---|---|---|
| Matrix row sense | `S0..S7` | ESP32 inputs. DRV5032FC outputs are push-pull; controller row pullups are still present. |
| Column drive | `COL_DRV_A..COL_DRV_H` | ESP32 active-high inputs to TBD62783A |
| Matrix columns | `CA_PWR..CH_PWR` | TBD62783A switched column rails to matrix connector |
| LEDs | `LED_DATA`, `LED_DATA_5V` | ESP32 data shifted to 5 V through 74AHCT125 |
| Panel display | `I2C_SDA`, `I2C_SCL` | SSD1306 OLED on panel harness |
| Panel buttons | `BTN_POWER`, `BTN_MODE`, `BTN_SELECT` | Buttons short signal to GND |
| Battery monitor | `VBAT_MON` | Battery divider into ESP32 ADC |
| Spare panel GPIO | `PANEL_SPARE`, `PANEL_SPARE2` | Reserved at panel connector |

## Pin Plan

| Signal | GPIO | DevKitC physical pin | Type | Notes |
|---|---:|---:|---|---|
| `LED_DATA` | 32 | 7 | Output | Feeds 74AHCT125 input |
| `S0` | 4 | 26 | Input | Row sense |
| `S1` | 16 | 27 | Input | Row sense |
| `S2` | 17 | 28 | Input | Row sense |
| `S3` | 18 | 30 | Input | Row sense |
| `S4` | 19 | 31 | Input | Row sense |
| `S5` | 21 | 33 | Input | Row sense |
| `S6` | 22 | 36 | Input | Row sense |
| `S7` | 23 | 37 | Input | Row sense |
| `COL_DRV_A` | 13 | 15 | Output | TBD62783A input I1 |
| `COL_DRV_B` | 14 | 12 | Output | TBD62783A input I2 |
| `COL_DRV_C` | 27 | 11 | Output | TBD62783A input I3 |
| `COL_DRV_D` | 26 | 10 | Output | TBD62783A input I4 |
| `COL_DRV_E` | 25 | 9 | Output | TBD62783A input I5 |
| `COL_DRV_F` | 33 | 8 | Output | TBD62783A input I6 |
| `COL_DRV_G` | 5 | 29 | Output | Bootstrap pin; verify behavior at boot |
| `COL_DRV_H` | 15 | 23 | Output | Bootstrap pin; verify behavior at boot |
| `I2C_SDA` | 1 | 35 | Bidirectional | OLED I2C; conflicts with normal UART0 debug assumptions |
| `I2C_SCL` | 3 | 34 | Output | OLED I2C; conflicts with normal UART0 debug assumptions |
| `BTN_SELECT` | 2 | 24 | Input | Internal pullup in firmware |
| `BTN_POWER` | 36 | 3 | Input-only | External controller-side pullup |
| `BTN_MODE` | 39 | 4 | Input-only | External controller-side pullup |
| `VBAT_MON` | 34 | 5 | ADC input | Battery voltage divider |
| `PANEL_SPARE` | 35 | 6 | Input-only | Reserved; no internal pullup |

## ESP32 Gotchas

- GPIO34-39 are input-only and have no internal pullups.
- GPIO1 and GPIO3 are planned for OLED I2C, so serial debug must be disabled,
  moved, or used only during reset/bootloader workflows.
- GPIO5 and GPIO15 are bootstrap pins; validate column-driver behavior during
  boot before relying on this map.
- ADC battery sensing should stay on ADC1 while WiFi is active.
- `LED_DATA_5V` is the shifted output, not a direct ESP32 pin.
