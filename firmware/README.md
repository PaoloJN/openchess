# Firmware

This directory will hold a fork of [joojoooo/OpenChess](https://github.com/joojoooo/OpenChess) adapted for the openchess PCB.

## Status

Not yet populated. See top-level `STATUS.md` for current project phase.

## Setup (when ready)

```bash
cd firmware/
git clone https://github.com/joojoooo/OpenChess.git .
# or, once forked:
# git submodule add https://github.com/<your-user>/OpenChess.git
```

## What needs adapting from upstream

joojoooo's `BoardDriver` assumes **64 LEDs under squares** (8×8). This board has **81 LEDs at corners** (9×9). Modify in `src/board_driver.h` and `src/board_driver.cpp`:

- `LED_PIN` → GPIO 32 (see `docs/gpio-map.md`)
- `NUM_ROWS`, `NUM_COLS` → 9, 9
- `LED_COUNT` → 81
- `ledIndexMap` / `DefaultRowColToLEDindexMap` → corner-grid mapping

Pin assignments are runtime-configurable via the web UI, so the GPIO map can be set after first boot rather than at compile time.

## What works upstream with no changes

- Hall sensor matrix scan via 74HC595 + PNP transistors
- Lichess Board API client (`chess_lichess.cpp`)
- Stockfish bot (`chess_bot.cpp`)
- ChessConnect for chess.com
- Move history persistence to flash (`move_history.cpp`)
- OTA firmware updates (`ota_updater.cpp`)
- WiFi captive portal + web UI (`wifi_manager_esp32.cpp` + `src/web/*.html`)
