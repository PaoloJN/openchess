#!/usr/bin/env python3
"""Surgically merge the test/mech snippet INTO the main controller schematic.

Unlike the old chunk-based scripts (which OVERWRITE the entire
schematic), this script:
  1. Backs up the main schematic to .backup_before_merge
  2. Adds any missing symbol library definitions (TestPoint, MountingHole,
     Fiducial, +3V3, GND) into the main schematic's (lib_symbols) block
  3. Inserts the test/mech component instances + labels + wires + power
     ports just before the (sheet_instances) block at the end of the
     main schematic
  4. Validates that all parens balance before saving

Pre-requisites:
  - The snippet must exist at build/snippets/test_mech_snippet.kicad_sch
    (run gen_test_mech.py first to generate it)
  - KiCad should be CLOSED on the main schematic while this runs

Usage:
    cd hardware-controller
    python3 scripts/snippets/merge_test_mech.py

If you need to re-merge, manually delete the .backup_before_merge file
first, restore the main schematic from it, then run again.
"""
from __future__ import annotations
import re
import shutil
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
BOARD_DIR = HERE.parent.parent                    # hardware-controller/
MAIN_SCH = BOARD_DIR / "openchess-controller.kicad_sch"
SNIPPET = BOARD_DIR / "build" / "snippets" / "test_mech_snippet.kicad_sch"
BACKUP = BOARD_DIR / "openchess-controller.kicad_sch.backup_before_merge"


def block_end(text: str, start: int) -> int:
    """Given index of '(' in text, return index immediately after the
    matching ')'. Walks parens with simple depth counting."""
    if text[start] != '(':
        raise ValueError(f"block_end: text[{start}] is not '('")
    depth = 0
    j = start
    while j < len(text):
        c = text[j]
        if c == '(':
            depth += 1
        elif c == ')':
            depth -= 1
            if depth == 0:
                return j + 1
        j += 1
    raise ValueError(f"block_end: unbalanced parens starting at {start}")


def find_top_level(text: str, marker: str) -> int:
    """Find the index of the first '(' that starts a top-level
    `(<marker> ...)` block. Returns -1 if not found."""
    needle = '(' + marker
    i = text.find(needle)
    return i if i != -1 else -1


def extract_lib_symbol_defs(lib_block: str) -> dict[str, str]:
    """Return dict of {lib_id: definition_text} for each top-level
    (symbol "Lib:Name" ...) inside a (lib_symbols ...) block.

    Sub-symbols (Name_0_1, Name_1_1) are nested inside their parent
    and are skipped here — only the outermost symbol per lib_id."""
    # Skip past the opening "(lib_symbols"
    inner_start = lib_block.find('(lib_symbols') + len('(lib_symbols')

    defs: dict[str, str] = {}
    depth = 0  # depth inside lib_symbols
    i = inner_start
    while i < len(lib_block):
        c = lib_block[i]
        if c == '(':
            if depth == 0 and lib_block[i:i+9] == '(symbol "':
                # Top-level symbol entry
                name_start = i + len('(symbol "')
                name_end = lib_block.find('"', name_start)
                name = lib_block[name_start:name_end]
                if ':' in name:
                    end = block_end(lib_block, i)
                    defs[name] = lib_block[i:end]
                    i = end
                    continue
            depth += 1
        elif c == ')':
            depth -= 1
            if depth < 0:
                break
        i += 1
    return defs


def find_uuids(text: str) -> set[str]:
    """Return all UUID strings in the text."""
    return set(re.findall(r'\(uuid\s+"([^"]+)"\)', text))


def main() -> int:
    # ── Pre-flight ────────────────────────────────────────────────
    if not MAIN_SCH.exists():
        print(f"ERROR: main schematic not found: {MAIN_SCH}")
        return 1
    if not SNIPPET.exists():
        print(f"ERROR: snippet not found at {SNIPPET}")
        print("Run 'python3 scripts/snippets/gen_test_mech.py' first.")
        return 1
    if BACKUP.exists():
        print(f"ERROR: backup already exists: {BACKUP}")
        print()
        print("A previous merge ran. To re-merge:")
        print("  1. (Optional) Restore from backup if the previous merge was bad:")
        print(f"       cp {BACKUP.name} {MAIN_SCH.name}")
        print("  2. Delete the backup to allow a new merge:")
        print(f"       rm {BACKUP.name}")
        print("  3. Re-run this script.")
        return 1

    main_text = MAIN_SCH.read_text()
    snip_text = SNIPPET.read_text()

    # ── Locate (lib_symbols) and (sheet_instances) in both files ───
    main_lib_start = find_top_level(main_text, "lib_symbols")
    if main_lib_start == -1:
        print("ERROR: main schematic has no (lib_symbols) block")
        return 1
    main_lib_end = block_end(main_text, main_lib_start)

    main_si_start = find_top_level(main_text, "sheet_instances")
    if main_si_start == -1:
        print("ERROR: main schematic has no (sheet_instances) block")
        return 1

    snip_lib_start = find_top_level(snip_text, "lib_symbols")
    snip_lib_end = block_end(snip_text, snip_lib_start)
    snip_si_start = find_top_level(snip_text, "sheet_instances")

    # ── Extract data ────────────────────────────────────────────────
    main_lib_block = main_text[main_lib_start:main_lib_end]
    snip_lib_block = snip_text[snip_lib_start:snip_lib_end]

    # Content = everything between (lib_symbols) and (sheet_instances)
    snippet_content = snip_text[snip_lib_end:snip_si_start]

    # ── UUID collision check ────────────────────────────────────────
    main_uuids = find_uuids(main_text)
    snip_uuids = find_uuids(snippet_content)
    # Add UUIDs from snippet's missing lib_symbol defs too
    snip_lib_defs = extract_lib_symbol_defs(snip_lib_block)
    main_lib_defs = extract_lib_symbol_defs(main_lib_block)
    missing_defs = {k: v for k, v in snip_lib_defs.items() if k not in main_lib_defs}

    collisions = (main_uuids & snip_uuids)
    if collisions:
        print(f"ERROR: {len(collisions)} UUID collisions between main and snippet:")
        for u in list(collisions)[:5]:
            print(f"  {u}")
        if len(collisions) > 5:
            print(f"  … and {len(collisions) - 5} more")
        print()
        print("This usually means you've already merged once and the snippet")
        print("has the same deterministic UUIDs. Regenerate the snippet with")
        print("a different PFX value, or just open the snippet in KiCad and")
        print("copy-paste manually (KiCad regenerates UUIDs on paste).")
        return 1

    # ── Build the new main schematic ────────────────────────────────
    # 1. Insert missing lib symbols into main's lib_symbols block
    if missing_defs:
        # Insert just before the closing ')' of (lib_symbols)
        new_lib_block = main_lib_block.rstrip()
        if new_lib_block.endswith(')'):
            insert_at = len(new_lib_block) - 1
        else:
            print("ERROR: malformed (lib_symbols) block")
            return 1
        added_lines = "\n" + "\n".join(missing_defs.values()) + "\n"
        new_lib_block = new_lib_block[:insert_at] + added_lines + new_lib_block[insert_at:]
    else:
        new_lib_block = main_lib_block

    # 2. Splice: header + new_lib_block + middle (between lib_symbols and
    #    sheet_instances) + snippet_content + (sheet_instances) + footer
    header = main_text[:main_lib_start]
    middle = main_text[main_lib_end:main_si_start]
    footer = main_text[main_si_start:]

    new_main = header + new_lib_block + middle + snippet_content + footer

    # ── Validate ────────────────────────────────────────────────────
    depth = 0
    bad = 0
    for c in new_main:
        if c == '(':
            depth += 1
        elif c == ')':
            depth -= 1
            if depth < 0:
                bad += 1
    if depth != 0 or bad > 0:
        print(f"ERROR: post-merge paren balance bad (depth={depth}, neg_crossings={bad})")
        print("Aborting without writing.")
        return 1

    # ── Backup and write ────────────────────────────────────────────
    shutil.copy2(MAIN_SCH, BACKUP)
    MAIN_SCH.write_text(new_main)

    # ── Summary ─────────────────────────────────────────────────────
    print(f"✓ Merged test/mech snippet into {MAIN_SCH.name}")
    print(f"  Backup: {BACKUP.name}")
    print(f"  Schematic size: {len(main_text):,} → {len(new_main):,} bytes")
    if missing_defs:
        print(f"  Added {len(missing_defs)} lib symbol(s):")
        for name in missing_defs:
            print(f"    + {name}")
    print(f"  Inserted {len(snip_uuids)} new UUIDs (test points + power ports + labels + wires)")
    print()
    print("Next steps:")
    print("  1. Open openchess-controller.kicad_sch in KiCad")
    print("  2. Verify the test points appear in the TEST + MECH box area")
    print("  3. Run Tools → Annotate Schematic to clean up refdes if needed")
    print("  4. Run ERC")
    print()
    print("If the merge looks wrong, recover with:")
    print(f"    cp {BACKUP.name} {MAIN_SCH.name}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
