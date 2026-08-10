# Front Panel — v1 test part

`front-panel-v1.stl` — the OLED + 3-button panel for the case's FRONT wall
(the vertical face toward the player), printed standalone first to
fit-check the real parts before the wall gets cut.

Layout change 2026-08-10: controls moved from the left wall to the front
wall; the **USB-C moved off the panel entirely** — it will mount directly
into the left wall near the front corner (the AAOTOKK adapter's own flange
+ 2 screws, no panel needed).

## Print settings

- Orientation: **flat, outer face DOWN** on the bed (the OLED tray walls
  point up). No supports needed.
- PLA, 0.2 mm layers, 3 walls, ~15 min.
- Part is 89 × 17 × 2.5 mm (tray adds 6 mm behind).

## Fit-check list (do all before we cut the case)

1. **OLED (0.91")** — drops into the rear tray, snaps under the two nubs,
   screen centered in the window. Mount the module with its **4 pins toward
   the BUTTONS** — the window is offset for that orientation. If the
   visible area still sits off-center, note which way and by how much.
2. **8 mm buttons** — barrel passes the Ø8.2 holes, nut clamps snug on the
   2.5 mm plate, nuts don't hit the OLED tray or each other (14 mm spacing).

The OLED needs no glue: pocket + snap nubs hold it; glue gun only as
fallback. Panel wall mounting is TBD (snap/friction into the wall rebate —
decided at wall-integration time). The USB-C flange fit gets its own check
when the left-wall cutout is made.

## Hole map (part local, from the left end of the part)

| item | position from left end (x=6 edge) | size |
|---|---|---|
| OLED tray (behind) | 2.1 → 43 mm | 40.9 × 14.9 outside |
| OLED window | 19 mm (center) | 24 × 7 |
| buttons | 50 / 64 / 78 mm | Ø8.2 |

All items on the vertical centerline (z −5 world). World coords: panel
x 6→96, outer face y = −13, window x 13→37, buttons at world x 56/70/84 —
clear of the controller which starts at x 90 behind the front wall.
Spacing balanced v2: ~7 mm margins at both ends.
