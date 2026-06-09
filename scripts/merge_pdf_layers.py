"""
Overlay multiple single-page PDFs into one PDF page.

Use case: KiCad's Plot exports one PDF per layer. This script stacks them
into a single page so you can print one sheet that shows Edge.Cuts +
F.Silkscreen + F.Fab + F.Cu + B.Cu all at once at true 1:1 scale.

Usage:
    python3 scripts/merge_pdf_layers.py <dir_or_glob> [-o output.pdf] [--include EdgeCuts,F_Silkscreen,...]

Examples:
    # Merge every PDF in a directory
    python3 scripts/merge_pdf_layers.py hardware/hardware-board/images -o merged.pdf

    # Only include specific layers
    python3 scripts/merge_pdf_layers.py hardware/hardware-board/images \
        --include Edge_Cuts,F_Silkscreen,F_Cu,B_Cu \
        -o openchess-board-8x8-papertest-merged.pdf

Requires: pypdf  (pip install --user --break-system-packages pypdf)
"""

import argparse
import os
import sys
from pathlib import Path

try:
    from pypdf import PdfReader, PdfWriter
except ImportError:
    sys.exit("pypdf not installed. Run: python3 -m pip install --user --break-system-packages pypdf")


def collect_pdfs(path: Path, include: list[str] | None) -> list[Path]:
    if path.is_file():
        return [path]
    pdfs = sorted(path.glob("*.pdf"))
    if include:
        keep = []
        for needle in include:
            matches = [p for p in pdfs if needle.lower() in p.name.lower()]
            if not matches:
                print(f"  ! no PDF matches '{needle}' in {path}", file=sys.stderr)
            keep.extend(matches)
        # dedupe preserving order
        seen = set()
        pdfs = [p for p in keep if not (p in seen or seen.add(p))]
    return pdfs


def merge(pdfs: list[Path], output: Path) -> None:
    if not pdfs:
        sys.exit("No input PDFs.")

    print(f"Overlaying {len(pdfs)} PDFs:")
    base = PdfReader(str(pdfs[0]))
    base_page = base.pages[0]
    print(f"  base: {pdfs[0].name}  ({base_page.mediabox.width:.1f} x {base_page.mediabox.height:.1f} pt)")

    for layer_path in pdfs[1:]:
        layer = PdfReader(str(layer_path))
        layer_page = layer.pages[0]
        base_page.merge_page(layer_page)
        print(f"  + {layer_path.name}")

    writer = PdfWriter()
    writer.add_page(base_page)
    output.parent.mkdir(parents=True, exist_ok=True)
    with open(output, "wb") as f:
        writer.write(f)
    print(f"Wrote {output}  ({output.stat().st_size / 1024:.1f} KB)")


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("input", help="Directory of PDFs or a single PDF file")
    ap.add_argument("-o", "--output", default="merged.pdf", help="Output PDF path")
    ap.add_argument("--include", default=None,
                    help="Comma-separated list of layer name substrings to include (e.g. Edge_Cuts,F_Silkscreen)")
    args = ap.parse_args()

    path = Path(args.input)
    if not path.exists():
        sys.exit(f"Not found: {path}")

    include = [s.strip() for s in args.include.split(",")] if args.include else None
    pdfs = collect_pdfs(path, include)
    merge(pdfs, Path(args.output))


if __name__ == "__main__":
    main()
