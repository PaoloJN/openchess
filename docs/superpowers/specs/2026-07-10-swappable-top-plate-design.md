# OpenChess — Swappable Top Plate Design

Date: 2026-07-10
Status: Draft for review.

## Goal

Split the top plate off from the case walls so it becomes a **separate,
screw-on part**. This lets Paolo keep **two interchangeable tops** that share
one mounting interface:

- **Printed top** — the current chessboard plate (black/white squares, border,
  a–h/1–8 labels, 81 LED corner holes).
- **Plexiglass top** — a clear flat panel. See-through to the PCB's own
  silkscreen and the LEDs; no pattern on it.

Swapping a top = undo 4 screws, lift, drop the other on, redo 4 screws. The PCB
and everything below stays put.

## Constraints / current state (what this changes)

- Today the top plate is a separate Fusion component but conceptually printed as
  one piece with the walls. The PCB is **sandwich-clamped**: back-cover corner
  posts + 4 long M3 screws tie back cover + PCB + top plate together at the M3
  hole positions (19 mm in from the case edge).
- Case: 308 × 308 mm, ~10 mm-thick walls, open top and bottom, 22 mm tall.
  Current top plate already sits **on top** of the walls (plate underside at the
  wall-top height; top surface ~3 mm above).
- Matrix PCB: 282 mm, M3 holes 6 mm in from each PCB corner → **19 mm in from
  the case edge** (9 mm inboard of the inner wall face).
- Chosen hardware: **M3 heat-set inserts** (Ø5 × 5 mm) + M3 screws.

The sandwich clamp is the problem: it makes the top structural. If the top must
come off freely, PCB retention has to come off the top plate.

## Architecture

Three parts, each with one job:

1. **Case (walls)** — carries all mounting. Open top/bottom frame, plus **8
   heat-set inserts in the 4 corners** (one accessible from the top for the top
   plate, one from the bottom for the back cover). No new internal structure.
2. **Top plate** (two versions) — a flat panel that sits on the wall rim, held
   by 4 corner screws. Purely a lid; carries no structure.
3. **Back cover** — closes the open bottom, keeps its existing corner posts and
   support feet. Screws to the case. The PCB just **rests** on its posts.

### 1. Top mount (the headline change)

- The top panel stays **full 308 × 308 mm** and sits **on top of the wall rim**,
  edges flush with the case — the current look, no rebate.
- **4 heat-set inserts** in the 4 wall corners, accessible from the top (Ø4.0 mm
  boss holes, ~6 mm deep), at ~5–7 mm inset (in the corner/border).
- Each top panel has **4 countersunk M3 clearance holes** (Ø3.4 + 90° csink) at
  matching corners. Flush flat-head M3 screws.
- The **4 corner screws locate the panel** (close-fit holes). Alignment is only
  critical for the printed top (its 81 LED holes must sit over the PCB LEDs); a
  close-tolerance corner fit handles that. Optional: add 2 small locating pins on
  the rim for the printed top if needed (the plexi has nothing to align).
- Both tops are interchangeable: same 308 mm outline, same 4 corner holes.

**Printed top:** the current chessboard plate + the 4 corner holes. Keeps
squares / border / labels / 81 LED holes. Outline stays 308 mm.

**Plexiglass top:** a clear flat panel, 308 mm, 3 mm thick, with just the 4
corner holes (drilled or laser-cut — acrylic takes both cleanly). No LED holes
needed; light passes through the clear acrylic.

### 2. PCB mount (kept simple — rests on existing posts)

- **No change to where the PCB lives and no new parts.** It keeps sitting on the
  back cover's 4 corner posts at the 19 mm positions, exactly as now.
- Drop the long sandwich screws entirely. The PCB simply **rests** on the posts
  and is **captured**: posts below, top-plate underside ~2 mm above. It can lift
  at most ~2 mm and can't fall out. Right-side up on a table (normal use), it
  stays seated by gravity.
- No PCB screws, no internal case shelves. (If positive fastening is ever wanted,
  4 short screws into inserts in the post tops can be added later — not now.)

### 3. Back cover (now the bottom fastener)

- Keeps closing the open bottom, its corner posts, and its support feet.
- Attaches to the case with **4 corner screws from the bottom** into the 4 wall
  corners (bottom inserts) — separate from the top inserts (the ~22 mm-tall
  corner has room for a top insert and a bottom insert that don't meet).
- Removing the back cover (4 bottom screws) is how you get the PCB out.

### XY positions

- **Top-plate and back-cover screws** → the **4 outer wall corners** (~5–7 mm in
  from the edge). Same 4 corner columns, top insert + bottom insert each.
- **PCB** → rests inboard on the back-cover posts at the **19 mm** positions.
  No screws there.

## Vertical stack at a corner (schematic — heights unchanged, new fastening)

```
 top screw ↓  [▓ M3 flat-head, countersunk]
 ───────────  top panel, full 308, on the wall rim        z ≈ 6.5 → 3.5
   wall rim  ── insert (top) ──┐
 ─ ─ ─ ─ ─ ─  PCB rests on back-cover posts (~2 mm gap)   z 0 → 1.52
   ...controller / ESP32...    │  (wall corner column)
 ───────────  back cover       ── insert (bottom) ──┘      z −13.5 → −15.5
 bottom screw ↑ [M3]
```

## Screw / insert budget

| Location | Count | Screw | Insert |
|---|---|---|---|
| Top plate → case corners | 4 | M3 flat-head, ~8 mm | 4 (top) |
| Back cover → case corners | 4 | M3, ~6 mm | 4 (bottom) |
| PCB | 0 | — (rests on posts) | — |

**8 inserts, 8 screws total** — all in the 4 wall corners. Only the **4 top
screws** get touched to swap a top.

## Open items / decisions deferred to implementation

- **Back cover attachment** could be a snap-fit lip instead of 4 screws to save
  hardware — decide during modeling; screws assumed here for security.
- Exact screw lengths pending insert seating depths.
- Optional **2 locating pins** for the printed top if the 4-screw fit doesn't
  align the LED holes tightly enough.
- Plexi thickness (3 mm assumed); confirm the printed top's thickness so both
  tops present the same top surface height when swapped.

## Out of scope (later)

- Any pattern / etching on the plexi (staying clear).
- Side-panel cutouts (OLED / buttons / USB) — reverted; not part of this.
- Splitting the 308 mm parts for the 235 mm print bed.
