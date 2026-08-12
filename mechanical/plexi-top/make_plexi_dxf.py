#!/usr/bin/env python3
"""Generate the plexiglass top laser file for LightBurn.

Two layers:
  - "Cut"  : 300 mm square outline + 4 corner M3 clearance holes (Ø3.4).
             Set to LINE (cut-through) mode in LightBurn.
  - "Etch" : the chessboard pattern — 32 light squares, frame line, and the
             a–h / 1–8 labels. Set to FILL (engrave) mode in LightBurn.

The etch geometry is extracted from the Fusion 360 printed-top model
(etch-geometry.json, world mm coordinates) so the plexi pattern matches the
printed top and the PCB underneath exactly. Regenerate that JSON from Fusion
if the board design changes; then re-run this script.

The 300 mm sheet is centered on the 308 mm case (4 mm reveal per side), so
world coords map to sheet coords via +9 mm. Screw holes land 6 mm from the
sheet edges — same case inserts the printed top uses, tops stay swappable.

Sheet is 6 mm acrylic. Holes stay STRAIGHT (no countersinking): the printed
bezel frame (plexi_bezel in Fusion) fills the 4 mm gap between the 300 sheet
and the 308 case, and its thin corner plates overlap the sheet's corners;
the M3 x 12 flat-heads countersink into those plates, pass through these
plexi holes, and clamp frame + sheet to the case.

Etching is drawn for a TOP-surface engrave. If you prefer to engrave the
underside (protects the frosting), mirror the whole job in LightBurn and
flip the sheet.
"""

import json
import os

HERE = os.path.dirname(os.path.abspath(__file__))

SIZE = 300.0     # plexi edge (mm) — max sheet size available
HOLE_D = 3.4     # M3 clearance
INSET = 6.0      # hole center from sheet edge (case inserts, world (-3,-3) etc.)
WORLD_OFFSET = 9.0   # world mm -> sheet mm (sheet spans world -9..291)

pts = [(0, 0), (SIZE, 0), (SIZE, SIZE), (0, SIZE)]
holes = [(INSET, INSET), (SIZE - INSET, INSET),
         (INSET, SIZE - INSET), (SIZE - INSET, SIZE - INSET)]
r = HOLE_D / 2

with open(os.path.join(HERE, "etch-geometry.json")) as f:
    etch = json.load(f)


def to_sheet(loop):
    return [(x + WORLD_OFFSET, y + WORLD_OFFSET) for x, y in loop]


# etch entities: list of (name, [loop, ...]) — loops of one entity fill
# together (even-odd), so inner cutouts / letter counters stay clear
entities = [("square", [to_sheet(l)]) for l in etch["squares"]]
entities.append(("frame", [to_sheet(l) for l in etch["frame"]]))
for lbl in etch["labels"]:
    entities.append((lbl["name"], [to_sheet(l) for l in lbl["loops"]]))

# ---- DXF ----
dxf = ["0", "SECTION", "2", "HEADER", "9", "$INSUNITS", "70", "4", "0", "ENDSEC",
       "0", "SECTION", "2", "ENTITIES"]

def add_polyline(layer, loop):
    dxf.extend(["0", "LWPOLYLINE", "8", layer, "90", str(len(loop)), "70", "1"])
    for x, y in loop:
        dxf.extend(["10", f"{x:.3f}", "20", f"{y:.3f}"])

add_polyline("Cut", pts)
for cx, cy in holes:
    dxf.extend(["0", "CIRCLE", "8", "Cut",
                "10", f"{cx:.3f}", "20", f"{cy:.3f}", "40", f"{r:.3f}"])
for _, loops in entities:
    for loop in loops:
        add_polyline("Etch", loop)
dxf.extend(["0", "ENDSEC", "0", "EOF"])
with open(os.path.join(HERE, "plexi-top.dxf"), "w") as f:
    f.write("\n".join(dxf) + "\n")

# ---- SVG (preview / alternative import) ----
def path_d(loops):
    parts = []
    for loop in loops:
        parts.append("M " + " L ".join(f"{x:.3f} {y:.3f}" for x, y in loop) + " Z")
    return " ".join(parts)

etch_paths = "\n  ".join(
    f'<path d="{path_d(loops)}" fill="#888" fill-rule="evenodd" stroke="none"/>'
    for _, loops in entities)
hole_circles = "\n  ".join(
    f'<circle cx="{cx}" cy="{cy}" r="{r}" fill="none" stroke="red" stroke-width="0.2"/>'
    for cx, cy in holes)
svg = f'''<svg xmlns="http://www.w3.org/2000/svg" width="{SIZE}mm" height="{SIZE}mm" viewBox="0 0 {SIZE} {SIZE}">
<g transform="translate(0,{SIZE}) scale(1,-1)">
  <rect x="0" y="0" width="{SIZE}" height="{SIZE}" fill="none" stroke="red" stroke-width="0.2"/>
  {hole_circles}
  {etch_paths}
</g>
</svg>
'''
with open(os.path.join(HERE, "plexi-top.svg"), "w") as f:
    f.write(svg)

n_loops = sum(len(loops) for _, loops in entities)
print(f"wrote plexi-top.dxf + plexi-top.svg: {SIZE:.0f} mm sq, 4x Ø{HOLE_D} holes "
      f"{INSET} mm from edges, {len(entities)} etch entities ({n_loops} loops)")
