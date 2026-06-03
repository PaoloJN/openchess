# /restore — Restore design files from a master backup

List available master backups and restore the user's chosen one to the live `hardware/` files.

## What to do

1. List available backups:

```bash
ls -la ~/Projects/openchess/.backups/master/ 2>/dev/null
```

2. If multiple timestamps exist, ask the user **which timestamp** they want to restore. Show the dates clearly.

3. If a timestamp is specified (e.g. user said `/restore 20260603_074909`), restore all files matching that timestamp:

```bash
TS=<requested_timestamp>
cd ~/Projects/openchess/.backups/master
for f in *.${TS}; do
  dest=$(echo "$f" | sed "s/\.${TS}$//")
  cp "$f" ~/Projects/openchess/hardware/$dest
  echo "Restored $dest"
done
```

4. Warn the user: **KiCad must be closed before running**, otherwise it will overwrite the restored files on save. If unsure, ask them to confirm KiCad is closed first.

5. After restore, suggest they re-open the KiCad project and verify it looks right.

## Notes

- Per-script backups (`hardware/*.backup_before_*`) also exist for granular rollback after individual script runs. Restore those manually with `cp` if needed; this command only handles master backups.
