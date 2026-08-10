# OpenChess — Side Panel (OLED / Buttons / USB-C) + Insert-Free Fastening

Date: 2026-08-10
Status: Approved in conversation; written for review.

## Goal

Two changes to the case:

1. **A modular side panel** that carries the OLED display, the 3 buttons, and
   the USB-C charging port — first printed standalone as a small test
   rectangle to fit-check the real parts, then dropped into an opening in the
   case's left wall.
2. **Replace all heat-set inserts with square nuts in printed pockets.**
   The inserts failed (plastic melted into the threads); nuts give metal
   threads that survive unlimited screw cycles — which the swappable top
   needs.

## Hardware (what Paolo has / is ordering)

| Part | Product | Key dims (nominal — verify on test print) |
|---|---|---|
| OLED | 0.91" SSD1306 I2C module, 4-pin (GND/VCC/SCL/SDA) | PCB ~38 × 12 mm; matches controller `J6` |
| Buttons ×3 | Gebildet 8 mm mini metal momentary, pre-wired | Ø8 threaded barrel + rear nut; head ~Ø10 proud |
| USB-C | AAOTOKK panel-mount USB-C 3.1 extension | Rect flange ~24 × 14 mm, 2 flange screws, cable to controller port |
| **To order** | M3 **square** nuts (DIN 562, 5.5 × 5.5 × 1.8 mm), pack of 50 | Slot fit 5.8 × 2.0 mm |
| **To order** | M3 flat-head (countersunk) screws, 8 mm + 12 mm | One assortment box covers both |

No more heat-set inserts anywhere in the project.

## Part A — The panel (the test rectangle)

A flat printed plate, **~120 × 17 × 2.5 mm** faceplate — the **full height
of the wall face**, so it reads as a full-height wall segment: only the two
vertical end seams show, and the top plate / back cover edges hide the
horizontal joints. Prints face-down, ~20 min. Layout viewed from outside,
left to right:

```
┌────────────────────────────────────────────┐
│ ⊙  ┌──────────┐   (O)  (O)  (O)  ┌────┐  ⊙ │  17 mm
│    │   OLED   │   UP  DOWN  OK   │USB-C│   │
└────────────────────────────────────────────┘
                  ~120 mm              ⊙ = M3 mounting screw
```

- **OLED**: window cut to the visible screen area; behind it a pocket the
  module drops into, held by small printed clips. No glue, no tiny screws.
- **Buttons**: 3 × Ø8.2 holes; barrel through, nut clamps on the back.
  ~14 mm spacing.
- **USB-C**: cutout for the port body + 2 clearance holes for the adapter's
  own flange screws (flange mounts behind the faceplate, port pokes through).
- **Panel mounting**: 2 × M3 flat-heads, countersunk into the faceplate near
  each end, threading into square nuts in the wall (Part B).

**Test-first workflow (the point of this part):** print the panel alone and
fit-check all three real components on the bench. Iterate the print until
everything clicks in. Only then cut the case wall. Expect 1–2 quick
iterations — the USB-C flange and OLED dims are nominal until proven.

## Part B — Wall integration (left wall, near the front corner)

The left wall (world x = −13 outer face, 10 mm thick, exterior face 17 mm
tall, z 3.5 → −13.5) gets, in Fusion:

1. **Through-opening** in the inner 7.5 mm of wall, ≥2 mm smaller than the
   panel on all sides, for the component bodies.
2. **Rebate** (recess) 2.5 mm deep and full wall-face height, so the panel
   sits **flush** with the outer face — no bump, vertical end seams only.
3. **Two square-nut slots** in the wall at the panel screw positions, opening
   on the hidden inner face. M3×8 screws from outside.

Position: near the **front-left corner** (small world y). The controller
also lives at the front-left inside the case — **implementation must query
the controller/ESP32 bounding box in Fusion and place the panel so button
barrels and the OLED body clear it**, nudging the panel toward the back as
needed. Component bodies otherwise hang in the open space under the matrix
PCB (PCB edge stops at world x = 0, i.e. 3 mm inboard of the inner wall
face; everything below z = 0 near the wall is empty).

Relocation later ("flip to front-facing"): the opening + rebate + nut slots
are one recipe — reapply to the front wall in CAD; the same panel drops in.

## Part C — Corner fastening rework (all 4 corner bosses)

- **Fill the existing Ø4.0 insert pockets** (top and bottom of each boss).
- Cut a **square-nut slot** (5.8 wide × 2.0 tall) per screw, opening on the
  boss's inner (hidden) face: one a few mm below the top rim for the top
  plate screw, one mirrored above the bottom face for the back cover screw.
  Nut slides in sideways; can't spin; captured once the screw is in.
- Screw XY positions unchanged: world (−3,−3) / (285,−3) / (−3,285) /
  (285,285) — the drilled/lasered plexi still fits.
- Screw lengths: **M3×12** for the plexi top (6 mm sheet, straight holes +
  washer), **M3×8** for the printed top (3 mm) and back cover (2 mm plate).
  Exact slot depths set at implementation so each screw engages the nut
  fully.
- **Folds in the pending fix**: the printed top and back cover still have
  screw holes at the old position — they move to the (−3,−3) family as part
  of this work.

## Out of scope

- Front-wall panel opening (recipe documented, applied later if wanted).
- Splitting the 308 mm parts for the 235 mm print bed.
- Back-cover ribs, chess pieces/magnets.

## Risks / notes

- USB-C flange height (~14 mm) fits the 17 mm panel with ~1.5 mm margins —
  tight; confirmed fit is a test-print exit criterion before the wall is cut.
- 0.91" OLED clip geometry is the fiddliest print feature; fallback is a
  dab of double-sided tape inside the same pocket.
- Wall opening spans most of the wall height over ~120 mm; the wall ring
  plus the screwed-in panel keeps stiffness acceptable, but keep ≥2 mm of
  wall frame top and bottom of the opening.
