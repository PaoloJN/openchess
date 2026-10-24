# Firmware

PlatformIO ESP32 firmware for OpenChess.

## Layout

```text
src/main.cpp        the integrated product: menu + offline game + lights + BLE
src/pins.h          GPIO map for the v0.1 controller, extracted from the schematic
src/engine/         board driver, chess engine, AI, game controller, LED language
src/ui/             SSD1306 OLED menu
src/shell/          BLE server (NimBLE) and JSON protocol
src/bench/          one-file bench sketches, each with its own PlatformIO env
test/               native unit tests (engine, protocol) and an Arduino stub
tools/ble_debug.py  talk to the board's BLE service from a laptop
```

## Build

```bash
pio run -e esp32dev -t upload       # product build
pio run -e bench_sensor -t upload   # any bench env, see platformio.ini
pio test -e native_ai               # engine tests on the desktop
```

Bench envs: `bench_alive`, `bench_led`, `bench_sensor`, `bench_highlight`,
`bench_buttons`, `bench_oled`, `bench_demo`, `bench_board`, `bench_map`,
`bench_coach`, `bench_ui`, `bench_diag`, `bench_roarm`. The bring-up order is
in `BENCH.md`.

## Hardware Facts The Firmware Follows

- Row sense nets `S0..S7`, column power `CA_PWR..CH_PWR`, one column powered
  at a time. Column A gets a 50 ms settle because sensor U5 wakes slowly.
- 81 WS2812B LEDs in a 9x9 corner grid. A square is its four corners.
- LED frames go out over the I2S DMA method. Do not switch back to RMT.
- v0.1 OLED I2C is on GPIO1/3, the UART0 pins. Unplug the OLED to flash.
- Buttons: UP GPIO36, DOWN GPIO39, OK GPIO2. GPIO2 uses the internal pullup
  only.
- Battery voltage through the divider on GPIO34. Low-battery cutoff at
  3.30 V.

## License

MIT. The engine and board driver started as an adaptation of
[joojoooo/OpenChess](https://github.com/joojoooo/OpenChess). See `LICENSE`.
