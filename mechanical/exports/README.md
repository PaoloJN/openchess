# OpenChess Case — Print Package (2026-08-11)

Everything exported from the final clean model (`openchess-board`, post
clean-rebuild). Send these to print.

## Files

| file | what | print notes |
|---|---|---|
| `corner-test-v9.stl` | **PRINT FIRST** — front-left corner test (~22 g) | flat on top rim, no supports; validates OLED/buttons/USB/hex-nut corner |
| `case-walls.stl` | the case ring: front cluster, USB-C mount, robot-arm mount, 4 hex-nut corners | 308 × 308 × 17 mm — flat on the top rim, no supports |
| `top-plate-black.stl` | printed chessboard top, black base | print together as one 2-color job |
| `top-plate-white.stl` | white inlays (squares, frame, labels) | load with black as one object / 2 parts, assign filaments |
| `back-cover.stl` | bottom cover: nested corner pads (flush socket heads) + PCB posts with anti-melt insert bosses | flat, outside face down |

Plexi top is NOT printed — laser it from `mechanical/plexi-top/plexi-top.dxf`
(300 mm sheet, LightBurn: Cut + Etch layers).

⚠ **Bed size:** `case-walls`, `top-plate-*`, and `back-cover` are 308 mm —
too big for a 235/256 mm home bed. Either send those to a large-format
print service, or we split them for the bed (not designed yet — ask).

## Hardware list (all from the black M3 kit + button/USB packages)

| joint | screws | fastener | washers |
|---|---|---|---|
| Printed top → case | 4 × M3×8 **pan head** (~flush in recesses) | top corner **heat-set inserts** | — |
| Plexi top → case (swap) | 4 × M3×12 **socket cap** | (same top inserts) | 4 × M3 flat |
| Back cover → case | 7 × M3×8 **socket cap** (fully flush) | corner + mid-edge **heat-set inserts** (4 corners + 3 mid: front/left/right) | — |
| PCB → cover posts | 4 × M3×6 (head ≤1.9 mm tall — button style) | post **heat-set inserts** | — |
| USB-C extension | — glued into its pocket | — | — |
| Buttons (×3) | — | their own 10 mm nuts (button bag) | — |
| OLED | none — snap-fit pocket | | |
| Robot arm | none — slide-in slot | | |

**Totals: 19 screws (4×M3×8 pan, 11×M3×8/12 socket, 4×M3×6 low-head),
15 × M3×5 heat-set inserts (8 corners + 3 mid-edge + 4 posts), 4 washers,
glue for USB.**
Hex nuts no longer used. Insert install: kit's M3 iron tip, slow, stop
~0.3 mm below flush (relief ring), cool before screwing. Every insert bore
has spare depth below so melt can't block the screw.

## Assembly order

1. Slide 8 hex nuts into the case corner slots (4 top, 4 bottom) + 2 into
   the USB flange arrangement when mounting it.
2. Mount USB-C from inside (nose through slot, flush), screws from outside.
3. Snap the OLED into its pocket from inside (pins toward the corner),
   buttons from outside, nuts in the groove.
4. Drop the PCB onto the back-cover posts, close the cover, 4 bottom screws.
5. Top of choice: printed top (4 pan) or plexi (4 socket + washers).
