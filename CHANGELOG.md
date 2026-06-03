# Changelog

All notable hardware revisions and project milestones. Format roughly follows [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

### Hardware (rev 2.0 — in progress)
- Schematic complete, ERC clean
- Footprints assigned for all components
- Front-side hall sensors (64) + LEDs (81) placed via `hardware/scripts/grid_placement.py`
- Silkscreen: board outline, chess grid, A1–H8 labels, file/rank labels, title block, mounting holes

### Pending before rev 2.0 tape-out
- Back-side component placement (manual)
- Trace routing (Freerouting)
- DRC pass
- Gerber export → `hardware/fab/gerbers/`

### Firmware
- Not started. Will fork [joojoooo/OpenChess](https://github.com/joojoooo/OpenChess).

### Mechanical
- Not started. Wooden case + 3D-printed pieces planned for phase 3.

## [Repo restructure — 2026-06-03]
- Adopted lowercase open-hardware repo convention (`hardware/`, `firmware/`, `mechanical/`, `docs/`)
- Moved KiCad pre-step backups out of `hardware/` to gitignored `.backups/`
- Split `scripts/` into `hardware/scripts/` (blessed) and `hardware/scripts/experimental/`
- Added `hardware/fab/` for fabrication outputs (Gerbers, BOM, CPL)
- Added per-domain `LICENSE-hardware`, `LICENSE-firmware`, `LICENSE-docs`
- Extracted GPIO map to `docs/gpio-map.md` so non-AI readers find it
