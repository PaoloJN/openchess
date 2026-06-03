# /status — Show current project phase and recent activity

Reads `STATUS.md` and shows the user where the project is, plus any recently-modified design files.

## What to do

1. Read `~/Projects/openchess/STATUS.md` and print its contents (or summarize the key sections: Done / In Progress / Open Questions).

2. Show recently modified design files:

```bash
find ~/Projects/openchess/{hardware,firmware,docs} -type f -newer ~/Projects/openchess/STATUS.md -not -path "*/.backups/*" -not -path "*/references/*" 2>/dev/null | head -20
```

3. Show last few master backups so the user knows what state can be restored:

```bash
ls -la ~/Projects/openchess/.backups/master/ 2>/dev/null | tail -10
```

4. Ask the user if they want to update STATUS.md based on what they're working on.
