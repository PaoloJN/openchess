# Firmware Audit

Current hardware assumption: two PCBs plus OLED/button panel harness.

## Hardware Facts Firmware Must Follow

- The active validation target is controller plus 3x3 matrix board.
- The full matrix uses 81 WS2812B LEDs in a 9x9 corner grid.
- The 3x3 validation board uses 16 WS2812B LEDs around its validation squares.
- There is no matrix-side battery/status WS2812B offset.
- Panel UI is an SSD1306 OLED plus POWER, MODE, SELECT buttons on controller
  `J3`.
- Hall row sense nets are `S0..S7`.
- Matrix column power nets are `CA_PWR..CH_PWR`.
- LED data leaves the controller as `LED_DATA_5V` after level shifting.
- Battery voltage is read through `VBAT_MON`.

## Firmware Work To Recheck

- Remove or avoid any LED-index offset that existed only for old indicator LEDs.
- Recheck 3x3 and 8x8 LED mapping against current PCB ordering.
- Recheck GPIO assignments against `docs/gpio-map.md`.
- Add or keep simple bring-up commands for OLED, buttons, LED chain, single
  Hall sensor, full Hall scan, and battery ADC.
- Confirm the web UI protocol still matches `src/shell/protocol.h` and
  `../web/src/protocol.ts`.
