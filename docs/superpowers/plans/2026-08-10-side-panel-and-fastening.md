# Side Panel (OLED/Buttons/USB-C) + Insert-Free Fastening — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the modular OLED/buttons/USB-C side panel in Fusion (printable test part first, print-gate before touching the case), then cut the left-wall mount and replace all heat-set inserts with square-nut pockets.

**Architecture:** New `side_panel` component modeled **in place** at its final left-wall position (world x −13…−10.5). Export → print → fit-check gate. Only after the gate: cut the wall (rebate + opening + nut slots) and rework the 4 corner bosses (fill insert pockets, cut nut slots, move top-plate/back-cover holes).

**Tech Stack:** Fusion 360 via `fusion` MCP (`fusion_mcp_execute` Python, `fusion_mcp_read` screenshots). Spec: `docs/superpowers/specs/2026-08-10-side-panel-and-fastening-design.md`.

## Global Constraints

- **Fusion internal units = cm.** All world dims below in **mm**; divide by 10 in scripts.
- **≤2 features per MCP script** — heavier scripts drop the socket ("socket closed unexpectedly").
- **Occurrence transforms revert on ANY feature op.** After every feature task, run the electronics re-position check (Task 0 Step 4) before `doc.save()`. Use **MoveFeature** (not occurrence transforms) for anything that must survive.
- **Profile collection on faces:** when cutting holes sketched on a face, collect ONLY small profiles: `if p.areaProperties().area < 1.0`. Never cut all `sketch.profiles`.
- **Verify by face/body world coords or screenshots**, not `occ.boundingBox` (goes stale) and not `pointContainment` (unreliable on complex bodies).
- **yZ base-plane mapping** (identity component): sketch point `(a,b)` → world `(0, y=b, z=−a)`; extrude direction −X. xY plane: sketch `(a,b)` → world `(x=a, y=b, 0)`.
- Every script starts with the preamble:
  ```python
  import adsk.core as ac, adsk.fusion as af, math
  app = ac.Application.get(); d = af.Design.cast(app.activeProduct); root = d.rootComponent
  def P(x,y,z=0): return ac.Point3D.create(x,y,z)
  def V(o): return ac.ValueInput.createByReal(o)   # cm
  ```
- MCP connection: server accepts **only `127.0.0.1`**, not `localhost`. If "Invalid Host header": `claude mcp remove fusion && claude mcp add --transport http fusion http://127.0.0.1:27182/mcp`, then `/mcp` reconnect.
- Save the Fusion doc at the end of every task (`app.activeDocument.save('msg')`).

## Key coordinates (world mm)

| Item | Value |
|---|---|
| Left wall | outer face x=−13, inner face x=−3, face z 3.5→−13.5 (17 tall) |
| Panel faceplate | x −13→−10.5 (2.5 t), y 15→135 (120 long), z −13.5→3.5 |
| Item centerline | z = −5 (mid-face) |
| Screw A / B | y = 21 / y = 129, z = −5, axis = X |
| USB-C center | y = 32 (nearest front corner → shortest cable) |
| Buttons ×3 (Ø8.2) | y = 49, 63, 77 |
| OLED pocket center | y = 103 (pocket y 83.75→122.25) |
| Wall opening (after gate) | x −10.5→−3 through, y 19→131, z −11.5→1.5 (≥2 frame) |
| Corner screws | (−3,−3) (285,−3) (−3,285) (285,285), axis = Z |
| Square nut DIN 562 | 5.5×5.5×1.8 → slot 5.8 wide × 2.0 thick, +0.3 over-travel |

---

### Task 0: Pre-flight — reconnect, inventory, controller clearance

**Files:** none (live Fusion doc `openchess-board`).

**Interfaces:** Produces: recorded controller/ESP32 world bbox (mm) used by Tasks 1 & 6 to confirm/adjust panel y-range; confirmed component names.

- [ ] **Step 1: Verify MCP.** Call `fusion_mcp_read` (screenshot). If host error → re-register per Global Constraints. If socket-closed → Fusion busy; wait/dismiss dialogs.
- [ ] **Step 2: Inventory components.** Script: list `root.occurrences` names + each `bRepBodies` count. Expect: `board`, `top_plate`, `case`, `back_cover`, `openchess-controller v1`, `esp32_sockets`, `ESP32-DEVKITC`, `top_plate_plexi`, root mockup `Body1`.
- [ ] **Step 3: Record controller + ESP32 world extents** via proxy bodies:
  ```python
  out=[]
  for name in ['openchess-controller v1','esp32_sockets','ESP32-DEVKITC']:
      occ=[o for o in root.occurrences if o.name.startswith(name)][0]
      for b in occ.bRepBodies:
          bb=b.boundingBox
          out.append((name,[round(v*10,1) for v in (bb.minPoint.x,bb.minPoint.y,bb.minPoint.z,bb.maxPoint.x,bb.maxPoint.y,bb.maxPoint.z)]))
  print(out)
  ```
  **Record min-x and the y-range near x<20.** If any electronics body intrudes into x < 20 **and** y 15–135 **and** z < 0 → panel items may collide; shift the panel back (+y) until the button-barrel zone (x −10.5→+7, item y ±6, z −5±5) is clear. Note the final y-shift (default 0).
- [ ] **Step 4: Verify electronics are positioned** (guard used all sessions): controller min-x×10 ≥ 60mm means positioned; if reverted, run the re-position script from memory (`setToAlignCoordinateSystems` recipe) before any save.

### Task 1: `side_panel` component + faceplate

**Interfaces:** Produces: component `side_panel`, one body `panel` at x −13→−10.5, y 15→135, z −13.5→3.5.

- [ ] **Step 1: Create component + faceplate.** One script, 2 features (extrude + move):
  ```python
  occ=root.occurrences.addNewComponent(ac.Matrix3D.create()); comp=occ.component; comp.name='side_panel'
  sk=comp.sketches.add(comp.yZConstructionPlane)   # (a,b)->world(0, y=b, z=-a)
  sk.sketchCurves.sketchLines.addTwoPointRectangle(P(-0.35,1.5),P(1.35,13.5))  # z 3.5..-13.5, y 15..135
  ext=comp.features.extrudeFeatures.addSimple(sk.profiles.item(0),V(-0.25),af.FeatureOperations.NewBodyFeatureOperation)
  body=ext.bodies.item(0); body.name='panel'
  mv=ac.Matrix3D.create(); mv.translation=ac.Vector3D.create(-1.05,0,0)
  bc=ac.ObjectCollection.create(); bc.add(body)
  comp.features.moveFeatures.add(comp.features.moveFeatures.createInput2(bc)) if False else None
  mi=comp.features.moveFeatures.createInput2(bc); mi.defineAsFreeMove(mv); comp.features.moveFeatures.add(mi)
  bb=body.boundingBox; print([round(v*10,2) for v in (bb.minPoint.x,bb.maxPoint.x,bb.minPoint.y,bb.maxPoint.y,bb.minPoint.z,bb.maxPoint.z)])
  ```
- [ ] **Step 2: Verify** print = `[-13, -10.5, 15, 135, -13.5, 3.5]` (apply Task 0 y-shift if any).
- [ ] **Step 3:** Electronics guard (Task 0 Step 4) → `doc.save('side_panel faceplate')`.

### Task 2: Button holes + panel mounting screw holes

**Interfaces:** Consumes `side_panel/panel`. Produces: 3×Ø8.2 @ y 49/63/77; 2×Ø3.4+csink Ø6.2 @ y 21/129 (all z −5).

- [ ] **Step 1: Button holes.** Sketch on the **outer face** (find planar face with world x≈−13), circles r0.41 at the 3 positions; collect ONLY profiles with `area < 1.0`; cut two-sided 0.5cm (`setTwoSidesExtent`).
- [ ] **Step 2: Verify** via `fusion_mcp_read` screenshot (left view): 3 round holes centered on the face.
- [ ] **Step 3: Screw holes + countersinks.** Same face: 2 circles r0.17 → two-sided cut. Then csinks: 2 circles r0.31 on outer face → **tapered cut** (−45° taper, depth 0.155cm) *or* simpler: cut cylinders r0.31 depth 0.155 from outer face (flat-bottom counterbore acceptable for v1 test; note in print card).
- [ ] **Step 4:** Screenshot verify → electronics guard → save.

### Task 3: OLED window + pocket + clips

**Interfaces:** Consumes `panel`. Produces: window 24×7 through faceplate @ (y 103, z −5); rear pocket 38.5×12.5×4 deep with 1.2 walls; 2 retention nubs.

- [ ] **Step 1: Pocket walls (JOIN).** Sketch on **back face** (x=−10.5): two rects centered (y 103, z −5) — outer 40.9×14.9 (y 82.55→123.45, z −12.45→2.45; fits inside the panel face z −13.5→3.5), inner 38.5×12.5. Select the **ring** profile only → extrude JOIN +0.6cm in +X (walls reach x −4.5).
- [ ] **Step 2: Window cut.** Sketch on outer face: rect 24×7 centered (y103,z−5) → cut through faceplate only (distance 0.25cm, +X).
- [ ] **Step 3: Retention nubs.** On each long pocket wall inner face, a small wedge 4×0.4×0.6 at x −10.5+1.8 (module PCB 1.2 sits against faceplate; nub snaps over its back). Build as 2 tiny JOIN extrudes from sketches on the wall faces. If the sketch-on-wall-face is fiddly, acceptable v1 fallback: skip nubs, note "tape retention" on the print card.
- [ ] **Step 4:** Screenshot (front + back iso) → guard → save.

### Task 4: USB-C flange cutout

**Interfaces:** Consumes `panel`. Produces: port slot 10×5 rounded-ends @ (y 32, z −5) + 2×Ø2.6 flange screw holes @ y 32±9 (18mm spacing, **nominal — verify against real part**).

- [ ] **Step 1: Port slot.** Sketch on outer face: slot (two r2.5 arcs + lines, ends at y 29.5/34.5, z −5) → collect small profiles only → cut through 0.5cm two-sided.
- [ ] **Step 2: Flange screw holes.** Circles r0.13 at (y 23, z −5) and (y 41, z −5) → cut through. *(If Paolo measures the real flange before this task, substitute measured spacing/diameters.)*
- [ ] **Step 3:** Screenshot → guard → save.

### Task 5: Export STL + PRINT GATE 🛑

**Files:** Create `mechanical/side-panel/side-panel-v1.stl`, `mechanical/side-panel/README.md`.

- [ ] **Step 1: Export.**
  ```python
  em=d.exportManager
  occ=[o for o in root.occurrences if o.name.startswith('side_panel')][0]
  op=em.createSTLExportOptions(occ,'/Users/paolonessim/Projects/openchess/mechanical/side-panel/side-panel-v1.stl')
  op.meshRefinement=ac.MeshRefinementSettings.MeshRefinementHigh; em.execute(op)
  ```
- [ ] **Step 2: Print card** (`README.md`): orientation **outer face DOWN** (flat, no supports; pocket walls print up), PLA 0.2mm, 3 walls, ~20 min. Fit-check list: OLED drops into pocket + screen centered in window; 8mm buttons pass Ø8.2 + nut clamps on 2.5mm; USB-C flange screws align + port centered in slot; M3 flat-head sits ≤flush in csink.
- [ ] **Step 3: Commit** `git add mechanical/side-panel && git commit -m "feat(mech): side panel v1 test part"`.
- [ ] **Step 4: STOP — user prints & fit-checks.** Iterate Tasks 2–5 dims from real-part feedback (bump `-v2.stl`). **Do not start Task 6 until the user confirms all fits.**

### Task 6: Wall integration (AFTER gate)

**Interfaces:** Consumes final panel dims (incl. any y-shift / measured USB spacing). Produces: left-wall rebate + opening + 2 nut slots in `case/walls`.

- [ ] **Step 1: Rebate.** Sketch on wall **outer face** (x=−13): rect y 14.85→135.15, full face height → cut 0.25cm (+X). (0.15 clearance per side.)
- [ ] **Step 2: Opening.** Sketch on rebate floor (x=−10.5): rect y 19→131, z −11.5→1.5 → cut through 0.75cm (+X). Collect small profiles only.
- [ ] **Step 3: Nut slots ×2** for panel screws (axis X). M3×8 from the outer face (x −13) tips out at x −5, so the nut (1.8 thick) sits at x −7.75→−5.75. Cut a vertical drop-slot from the wall **top face** (z 3.5): rect 2.0 in x (−7.75→−5.75) × 5.8 in y (centered y 21 / 129), cut down to z −7.75 (nut is 5.5 tall around the z −5 screw axis). Nut drops in from the top; the top plate covers the slot mouth.
- [ ] **Step 4: Verify** screenshot outside-left + inside; check a mid-wall point far from the opening is still solid (the walls-cut bug). Guard → save.
- [ ] **Step 5: Panel screws now:** M3×8 flat-head through panel csink → wall nut. Confirm on screenshot that slot y-centers match panel holes exactly (y 21/129 + shift).

### Task 7: Corner bosses — fill inserts, cut nut slots

**Interfaces:** Produces at each of 4 corners: filled Ø4 pockets; Ø3.4 through-hole at screw XY; top nut slot (nut z 0.5→−1.3) + bottom nut slot (nut z −9.5→−7.7), sliding from the boss **inner corner face**.

Corner screw XY: (−3,−3) (285,−3) (−3,285) (285,285). Do **one corner per script pair** (8 small scripts) to respect the 2-feature limit.

- [ ] **Step 1: Fill pockets** (per corner): JOIN-extrude two Ø4.0 cylinders — top face down 6mm, bottom face up 6mm — at the screw XY. Re-fetch the walls body reference each script (stale-reference gotcha).
- [ ] **Step 2: Through-hole:** sketch circle r0.17 at screw XY on boss top face → cut through-all downward (small-profile filter).
- [ ] **Step 3: Top nut slot** = horizontal **side-entry channel**, z-span 0.5→−1.3 (2.0 tall: 1.8 nut + 0.2). Sketch the footprint on the **xY plane** (z=0, base plane — never an offset plane): rect 5.8 wide centered on the screw XY, running from the boss **inner face** to 0.3 past the screw axis. Extrude two-sided so the cut lands at world z −1.3→0.5 (`setTwoSidesExtent`; exit criterion = the resulting cut's z-span, flip a sign if it lands wrong). Nut slides in horizontally from inside the case; invisible outside.
- [ ] **Step 4: Bottom nut slot:** same footprint, cut z-span −9.5→−7.7 (two-sided distances from the z=0 sketch; again verify the resulting z-span, not the input signs). Back-cover M3×8 tips out at z −7.5, protruding 0.2 past the nut.
- [ ] **Step 5: Verify per corner:** screenshot + check boss still solid at rim mid-edge. Guard → save after each corner.

### Task 8: Move top-plate + back-cover screw holes to the (−3,−3) family

**Interfaces:** Consumes corner XY. Produces: printed `top_plate` and `back_cover` each with 4×Ø3.4 (+csink Ø6.2 where flat-heads seat) at (−3,−3)(285,−3)(−3,285)(285,285); old-position holes filled.

- [ ] **Step 1: Locate old holes:** query `top_plate` / `back_cover` bodies for cylindrical faces r≈1.7mm; print their world XY centers.
- [ ] **Step 2: Fill old holes:** per hole, JOIN-extrude a Ø3.4 plug spanning the exact plate thickness (top_plate z 3.5→6.5; back_cover z −13.5→−15.5); csink volumes too (Ø6.2 cone/cylinder plugs) if present.
- [ ] **Step 3: Cut new holes:** top_plate — 4×Ø3.4 through + csink Ø6.2×90° from the **top** face (flat-heads flush). back_cover — 4×Ø3.4 through + csink from the **bottom** face. Small-profile filter, ≤2 features per script.
- [ ] **Step 4: Alignment check:** all four parts' holes concentric at each corner (screenshot top ortho — remember top view mirrors X; verify by coordinates instead: print hole-face centers of case/top_plate/plexi/back_cover, all must match (−3,−3) family ±0.05).
- [ ] **Step 5:** Guard → save.

### Task 9: Final verify + exports + docs

- [ ] **Step 1: Full-model screenshots** (iso, left, bottom) — check: panel flush in wall, no wall damage, corners solid.
- [ ] **Step 2: Re-export** final `side-panel.stl` (if dims changed post-gate) + `back-cover.stl` + case STL when Paolo is ready to print; save to `mechanical/exports/`.
- [ ] **Step 3: Update memory + STATUS:** append to `openchess-case-cad.md`: nut-slot positions, panel coords, gate results. Update `STATUS.md` current phase.
- [ ] **Step 4: Commit** `git add mechanical docs && git commit -m "feat(mech): side panel integrated + square-nut fastening"`.

---

## Self-review notes

- Spec coverage: Part A → Tasks 1–5; Part B → Task 6; Part C → Tasks 7–8; shopping list → user-side (nuts/screws ordered separately); risks (USB flange fit, OLED clips, wall stiffness) → gated at Task 5 / verified Task 6.
- Task 7 Step 3/4 extrude-direction signs are the riskiest lines (two-sided extent signs vary); the step's exit criterion is the **resulting cut z-span**, not the input signs — verify and flip if wrong.
- USB-C flange numbers are nominal by design; Task 4 says substitute measured values, Task 6 consumes finals only after the gate.
