# CLAUDE.md

Durable project context. For current status see `STATUS.md`; for the
authoritative hardware design see `hardware/DESIGN_NOTES.md`.

## What This Project Is

OpenChess is a **one-off personal hobby project**. The goal is to learn
through hands-on PCB design and build **one** physical chess board that
works cleanly the first time. It is **not** a product, not commercial,
not intended for sale or distribution. Design decisions optimize for:

1. **First-build reliability** — every part should work first try
2. **Learning value** — understand each subsystem, even if a module
   would be slightly simpler
3. **Solo assembly** — one person hand-soldering modules + getting JLC
   to assemble the SMD components
4. **Done, not shipped** — when it works on Paolo's desk, the project
   is finished; no v2, no scaling, no support burden

This shapes choices like: preferring well-tested daughterboard modules
(Seeed Lipo Rider Plus for power) over discrete switching regulators
we'd have to debug; preferring panel-mount components on flying leads
over a separate panel PCB; accepting slightly higher unit cost in
exchange for lower risk.

## What it does

A physical chess board that plays online via Lichess and offline via
Stockfish. Magnetic piece detection via Hall sensors, corner LEDs for
move indication, ESP32 firmware, OLED display + buttons for local UI,
LiPo battery powered with USB-C charging.

## Current Hardware Architecture

Two KiCad PCBs and one cable-mounted component group:

- **`hardware-board/`** — passive matrix board: 64× A3144 Hall sensors,
  81× WS2812B corner LEDs. Big PCB, all passive.
- **`hardware-controller/`** — ESP32 socket, level shifter, column
  driver IC, Lipo Rider Plus power daughterboard, connectors. Brain
  of the board.
- **Panel components (no PCB)** — SSD1306 OLED module + 3 panel-mount
  pushbuttons, mounted in the enclosure on flying leads. Connected to
  the controller via the `J_PANEL` connector (JST XH 10-pin).

The old `hardware-control-panel/` PCB design was dropped on 2026-06-05
and archived to `delete/hardware-control-panel-2026-06-05/`.

The older monolithic single-PCB design was archived to
`delete/old-hardware-2026-06-04/`. Do not use old `openchess.kicad_sch`,
`led_chain.kicad_sch`, or old rev0.1 walkthrough docs as active design
guidance.

## Current Connector Contracts

**Matrix connector** (board-to-board stacking, no ribbon):
- Matrix side: `J_CTRL` (2×13 female socket on the matrix back face)
- Controller side: `J_MAIN` (2×13 male pin header on the controller top face)
- Assembly: controller PCB stacks directly under matrix PCB; 4× M3
  standoffs (~11 mm) hold the stack at the right spacing
- Contract: `docs/inter-board-connector.md`
- Nets: `+5V_LED`, `GND`, `LED_DATA_5V`, `S0..S7`, `CA_PWR..CH_PWR`

**Panel connector** (flying leads from controller to discrete panel
components):
- Controller side: `J3` on the controller (JST XH 10-pin recommended)
- Panel side: bare wires to OLED module + panel-mount buttons
- Contract: `docs/inter-board-connector.md`
- Nets: `+3V3`, `GND`, `I2C_SDA`, `I2C_SCL`, `BTN_SELECT`,
  `BTN_POWER`, `BTN_MODE`, `PANEL_SPARE`, `PANEL_SPARE2`

## Maintenance Approach

- **Matrix board**: schematic is script-generated under
  `hardware-board/scripts/sch/`. 236 components are too many to
  hand-draw practically. Keep using the scripts.
- **Controller board**: hand-drawn in KiCad GUI. Scripts archived.
  Single source of truth for the build is
  `hardware-controller/SCHEMATIC_GUIDE.md`.

## Reference Mapping

**Matrix board**:
- Hall sensors: `U1..U64`, file-major order, `U1 = A1`, `U64 = H8`
- Matrix LEDs: `D1..D81`, row-major, `D1 = top-left`, `D81 = bottom-right`
- Per-LED caps: `C10..C90`
- Row bulk caps: `C1..C9`
- LED entry cap: `C91`

**Controller board** (see `DESIGN_NOTES.md` §5.1 for the full table):
- `M1` = Seeed Lipo Rider Plus power module
- `U2` = ESP32-DevKitC, `U3` = 74AHCT125, `U6` = TBD62783A
- `D2` = SS14 Schottky (between +5V_LED and DevKit pin 19)
- `J1` = J_MAIN (to matrix), `J3` = J_PANEL (to panel wiring)
- `R1..R8` = row pullups, `R11` = LED series, `R36, R37` = button pullups
- `C1, C2, C5, C11` = various decoupling
- _No LDO_ — Lipo Rider Plus's 3V3 output drives +3V3 directly

## Hardware Gotchas

- A3144 outputs are open-collector; pullups belong on the controller at `+3V3`.
- WS2812B data is level-shifted to 5V via 74AHCT125 before entering the matrix board cable.
- Matrix `+5V_LED` is the only 5V rail; comes from the PowerBoost module.
- Panel buttons short signal nets to GND; pullups on the controller for input-only ESP32 pins (BTN_POWER, BTN_MODE).
- DevKitC's onboard EN button is the only reset (no panel reset).
- UART0 (GPIO1/3) is repurposed as the I²C bus to the OLED — no serial debug.

## When In Doubt

- `STATUS.md` — current progress + next actions
- `hardware/DESIGN_NOTES.md` — **source of truth for the design**
- `hardware/hardware-controller/SCHEMATIC_GUIDE.md` — controller build sheet
- `hardware/hardware-board/SCHEMATIC_GUIDE.md` — matrix board reference
- `docs/inter-board-connector.md` — cable contracts
- `docs/gpio-map.md` — ESP32 pin assignments
