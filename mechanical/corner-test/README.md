# Corner Test Piece — v2

`corner-test-v9.stl` — the front-left corner of the case (115 × 61 mm
L-section, 17 mm tall, ~22 g), carved from the final clean model (v2: 30×12 glass-flush OLED window). One print
tests every mechanical unknown before the full 308 mm case print.

## Print settings

- Orientation: **flat on the TOP rim** (the widest flat face down). All
  wall features (window, button holes, USB slot) print as vertical-wall
  holes — no supports needed. The corner nut slots print as short side
  bridges (~6 mm) — fine in PLA.
- PLA, 0.2 mm layers, 3 walls.

## Fit-check list

1. **OLED (0.91")** — insert from the inside into the pocket behind the
   window (pins toward the corner), snaps under the two nubs, screen
   centered in the window.
2. **8 mm buttons** — barrels through the Ø8.4 holes from outside, 10 mm
   nuts thread on inside the groove; check all 3 nuts fit side by side and
   the first one clears the OLED pocket.
3. **USB-C** — NO SCREWS: flange slides into the (now 12.5mm-tall) pocket
   from inside, nose pokes through the slot flush with the outer face; glue the flange into the pocket (it is already a snug
   fit). Outside wall is completely clean — no screws, no extra parts.
4. **Corner fastening (HEAT-SET INSERTS now)** — melt an M3×5 insert into
   the corner's top mouth (and one into the bottom mouth via the cover-pad
   pocket): kit iron tip, slow, stop ~0.3 mm below flush, cool. Then M3×8
   should run in smoothly all the way — no plastic in the threads.
5. **General** — outer faces clean (no seams/blades — this is the rebuilt
   clean body), wall stiffness feel.

## What this validates for the real print

OLED seat, button stack (2.5+3 mm, 4.5 mm thread), USB flush-mount trick,
hex-nut fastening, and surface quality. The robot-arm mount (back wall) is
NOT in this piece — say the word for a second back-wall strip if you want
to test the arm clip too.

## Cover corner piece (corner-test-cover-v1.stl)

The matching back-cover corner for the same cut. Print flat, outside face
down. Tests:
1. **Heat-set insert** in the PCB post: M3×5 insert with the kit's M3 iron
   tip, press slow, stop ~0.3 mm below the top (the relief ring), let cool.
   Then M3×6 screw all the way in — this is the melt-proof geometry test.
2. **Flush cover screw**: with an insert melted into the walls piece's
   lower mouth, nest the cover corner's pad into the boss pocket, M3×8
   socket cap through the counterbore — head lands ~0.2 mm below the cover
   surface, fully flush.
3. **Pad registration**: the cover corner should locate itself in the boss
   pocket with no slop.
