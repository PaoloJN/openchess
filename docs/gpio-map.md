# ESP32 GPIO Map

Current controller-board GPIO plan for hardware-controller-v2 (integrated ESP32 + battery).
The v1 ESP32-DevKitC pinout is frozen and kept below for reference.

The controller PCB net name is `+3.3V`; some prose may refer to the same rail
as 3V3.

Last updated: 2026-07-28.

## v2 (hardware-controller-v2 — current)

Design rules that produced this map: GPIO1/3 reserved for UART0↔USB-serial (debug + flashing); GPIO0 reserved for BOOT button; strapping pins carry only boot-safe signals (GPIO5/15 may idle HIGH → row sense; GPIO12 must NOT idle high and GPIO2 must not be pulled high externally → column drives, which idle low; GPIO2 keeps BTN_SELECT with internal-only pullup exactly as proven in v1); I2C lands on GPIO21/22, the ESP32 Arduino `Wire` defaults.

| Signal | GPIO | WROOM-32E pin | Type | Notes |
|---|---:|---|---|---|
| `LED_DATA` | 32 | 8 (IO32) | Output | unchanged |
| `S0` | 16 | 27 (IO16) | Input | row sense, ext 10k pullup R1 |
| `S1` | 17 | 28 (IO17) | Input | R2 |
| `S2` | 18 | 30 (IO18) | Input | R3 |
| `S3` | 19 | 31 (IO19) | Input | R4 |
| `S4` | 23 | 37 (IO23) | Input | R5 |
| `S5` | 5 | 29 (IO5) | Input | strapping; idles HIGH = boot-safe; R6 |
| `S6` | 15 | 23 (IO15) | Input | strapping; idles HIGH = boot-safe; R7 |
| `S7` | 35 | 7 (IO35) | Input | input-only; ext pullup R8 (required — no internal pullup) |
| `COL_DRV_A` | 13 | 16 (IO13) | Output | unchanged |
| `COL_DRV_B` | 14 | 13 (IO14) | Output | unchanged |
| `COL_DRV_C` | 27 | 12 (IO27) | Output | unchanged |
| `COL_DRV_D` | 26 | 11 (IO26) | Output | unchanged |
| `COL_DRV_E` | 25 | 10 (IO25) | Output | unchanged |
| `COL_DRV_F` | 33 | 9 (IO33) | Output | unchanged |
| `COL_DRV_G` | 4 | 26 (IO4) | Output | off strapping pin |
| `COL_DRV_H` | 12 | 14 (IO12) | Output | strapping but idles LOW (driver input) = boot-safe |
| `I2C_SDA` | 21 | 33 (IO21) | Bidirectional | Arduino Wire default |
| `I2C_SCL` | 22 | 36 (IO22) | Output | Arduino Wire default |
| `BTN_SELECT` | 2 | 24 (IO2) | Input | internal pullup only (NO external pullup — would break USB download mode) |
| `BTN_DOWN` | 36 | 4 (SENSOR_VP) | Input-only | ext pullup R36; connector J8 |
| `BTN_UP` | 39 | 5 (SENSOR_VN) | Input-only | ext pullup R37; connector J7 |
| `VBAT_MON` | 34 | 6 (IO34) | ADC input | ADC1_CH6, divider R14/R15 |
| UART0 TX | 1 | 35 (TXD0) | Output | to USB-serial RXD |
| UART0 RX | 3 | 34 (RXD0) | Input | to USB-serial TXD |
| BOOT | 0 | 25 (IO0) | Input | BOOT button + auto-program transistor |
| EN | — | 3 (EN) | — | 10k pullup + 1µF to GND + EN button + auto-program transistor |

## v1 (ESP32-DevKitC — frozen hardware)

## Nets To Support

| Group | Nets | Notes |
|---|---|---|
| Matrix row sense | `S0..S7` | ESP32 inputs. DRV5032FC outputs are push-pull; controller row pullups are still present. |
| Column drive | `COL_DRV_A..COL_DRV_H` | ESP32 active-high inputs to TBD62783A |
| Matrix columns | `CA_PWR..CH_PWR` | TBD62783A switched column rails to matrix connector |
| LEDs | `LED_DATA`, `LED_DATA_5V` | ESP32 data shifted to 5 V through 74AHCT125 |
| Panel display | `I2C_SDA`, `I2C_SCL` | SSD1306 OLED on panel harness |
| Panel buttons | `BTN_UP`, `BTN_DOWN`, `BTN_OK` | Buttons short signal to GND |
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
| `BTN_OK` | 2 | 24 | Input | Internal pullup in firmware |
| `BTN_DOWN` | 36 | 3 | Input-only | External controller-side pullup |
| `BTN_UP` | 39 | 4 | Input-only | External controller-side pullup |
| `VBAT_MON` | 34 | 5 | ADC input | Battery voltage divider |
| `PANEL_SPARE` | 35 | 6 | Input-only | Reserved; no internal pullup |

## ESP32 Gotchas

- **v2 notes:** GPIO1/3 are now UART0 (serial debug); OLED I2C moved to GPIO21/22 (Arduino Wire defaults), so serial debug and OLED can coexist. Strapping pins (GPIO0/2/5/12/15) are designed-in per the design rules above.
- GPIO34-39 are input-only and have no internal pullups.
- GPIO5 and GPIO15 are bootstrap pins; they idle HIGH for row sense, which is boot-safe.
- ADC battery sensing should stay on ADC1 while WiFi is active.
- `LED_DATA_5V` is the shifted output, not a direct ESP32 pin.
