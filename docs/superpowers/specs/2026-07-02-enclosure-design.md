# OpenChess Enclosure — Design Spec

Date: 2026-07-02
Status: Draft for review. Sections 1–2 approved by user; sections 3–5
presented but not yet explicitly signed off (review this file to confirm).

This spec covers the **case ("bathtub") below the matrix PCB**, which
Claude designs in Fusion 360 via MCP. The **visible top plate + legs** are
designed by Paolo separately; this spec defines the interface between the
two so they mate.

---

## 1. Goal & constraints

- One-off personal build. Print on a **235 × 235 mm bed** (Ender 3 V2 / S1
  class). PLA.
- Look: a plain, standard chessboard casing. The light/dark squares are
  **not** on the case — they live on the matrix PCB silkscreen. The case
  top only needs **holes for the 81 corner LEDs** (that top plate is
  Paolo's part, not covered here beyond the interface).
- Design around the **split-board hardware** (matrix PCB on top, controller
  stacked underneath on standoffs, LiPo alongside), per
  `hardware/DESIGN_NOTES.md` §10.3.

## 2. Hardware the case must fit (verified facts)

- **Matrix PCB**: **282 × 282 mm, 1.6 mm thick** (edge-cut span confirmed
  from `hardware/hardware-board/openchess-board.kicad_pcb`; STEP exported to
  `mechanical/case/import/openchess-board.step`, product `openchess-board`,
  bare board, 188 KB).
- **Mounting holes**: 4× Ø3.2 mm (M3), **6 mm inset** from each board
  corner.
- **Controller PCB**: 58 × 71 mm, stacked ~11 mm below the matrix on M3
  brass standoffs via the J_MAIN↔J_CTRL 2×13 board-to-board connector.
- **LiPo battery**: reserve ~50 × 50 × 8 mm on the enclosure floor,
  alongside the controller (never sandwiched between PCBs).
- **Panel components** (flying leads to controller J3): SSD1306 OLED
  (~27 × 27 mm module, ~24 × 14 mm active window), 3× 12 mm panel-mount
  pushbuttons, panel-mount USB-C extension.

## 3. Architecture (approved)

Shallow square box, **~292 × 292 × ~28 mm external**. The matrix PCB is the
top surface. Internal cavity ~22 mm deep (controller on 11 mm standoffs +
8 mm battery + clearance).

**Printed parts — Claude's side (5 total):**

- **4× L-quadrant** — each an integrated print: corner floor + 2 outer
  walls + internal top-retaining lip + integral M3 corner boss. Footprint
  ~146 × 146 mm, fits the 235 bed. Prints floor-down, no supports.
- **1× service hatch** — flat plate ~80 × 120 × 3 mm covering an opening in
  one quadrant's floor.

The 4 quadrants meet in a `+` seam under the center of the PCB; the matrix
PCB's 4 corner screws tie all four quadrants together, putting the central
joint in tension rather than leaving it floating. Inner-seam flanges stop
~120 mm short of center to avoid a 4-way tolerance pile-up.

**Paolo's side (interface only):** one solid top plate ~282 × 282 mm
covering the PCB, with holes only for the 81 LEDs, plus 4 downward hollow
legs at the PCB mounting-hole positions.

## 4. Interfaces

### 4.1 Top-plate ↔ case (the critical join)

- Paolo's plate has **4 hollow legs**, one per corner, aligned to the PCB's
  M3 holes (6 mm inset).
- Each leg is **≤ 3.0 mm diameter** where it passes through the PCB's
  Ø3.2 mm hole (0.2 mm clearance), and lands on top of Claude's corner
  boss.
- **M3 × 16 mm socket-cap screw**, countersunk into the top plate's top
  surface, passes down through the hollow leg → through the PCB hole →
  into a **Ø5.0 mm × 5 mm heat-set insert** in Claude's boss.
- Result: unscrew 4 screws from the top to lift the whole top+PCB assembly
  off the bathtub. Removable, one-off-friendly.

### 4.2 Corner bosses (Claude's side)

- 4× boss, top face at the PCB underside height (PCB top flush with case
  wall top via a 4 mm × 1.6 mm inside rebate on each wall's top edge).
- Each boss carries one Ø5.0 × 5 mm M3 heat-set insert.

### 4.3 Quadrant-to-quadrant joinery

- Along each inner-seam flange (5 mm thick × 10 mm tall, ~120 mm long):
  **2× M3 clamping screws + 2× Ø4 mm steel dowel pins**. Dowels align,
  screws clamp.
- One mating face has M3 clearance holes, the other an M3 heat-set insert
  pocket; alternate direction around the ring so 3 quadrants are identical
  and the 4th differs only by carrying the side-panel + hatch features.

## 5. Side panel (one quadrant's outer wall)

145 mm wall, 20 mm usable height, ~10 mm end margins. Left→right:

| Feature | Cutout |
|---|---|
| USB-C panel-mount | 15 × 12 mm rect + 2× Ø2 mm mount holes @25 mm |
| OLED window | 24 × 14 mm rect |
| Button MODE | Ø12 mm through |
| Button SELECT | Ø12 mm through (15 mm c-c) |
| Button POWER | Ø12 mm through (15 mm c-c) |

## 6. Service hatch

- Rectangular opening ~80 × 120 mm in the side-panel quadrant's floor, over
  the controller + battery zone.
- 4× M3 heat-set inserts around the opening (underside); hatch plate has 4×
  Ø3.5 mm clearance holes + a 2 × 2 mm perimeter shoulder in a floor rebate.
- Open access to: DevKitC micro-USB (re-flash), battery swap, cable routing.

## 7. Materials & fasteners (case only)

- PLA, 0.2 mm layer, 3 walls, 15–20% infill. All parts print floor-down,
  no supports.
- 16× M3 brass heat-set inserts Ø5.0 × 5 mm (4 boss + 8 joinery + 4 hatch)
- 4× M3 × 16 mm socket-cap (top plate → bosses)
- 8× M3 × 8 mm socket-cap (quadrant joinery)
- 4× M3 × 4 mm socket-cap (hatch)
- 2× M2 × 6 mm (USB-C panel-mount)
- 8× Ø4 × 12 mm steel dowel pins (quadrant alignment)

## 8. Fusion coordinate system

Adopt the imported STEP's frame. Board lands offset (KiCad origin: board at
X 50→332, Y −50→−332). First step in Fusion: align a board corner to the
origin, then build the bathtub downward (−Z below the PCB underside, PCB top
at the case top).

## 9. Open items / notes

- Paolo's top plate (282 mm) also exceeds the 235 bed — he'll split it
  (likely along a chess file line). Does not affect Claude's parts.
- CLAUDE.md quotes the matrix board as "282 mm"; confirmed here.
- Build style (Paolo's choice): **one component at a time, show + confirm
  each in Fusion before moving on.** Start with the corner-boss piece so we
  can validate the top-plate-leg interface before committing all 5 parts.
- MCP: Fusion server registered in Claude Code as `fusion`
  (`http://localhost:27182/mcp`, Streamable HTTP). Tools:
  `fusion_mcp_read`, `fusion_mcp_execute`, `fusion_mcp_update`,
  `fusion_mcp_electronics_read`. Tools load at session start — a restart
  (ideally `claude --continue`) is required before Claude can drive Fusion.
