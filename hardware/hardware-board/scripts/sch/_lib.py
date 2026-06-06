"""_lib.py — shared utilities for the matrix-board schematic pipeline.

The pipeline writes openchess-board.kicad_sch as concatenated chunks.
Each step script (01_skeleton.py, 02_halls.py, ...) writes ONE chunk
to build/sch/<name>.sexp and then triggers 99_assemble.py to rebuild
the final file. Re-running step N regenerates only its chunk.

Conventions
-----------
- Grid: G = 2.54 mm. Every pin / wire / label endpoint MUST land on G.
- KiCad world coordinates: Y is DOWN-POSITIVE (page top at y=0).
- KiCad symbol-local coordinates: Y is UP-POSITIVE (math convention).
  When a symbol is instantiated at world (wx, wy) with rotation R,
  a pin at sym (px, py) lands at world `pin_world(wx, wy, px, py, R)`.
- Component refs are firmware contract — see hardware-board/scripts/README.md.

UUIDs
-----
Each step uses a unique 4-hex-char prefix (PFX_*). Within a step, the
integer is a free counter; the helper `uid(prefix, n)` produces a stable
v4-shaped UUID. Cross-step references are by NET LABEL (e.g. "+5V"), not
by UUID, so chunks don't couple to each other's internal numbering.
"""
from __future__ import annotations
import os
import shutil
import subprocess
import sys
from pathlib import Path

# ────────────────────────────────────────────────────────────────────────
# Paths
# ────────────────────────────────────────────────────────────────────────
HERE = Path(__file__).resolve().parent              # scripts/sch/
SCRIPTS_DIR = HERE.parent                            # scripts/
BOARD_DIR = SCRIPTS_DIR.parent                       # hardware-board/
REPO_ROOT = BOARD_DIR.parent.parent                  # openchess/
BUILD_DIR = BOARD_DIR / "build" / "sch"
LIB_CACHE_DIR = HERE / "lib_symbols"                 # cached symbol fragments (committed)
OUT_PATH = BOARD_DIR / "openchess-board.kicad_sch"
ASSEMBLE_SCRIPT = HERE / "99_assemble.py"

# KiCad bundled symbol library search paths — tried in order until a
# matching `<lib_name>.kicad_sym` is found. Used only on the first run
# when the local cache (LIB_CACHE_DIR) is empty.
KICAD_SYMBOL_SEARCH_PATHS = [
    os.environ.get("KICAD10_SYMBOL_DIR"),
    os.environ.get("KICAD9_SYMBOL_DIR"),
    os.environ.get("KICAD_SYMBOL_DIR"),
    "/Applications/KiCad/KiCad.app/Contents/SharedSupport/symbols",
    "/usr/share/kicad/symbols",
    "/usr/local/share/kicad/symbols",
]


# ────────────────────────────────────────────────────────────────────────
# Grid
# ────────────────────────────────────────────────────────────────────────
G = 2.54

def g(n: float) -> float:
    """Grid units → mm. g(1) == 2.54 mm."""
    return n * G


# ────────────────────────────────────────────────────────────────────────
# Number formatters — match KiCad's stringification so re-runs produce
# byte-identical output when nothing changed.
# ────────────────────────────────────────────────────────────────────────
def n_size(x: float) -> str:
    """Font size — KiCad keeps '4.0' for whole numbers."""
    if isinstance(x, int) or x == int(x):
        return f"{x:.1f}"
    s = f"{x:.6f}".rstrip("0")
    return s + "0" if s.endswith(".") else s


def nc(x: float) -> str:
    """Coordinate — KiCad strips trailing '.0' from whole numbers."""
    if isinstance(x, int) or x == int(x):
        return str(int(x))
    s = f"{x:.6f}".rstrip("0")
    return s.rstrip(".")


# ────────────────────────────────────────────────────────────────────────
# Symbol-to-world coordinate transform.
#
# KiCad library symbols define pins in a Y-UP coordinate system. KiCad's
# schematic world is Y-DOWN. On instantiation the Y-axis is inverted.
#
# Rotation is applied to the symbol-local point first (CCW), then the
# instantiation offset + Y-inversion gives the world coordinate.
# ────────────────────────────────────────────────────────────────────────
def pin_world(wx: float, wy: float,
              px: float, py: float, rot: int) -> tuple[float, float]:
    """World (x, y) of a pin at symbol-local (px, py) for a symbol
    placed at world (wx, wy) with rotation `rot` (deg, CCW)."""
    if rot == 0:
        rx, ry = px, py
    elif rot == 90:
        rx, ry = -py, px
    elif rot == 180:
        rx, ry = -px, -py
    elif rot == 270:
        rx, ry = py, -px
    else:
        raise ValueError(f"unsupported rotation: {rot}")
    return (wx + rx, wy - ry)


# ────────────────────────────────────────────────────────────────────────
# UUID prefixes — one per logical group. Distinct prefixes guarantee
# no cross-step UUID collisions even if integer ranges overlap.
# ────────────────────────────────────────────────────────────────────────
PFX_SKEL     = "5ce1"   # skeleton-owned (rare; lib_symbols block etc.)
PFX_DECOR    = "deca"   # boxes, heading, separator (chunk 01)
PFX_HALL     = "ba11"   # 64 halls + stubs + labels (chunk 02)
PFX_LED      = "1ed0"   # 81 LEDs (chunk 03)
PFX_LED_CAP  = "1ed5"   # 81 100 nF caps (chunk 03)
PFX_PULLUP   = "9011"   # reserved: row pullups now live on controller PCB
PFX_BULK_CAP = "bc00"   # 9 C1..C9 + stubs + labels (chunk 04)
PFX_JCTRL    = "1c70"   # J1 + pin stubs (chunk 05)
PFX_LABEL    = "1ab1"   # J1 pin labels (chunk 05)
PFX_LED_DECOUP = "1ec0" # +5V_LED rail entry bulk cap (chunk 06)
PFX_TEST_MECH  = "7e57" # test points + mounting holes + fiducials (chunk 07)


def uid(prefix: str, n: int) -> str:
    """Deterministic v4-shaped UUID — stable across runs.
    Same (prefix, n) always returns the same string."""
    return f"{prefix}{n:04x}-0000-4000-8000-{n:012x}"


# ────────────────────────────────────────────────────────────────────────
# Pin-coordinate table — values VERIFIED against KiCad 9 bundled libs
# at /Applications/KiCad/KiCad.app/Contents/SharedSupport/symbols/.
# Symbol-local coordinates (Y-UP); call pin_world() to get world coords.
# ────────────────────────────────────────────────────────────────────────
PIN_COORDS: dict[str, dict[str, tuple[float, float]]] = {
    "openchess:A3144": {
        "1": (-5.08, +2.54),   # VCC (passive)
        "2": (-5.08,  0.0),    # GND (passive)
        "3": (-5.08, -2.54),   # OUT (open_collector)
    },
    "Device:R": {              # unrotated
        "1": (0.0, +3.81),
        "2": (0.0, -3.81),
    },
    "Device:C": {
        "1": (0.0, +3.81),
        "2": (0.0, -3.81),
    },
    "Device:C_Polarized": {       # polarized — pin 1 is the (+) terminal
        "1": (0.0, +3.81),
        "2": (0.0, -3.81),
    },
    "LED:WS2812B": {
        "1": (0.0, +7.62),     # VDD
        "2": (+7.62, 0.0),     # DOUT
        "3": (0.0, -7.62),     # VSS
        "4": (-7.62, 0.0),     # DIN
    },
    "Connector_Generic:Conn_02x13_Odd_Even": {
        # Odd pins (left col) at sym x=-5.08, even (right col) at +7.62.
        # Pin 1 at sym y=+15.24, paired pins drop 2.54 per pair.
        **{str(p): (-5.08 if p % 2 == 1 else +7.62,
                    15.24 - ((p - 1) // 2) * 2.54) for p in range(1, 27)},
    },
    "power:PWR_FLAG": {
        "1": (0.0, 0.0),
    },
    "power:GND": {
        "1": (0.0, 0.0),       # pin at origin; triangle body extends in sym +y
    },
    "Connector:TestPoint": {
        "1": (0.0, 0.0),       # pin endpoint at origin; body extends upward
    },
    # Mechanical:MountingHole and Mechanical:Fiducial have no electrical
    # pins — they're documentation / BOM / PCB anchor symbols. Listed here
    # for completeness but no pin entries needed.
}


# ────────────────────────────────────────────────────────────────────────
# S-expression emitters — append KiCad text fragments to a list `o`.
# Top-level elements live inside the (kicad_sch ...) form, so every line
# is indented one tab.
# ────────────────────────────────────────────────────────────────────────
def emit_rectangle(o: list[str], x1, y1, x2, y2, u, stroke=0.2) -> None:
    o.append("\t(rectangle")
    o.append(f"\t\t(start {nc(x1)} {nc(y1)}) (end {nc(x2)} {nc(y2)})")
    o.append(f"\t\t(stroke (width {nc(stroke)}) (type default))")
    o.append("\t\t(fill (type none))")
    o.append(f'\t\t(uuid "{u}")')
    o.append("\t)")


def emit_text(o: list[str], s, x, y, size, justify, u,
              bold=False, italic=False) -> None:
    font = f"(font (size {n_size(size)} {n_size(size)})"
    if bold:
        font += " (bold yes)"
    if italic:
        font += " (italic yes)"
    font += ")"
    o.append(f'\t(text "{s}"')
    o.append("\t\t(exclude_from_sim no)")
    o.append(f"\t\t(at {nc(x)} {nc(y)} 0)")
    o.append(f"\t\t(effects {font} (justify {justify}))")
    o.append(f'\t\t(uuid "{u}")')
    o.append("\t)")


def emit_polyline(o: list[str], x1, y1, x2, y2, u, stroke=0.2) -> None:
    o.append("\t(polyline")
    o.append(f"\t\t(pts (xy {nc(x1)} {nc(y1)}) (xy {nc(x2)} {nc(y2)}))")
    o.append(f"\t\t(stroke (width {nc(stroke)}) (type default))")
    o.append(f'\t\t(uuid "{u}")')
    o.append("\t)")


def emit_label(o: list[str], label, x, y, angle, u,
               size=1.27, justify="left bottom") -> None:
    o.append(f'\t(label "{label}"')
    o.append(f"\t\t(at {nc(x)} {nc(y)} {angle})")
    o.append(f"\t\t(effects (font (size {n_size(size)} {n_size(size)})) (justify {justify}))")
    o.append(f'\t\t(uuid "{u}")')
    o.append("\t)")


def emit_wire(o: list[str], x1, y1, x2, y2, u) -> None:
    o.append("\t(wire")
    o.append(f"\t\t(pts (xy {nc(x1)} {nc(y1)}) (xy {nc(x2)} {nc(y2)}))")
    o.append("\t\t(stroke (width 0) (type default))")
    o.append(f'\t\t(uuid "{u}")')
    o.append("\t)")


def emit_junction(o: list[str], x, y, u, diameter=0) -> None:
    o.append("\t(junction")
    o.append(f"\t\t(at {nc(x)} {nc(y)})")
    o.append(f"\t\t(diameter {nc(diameter)})")
    o.append("\t\t(color 0 0 0 0)")
    o.append(f'\t\t(uuid "{u}")')
    o.append("\t)")


def emit_no_connect(o: list[str], x, y, u) -> None:
    """Emit a (no_connect ...) flag at world (x, y). Use on pin endpoints
    that are intentionally unconnected so ERC accepts them."""
    o.append("\t(no_connect")
    o.append(f"\t\t(at {nc(x)} {nc(y)})")
    o.append(f'\t\t(uuid "{u}")')
    o.append("\t)")


def emit_symbol(o: list[str], lib_id: str,
                x: float, y: float, rot: int,
                ref: str, value: str, footprint: str,
                sym_uuid: str, pin_uuids: dict[str, str],
                properties: dict[str, str] | None = None,
                ref_offset: tuple[float, float] = (2.54, -2.54),
                value_offset: tuple[float, float] = (2.54, 2.54),
                in_bom: bool = True,
                on_board: bool = True,
                dnp: bool = False,
                hide_ref: bool = False,
                hide_value: bool = False) -> None:
    """Emit a top-level component instance. ref_offset / value_offset
    are in WORLD coordinates added to (x, y) — they are NOT subject to
    the symbol-Y inversion (text is positioned in world space directly).

    hide_ref / hide_value add `(hide yes)` to the property's effects so
    KiCad keeps the property data (for ERC / annotation) but doesn't
    render the text in the schematic. Useful for power symbols where
    the symbol body already says it all."""
    properties = properties or {}
    ref_effects  = "(effects (font (size 1.27 1.27)) (justify left)" + (" (hide yes)" if hide_ref   else "") + ")"
    val_effects  = "(effects (font (size 1.27 1.27)) (justify left)" + (" (hide yes)" if hide_value else "") + ")"
    o.append("\t(symbol")
    o.append(f'\t\t(lib_id "{lib_id}")')
    o.append(f"\t\t(at {nc(x)} {nc(y)} {nc(rot)})")
    o.append("\t\t(unit 1)")
    o.append("\t\t(exclude_from_sim no)")
    o.append(f"\t\t(in_bom {'yes' if in_bom else 'no'})")
    o.append(f"\t\t(on_board {'yes' if on_board else 'no'})")
    o.append(f"\t\t(dnp {'yes' if dnp else 'no'})")
    o.append(f'\t\t(uuid "{sym_uuid}")')
    o.append(f'\t\t(property "Reference" "{ref}"')
    o.append(f"\t\t\t(at {nc(x + ref_offset[0])} {nc(y + ref_offset[1])} 0)")
    o.append(f"\t\t\t{ref_effects}")
    o.append("\t\t)")
    o.append(f'\t\t(property "Value" "{value}"')
    o.append(f"\t\t\t(at {nc(x + value_offset[0])} {nc(y + value_offset[1])} 0)")
    o.append(f"\t\t\t{val_effects}")
    o.append("\t\t)")
    o.append(f'\t\t(property "Footprint" "{footprint}"')
    o.append(f"\t\t\t(at {nc(x)} {nc(y)} 0)")
    o.append("\t\t\t(effects (font (size 1.27 1.27)) (hide yes))")
    o.append("\t\t)")
    for k, v in properties.items():
        o.append(f'\t\t(property "{k}" "{v}"')
        o.append(f"\t\t\t(at {nc(x)} {nc(y)} 0)")
        o.append("\t\t\t(effects (font (size 1.27 1.27)) (hide yes))")
        o.append("\t\t)")
    for pin_num, pin_uuid in pin_uuids.items():
        o.append(f'\t\t(pin "{pin_num}"')
        o.append(f'\t\t\t(uuid "{pin_uuid}")')
        o.append("\t\t)")
    o.append("\t\t(instances")
    o.append('\t\t\t(project "openchess-board"')
    o.append(f'\t\t\t\t(path "/" (reference "{ref}") (unit 1))')
    o.append("\t\t\t)")
    o.append("\t\t)")
    o.append("\t)")


# ────────────────────────────────────────────────────────────────────────
# Load a stock KiCad symbol definition for embedding in lib_symbols.
#
# The schematic is self-contained — every symbol it references must be
# defined inside its (lib_symbols ...) block. We read the canonical
# definition from a KiCad bundled .kicad_sym file once and cache the
# resulting s-expression block under scripts/sch/lib_symbols/ in the
# repo, so future runs don't need a local KiCad install.
# ────────────────────────────────────────────────────────────────────────
def _find_kicad_lib(lib_name: str) -> Path:
    """Find <lib_name>.kicad_sym in one of the configured KiCad lib dirs."""
    for raw in KICAD_SYMBOL_SEARCH_PATHS:
        if not raw:
            continue
        candidate = Path(raw) / f"{lib_name}.kicad_sym"
        if candidate.exists():
            return candidate
    raise FileNotFoundError(
        f"Could not locate '{lib_name}.kicad_sym' in any of: "
        f"{[p for p in KICAD_SYMBOL_SEARCH_PATHS if p]}. "
        f"Either install KiCad, set KICAD10_SYMBOL_DIR, "
        f"or commit a cached fragment to {LIB_CACHE_DIR}."
    )


def _extract_symbol_block(lib_text: str, sym_name: str) -> str:
    """Return the `(symbol "<sym_name>" ... )` block from a .kicad_sym file's
    text, preserving original indentation. Walks parens to find the close."""
    needle = f'(symbol "{sym_name}"'
    i = lib_text.find(needle)
    if i == -1:
        raise ValueError(f"symbol '{sym_name}' not found in lib")
    # back up to the start of the line so leading tabs are preserved
    line_start = lib_text.rfind("\n", 0, i) + 1
    depth = 0
    j = i
    while j < len(lib_text):
        c = lib_text[j]
        if c == "(":
            depth += 1
        elif c == ")":
            depth -= 1
            if depth == 0:
                j += 1
                break
        j += 1
    return lib_text[line_start:j]


def load_symbol_def(lib_id: str) -> str:
    """Return the symbol s-expression block for `lib_id` ("Library:Symbol"),
    re-indented one tab deeper so it slots into a (lib_symbols ...) block.

    The PARENT symbol name is rewritten from the bare name used inside the
    source lib file (e.g. `(symbol "C"`) to the full lib_id KiCad expects
    inside a project's lib_symbols block (e.g. `(symbol "Device:C"`).
    Sub-symbols (the `Name_0_1`, `Name_1_1` units) keep their bare names —
    those are internal references within the parent.

    Caches the rewritten result under scripts/sch/lib_symbols/<lib>_<sym>.sexp_fragment
    on first read. The cache files are committed to the repo so subsequent
    runs don't need a local KiCad install."""
    lib_name, sym_name = lib_id.split(":", 1)
    safe_sym = sym_name.replace("/", "_")
    cache_path = LIB_CACHE_DIR / f"{lib_name}_{safe_sym}.sexp_fragment"

    if cache_path.exists():
        return cache_path.read_text()

    src = _find_kicad_lib(lib_name)
    block = _extract_symbol_block(src.read_text(), sym_name)

    # Rewrite the parent name to the full lib_id. The bare name appears
    # exactly once at the start of the block: `(symbol "<sym_name>"`.
    bare_head = f'(symbol "{sym_name}"'
    full_head = f'(symbol "{lib_id}"'
    if bare_head not in block:
        raise ValueError(f"could not find parent symbol header in extracted block for {lib_id}")
    block = block.replace(bare_head, full_head, 1)

    # Re-indent: each line in the lib file is at level 1 (one tab) inside
    # the outer (kicad_symbol_lib …). Inside our (lib_symbols …) we need
    # level 2 — prepend one more tab.
    re_indented = "\n".join(
        ("\t" + line) if line else line for line in block.splitlines()
    )

    LIB_CACHE_DIR.mkdir(parents=True, exist_ok=True)
    cache_path.write_text(re_indented)
    print(f"  cached → {cache_path.relative_to(REPO_ROOT)}")
    return re_indented


# ────────────────────────────────────────────────────────────────────────
# Chunk write + assembler trigger.
# ────────────────────────────────────────────────────────────────────────
def write_chunk(name: str, lines: list[str]) -> Path:
    """Write `lines` to build/sch/<name>.sexp.
    Backs up any existing chunk to <name>.sexp.backup_before_step."""
    BUILD_DIR.mkdir(parents=True, exist_ok=True)
    path = BUILD_DIR / f"{name}.sexp"
    if path.exists():
        backup = path.with_suffix(path.suffix + ".backup_before_step")
        shutil.copy2(path, backup)
    text = "\n".join(lines).rstrip() + "\n"
    path.write_text(text)
    print(f"  chunk  → {path.relative_to(REPO_ROOT)}  ({len(lines)} lines)")
    return path


def assemble() -> None:
    """Run 99_assemble.py to concatenate chunks into the final .kicad_sch.
    Errors loudly if the assembler returns non-zero."""
    r = subprocess.run([sys.executable, str(ASSEMBLE_SCRIPT)])
    if r.returncode != 0:
        sys.exit(f"assemble failed with exit code {r.returncode}")
