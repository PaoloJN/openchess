# ESP32 GPIO Map

Authoritative mapping between ESP32 pins and on-board signals. **Keep this in sync with the schematic and the firmware's `board_driver.h`.**

| GPIO | Function | Signal name |
|---|---|---|
| 32 | LED data (WS2812 chain in) | `LED_DATA` |
| 14 | 74HC595 shift register clock | `SR_CLK` |
| 26 | 74HC595 latch | `SR_LATCH` |
| 33 | 74HC595 data in | `SR_DATA` |
| 4  | Hall sensor row 0 sense | `S0` |
| 16 | Hall sensor row 1 sense | `S1` |
| 17 | Hall sensor row 2 sense | `S2` |
| 18 | Hall sensor row 3 sense | `S3` |
| 19 | Hall sensor row 4 sense | `S4` |
| 21 | Hall sensor row 5 sense | `S5` |
| 22 | Hall sensor row 6 sense | `S6` |
| 23 | Hall sensor row 7 sense | `S7` |
| 2  | Reserved (boot strap; was side button in v1, unused in v2) | — |

## Power pins

- **Pin 1 (3V3)**: ESP32 internal regulator output, powers the 8 sensor pull-ups
- **Pin 19 (5V/VIN)**: powered from the external MT3608 boost converter module

## Gotchas

- **GPIO 12 is a flash voltage strap pin** — must be LOW at boot. Not used here; ensure nothing drives it HIGH.
- **GPIO 2 is a boot strap** — was the v1 side button, now reserved. Leave floating or pull-down.
- **WS2812 needs 5V data; ESP32 GPIO is 3.3V** — joojoooo's firmware design uses a level shifter (TXS0104E or similar) on the LED data line. Make sure that's on the BOM.
