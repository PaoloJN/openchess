"""
Tile a large single-page PDF across multiple A4 (or any size) sheets at 1:1.

Use case: KiCad plot or the merged overlay PDF is too big for an A4 home
printer. This script splits the page into a grid of A4-sized tiles with a
configurable overlap, preserving vector content. Print each tile at 100%
scale, trim margins, tape along the overlap lines.

Usage:
    python3 scripts/tile_pdf_to_a4.py <input.pdf> [-o output.pdf]
                                       [--tile A4|A4-landscape|<wmm>x<hmm>]
                                       [--overlap MM]

Examples:
    # 8x8 overlay → A4 portrait tiles with 5 mm overlap
    python3 scripts/tile_pdf_to_a4.py hardware/openchess-board-8x8-papertest-overlay.pdf \\
        -o hardware/openchess-board-8x8-papertest-a4tiled.pdf

    # Custom tile size
    python3 scripts/tile_pdf_to_a4.py input.pdf --tile 200x280 --overlap 8

Then open output in Preview/Adobe → Print all pages at 100% scale, no fit-to-page.

Requires: pypdf  (pip install --user --break-system-packages pypdf)
"""

import argparse
import math
import sys
from pathlib import Path

try:
    from pypdf import PdfReader, PdfWriter, Transformation
    from pypdf.generic import RectangleObject
except ImportError:
    sys.exit("pypdf not installed. Run: python3 -m pip install --user --break-system-packages pypdf")


MM_TO_PT = 72 / 25.4

TILE_PRESETS = {
    "a4": (210, 297),
    "a4-landscape": (297, 210),
    "letter": (216, 279),
    "letter-landscape": (279, 216),
}


def parse_tile(s: str) -> tuple[float, float]:
    s = s.lower().strip()
    if s in TILE_PRESETS:
        return TILE_PRESETS[s]
    if "x" in s:
        w_str, h_str = s.split("x")
        return float(w_str), float(h_str)
    sys.exit(f"Unrecognized tile size: {s}. Use A4, A4-landscape, Letter, or <wmm>x<hmm>.")


def tile(input_pdf: Path, output_pdf: Path, tile_w_mm: float, tile_h_mm: float, overlap_mm: float) -> None:
    tile_w = tile_w_mm * MM_TO_PT
    tile_h = tile_h_mm * MM_TO_PT
    overlap = overlap_mm * MM_TO_PT
    step_w = tile_w - overlap
    step_h = tile_h - overlap

    reader = PdfReader(str(input_pdf))
    src = reader.pages[0]
    src_w = float(src.mediabox.width)
    src_h = float(src.mediabox.height)

    src_w_mm = src_w / MM_TO_PT
    src_h_mm = src_h / MM_TO_PT

    n_cols = max(1, math.ceil((src_w - overlap) / step_w))
    n_rows = max(1, math.ceil((src_h - overlap) / step_h))

    print(f"Source: {src_w_mm:.1f} x {src_h_mm:.1f} mm  ({input_pdf.name})")
    print(f"Tile  : {tile_w_mm:.1f} x {tile_h_mm:.1f} mm  overlap {overlap_mm:.1f} mm")
    print(f"Grid  : {n_cols} cols x {n_rows} rows  ->  {n_cols * n_rows} sheets")

    writer = PdfWriter()

    for row in range(n_rows):
        for col in range(n_cols):
            new_page = writer.add_blank_page(width=tile_w, height=tile_h)
            tx = -col * step_w
            ty = -(src_h - row * step_h - tile_h)
            tr = Transformation().translate(tx, ty)
            new_page.merge_transformed_page(src, tr, expand=False)

            # Add cut marks at the tile corners by setting the cropbox slightly
            # inside the mediabox. Most printers honor cropbox as the visible area.
            # (Skip for now — relying on the tile boundary itself for alignment.)

            tile_index = row * n_cols + col + 1
            print(f"  page {tile_index:>2}: row {row+1}/{n_rows}, col {col+1}/{n_cols}")

    output_pdf.parent.mkdir(parents=True, exist_ok=True)
    with open(output_pdf, "wb") as f:
        writer.write(f)
    print(f"Wrote {output_pdf}  ({output_pdf.stat().st_size / 1024:.1f} KB)")


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("input", help="Input PDF (single-page)")
    ap.add_argument("-o", "--output", default=None, help="Output PDF (default: <input>-tiled.pdf)")
    ap.add_argument("--tile", default="A4", help="Tile size: A4, A4-landscape, Letter, or <wmm>x<hmm>")
    ap.add_argument("--overlap", type=float, default=5.0, help="Overlap between tiles in mm (default 5)")
    args = ap.parse_args()

    inp = Path(args.input)
    if not inp.exists():
        sys.exit(f"Not found: {inp}")

    out = Path(args.output) if args.output else inp.with_name(inp.stem + "-tiled.pdf")
    tile_w, tile_h = parse_tile(args.tile)
    tile(inp, out, tile_w, tile_h, args.overlap)


if __name__ == "__main__":
    main()
