# CLAUDE.md

Durable project context. For current status see `STATUS.md`; for the active
hardware split see `hardware/DESIGN_NOTES.md`.

## What This Project Is

OpenChess is a physical chess board that plays online via Lichess and offline
via Stockfish. It uses magnetic piece detection, corner LEDs, ESP32 firmware,
and a phone web UI.

## Current Hardware Architecture

The active hardware is split into three KiCad projects under `hardware/`:

- `hardware-board`: passive matrix board with 64 A3144 Hall sensors and 81 WS2812B corner LEDs.
- `hardware-controller`: ESP32, power, row pullups, column drivers, LED data level shift, matrix/panel connectors.
- `hardware-control-panel`: cable-mounted side panel with buttons and normal status LEDs.

The old integrated board was archived to `delete/old-hardware-2026-06-04/`.
Do not use old `openchess.kicad_sch`, `led_chain.kicad_sch`, or old rev0.1
walkthrough docs as active design guidance.

## Current Connector Contracts

Matrix connector:

- Matrix side: `J_CTRL`
- Controller side: `J_MAIN`
- Contract: `docs/inter-board-connector.md` and `hardware/DESIGN_NOTES.md`
- Nets: `+5V_LED`, `GND`, `LED_DATA_5V`, `S0..S7`, `CA_PWR..CH_PWR`

Control panel connector:

- Panel side: `J_PANEL`
- Controller side: pending chunk
- Nets: `+3V3`, `GND`, `LED_PWR_N`, `LED_CONN_N`, `LED_BATT_N`, `BTN_POWER`, `BTN_MODE`, `BTN_RESET`, `PANEL_SPARE`

## Generated Schematic Pattern

Each hardware board follows the same script structure:

```text
scripts/sch/config.py
scripts/sch/geometry.py
scripts/sch/parts.py
scripts/sch/01_*.py ...
scripts/sch/99_assemble.py
```

Run chunk scripts from `hardware/`, with KiCad closed. Use KiCad ERC before
claiming a schematic is clean.

## Reference Mapping

Matrix board current references:

- Hall sensors: `U1..U64`, file-major order, `U1 = A1`, `U64 = H8`
- Matrix LEDs: `D1..D81`, row-major, `D1 = top-left`, `D81 = bottom-right`
- Per-LED caps: `C10..C90`
- Row bulk caps: `C1..C9`
- LED entry cap: `C91`

Control panel current references:

- Status LEDs: `D1..D3`
- LED resistors: `R1..R3`
- Buttons: `SW1..SW3`

## Hardware Gotchas

- A3144 outputs are open-collector; pullups belong on the controller at `+3V3`.
- WS2812B data should be level-shifted to 5V before entering the matrix board.
- Matrix `+5V_LED` is intentionally separate from controller logic rails.
- Control-panel LEDs are active-low; the controller sinks `LED_*_N` nets.
- Control-panel buttons short signal nets to GND; pullups live on the controller.

## When In Doubt

- `STATUS.md` for current work
- `hardware/DESIGN_NOTES.md` for hardware decisions
- `docs/README.md` for docs index
- `docs/inter-board-connector.md` for pinouts
- `docs/gpio-map.md` for provisional controller GPIO planning
