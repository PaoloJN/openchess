# OpenChess Case — Print Package (2026-08-11)

Everything exported from the final clean model (`openchess-board`, post
clean-rebuild). Send these to print.

## Files

| file | what | print notes |
|---|---|---|
| `corner-test-v3.stl` | **PRINT FIRST** — front-left corner test (~22 g) | flat on top rim, no supports; validates OLED/buttons/USB/hex-nut corner |
| `case-walls.stl` | the case ring: front cluster, USB-C mount, robot-arm mount, 4 hex-nut corners | 308 × 308 × 17 mm — flat on the top rim, no supports |
| `top-plate-black.stl` | printed chessboard top, black base | print together as one 2-color job |
| `top-plate-white.stl` | white inlays (squares, frame, labels) | load with black as one object / 2 parts, assign filaments |
| `back-cover.stl` | bottom cover: posts + screw recesses (feet pads removed; flush-screw groove TBD) | flat, outside face down |

Plexi top is NOT printed — laser it from `mechanical/plexi-top/plexi-top.dxf`
(300 mm sheet, LightBurn: Cut + Etch layers).

⚠ **Bed size:** `case-walls`, `top-plate-*`, and `back-cover` are 308 mm —
too big for a 235/256 mm home bed. Either send those to a large-format
print service, or we split them for the bed (not designed yet — ask).

## Hardware list (all from the black M3 kit + button/USB packages)

| joint | screws | nuts | washers |
|---|---|---|---|
| Printed top → case | 4 × M3×8 **pan head** (sits ~flush in the recesses) | 4 × M3 hex — live in the case's top corner slots | — |
| Plexi top → case (swap) | 4 × M3×12 **socket cap** | (same 4 nuts, already in the slots) | 4 × M3 flat |
| Back cover → case | 4 × M3×8 **socket cap** (recessed; case stands on its pads) | 4 × M3 hex — bottom corner slots | — |
| USB-C extension | 2 × M3×12 **pan head** (through the skin slots + flange) | 2 × M3 hex — behind the flange | 2 × M3 flat |
| Buttons (×3) | — | their own 10 mm nuts (in the button bag) | — |
| OLED | none — snap-fit pocket | | |
| Robot arm | none — slide-in slot | | |

**Totals: 14 screws (M3×8: 4 pan + 4 socket; M3×12: 4 socket + 2 pan),
10 × M3 hex nuts, 6 × M3 flat washers.** No heat-set inserts anywhere.

## Assembly order

1. Slide 8 hex nuts into the case corner slots (4 top, 4 bottom) + 2 into
   the USB flange arrangement when mounting it.
2. Mount USB-C from inside (nose through slot, flush), screws from outside.
3. Snap the OLED into its pocket from inside (pins toward the corner),
   buttons from outside, nuts in the groove.
4. Drop the PCB onto the back-cover posts, close the cover, 4 bottom screws.
5. Top of choice: printed top (4 pan) or plexi (4 socket + washers).
