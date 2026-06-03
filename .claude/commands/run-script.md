# /run-script — Safely run a PCB automation script

Safely executes one of the scripts in `hardware/scripts/` with the right preconditions and verification.

## What to do

1. **Confirm which script** the user wants to run. If they said `/run-script grid_placement`, look for `hardware/scripts/grid_placement.py`. If unclear, list available scripts:

```bash
ls ~/Projects/openchess/hardware/scripts/*.py
```

2. **Check KiCad is closed.** Look for lock files:

```bash
ls ~/Projects/openchess/hardware/*.lck 2>/dev/null
```

If any lock file exists, STOP and tell the user to close KiCad first. Do not proceed — scripts will silently fight KiCad for file ownership and the user will lose work.

3. **Auto-create a master backup before running** (call the `/backup` workflow first — see `backup.md`).

4. **Run the script:**

```bash
cd ~/Projects/openchess/hardware/scripts && python3 <script_name>.py
```

5. **Validate the output**. Confirm the PCB file is still well-formed:

```bash
python3 -c "
with open('/Users/paolonessim/Projects/openchess/hardware/openchess.kicad_pcb') as f: text = f.read()
depth = 0; in_str = False; esc = False
for c in text:
    if esc: esc=False; continue
    if c=='\\\\': esc=True; continue
    if c=='\"': in_str = not in_str; continue
    if in_str: continue
    if c=='(': depth+=1
    elif c==')': depth-=1
print(f'PCB depth={depth} (must be 0)')
"
```

If depth != 0, the file is broken — restore from the backup created in step 3 and report the issue.

6. **Tell the user** what changed (script's stdout output is the source of truth here) and remind them to open KiCad to visually verify.

## Notes

- The scripts in `hardware/scripts/experimental/` are known-messy. Warn the user before running anything from that subfolder.
- `grid_placement.py` is idempotent (safe to re-run). Other scripts may not be — check the script's docstring.
