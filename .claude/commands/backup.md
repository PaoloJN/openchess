# /backup — Create A Timestamped Hardware Backup

Back up the active split-board KiCad projects into `.backups/master/`.

## Command

```bash
TS=$(date +%Y%m%d_%H%M%S)
mkdir -p ~/Projects/openchess/.backups/master
cd ~/Projects/openchess
for f in \
  hardware/hardware-board/openchess-board.kicad_pro \
  hardware/hardware-board/openchess-board.kicad_sch \
  hardware/hardware-controller/openchess-controller.kicad_pro \
  hardware/hardware-controller/openchess-controller.kicad_sch \
  hardware/hardware-control-panel/openchess-control-panel.kicad_pro \
  hardware/hardware-control-panel/openchess-control-panel.kicad_sch
  do
    [ -f "$f" ] && mkdir -p ".backups/master/$(dirname "$f")" && cp "$f" ".backups/master/${f}.${TS}"
  done
echo "Backed up hardware projects with timestamp $TS"
```

## Notes

- `.backups/` is gitignored.
- This backs up active KiCad project/schematic files only. Generated chunks can be regenerated from scripts.
