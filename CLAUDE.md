# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this project is

A physical chess board that plays online via the Lichess Board API and offline via Stockfish. **Single integrated PCB** — no separate controller box, no touchscreen. Phone web UI is the entire user interface.

This is a **redesign** of the original `chessboard-robot` project (cloned in-repo at `references/chessboard-v1-omercier/`) — Paolo built that following Olivier Mercier's open-source design, then hit two walls: reed switches were unreliable, and the LED matrix wiring was too painful to hand-assemble. This v2 fixes both by switching to hall sensors and WS2812 LEDs, and uses [joojoooo/OpenChess](https://github.com/joojoooo/OpenChess) as the firmware foundation.

## Hardware design (one PCB)

**Front (F.Cu) — visible when chess board is right-side up:**
- 64× **A3144 hall sensors** at chess square centers (8×8 grid, 32mm pitch)
- 81× **WS2812B 5050 LEDs** at the 9×9 grid corners (between/around the squares)
- Chess board silkscreen: grid lines, A1-H8 labels, file/rank labels, WHITE/BLACK markers, title block, mounting hole markers

**Back (B.Cu) — hidden under the wooden chess board:**
- ESP32-WROOM-32 dev board (mounted via 2×19 pin header)
- 74HC595 shift register (drives column scan via 8× 2N3906 PNP transistors)
- 16× pull-up resistors (8 for transistor bases, 8 for sensor row sense)
- BATT_LED (single WS2812 for battery indicator) + 100nF decoupling cap
- C2 (2.2µF) on ESP32 EN pin — fixes USB upload glitches
- USB-C charging module connector (J1) + power switch (SW1) + boost converter module connector (J2)

**Power flow:** USB-C → external TP4056 charging module → J1 → SW1 → external MT3608 boost module (J2) → +5V rail → everywhere.

## Component reference mapping (memorize this)

Hall sensors (U3-U66):
- `U(3 + file*8 + rank)` where file = 0-7 (A-H), rank = 0-7 (rank 1-8)
- e.g. **U3 = A1**, U10 = A8, **U66 = H8**
- A1 (white queenside) is at the **bottom-left** of the board

LEDs (D2-D82):
- `D(2 + row*9 + col)` where col = 0-8 (left to right), row = 0-8 (top to bottom)
- D2 = top-left corner, D10 = top-right, D82 = bottom-right
- D1 = BATT_LED on main schematic sheet, separate from the 9×9 grid

Power:
- `+5V`, `+3V3`, `GND` are global power nets (propagate across hierarchical sheets)

## ESP32 GPIO map

Authoritative reference: **`docs/gpio-map.md`** — keep that file and the schematic in sync. The same table also needs to match the firmware's `board_driver.h`.

## Schematic structure

KiCad project is at `hardware/openchess.kicad_pro`. Hierarchical sheets:
- **Root sheet** (`openchess.kicad_sch`): ESP32, 74HC595, 8 PNP transistors, pull-ups, BATT_LED (D1), power connectors, hall sensors, etc.
- **LED_Chain sub-sheet** (`led_chain.kicad_sch`): the 81 WS2812 LEDs in series. Connected to root via hierarchical pin `LED_DATA_OUT_1` (BATT_LED's DOUT feeds D2's DIN).

Inside LED_Chain, the daisy-chain bridges between rows are labeled `R2_IN` through `R9_IN` (each row's last LED DOUT → next row's first LED DIN). D82's DOUT has a no-connect flag.

## Firmware

Forked from joojoooo/OpenChess (see `firmware/` — not yet populated; clone from <https://github.com/joojoooo/OpenChess>).

**What needs adapting from joojoooo's defaults:**
- joojoooo's `BoardDriver` expects **64 LEDs under squares** (8×8); we have **81 LEDs at corners** (9×9). Adapt `LED_PIN`, `NUM_ROWS`, `NUM_COLS`, `LED_COUNT`, and the `ledIndexMap`/`DefaultRowColToLEDindexMap` in `src/board_driver.h` and `src/board_driver.cpp`.
- Hardware pin assignments to match this PCB (see "ESP32 GPIO map" below). joojoooo allows runtime config via web UI, so this can be done after first boot, not at compile time.

**What's already supported by joojoooo's firmware (no changes needed):**
- Hall sensor matrix scan via 74HC595 + 8 PNP transistors
- Lichess online play (`chess_lichess.cpp`)
- Stockfish bot (`chess_bot.cpp`)
- ChessConnect for chess.com
- Game state persistence to flash (`move_history.cpp`)
- OTA firmware updates (`ota_updater.cpp`)
- WiFi captive portal + full web UI (`wifi_manager_esp32.cpp` + `src/web/*.html`)

## Project structure (post 2026-06-03 restructure)

```
~/Projects/openchess/
├── README.md                                ← user-facing overview
├── CLAUDE.md                                ← this file
├── STATUS.md                                ← active heartbeat: phase + next steps
├── CHANGELOG.md                             ← board revisions + milestones
├── LICENSE-hardware / -firmware / -docs     ← split by artifact type
├── .gitignore                               ← KiCad cache, .backups/, references/*
│
├── hardware/                                ← KiCad sources
│   ├── openchess.kicad_pro|sch|pcb      ← root schematic + PCB
│   ├── led_chain.kicad_sch                  ← LED chain hierarchical sub-sheet
│   ├── lib/                                 ← custom symbols/footprints (empty)
│   ├── fab/                                 ← generated: gerbers, BOM csv, CPL csv
│   ├── datasheets/                          ← PDFs of parts used (pinned to rev)
│   ├── scripts/                             ← PCB layout automation
│   │   ├── grid_placement.py                ← ⭐ active, idempotent
│   │   ├── export_gerbers.py                ← final fab step
│   │   └── experimental/                    ← messy-output scripts kept for reference
│   └── errata/                              ← per-revision bug list (rev<N>.md)
│
├── firmware/                                ← fork of joojoooo/OpenChess (not yet populated)
│
├── mechanical/                              ← phase 3
│   ├── case/                                ← wooden case CAD
│   ├── pieces/                              ← 3D-printed pieces (magnets)
│   └── fab/                                 ← STLs ready to print
│
├── docs/
│   ├── assembly.md                          ← how to build one
│   ├── design-decisions.md
│   ├── bom.md
│   ├── gpio-map.md                          ← ESP32 pin map (extracted from CLAUDE.md)
│   └── images/
│
├── references/                              ← read-only clones (gitignored)
│   ├── chessboard-v1-omercier/              ← Olivier Mercier's v1 (github.com/omercier01/Chessboard)
│   └── openchess-joojoooo/                  ← firmware foundation (github.com/joojoooo/OpenChess)
│
└── .backups/                                ← local-only, gitignored
    ├── kicad-pcb/                           ← per-step + master pcb snapshots
    ├── kicad-sch/                           ← schematic snapshots
    └── history-snapshot/                    ← moved from old hardware/.history/
```

## Status & next steps (as of 2026-06-03)

**Done:**
- Full schematic — ERC clean (only the footprint library warning remains)
- Footprints assigned for all 200+ components
- Hall sensors + LEDs placed on 8×8 / 9×9 grid via `hardware/scripts/grid_placement.py`
- Board outline + chess grid + A1-H8 labels + file/rank labels + title block + mounting hole markers on silkscreen
- Master backup of all design files in `.backups/{kicad-pcb,kicad-sch}/*_master_20260603_074909.*`

**In progress:**
- Manual back-side component placement (joojoooo-aligned layout)
- Manual routing using Freerouting plugin

**Not started:**
- Firmware fork + 9×9 LED adaptation
- Mechanical: `mechanical/case/` (wooden enclosure CAD)
- Mechanical: wood overlay for the chess squares
- Mechanical: `mechanical/pieces/` (3D-printed chess pieces with magnets)

## Conventions

### Coordinate system
- KiCad PCB Y-axis is **positive-down** (screen coordinates)
- Board origin: (50, 50) — top-left of the Edge.Cuts outline
- LED grid origin: (62, 62) — top-left of the 9×9 LED grid (12mm inside the board)
- Hall sensor A1 at (78, 302) — **bottom-left** of the chess area

### Scripts
- All scripts in `hardware/scripts/` automatically back up `openchess.kicad_pcb` before modifying
- Scripts must be run with KiCad **closed** (otherwise file lock conflicts)
- `grid_placement.py` is idempotent — tracks items it created via UUID prefix markers (10000000-, 20000000-, 30000000-, 40000000-) so re-running cleanly removes old items first
- Scripts in `hardware/scripts/experimental/` produced messy output last time — needs rework or skip in favor of manual layout + Freerouting

### Backups
- Per-script backups: `hardware/openchess.kicad_pcb.backup_before_<step>` (written next to the live file)
- Restructure-time master snapshots: `.backups/kicad-pcb/pcb_master_<YYYYMMDD_HHMMSS>.kicad_pcb` (and same in `.backups/kicad-sch/`)
- Restore: `cp .backups/kicad-pcb/pcb_master_<...>.kicad_pcb hardware/openchess.kicad_pcb`

## Hardware-specific gotchas

- **Hall sensors are A3144** (5V open-collector). KiCad symbol used is `Connector_Generic:Conn_01x03` because no real A3144 symbol exists; pinout assigned is 1=VCC, 2=GND, 3=OUT. The actual TO-92 footprint at PCB stage matches this.
- **WS2812B chain is sensitive to power noise.** One bad LED kills the chain downstream. Order from a trusted source (LCSC, Adafruit), not random AliExpress.
- **ESP32 GPIO 12 is a flash voltage strap pin** — must be LOW at boot or the chip silently fails to load firmware. Not used in this design but make sure nothing accidentally drives it HIGH.
- **WS2812 LED at 5V vs ESP32 GPIO at 3.3V** — joojoooo's design includes a level shifter for the data line. Make sure this is in the BOM (4-channel level shifter like TXS0104E).

## Reference projects (read-only, for design comparison)

Now kept **in-repo** under `references/` (gitignored, each has its own upstream remote).

- **`references/chessboard-v1-omercier/`** — Olivier Mercier's v1 design with reed switches and LED matrix. Useful CAD files (`Cad/circuit_ESP32.svg`, `Cad/notes.txt`) and the proven Lichess client firmware. Upstream: <https://github.com/omercier01/Chessboard>
- **`references/openchess-joojoooo/`** — the firmware foundation. Modern C++ codebase with persistence, OTA, web UI, full chess engine, Stockfish integration. Upstream: <https://github.com/joojoooo/OpenChess>

## When in doubt

Open `README.md` for the user-facing overview, `docs/design-decisions.md` for why specific choices were made, and `hardware/scripts/README.md` for how the layout automation works.
