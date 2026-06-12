# Firmware

PlatformIO ESP32 firmware for OpenChess. This directory is populated with an
adapted OpenChess engine codebase, shell protocol support, and hooks for an
embedded web UI.

## Status

Active but not yet proven against real hardware. The next validation target is
the controller plus 3x3 matrix board.

Current firmware work must be checked against:

- `hardware/hardware-controller/openchess-controller.kicad_sch`
- `hardware/hardware-controller/openchess-controller.kicad_pcb`
- `hardware/hardware-board-3x3/openchess-board-3x3.kicad_sch`
- `hardware/hardware-board-3x3/openchess-board-3x3.kicad_pcb`
- `docs/gpio-map.md`
- `docs/inter-board-connector.md`

## Build

```bash
cd firmware
platformio run
```

Upload target depends on the connected ESP32 board and local PlatformIO setup.

## Web UI Embedding

The web UI lives in `../web`. The firmware includes `data/index.html` for ESP32
serving. Use `scripts/embed_web.sh` when refreshing the embedded artifact from
the web build.

## Hardware Facts Firmware Must Follow

- Matrix sensors are DRV5032FC SOT-23.
- Matrix row sense nets are `S0..S7`.
- Matrix column power nets are `CA_PWR..CH_PWR`.
- LED data leaves the controller as `LED_DATA_5V` after 74AHCT125 level
  shifting.
- The 8x8 matrix has 81 WS2812B LEDs in a 9x9 corner grid.
- The 3x3 validation board has 16 WS2812B LEDs around its validation squares.
- Panel UI is an SSD1306 OLED plus POWER, MODE, SELECT buttons on a harness to
  controller `J3`.

## Work To Recheck During Bring-Up

- GPIO assignments and boot-pin behavior.
- LED index mapping for the 3x3 and 8x8 corner grids.
- Hall scan timing and column-drive sequencing.
- OLED I2C on GPIO1/GPIO3.
- Button pullup behavior for POWER, MODE, and SELECT.
- Battery voltage conversion from `VBAT_MON`.
- WebSocket protocol compatibility with `web/src/protocol.ts`.
