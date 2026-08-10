# Side Panel — v1 test part

`side-panel-v1.stl` — the OLED / 3-button / USB-C panel for the case's left
wall, printed standalone first to fit-check the real parts before the wall
gets cut.

## Print settings

- Orientation: **flat, outer face DOWN** on the bed (the OLED pocket walls
  point up). No supports needed.
- PLA, 0.2 mm layers, 3 walls, ~100% of a 20-minute print.
- Part is 120 × 17 × 2.5 mm (pocket walls add 6 mm behind).

## Fit-check list (do all before we cut the case)

1. **OLED (0.91")** — drops into the rear pocket, snaps under the two nubs,
   screen centered in the window. If the visible area sits off-center
   (these modules are offset toward the non-pin end), note which way and by
   how much.
2. **8 mm buttons** — barrel passes the Ø8.2 holes, nut clamps snug on the
   2.5 mm plate, buttons don't touch each other's nuts (14 mm spacing).
3. **USB-C panel adapter** — port centered in the 10×5 slot, flange screw
   holes line up (modeled at **18 mm spacing, Ø2.6** — NOMINAL, measure the
   real flange and report if different).

No face screws: the panel's own wall mounting is TBD (snap/friction into
the wall rebate — decided at wall-integration time). The OLED needs no
glue: it drops into the rear pocket and clicks under two snap nubs; glue
gun is the fallback if the nubs run loose.

## Hole map (part local, from the front-corner end)

| item | position from front end (y=15 edge) | size |
|---|---|---|
| USB flange holes | 5 / 23 mm | Ø2.6 |
| USB port slot | 14 mm (center) | 10 × 5 rounded |
| buttons | 34 / 48 / 62 mm | Ø8.2 |
| OLED window | 88 mm (center) | 24 × 7 |

All items on the vertical centerline (z −5 world). USB cluster sits at
y=29 (moved frontward for clearance from the buttons).

## After the fit-check

Report results → v2 tweaks if needed → then Task 6 (cut the wall) proceeds
with the proven dimensions.
