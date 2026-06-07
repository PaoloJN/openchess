"""
lib_layout — shared utilities for the openchess PCB layout scripts.

Imported by scripts/01_*.py through 07_*.py. Not runnable on its own.

Conventions
-----------
- Coordinates are KiCad PCB world coords in mm; Y-axis is +down (screen
  coordinates), origin at (0, 0). The chessboard origin sits at (50, 50).
- Component lookup is by **reference designator** (U1, D42, C9). UUIDs
  are not stable across schematic regenerations; references are.
- Script-owned artifacts (board outline, silkscreen, pours) carry a
  UUID prefix marker so the owning script can idempotently undo and
  re-place them.
- All write operations are wrapped in: backup → write → paren-balance
  check → restore-on-failure.
"""
from __future__ import annotations

import os
import shutil
import uuid
from pathlib import Path

# ----------------------------------------------------------------------
# UUID prefix registry — every script picks a prefix for items it OWNS
# ----------------------------------------------------------------------

# Existing conventions (inherited from grid_placement.py, kept stable):
MARKER_OUTLINE = "10000000"          # board outline (script 01)
MARKER_LABEL = "20000000"            # silkscreen text labels (script 01)
MARKER_GRID = "30000000"             # silkscreen lines / chess grid (01)
MARKER_MOUNTING_HOLE = "40000000"    # mounting hole markers (script 01)
MARKER_GND_POUR = "50000000"         # B.Cu GND pour (script 07)
MARKER_ZONE_SILK = "60000000"        # zone-boundary silkscreen (any)


# ----------------------------------------------------------------------
# Paths
# ----------------------------------------------------------------------

HARDWARE_DIR = Path(__file__).resolve().parent.parent
PCB_PATH = HARDWARE_DIR / "openchess-board-3x3.kicad_pcb"
SCH_PATH = HARDWARE_DIR / "openchess-board-3x3.kicad_sch"


# ----------------------------------------------------------------------
# Low-level S-expression scanning
# ----------------------------------------------------------------------

def find_balanced(s: str, start: int) -> int:
    """Return index of matching ')' for '(' at s[start]. Raises if unbalanced."""
    depth = 0
    in_string = False
    escape = False
    for i in range(start, len(s)):
        c = s[i]
        if escape:
            escape = False
            continue
        if c == "\\":
            escape = True
            continue
        if c == '"':
            in_string = not in_string
            continue
        if in_string:
            continue
        if c == "(":
            depth += 1
        elif c == ")":
            depth -= 1
            if depth == 0:
                return i
    raise ValueError(f"unbalanced parens starting at {start}")


def paren_balance(text: str) -> int:
    """Return delta = open - close, ignoring strings. 0 means balanced."""
    depth = 0
    in_string = False
    escape = False
    for c in text:
        if escape:
            escape = False
            continue
        if c == "\\":
            escape = True
            continue
        if c == '"':
            in_string = not in_string
            continue
        if in_string:
            continue
        if c == "(":
            depth += 1
        elif c == ")":
            depth -= 1
    return depth


# ----------------------------------------------------------------------
# Footprint enumeration
# ----------------------------------------------------------------------

def find_footprint_blocks(text: str) -> list[tuple[int, int, str]]:
    """Yield (start, end, ref) for each (footprint ...) block in `text`.

    `start` and `end` are byte offsets; `text[start:end+1]` is the full
    block including its closing paren. `ref` is the value of the
    "Reference" property inside the block (e.g. "U1", "C9", "D42").
    Footprints with no Reference property are skipped.
    """
    import re
    out = []
    i = 0
    needle = "(footprint "
    while True:
        idx = text.find(needle, i)
        if idx == -1:
            return out
        end = find_balanced(text, idx)
        block = text[idx : end + 1]
        ref_m = re.search(r'\(property "Reference" "([^"]+)"', block)
        if ref_m:
            out.append((idx, end, ref_m.group(1)))
        i = end + 1


def find_blocks_with_marker(text: str, keyword: str, marker_prefix: str) -> list[tuple[int, int]]:
    """Return (start, end) byte ranges of S-expr blocks whose UUID starts with
    `marker_prefix-`. The block opens with `(<keyword> ...)` (e.g. "gr_text",
    "gr_line", "zone", "gr_rect"). Accepts either space or newline after the
    keyword (KiCad's pretty-printer uses newlines).
    """
    import re
    out = []
    needle = re.compile(r"\(" + re.escape(keyword) + r"[\s\(]")
    i = 0
    while True:
        m = needle.search(text, i)
        if not m:
            return out
        idx = m.start()
        end = find_balanced(text, idx)
        block = text[idx : end + 1]
        if f'(uuid "{marker_prefix}-' in block:
            out.append((idx, end))
        i = end + 1


def iter_refs(text: str, prefix: str = "") -> list[tuple[str, float, float, str]]:
    """Enumerate placed footprints whose ref starts with `prefix`.

    Returns list of (ref, x, y, layer) using each footprint's current
    `(at X Y [rot])` and `(layer "F.Cu"|"B.Cu")`. Useful for
    "find every D-prefix footprint to mirror its position" style passes.
    """
    import re
    out = []
    for start, end, ref in find_footprint_blocks(text):
        if prefix and not ref.startswith(prefix):
            continue
        block = text[start : end + 1]
        at_m = re.search(r"\(at ([\-\d.]+) ([\-\d.]+)(?:\s+([\-\d.]+))?\)", block)
        layer_m = re.search(r'\(layer "([^"]+)"\)', block)
        if at_m and layer_m:
            x, y = float(at_m.group(1)), float(at_m.group(2))
            out.append((ref, x, y, layer_m.group(1)))
    return out


# ----------------------------------------------------------------------
# Footprint placement / mutation
# ----------------------------------------------------------------------

def _format_at(x: float, y: float, rot: float | None) -> str:
    if rot is None:
        return f"(at {x:.4g} {y:.4g})"
    return f"(at {x:.4g} {y:.4g} {rot:.4g})"


def place_footprint(text: str, ref: str, x: float, y: float, rot: float = 0.0,
                    layer: str = "F.Cu") -> tuple[str, bool]:
    """Move footprint `ref` to (x, y, rot) on `layer`.

    Updates ONLY the top-level `(at ...)` and `(layer ...)` of the footprint
    block — KiCad mirrors pads automatically when layer is B.Cu. The
    footprint's child properties (Reference, Value, etc.) keep their own
    (at ...) sub-positions relative to the footprint anchor.

    Returns (new_text, found). `found` is False if the ref doesn't exist
    (script silently skips, supporting schematic-deletion changes).
    """
    import re
    for start, end, this_ref in find_footprint_blocks(text):
        if this_ref != ref:
            continue
        block = text[start : end + 1]

        # Replace top-level (at X Y [rot]) — the FIRST occurrence after
        # the (footprint header.
        at_m = re.search(r"\(at ([\-\d.]+) ([\-\d.]+)(?:\s+([\-\d.]+))?\)", block)
        if not at_m:
            return text, True  # weird; leave alone
        new_at = _format_at(x, y, rot)
        block = block[: at_m.start()] + new_at + block[at_m.end():]

        # Replace top-level (layer "...")
        layer_m = re.search(r'\(layer "[^"]+"\)', block)
        if layer_m:
            block = block[: layer_m.start()] + f'(layer "{layer}")' + block[layer_m.end():]

        return text[:start] + block + text[end + 1 :], True
    return text, False


# ----------------------------------------------------------------------
# UUID generation
# ----------------------------------------------------------------------

def make_uuid(marker_prefix: str) -> str:
    """Make a fresh UUID whose first segment is `marker_prefix`.

    Lets scripts identify their own artifacts later via find_blocks_with_marker.
    """
    rest = str(uuid.uuid4()).split("-", 1)[1]
    return f"{marker_prefix}-{rest}"


# ----------------------------------------------------------------------
# Safe file I/O
# ----------------------------------------------------------------------

def read_pcb(path: Path = PCB_PATH) -> str:
    return path.read_text()


def write_pcb(path: Path, new_text: str, backup_suffix: str) -> None:
    """Write `new_text` to `path` after backing up.

    Validates paren balance before committing — if non-zero, restores the
    backup and raises.
    """
    if paren_balance(new_text) != 0:
        raise ValueError(
            f"refusing to write {path.name}: paren imbalance "
            f"{paren_balance(new_text)} (open - close)"
        )
    backup = path.with_suffix(path.suffix + backup_suffix)
    shutil.copy2(path, backup)
    path.write_text(new_text)


# ----------------------------------------------------------------------
# Removal of script-owned items (idempotency)
# ----------------------------------------------------------------------

def remove_owned_items(text: str, keywords: list[str], marker_prefix: str) -> tuple[str, int]:
    """Remove every (keyword ...) block whose UUID starts with marker_prefix-.

    `keywords` is the list of block kinds to scan (e.g.
    ["gr_rect", "gr_text", "gr_line", "gr_circle", "zone"]).

    Returns (new_text, count_removed). Removes blocks in reverse order
    so byte offsets stay valid during deletion.
    """
    ranges = []
    for kw in keywords:
        ranges.extend(find_blocks_with_marker(text, kw, marker_prefix))
    ranges.sort(key=lambda r: r[0], reverse=True)
    for start, end in ranges:
        # also eat the trailing newline if there is one
        kill_end = end + 1
        if kill_end < len(text) and text[kill_end] == "\n":
            kill_end += 1
        text = text[:start] + text[kill_end:]
    return text, len(ranges)


# ----------------------------------------------------------------------
# Convenience helpers for child scripts
# ----------------------------------------------------------------------

def back_layer_for(front_layer: str) -> str:
    """F.Cu <-> B.Cu, F.SilkS <-> B.SilkS, etc."""
    if front_layer.startswith("F."):
        return "B." + front_layer[2:]
    if front_layer.startswith("B."):
        return "F." + front_layer[2:]
    return front_layer


def chess_origin() -> tuple[float, float]:
    """Top-left of the LED grid on F.Cu (= board origin + margin)."""
    return (62.0, 62.0)


def board_size() -> tuple[float, float]:
    """(width, height) of the board outline."""
    return (280.0, 280.0)


def board_origin() -> tuple[float, float]:
    """(x, y) of the top-left of the board outline."""
    return (50.0, 50.0)
