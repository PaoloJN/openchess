#!/usr/bin/env python3
"""Generate pcb-test-foot.stl — 4 no-hardware SNAP-FIT legs for bench-testing
the matrix PCB. Each is a 45 mm post; on top, a peg with a + slot splitting it
into 4 flexible prongs with barbs. The board pushes down over the peg: prongs
squeeze through the M3 hole (low force -> won't snap), then the barbs click over
the top of the board and hold it. Pull firmly / pinch the prongs to remove.

Needs trimesh + manifold3d (run with the scratchpad venv). No screws needed.
"""
import math
import numpy as np
import trimesh

# --- parameters (mm) ---
HEIGHT     = 45.0   # post height = PCB rest face (shoulder)
COL_D      = 8.0    # post diameter
PAD_D      = 14.0   # foot pad diameter
PAD_H      = 2.0    # foot pad thickness

SHAFT_D    = 3.0    # peg shaft (slips through the Ø3.2 M3 hole)
BOARD_GAP  = 1.8    # shoulder -> barb underside (board 1.6 mm + 0.2 play)
BARB_D     = 3.8    # barb catch diameter (> hole -> holds the board down)
TIP_D      = 2.2    # barb tip (< hole -> self-guides / compresses on the way in)
PEG_TOP    = HEIGHT + BOARD_GAP + 2.7   # tip height

SLOT_W     = 1.2    # + slot width (prong gap -> lets them flex)
SLOT_ROOT  = HEIGHT - 3.0               # slot cuts this far down (prong hinge)
SEG        = 96
GRID       = 22.0

barb_z = HEIGHT + BOARD_GAP

# axisymmetric meridian (r, z), CCW-ish; revolved then slotted
meridian = [
    (0.0,        0.0),      # bottom center
    (PAD_D / 2,  0.0),      # pad rim
    (PAD_D / 2,  PAD_H),    # pad top
    (COL_D / 2,  PAD_H),    # step to post
    (COL_D / 2,  HEIGHT),   # post top (outer, shoulder edge)
    (SHAFT_D / 2, HEIGHT),  # shoulder annulus (PCB rests here)
    (SHAFT_D / 2, barb_z),  # shaft up to barb
    (BARB_D / 2, barb_z),   # barb catch (underside holds board)
    (TIP_D / 2,  PEG_TOP),  # barb taper to tip
    (0.0,        PEG_TOP),  # tip center
]


def revolve(meridian, n):
    tris = []
    m = len(meridian)
    for j in range(m):
        rj, zj = meridian[j]
        rk, zk = meridian[(j + 1) % m]
        if rj < 1e-9 and rk < 1e-9:
            continue
        for i in range(n):
            t0, t1 = 2 * math.pi * i / n, 2 * math.pi * (i + 1) / n
            A = (rj * math.cos(t0), rj * math.sin(t0), zj)
            B = (rj * math.cos(t1), rj * math.sin(t1), zj)
            C = (rk * math.cos(t1), rk * math.sin(t1), zk)
            D = (rk * math.cos(t0), rk * math.sin(t0), zk)
            if rj > 1e-9:
                tris.append((A, B, C))
            if rk > 1e-9:
                tris.append((A, C, D))
    return np.array(tris).reshape(-1, 3)


verts = revolve(meridian, SEG)
faces = np.arange(len(verts)).reshape(-1, 3)
body = trimesh.Trimesh(vertices=verts, faces=faces, process=True)
body.merge_vertices()
body.update_faces(body.nondegenerate_faces())
body.fix_normals()
assert body.is_watertight, "revolved body not watertight"

# + slot: two thin boxes crossing at the axis, from SLOT_ROOT up past the tip
slot_h = PEG_TOP + 1.0 - SLOT_ROOT
cz = (SLOT_ROOT + PEG_TOP + 1.0) / 2
b1 = trimesh.creation.box(extents=[COL_D + 4, SLOT_W, slot_h])
b1.apply_translation([0, 0, cz])
b2 = trimesh.creation.box(extents=[SLOT_W, COL_D + 4, slot_h])
b2.apply_translation([0, 0, cz])

leg = body.difference(b1).difference(b2)
assert leg.is_watertight, "slotted leg not watertight"

# 4 up on the plate
plate = trimesh.util.concatenate(
    [leg.copy().apply_translation([gx, gy, 0])
     for gx in (0.0, GRID) for gy in (0.0, GRID)])
plate.export("pcb-test-foot.stl")

print(f"wrote pcb-test-foot.stl  ({len(plate.faces)} faces, 4 legs)")
print(f"each: {PEG_TOP:.1f} mm tall | board rests at {HEIGHT:.0f} mm "
      f"| post Ø{COL_D:.0f} | barb Ø{BARB_D} in Ø3.2 hole | 4 prongs, {SLOT_W} slot")
print(f"per-leg watertight: {leg.is_watertight}")
