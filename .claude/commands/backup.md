# /backup — Create a timestamped master backup of design files

Snapshots the KiCad PCB, schematic, sub-sheets, and project file into `.backups/master/` with today's date+time so you can always roll back.

## What to do

1. Run this bash command:

```bash
TS=$(date +%Y%m%d_%H%M%S)
mkdir -p ~/Projects/openchess/.backups/master
cd ~/Projects/openchess/hardware
for f in openchess.kicad_pcb openchess.kicad_sch led_chain.kicad_sch openchess.kicad_pro; do
  [ -f "$f" ] && cp "$f" ~/Projects/openchess/.backups/master/${f}.${TS}
done
echo "Backed up to .backups/master/ with timestamp $TS"
ls -la ~/Projects/openchess/.backups/master/ | tail -5
```

2. Tell the user the timestamp + how to restore (see `/restore` command).

## Notes

- Each restore is one `cp` command. Keep this list growing; old backups stay until manually deleted.
- The `.backups/` folder is gitignored.
