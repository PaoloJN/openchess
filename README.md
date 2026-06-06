# openchess

Physical chess board that plays online via Lichess and offline via Stockfish.
The current hardware direction is a clean three-board split: a passive matrix
board, an ESP32 controller board, and a small cable-mounted control panel.

## High-level

- **Matrix board:** 64x A3144 Hall sensors, 81x WS2812B corner LEDs, row bulk caps, testpoints, and `J_CTRL`.
- **Controller board:** ESP32, power, scan drivers, row pullups, LED data level shifting, `J_MAIN`, and `J_PANEL`.
- **Control panel:** side-mounted buttons and normal status LEDs over a simple cable.
- **Firmware:** based on joojoooo/OpenChess, adapted for 9x9 corner LEDs and split-board IO.
- **UI:** phone web app served from the ESP32; physical panel is only for local controls/status.

## Repo Layout

```text
openchess/
├── README.md
├── STATUS.md
├── CLAUDE.md
├── WORKSPACE.md
├── hardware/
│   ├── README.md
│   ├── DESIGN_NOTES.md
│   ├── hardware-board/
│   ├── hardware-controller/
│   └── hardware-control-panel/
├── firmware/
├── mechanical/
├── docs/
│   ├── README.md
│   ├── assembly.md
│   ├── bom.md
│   ├── design-decisions.md
│   ├── gpio-map.md
│   ├── inter-board-connector.md
│   └── archive/
└── references/
```

## Starting Points

| If you want to... | Read this |
|---|---|
| See current phase | `STATUS.md` |
| Understand hardware split | `hardware/DESIGN_NOTES.md` |
| Open hardware projects | `hardware/README.md` |
| Check connector pinouts | `docs/inter-board-connector.md` |
| Check planned GPIOs | `docs/gpio-map.md` |
| Buy prototype parts | `docs/bom.md` |
| Build/assemble | `docs/assembly.md` |
| Brief an agent session | `CLAUDE.md` |

## Current Hardware Projects

- `hardware/hardware-board/openchess-board.kicad_pro`
- `hardware/hardware-controller/openchess-controller.kicad_pro`
- `hardware/hardware-control-panel/openchess-control-panel.kicad_pro`

Each board has a scripted schematic generator under its own `scripts/sch/`
folder. Generated schematics currently pass KiCad ERC for the scripted chunks.

## Background

This is a redesign inspired by Olivier Mercier's chessboard project and
joojoooo/OpenChess. The design keeps the physical smart-board idea while using
Hall sensors, addressable LEDs, and a more modular hardware split to reduce PCB
risk and make testing easier.

## License

Mixed license: CERN-OHL-S v2 for hardware, upstream license for firmware,
CC-BY-4.0 for docs. See the `LICENSE-*` files.
