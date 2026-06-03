# PCB Generation Scripts

Python scripts that modify `hardware/openchess.kicad_pcb` directly (parsing/writing KiCad's S-expression format). Use these to automate the repetitive mechanical parts of PCB layout.

## ⚠️ Before running any script

1. **Close KiCad completely.** Scripts hold the file open; KiCad will overwrite changes on save.
2. Run from this directory: `cd hardware/scripts && python3 grid_placement.py`

Every script auto-backs up the PCB before modifying. Look for `openchess.kicad_pcb.backup_before_<step>` in `hardware/` if you need to undo.

## Production scripts (run order)

### `grid_placement.py` — ⭐ active, idempotent

**What it does:**
- Places 64 hall sensors at 8×8 chess-square centers
- Places 81 WS2812 LEDs at 9×9 grid corners
- Draws the board outline on Edge.Cuts
- Draws silkscreen decorations: chess grid lines, A1-H8 labels, file/rank labels (A-H + 1-8), title block, WHITE/BLACK cardinal markers, mounting hole markers

**Idempotent.** Edit the config at the top of the script and re-run — it removes previous additions (via UUID prefix tags) and re-creates with new parameters.

**Knobs:**
- `SQUARE_SIZE` (default 32mm) — chess square pitch
- `BOARD_MARGIN` (default 12mm) — extra edge around LED grid
- `DRAW_*` toggles to enable/disable each silkscreen decoration
- Title text, fonts, line widths, etc.

### `export_gerbers.py` — final fab step

**What it does:** Calls `kicad-cli` to export all Gerber + drill files into `../fab/gerbers/`, then zips them up for JLCPCB upload.

**When to run:** After PCB layout is fully done and DRC passes.

## Experimental scripts

In `experimental/`. These produced messy output last time and are kept for reference / future rework. Don't run blindly.

### `experimental/back_side_placement.py` 🟡

Output was too cramped (28 components packed into a 30mm strip). Recommendation: place support components manually in KiCad — one-time job, better aesthetic.

### `experimental/power_planes.py` 🟡

Generated valid copper pours but the +5V pour blanketed the entire front side, conflicting with LED data routing. Recommendation: add power planes manually in KiCad AFTER routing, so the pour flows around existing traces.

### `experimental/led_chain_route.py` 🟡

Generated straight-line traces; D10→D11 became a diagonal across the whole board. Recommendation: use the Freerouting plugin (KiCad → Plugin Manager → Freerouting) for the LED chain.

## Reverting if a script breaks something

Each script makes `openchess.kicad_pcb.backup_before_<step>` before modifying:

```bash
cd hardware/
cp openchess.kicad_pcb.backup_before_grid_placement openchess.kicad_pcb
```

For a full reset to a known-good state, restore from `.backups/kicad-pcb/`:

```bash
cp .backups/kicad-pcb/pcb_master_20260603_074909.kicad_pcb hardware/openchess.kicad_pcb
```

## Conventions

- All scripts target the same PCB file: `hardware/openchess.kicad_pcb`
- UUID prefix markers identify items created by scripts:
  - `10000000-` → board outline (created by `grid_placement.py`)
  - `20000000-` → silkscreen text labels
  - `30000000-` → silkscreen lines / chess grid
  - `40000000-` → mounting hole markers
- Idempotent scripts clean up their own previous items via these markers before re-creating

## When to write a new script vs do it manually

| Task | Approach |
|---|---|
| Place 64+ identical components on a precise grid | **Script** — saves hours |
| Add silkscreen labels/decorations following a pattern | **Script** — easy, repeatable |
| General trace routing between mixed components | **Freerouting** — too complex for naive scripts |
| Aesthetic component placement (back side) | **Manual** — judgment required |
| Single-component tweaks | **Manual** — faster than scripting |
| Re-exporting Gerbers | **Script** — one-line build |
