# CLAUDE.md

Durable project context for agent sessions. For status, read `STATUS.md`.
For current hardware facts, inspect the active KiCad schematic and PCB files
directly; older design notes and planning files may be stale.

## What This Project Is

OpenChess is a one-off personal hobby project. The goal is to learn through
hands-on PCB design and build one physical chess board that works cleanly. It
is not commercial, not intended for sale, and not designed as a supported
platform.

Design decisions optimize for:

1. First-build reliability
2. Learning value
3. Solo assembly with selective JLC SMT assembly
4. Finishing one working board rather than preparing for scale

## Current Hardware Sources

Use these files as the immediate hardware truth:

- `hardware/hardware-board/openchess-board.kicad_sch`
- `hardware/hardware-board/openchess-board.kicad_pcb`
- `hardware/hardware-board-3x3/openchess-board-3x3.kicad_sch`
- `hardware/hardware-board-3x3/openchess-board-3x3.kicad_pcb`
- `hardware/hardware-controller/openchess-controller.kicad_sch`
- `hardware/hardware-controller/openchess-controller.kicad_pcb`

`hardware/DESIGN_NOTES.md`, `planning/`, and archived docs can be useful
history, but do not treat them as authoritative when they conflict with the
KiCad files.

## Current Architecture

Two KiCad PCBs plus one cable-mounted panel harness:

- `hardware-board/`: full 8x8 matrix PCB, 282 mm by 282 mm.
- `hardware-board-3x3/`: 3x3 validation PCB, 132 mm by 132 mm.
- `hardware-controller/`: ESP32 controller PCB, 58 mm by 71 mm.
- Panel harness: SSD1306 OLED and 3 panel-mount buttons wired to controller
  `J3`.

There is no active panel PCB.

## Current Hardware Facts

- Matrix sensors are DRV5032FC SOT-23 parts.
- The 8x8 matrix has 64 Hall sensors and 81 WS2812B corner LEDs.
- The 3x3 validation board has 9 Hall sensors and 16 WS2812B corner LEDs.
- The controller has an ESP32-DevKitC, Seeed Lipo Rider Plus, 74AHCT125,
  TBD62783A DIP-18, SS14/BAT60A diode, row pullups, button pullups, battery
  divider, matrix connector `J1`, and panel connector `J3`.
- All active 2x13 matrix/controller `J` connectors are intended to use
  `PinSocket_2x13` footprints.
- The panel harness carries OLED I2C, POWER, MODE, SELECT, spare nets, 3.3 V,
  and GND.

## Firmware And Web

`firmware/` is populated with PlatformIO ESP32 firmware and adapted OpenChess
engine code. `web/` is populated with a React/Vite UI shell and shared
WebSocket protocol types.

Both are active but still need validation against real hardware. Before
claiming firmware is ready, re-check GPIO assignments, LED indexing, Hall scan
timing, OLED/button behavior, battery monitoring, and web protocol behavior
against the current 3x3/controller hardware.

## Gotchas

- DRV5032FC outputs are push-pull. Controller row pullups are still present.
- WS2812B data is level-shifted to 5 V through 74AHCT125 before reaching the
  matrix connector.
- The panel uses OLED plus buttons, not discrete indicator LEDs.
- DevKitC UART0 pins GPIO1/GPIO3 are used for OLED I2C in the current GPIO
  plan, so serial debug assumptions must be checked.
- `planning/` and `docs/archive/` are not active implementation guidance.

## When In Doubt

- Read `STATUS.md` for current phase and next actions.
- Read `docs/inter-board-connector.md` for human-readable connector contracts.
- Read `docs/gpio-map.md` for ESP32 pin assignments.
- Inspect the active KiCad files for current hardware truth.
