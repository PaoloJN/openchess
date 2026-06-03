#!/usr/bin/env python3
"""
Export Gerber files for manufacturing (JLCPCB / PCBWay / OSH Park).

Uses KiCad's command-line interface (kicad-cli) which ships with KiCad 7+.

Outputs:
  - <project>/gerbers/  - all standard Gerber files
  - <project>/gerbers/<project>.zip - zipped for upload to fab service
  - drill files inside the same folder

After running:
  1. Visit jlcpcb.com or pcbway.com
  2. Click "Upload Gerber file" / "Quote Now"
  3. Upload openchess.zip
  4. Verify the rendered preview matches your design
  5. Order with PCBA service if you want SMD components pre-soldered
"""

import os
import shutil
import subprocess
import sys

PCB_FILE = "../hardware/openchess.kicad_pcb"
OUTPUT_DIR = "../hardware/gerbers"
ZIP_NAME = "openchess-gerbers.zip"

# Layers to export for a standard 2-layer board.
# For 4-layer add: In1.Cu, In2.Cu
LAYERS_2_LAYER = "F.Cu,B.Cu,F.Paste,B.Paste,F.SilkS,B.SilkS,F.Mask,B.Mask,Edge.Cuts"
LAYERS_4_LAYER = "F.Cu,In1.Cu,In2.Cu,B.Cu,F.Paste,B.Paste,F.SilkS,B.SilkS,F.Mask,B.Mask,Edge.Cuts"


def find_kicad_cli():
    """Locate the kicad-cli executable."""
    candidates = [
        "/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli",
        "/usr/local/bin/kicad-cli",
        "kicad-cli",   # in PATH
    ]
    for c in candidates:
        if os.path.exists(c) or shutil.which(c):
            return c
    raise RuntimeError("kicad-cli not found. Make sure KiCad is installed.")


def main():
    pcb_path = os.path.abspath(os.path.join(os.path.dirname(__file__), PCB_FILE))
    out_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), OUTPUT_DIR))

    if not os.path.exists(pcb_path):
        print(f"ERROR: PCB file not found at {pcb_path}")
        sys.exit(1)

    os.makedirs(out_dir, exist_ok=True)

    cli = find_kicad_cli()
    print(f"Using kicad-cli: {cli}")
    print(f"PCB file:        {pcb_path}")
    print(f"Output dir:      {out_dir}")
    print()

    # Detect 2 vs 4 layer board
    with open(pcb_path) as f:
        text = f.read()
    if 'In1.Cu' in text:
        layers = LAYERS_4_LAYER
        print("Detected 4-layer board")
    else:
        layers = LAYERS_2_LAYER
        print("Detected 2-layer board")
    print()

    # Export Gerbers
    print("Exporting Gerber files...")
    subprocess.run([
        cli, "pcb", "export", "gerbers",
        "--output", out_dir + "/",
        "--layers", layers,
        "--no-x2",                  # for JLCPCB compatibility
        "--no-netlist",
        "--subtract-soldermask",
        pcb_path,
    ], check=True)

    # Export drill files (NC drill format)
    print("Exporting drill files...")
    subprocess.run([
        cli, "pcb", "export", "drill",
        "--output", out_dir + "/",
        "--format", "excellon",
        "--map-format", "gerberx2",
        "--drill-origin", "absolute",
        "--excellon-zeros-format", "decimal",
        pcb_path,
    ], check=True)

    # Zip everything for upload
    print(f"Creating {ZIP_NAME}...")
    zip_path = os.path.join(out_dir, ZIP_NAME)
    if os.path.exists(zip_path):
        os.remove(zip_path)
    shutil.make_archive(zip_path[:-4], 'zip', out_dir)

    print()
    print("DONE. Files generated:")
    for fname in sorted(os.listdir(out_dir)):
        fpath = os.path.join(out_dir, fname)
        size_kb = os.path.getsize(fpath) / 1024
        print(f"  {fname:50s} {size_kb:8.1f} KB")

    print()
    print(f"UPLOAD: {zip_path}")
    print()
    print("NEXT:")
    print("  1. Visit jlcpcb.com or pcbway.com")
    print("  2. Upload the .zip and verify the preview")
    print("  3. Choose options:")
    print("     - 2-layer or 4-layer (match your design)")
    print("     - Surface finish: HASL is cheapest")
    print("     - PCBA service: yes if you want SMD components pre-soldered")
    print("  4. Order!")


if __name__ == "__main__":
    main()
