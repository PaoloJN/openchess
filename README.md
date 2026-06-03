# openchess

Physical chess board that plays online via Lichess (and offline vs Stockfish). Single PCB, phone-controlled via WiFi. 81 corner LEDs show moves; 64 hall sensors detect pieces.

## High-level

- **Hardware:** ESP32 + 64× A3144 hall sensors + 81× WS2812B LEDs + 74HC595 + 8× PNP transistors, all on one ~280×280 mm PCB
- **Firmware:** fork of [joojoooo/OpenChess](https://github.com/joojoooo/OpenChess), adapted for 9×9 corner-LED layout
- **UI:** phone web app served from the ESP32 (no native app)
- **Power:** Li-Po battery + USB-C charging
- **Cost:** ~$220 total (PCB + parts + PCBA on back side)

## Repo layout

```
openchess/
├── README.md                ← you are here
├── STATUS.md                ← current project phase, what's next
├── CHANGELOG.md             ← board revisions + milestones
├── CLAUDE.md                ← AI-agent briefing
├── LICENSE-hardware         ← CERN-OHL-S v2 (covers hardware/, mechanical/)
├── LICENSE-firmware         ← inherits from upstream OpenChess
├── LICENSE-docs             ← CC-BY-4.0 (covers docs/, all README.md)
│
├── hardware/                ← KiCad sources (the PCB)
│   ├── openchess.kicad_pro|sch|pcb
│   ├── led_chain.kicad_sch  ← LED-chain hierarchical sub-sheet
│   ├── lib/                 ← custom symbols/footprints (currently empty)
│   ├── fab/                 ← generated: Gerbers, BOM, CPL, schematic.pdf
│   ├── datasheets/          ← PDFs of parts used, pinned to this revision
│   ├── scripts/             ← layout automation (grid placement, gerber export)
│   │   └── experimental/    ← scripts that produced messy output, kept for reference
│   └── errata/              ← per-revision bug list (rev2.md, rev3.md, …)
│
├── firmware/                ← fork of joojoooo/OpenChess (not yet populated)
│
├── mechanical/              ← wooden case + 3D-printed pieces (phase 3)
│   ├── case/
│   ├── pieces/
│   └── fab/                 ← STLs ready to print
│
├── docs/                    ← durable reference docs
│   ├── assembly.md          ← how to build one
│   ├── design-decisions.md  ← why we chose this hybrid design
│   ├── bom.md               ← human-readable bill of materials
│   ├── gpio-map.md          ← ESP32 pin assignments
│   └── images/
│
└── references/              ← read-only clones of upstream projects (gitignored)
    ├── chessboard-v1-omercier/   ← Olivier Mercier's v1 design
    └── openchess-joojoooo/       ← the firmware foundation
```

## Starting points by use case

| If you want to... | Read this |
|---|---|
| See current project phase | `STATUS.md` |
| Build one | `docs/assembly.md` |
| Understand design choices | `docs/design-decisions.md` |
| Buy parts | `docs/bom.md` |
| Check ESP32 pins | `docs/gpio-map.md` |
| Open the KiCad project | `hardware/openchess.kicad_pro` |
| Run / modify layout scripts | `hardware/scripts/README.md` |
| Order PCBs | `hardware/fab/README.md` |
| Brief a new Claude Code session | `CLAUDE.md` |
| Read upstream source offline | `references/` |

## Quick context

This is a redesign of the original [chessboard-robot](https://www.oliviermercier.com/res/projects/chessboard/) project. v1 used reed switches (unreliable magnet detection) and a multiplexed LED matrix (painful to wire). v2 swaps in hall sensors + WS2812 addressable LEDs, drops the separate controller box + touchscreen, and uses joojoooo's mature firmware as the foundation.

Built with KiCad 10 on macOS.

## License

Mixed license — each artifact category has its own. See the three `LICENSE-*` files at the repo root. TL;DR: CERN-OHL-S v2 for the hardware, upstream license for firmware, CC-BY-4.0 for docs.
