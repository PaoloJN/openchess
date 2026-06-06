# /run-script — Run Hardware Automation Scripts

Use this for the current split-board scripts under `hardware/<board>/scripts/`.

## What To Do

1. Identify the board and script. Boards are:
   - `hardware-board`
   - `hardware-controller`
   - `hardware-control-panel`

2. If unclear, list scripts:

```bash
find ~/Projects/openchess/hardware -path '*/scripts/*.py' -o -path '*/scripts/sch/*.py' | sort
```

3. Check KiCad is closed for the target board:

```bash
find ~/Projects/openchess/hardware/<board> -name '*~*.lck' -o -name '*.lck'
```

If a lock exists, stop and ask the user to close KiCad or verify the lock is stale with `lsof`.

4. Run the script from `hardware/`:

```bash
cd ~/Projects/openchess/hardware
python3 <board>/scripts/sch/<script>.py
```

5. For schematic generation, run ERC:

```bash
/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli sch erc --severity-all <board>/<schematic>.kicad_sch
```

6. Report what changed and the ERC result.

## Notes

- The active schematic generators are chunk-based and live under each board's `scripts/sch/` folder.
- Old integrated-board scripts under archived folders are historical only.
