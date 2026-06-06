# ESP32 GPIO Map

This is a provisional controller-board GPIO plan. It must be finalized when the
ESP32 footprint and column-driver approach are chosen, then kept in sync with
firmware and controller schematic scripts.

Last updated: 2026-06-05.

## Current Nets To Support

| Group | Nets | Notes |
|---|---|---|
| Matrix row sense | `S0..S7` | Inputs with `+3V3` pullups on controller |
| Column drive (internal) | `COL_DRV_A..COL_DRV_H` | ESP32 active-high inputs to TBD62783A 8-ch high-side driver IC |
| Matrix columns (connector) | `CA_PWR..CH_PWR` | TBD62783A outputs — switched 5V column rails |
| LEDs | `LED_DATA` (3V3), `LED_DATA_5V` (post-shift) | ESP32 data level-shifted to 5V via 74AHCT125 |
| Control panel display | `I2C_SDA`, `I2C_SCL` | SSD1306 OLED on panel (replaces status LEDs) |
| Control panel buttons | `BTN_POWER`, `BTN_MODE`, `BTN_SELECT` | POWER + MODE (input-only, ext pullups); SELECT on GPIO2 (internal pullup) |
| Battery monitor | `VBAT_MON` (analog) | R14/R15 voltage divider on Lipo Rider Plus M1 pin 6 (raw BAT pad) → GPIO34 (ADC1_CH6). Firmware reads battery voltage via `esp_adc_cal_*`. |
| Spare panel GPIO | `PANEL_SPARE`, `PANEL_SPARE2` | Reserved at J_PANEL pins 8 and 9 |

## Finalized Pin Plan (ESP32-DevKitC v4)

| Signal | GPIO | DevKitC physical pin | Type | Notes |
|---|---:|---:|---|---|
| `LED_DATA` (pre-level-shift) | 32 | 7 | Output | Feeds 74AHCT125 gate A input |
| `S0` | 4 | 26 | Input | Row sense (open-collector) |
| `S1` | 16 | 27 | Input | Row sense |
| `S2` | 17 | 28 | Input | Row sense |
| `S3` | 18 | 30 | Input | Row sense |
| `S4` | 19 | 31 | Input | Row sense |
| `S5` | 21 | 33 | Input | Row sense |
| `S6` | 22 | 36 | Input | Row sense |
| `S7` | 23 | 37 | Input | Row sense |
| `COL_DRV_A` → `CA_PWR` | 13 | 15 | Output | Feeds TBD62783A input I1; output O1 drives column A at 5V |
| `COL_DRV_B` → `CB_PWR` | 14 | 12 | Output | TBD62783A I2 → O2 |
| `COL_DRV_C` → `CC_PWR` | 27 | 11 | Output | TBD62783A I3 → O3 |
| `COL_DRV_D` → `CD_PWR` | 26 | 10 | Output | TBD62783A I4 → O4 |
| `COL_DRV_E` → `CE_PWR` | 25 | 9 | Output | TBD62783A I5 → O5 |
| `COL_DRV_F` → `CF_PWR` | 33 | 8 | Output | TBD62783A I6 → O6 |
| `COL_DRV_G` → `CG_PWR` | 5 | 29 | Output | TBD62783A I7 → O7. Boot-strap pin must be HIGH at boot — boot HIGH briefly turns column G on (no rows scanned yet, benign) |
| `COL_DRV_H` → `CH_PWR` | 15 | 23 | Output | TBD62783A I8 → O8. Same boot-strap caveat as GPIO5 |
| `I2C_SDA` | 1 | 35 | Bidirectional | TX0 repurposed for I²C bus to SSD1306 OLED on panel. Software remap via `Wire.begin(1, 3)`. |
| `I2C_SCL` | 3 | 34 | Output | RX0 repurposed for I²C SCL to OLED |
| `BTN_SELECT` | 2 | 24 | Input | Confirms menu selection. GPIO2 internal pullup enabled in firmware. Boot-strap LOW satisfied by button-released-state floating high through pullup — actually GPIO2 must be LOW *or floating* at boot; with internal pullup off at boot, this is fine. |
| `BTN_POWER` | 36 (SVP) | 3 | Input-only | External 10k pullup to `+3V3`; button shorts to GND |
| `BTN_MODE` | 39 (SVN) | 4 | Input-only | Same |
| (BTN_RESET — removed) | — | — | — | Reset button was dropped from the panel 2026-06-05. DevKitC's onboard EN button is the only reset path during prototype. Enclosure can add a pinhole over it. |
| `VBAT_MON` | 34 | 5 | Input-only (ADC1_CH6) | Analog battery voltage monitor. R14 (220 k) + R15 (100 k) divider on M1 pin 6 (raw `BAT` pad). At 4.2 V battery, ADC sees ~1.31 V; at 3.0 V, ~0.94 V. Firmware uses `esp_adc_cal_*` for calibration, multiplies the mV reading by 3.2 to recover battery voltage. |
| `PANEL_SPARE` | 35 | 6 | Input-only | Reserved, no internal pullup; add external if used |

## ESP32 Gotchas

- Bootstrap pins: GPIO0 must be HIGH at boot (left available as DevKitC boot button), GPIO2 must be LOW or floating, GPIO5 and GPIO15 must be HIGH, GPIO12 must be LOW.
- GPIO34-39 are input-only and have no internal pullups/pulldowns.
- GPIO1 (TX0) and GPIO3 (RX0) are now used as the panel I²C bus (`I2C_SDA` / `I2C_SCL`) to drive the SSD1306 OLED. Tradeoff: no serial debug on the DevKitC's onboard USB-UART during normal operation. Flashing still works (bootloader uses UART0 during reset), but printf-style debug must be disabled or routed elsewhere. ESP32 supports software-remapping I²C to any GPIO pair via `Wire.begin(SDA=1, SCL=3)`.
- ADC rail sensing should use ADC1 pins if WiFi is active.
- `LED_DATA_5V` is not an ESP32 pin directly; it is the 5V side of the 74AHCT125 level shifter.
