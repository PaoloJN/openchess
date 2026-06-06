#!/usr/bin/env python3
"""Generate a standalone KiCad schematic snippet for the controller's
TEST + MECHANICAL section.

Output: build/test_mech_snippet.kicad_sch

Usage:
    1. With KiCad CLOSED, run: python3 gen_test_mech.py
    2. Open the generated build/test_mech_snippet.kicad_sch in KiCad
       (File → Open or as a separate schematic window)
    3. Edit → Select All (Ctrl+A), Copy (Ctrl+C)
    4. Switch to your main openchess-controller.kicad_sch tab
    5. Click in an empty area in the TEST + MECHANICAL box
       (world coordinates 28..566, 305..400)
    6. Paste (Ctrl+V)
    7. KiCad will auto-annotate refdes if needed; verify they match
       the guide's TP1..TPn, MH1..MH4, FID1..FID3 scheme

What it generates:
- 13 test points on the most useful nets (rails, data lines, sense lines)
- 4 M3 mounting holes
- 3 fiducial marks

Placement: arranged in a 4-row grid that fits within the TEST + MECH box.

The script is self-contained — it does NOT touch the main controller
schematic. It only writes a snippet file you copy from.
"""
from __future__ import annotations
import os
from pathlib import Path

HERE = Path(__file__).resolve().parent
BOARD_DIR = HERE.parent.parent          # hardware-controller/
BUILD_DIR = BOARD_DIR / "build" / "snippets"
OUT_PATH = BUILD_DIR / "test_mech_snippet.kicad_sch"

# KiCad bundled symbol library search paths
KICAD_SYMBOL_SEARCH_PATHS = [
    os.environ.get("KICAD10_SYMBOL_DIR"),
    os.environ.get("KICAD9_SYMBOL_DIR"),
    os.environ.get("KICAD_SYMBOL_DIR"),
    "/Applications/KiCad/KiCad.app/Contents/SharedSupport/symbols",
    "/usr/share/kicad/symbols",
    "/usr/local/share/kicad/symbols",
]

G = 2.54

def g(n: float) -> float:
    return n * G

# ────────────────────────────────────────────────────────────────────────
# What to generate
# ────────────────────────────────────────────────────────────────────────
# Each test point: (ref, net_name, kind)
#   kind = "label"     → regular net label
#   kind = "gnd"       → GND power port
#   kind = "+3v3"      → +3V3 power port
TEST_POINTS = [
    # Power rails
    ("TP1",  "+5V_LED",      "label"),
    ("TP2",  "+3V3",         "+3v3"),
    ("TP3",  "GND",          "gnd"),
    # Data nets
    ("TP4",  "LED_DATA",     "label"),
    ("TP5",  "LED_DATA_5V",  "label"),
    # Battery monitor
    ("TP6",  "VBAT_MON",     "label"),
    # Row sense
    ("TP7",  "S0",           "label"),
    ("TP8",  "S1",           "label"),
    ("TP9",  "S2",           "label"),
    ("TP10", "S3",           "label"),
    ("TP11", "S4",           "label"),
    ("TP12", "S5",           "label"),
    ("TP13", "S6",           "label"),
    ("TP14", "S7",           "label"),
    # Column power (debug — column nets pre- and post-driver are at J1)
    ("TP15", "CA_PWR",       "label"),
    ("TP16", "CB_PWR",       "label"),
    ("TP17", "CC_PWR",       "label"),
    ("TP18", "CD_PWR",       "label"),
    ("TP19", "CE_PWR",       "label"),
    ("TP20", "CF_PWR",       "label"),
    ("TP21", "CG_PWR",       "label"),
    ("TP22", "CH_PWR",       "label"),
]

MOUNTING_HOLES = ["MH1", "MH2", "MH3", "MH4"]
FIDUCIALS = ["FID1", "FID2", "FID3"]

# ────────────────────────────────────────────────────────────────────────
# Placement (inside TEST + MECH box: world 28..566 mm × 305..400 mm)
#
# Layout: 3 rows of TPs grouped by category, then MH and FID below.
#   Row 1 — y=327: power rails + data + monitor (6 TPs, centered)
#   Row 2 — y=350: row sense S0..S7 (8 TPs, evenly spread)
#   Row 3 — y=373: column power CA..CH (8 TPs, evenly spread)
#   MH    — y=385: 4 mounting holes, evenly spread
#   FID   — y=393: 3 fiducials, evenly spread
#
# Box usable area (subtract 5mm padding from each side):
#   x ∈ [33, 561]  (528 mm wide)
#   y ∈ [320, 396] (76 mm tall — below box header text)
# ────────────────────────────────────────────────────────────────────────
BOX_X_LEFT = 33
BOX_X_RIGHT = 561

# Each row: (y_position, list of TP indices that go in this row)
TP_ROW_LAYOUT = [
    (327, list(range(0, 6))),    # TP1..TP6  (power+data+monitor)
    (350, list(range(6, 14))),   # TP7..TP14 (row sense S0..S7)
    (373, list(range(14, 22))),  # TP15..TP22 (column power CA..CH)
]

MH_Y = 385
FID_Y = 393


def evenly_spread(n: int, x_left: float, x_right: float) -> list[float]:
    """Return n x-positions evenly spread across [x_left, x_right] with
    margins so items don't sit on the box edges. Useful for headers/holes/marks."""
    if n == 1:
        return [(x_left + x_right) / 2]
    # Use (n+1) gaps to give margin on each end
    gap = (x_right - x_left) / (n + 1)
    return [x_left + (i + 1) * gap for i in range(n)]


def tp_position(idx: int) -> tuple[float, float]:
    """Find which row this TP is in and its x position based on
    even-spread within that row."""
    for y, indices in TP_ROW_LAYOUT:
        if idx in indices:
            local_pos = indices.index(idx)
            xs = evenly_spread(len(indices), BOX_X_LEFT, BOX_X_RIGHT)
            return (xs[local_pos], y)
    raise ValueError(f"TP index {idx} not in any row")


MH_X = evenly_spread(4, BOX_X_LEFT, BOX_X_RIGHT)
FID_X = evenly_spread(3, BOX_X_LEFT, BOX_X_RIGHT)


# ────────────────────────────────────────────────────────────────────────
# UUID generation
# ────────────────────────────────────────────────────────────────────────
PFX = "7e57"  # 'test' in leetspeak

def uid(n: int) -> str:
    return f"{PFX}{n:04x}-0000-4000-8000-{n:012x}"


# ────────────────────────────────────────────────────────────────────────
# Symbol library loader (caches stock KiCad symbols)
# ────────────────────────────────────────────────────────────────────────
LIB_CACHE_DIR = HERE / "lib_cache"

def _find_kicad_lib(lib_name: str) -> Path:
    for raw in KICAD_SYMBOL_SEARCH_PATHS:
        if not raw:
            continue
        candidate = Path(raw) / f"{lib_name}.kicad_sym"
        if candidate.exists():
            return candidate
    raise FileNotFoundError(
        f"Could not find {lib_name}.kicad_sym. "
        f"Tried: {[p for p in KICAD_SYMBOL_SEARCH_PATHS if p]}"
    )


def _extract_symbol_block(lib_text: str, sym_name: str) -> str:
    """Extract `(symbol "<sym_name>" ...)` block from a .kicad_sym file."""
    needle = f'(symbol "{sym_name}"'
    i = lib_text.find(needle)
    if i == -1:
        raise ValueError(f"Symbol '{sym_name}' not found in lib")
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


def load_symbol(lib_id: str) -> str:
    """Return a re-indented (symbol ...) block for embedding in lib_symbols.
    Caches under lib_cache/. Rewrites parent symbol name to full lib_id."""
    lib_name, sym_name = lib_id.split(":", 1)
    safe = sym_name.replace("/", "_")
    cache = LIB_CACHE_DIR / f"{lib_name}_{safe}.sexp"
    if cache.exists():
        return cache.read_text()

    src = _find_kicad_lib(lib_name)
    block = _extract_symbol_block(src.read_text(), sym_name)
    # Rewrite parent symbol name
    block = block.replace(f'(symbol "{sym_name}"', f'(symbol "{lib_id}"', 1)
    # Indent one tab deeper for inclusion in (lib_symbols ...)
    block = "\n".join(("\t" + line) if line else line for line in block.splitlines())
    LIB_CACHE_DIR.mkdir(parents=True, exist_ok=True)
    cache.write_text(block)
    return block


# ────────────────────────────────────────────────────────────────────────
# S-expression emitters
# ────────────────────────────────────────────────────────────────────────
def fmt_num(x: float) -> str:
    if isinstance(x, int) or x == int(x):
        return str(int(x))
    return f"{x:.6f}".rstrip("0").rstrip(".")


def emit_symbol(o: list[str], *, lib_id: str, x: float, y: float, rot: int,
                ref: str, value: str, footprint: str, sym_uuid: str,
                pin_uuids: dict[str, str],
                in_bom: bool = True, on_board: bool = True) -> None:
    o.append("\t(symbol")
    o.append(f'\t\t(lib_id "{lib_id}")')
    o.append(f"\t\t(at {fmt_num(x)} {fmt_num(y)} {fmt_num(rot)})")
    o.append("\t\t(unit 1)")
    o.append("\t\t(exclude_from_sim no)")
    o.append(f"\t\t(in_bom {'yes' if in_bom else 'no'})")
    o.append(f"\t\t(on_board {'yes' if on_board else 'no'})")
    o.append("\t\t(dnp no)")
    o.append(f'\t\t(uuid "{sym_uuid}")')
    o.append(f'\t\t(property "Reference" "{ref}"')
    o.append(f"\t\t\t(at {fmt_num(x + 2.54)} {fmt_num(y - 2.54)} 0)")
    o.append("\t\t\t(effects (font (size 1.27 1.27)) (justify left))")
    o.append("\t\t)")
    o.append(f'\t\t(property "Value" "{value}"')
    o.append(f"\t\t\t(at {fmt_num(x + 2.54)} {fmt_num(y + 2.54)} 0)")
    o.append("\t\t\t(effects (font (size 1.27 1.27)) (justify left))")
    o.append("\t\t)")
    o.append(f'\t\t(property "Footprint" "{footprint}"')
    o.append(f"\t\t\t(at {fmt_num(x)} {fmt_num(y)} 0)")
    o.append("\t\t\t(effects (font (size 1.27 1.27)) (hide yes))")
    o.append("\t\t)")
    for pin_num, pin_uuid in pin_uuids.items():
        o.append(f'\t\t(pin "{pin_num}"')
        o.append(f'\t\t\t(uuid "{pin_uuid}")')
        o.append("\t\t)")
    o.append("\t\t(instances")
    o.append('\t\t\t(project "openchess-controller"')
    o.append(f'\t\t\t\t(path "/" (reference "{ref}") (unit 1))')
    o.append("\t\t\t)")
    o.append("\t\t)")
    o.append("\t)")


def emit_label(o: list[str], net: str, x: float, y: float, angle: int,
               u: str, size: float = 1.27, justify: str = "left bottom") -> None:
    o.append(f'\t(label "{net}"')
    o.append(f"\t\t(at {fmt_num(x)} {fmt_num(y)} {fmt_num(angle)})")
    o.append(f"\t\t(effects (font (size {fmt_num(size)} {fmt_num(size)})) (justify {justify}))")
    o.append(f'\t\t(uuid "{u}")')
    o.append("\t)")


def emit_wire(o: list[str], x1: float, y1: float, x2: float, y2: float,
              u: str) -> None:
    o.append("\t(wire")
    o.append(f"\t\t(pts (xy {fmt_num(x1)} {fmt_num(y1)}) (xy {fmt_num(x2)} {fmt_num(y2)}))")
    o.append("\t\t(stroke (width 0) (type default))")
    o.append(f'\t\t(uuid "{u}")')
    o.append("\t)")


# ────────────────────────────────────────────────────────────────────────
# Main
# ────────────────────────────────────────────────────────────────────────
def main() -> int:
    out: list[str] = []
    BUILD_DIR.mkdir(parents=True, exist_ok=True)

    # ── File header ──────────────────────────────────────────────────
    out.append("(kicad_sch")
    out.append("\t(version 20260306)")
    out.append('\t(generator "eeschema")')
    out.append('\t(generator_version "10.0")')
    out.append(f'\t(uuid "{uid(0)}")')
    out.append('\t(paper "A2")')
    out.append('\t(title_block')
    out.append('\t\t(title "Controller Test/Mech Snippet")')
    out.append('\t\t(date "2026-06-05")')
    out.append('\t\t(rev "0.1")')
    out.append('\t\t(company "Paolo Nessim")')
    out.append('\t\t(comment 1 "Copy contents into the main controller schematic\'s TEST + MECHANICAL section.")')
    out.append('\t)')

    # ── lib_symbols ──────────────────────────────────────────────────
    out.append("\t(lib_symbols")
    out.append(load_symbol("Connector:TestPoint"))
    out.append(load_symbol("Mechanical:MountingHole"))
    out.append(load_symbol("Mechanical:Fiducial"))
    out.append(load_symbol("power:GND"))
    out.append(load_symbol("power:+3V3"))
    out.append("\t)")

    counter = 100

    # ── Test points ──────────────────────────────────────────────────
    for i, (ref, net, kind) in enumerate(TEST_POINTS):
        cx, cy = tp_position(i)

        # TestPoint symbol — pin 1 is at the origin, body extends "up"
        # in symbol-local coords. We'll place it pointing right
        # (rotation 270 makes pin endpoint face right) so the stub
        # extends right.
        sym_uuid = uid(counter); counter += 1
        pin1_uuid = uid(counter); counter += 1

        # Place with rot=0 (pin points up in world). Pin endpoint is at (cx, cy).
        emit_symbol(
            out,
            lib_id="Connector:TestPoint",
            x=cx, y=cy, rot=0,
            ref=ref, value="TestPoint",
            footprint="TestPoint:TestPoint_Pad_D1.5mm",
            sym_uuid=sym_uuid,
            pin_uuids={"1": pin1_uuid},
        )

        # Short stub down from the pin endpoint, then label/power port.
        # The TestPoint body extends UPWARD from the pin in world view,
        # so the stub + label go DOWNWARD to keep clear of the body.
        stub_end_y = cy + 2 * G  # two grid units (5.08 mm) below the pin
        wire_uuid = uid(counter); counter += 1
        emit_wire(out, cx, cy, cx, stub_end_y, wire_uuid)

        if kind == "label":
            # Horizontal label (angle 0) extending to the right of the
            # stub endpoint — reads naturally left-to-right.
            label_uuid = uid(counter); counter += 1
            emit_label(out, net, cx, stub_end_y, 0, label_uuid,
                       justify="left bottom")
        elif kind == "gnd":
            # GND power port has its pin at the TOP of the symbol body
            # (extends downward in world view). Place it at stub end.
            pwr_sym_uuid = uid(counter); counter += 1
            pwr_pin_uuid = uid(counter); counter += 1
            emit_symbol(
                out,
                lib_id="power:GND",
                x=cx, y=stub_end_y, rot=0,
                ref="#PWR?", value="GND",
                footprint="",
                sym_uuid=pwr_sym_uuid,
                pin_uuids={"1": pwr_pin_uuid},
                in_bom=False, on_board=False,
            )
        elif kind == "+3v3":
            # +3V3 power port has its pin at the BOTTOM of the symbol body
            # (extends upward in world view). For our stub-going-down
            # arrangement, rotate it 180° so the body points DOWN and the
            # pin (now at the top) connects to the wire endpoint.
            pwr_sym_uuid = uid(counter); counter += 1
            pwr_pin_uuid = uid(counter); counter += 1
            emit_symbol(
                out,
                lib_id="power:+3V3",
                x=cx, y=stub_end_y, rot=180,
                ref="#PWR?", value="+3V3",
                footprint="",
                sym_uuid=pwr_sym_uuid,
                pin_uuids={"1": pwr_pin_uuid},
                in_bom=False, on_board=False,
            )

    # ── Mounting holes (no electrical connections) ───────────────────
    for i, ref in enumerate(MOUNTING_HOLES):
        sym_uuid = uid(counter); counter += 1
        emit_symbol(
            out,
            lib_id="Mechanical:MountingHole",
            x=MH_X[i], y=MH_Y, rot=0,
            ref=ref, value="M3",
            footprint="MountingHole:MountingHole_3.2mm_M3",
            sym_uuid=sym_uuid,
            pin_uuids={},  # no electrical pins
        )

    # ── Fiducials (no electrical connections) ────────────────────────
    for i, ref in enumerate(FIDUCIALS):
        sym_uuid = uid(counter); counter += 1
        emit_symbol(
            out,
            lib_id="Mechanical:Fiducial",
            x=FID_X[i], y=FID_Y, rot=0,
            ref=ref, value="Fiducial",
            footprint="Fiducial:Fiducial_1mm_Mask2mm",
            sym_uuid=sym_uuid,
            pin_uuids={},
        )

    # ── Footer ───────────────────────────────────────────────────────
    out.append("\t(sheet_instances")
    out.append('\t\t(path "/"')
    out.append('\t\t\t(page "1")')
    out.append("\t\t)")
    out.append("\t)")
    out.append(")")

    OUT_PATH.write_text("\n".join(out) + "\n")
    print(f"Wrote snippet: {OUT_PATH}")
    print()
    print("Next steps:")
    print(f"  1. Open {OUT_PATH.name} in KiCad (separate window)")
    print("  2. Edit → Select All (Ctrl+A)")
    print("  3. Copy (Ctrl+C)")
    print("  4. Switch to openchess-controller.kicad_sch")
    print("  5. Paste (Ctrl+V) into the TEST + MECHANICAL box area")
    print("  6. Re-annotate if needed (Tools → Annotate Schematic)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
