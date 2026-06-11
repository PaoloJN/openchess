#!/usr/bin/env python3
"""99_assemble.py — merge halls and LEDs chunks INTO the existing .kicad_sch.

This is a **merger**, not a replacer. It only touches the components owned
by the chunk scripts (halls and LEDs/LED-decoupling-caps). Everything else
in the schematic — page setup, lib_symbols, J_CTRL, mounting holes, fiducials,
test points, row bulks, decorative boxes, manual wires/labels — is left
EXACTLY as the user has it.

How merging works
-----------------
Each chunk script emits items with deterministic UUIDs starting with a known
prefix. On each run:

1. Read the existing .kicad_sch
2. For every script-managed prefix, DELETE the matching top-level blocks
   (those are old hall/LED instances that the chunk is regenerating)
3. INSERT the fresh chunk contents just before the (sheet_instances ...) footer
4. Save

User-added components (random UUIDs that don't match any script prefix) are
never touched. Manual KiCad work is safe.

Run with KiCad CLOSED.
"""
from __future__ import annotations
import re
import shutil
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from _lib import BUILD_DIR, OUT_PATH, REPO_ROOT

# Mapping: chunk filename → UUID prefixes that chunk owns.
# When a chunk is present in build/sch/, the merger deletes existing items
# with these prefixes and inserts the chunk content fresh.
CHUNK_OWNED_PREFIXES = {
    "02_halls": ("ba11",),                  # hall sensors + their stubs/labels
    "03_leds":  ("1ed0", "1ed5"),           # WS2812 LEDs + 100 nF decoupling caps
    "07_mech":  ("7e57",),                  # M3 mounting holes + fiducials
}

# Top-level S-expression keywords the merger inspects for UUID prefixes.
TOPLEVEL_KEYWORDS = (
    "symbol", "junction", "wire", "label", "global_label",
    "hierarchical_label", "no_connect", "bus", "bus_entry",
    "text", "rectangle", "polyline", "image", "sheet", "netclass_flag",
)


def _find_balanced(text: str, open_idx: int) -> int:
    """Return index of matching ')' for '(' at open_idx, handling strings."""
    depth = 0
    in_str = False
    escape = False
    for i in range(open_idx, len(text)):
        c = text[i]
        if escape:
            escape = False
            continue
        if c == "\\":
            escape = True
            continue
        if c == '"':
            in_str = not in_str
            continue
        if in_str:
            continue
        if c == "(":
            depth += 1
        elif c == ")":
            depth -= 1
            if depth == 0:
                return i
    raise ValueError(f"unbalanced parens starting at {open_idx}")


def remove_items_with_prefixes(text: str, prefixes: tuple[str, ...]) -> tuple[str, int]:
    """Remove every top-level block whose UUID starts with any given prefix.
    Returns (new_text, count_removed)."""
    ranges_to_kill: list[tuple[int, int]] = []
    prefixes_lower = tuple(p.lower() for p in prefixes)

    for keyword in TOPLEVEL_KEYWORDS:
        pattern = re.compile(r"\n\t\(" + re.escape(keyword) + r"[\s\(]")
        for match in pattern.finditer(text):
            open_idx = match.start() + 1
            try:
                close_idx = _find_balanced(text, open_idx)
            except ValueError:
                continue
            block = text[open_idx : close_idx + 1]
            uuid_m = re.search(r'\(uuid\s+"([0-9a-fA-F-]+)"', block)
            if uuid_m and uuid_m.group(1)[:4].lower() in prefixes_lower:
                ranges_to_kill.append((open_idx - 1, close_idx + 1))  # include leading \n

    # Delete in reverse order so byte offsets stay valid
    ranges_to_kill.sort(key=lambda r: r[0], reverse=True)
    for start, end in ranges_to_kill:
        text = text[:start] + text[end:]
    return text, len(ranges_to_kill)


def insert_chunk(text: str, chunk_content: str) -> str:
    """Insert chunk content just before the (sheet_instances ...) block.
    If no (sheet_instances ...) is found, append before the final closing paren."""
    idx = text.rfind("\n\t(sheet_instances")
    if idx == -1:
        # Fall back: insert before the LAST top-level closing paren
        idx = text.rfind("\n)")
        if idx == -1:
            raise ValueError("can't find insertion point — schematic malformed?")
    return text[:idx] + "\n" + chunk_content.rstrip() + "\n" + text[idx:]


def main() -> int:
    if not OUT_PATH.exists():
        sys.exit(
            f"ERROR: {OUT_PATH} doesn't exist. Create the schematic first in KiCad\n"
            "(File → New Schematic) and save it, then re-run."
        )

    text = OUT_PATH.read_text()

    # Backup before any change
    backup = OUT_PATH.with_suffix(OUT_PATH.suffix + ".backup_before_assemble")
    shutil.copy2(OUT_PATH, backup)

    total_removed = 0
    chunks_merged = []

    for chunk_name, prefixes in CHUNK_OWNED_PREFIXES.items():
        chunk_path = BUILD_DIR / f"{chunk_name}.sexp"
        if not chunk_path.exists():
            # No chunk → don't touch this prefix group at all
            continue

        # Step 1: remove old script-owned items with these prefixes
        text, removed = remove_items_with_prefixes(text, prefixes)
        total_removed += removed

        # Step 2: insert fresh chunk content
        chunk_content = chunk_path.read_text()
        text = insert_chunk(text, chunk_content)
        chunks_merged.append(chunk_name)

    OUT_PATH.write_text(text)

    print(f"OK  merged {len(chunks_merged)} chunk(s) into {OUT_PATH.relative_to(REPO_ROOT)}")
    print(f"    removed {total_removed} stale script-owned item(s)")
    print(f"    inserted chunks: {', '.join(chunks_merged) or '(none)'}")
    print(f"    {len(text):,} chars / {len(text.encode()):,} bytes")
    print(f"    backup: {backup.name}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
