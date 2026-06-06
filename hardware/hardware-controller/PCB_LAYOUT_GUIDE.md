# Controller PCB — Layout Guide

This is the layout companion to `SCHEMATIC_GUIDE.md`. It walks you
through KiCad's PCB Editor step-by-step: what shortcuts to use, what
menus to click, where each component goes, how to route, how to do
ground pour, how to run DRC, and how to export the gerber files.

Work through the sections in order. KiCad shortcuts shown in `boxed`
format. Every action either gives you a keyboard shortcut or a menu
path.

---

## 0. Open the PCB editor

If you've just imported the schematic into PCB layout, you should
already be in KiCad's PCB Editor (the icon looks like an IC chip,
not the schematic icon).

If not:
1. From the KiCad project window, double-click `openchess-controller.kicad_pcb`
2. Or in the Schematic Editor: **Tools → Open PCB Editor**

The PCB Editor opens with all your footprints laid out roughly at
schematic positions (the "ratsnest dump" you've already seen).

---

## 1. KiCad PCB Editor essentials

### 1.1 The Layer panel (right side of screen)

KiCad shows a list of layers on the right. The active layer is the
one you'll route on when you start drawing traces. Click any layer
name to make it active. Toggle the eye icon next to a layer to show/
hide it without changing active layer.

Layers you'll use most:

| Layer | Purpose |
|---|---|
| **F.Cu** (red, top) | Top copper — most signals route here |
| **B.Cu** (green/blue, bottom) | Bottom copper — ground pour + some signals |
| **F.Mask** | Top solder mask (negative — copper showing through means no mask) |
| **F.Silks** | Top silkscreen text + outlines |
| **Edge.Cuts** | Board outline — defines the PCB shape |
| **User.Drawings** | Notes / annotations that won't be fabricated |

### 1.2 Shortcuts you'll use constantly

| Key | What it does |
|---|---|
| `M` | Move selected item (click first to select) |
| `R` | Rotate selected item 90° CCW |
| `F` | Flip selected item to the other side of the board |
| `G` | Grab + move (drags connected traces with the part) |
| `E` | Edit properties of selected item |
| `Esc` | Cancel current action |
| `Del` | Delete selected item |
| `X` | Start drawing a trace from cursor position |
| `V` | Add a via at cursor position (during routing) |
| `Tab` | (during routing) Switch routing layer + auto-add via |
| `W` | (during routing) Cycle through trace widths |
| `B` | Fill all zones (e.g., refresh GND pour) |
| `U` | Unfill all zones |
| `Ctrl+Z` | Undo |
| `Ctrl+Shift+M` | Show/hide messages panel |
| `Ctrl+Home` | Zoom to fit board on screen |
| `+` / `-` | Cycle visible layers up/down |
| `Page Up` / `Page Down` | Switch active layer between F.Cu and B.Cu |
| `S` | Toggle grid display |
| `F5` | Open 3D viewer |
| `Ctrl+F` | Find a specific component by reference |

### 1.3 Grid setup

A grid that doesn't match the pad spacing will cause off-grid
placement. Set this once:

1. **View → Grid Settings** (or right-click empty area → "Grid")
2. Set grid to **0.5 mm** for component placement (fine enough to nudge but coarse enough for snap-to)
3. Switch to **0.1 mm** for fine adjustments during routing if needed

Toggle grid visibility with `S`.

### 1.4 Units

PCB layout works in either mils or mm. Pick one and stay consistent.
**Recommend mm** since the schematic guide uses mm.

**Preferences → Preferences → Common → Editing Options → Default units → millimeters**

### 1.5 3D view (sanity check)

Press `F5` any time to open the 3D viewer. Lets you check if
components physically collide, mounting holes line up, silkscreen
looks OK, etc.

Close with the X on the 3D window (don't close the PCB editor — the
3D viewer is a separate panel).

---

## 2. Set up the board (do this BEFORE placing anything)

These setup steps live in **File → Board Setup**. Do them all now so
your trace widths and net classes are correct from the start.

### 2.1 Net classes (set trace widths per net)

1. **File → Board Setup**
2. Navigate to **Design Rules → Net Classes** in the left tree
3. You should see a "Default" class — leave its width at **0.25 mm**
4. Click **+ Add Net Class** at the top of the table
5. Name it **"Power"**
6. Set its values:
   - **Clearance**: 0.15 mm
   - **Track Width**: **0.75 mm** (30 mil — for +5V_LED)
   - Via dimensions can stay default
7. Click **+ Add Net Class** again
8. Name it **"Power_3V3"**
9. Set Track Width: **0.4 mm** (15 mil — for +3V3)
10. Switch to the **Net Class Memberships** tab
11. **Move each net** from "Default" to the appropriate class:
    - `+5V_LED` → **Power** class
    - `GND` → **Power** class (we'll use a plane mostly, but traces should be wide)
    - `+3V3` → **Power_3V3** class
    - Everything else stays in **Default**
12. Click **OK** to save

Now whenever you route a trace, it uses the right width automatically
based on which net you're routing.

### 2.2 Design rules (clearance + minimum)

Still in **File → Board Setup**:

1. Navigate to **Design Rules → Constraints**
2. Set:
   - **Minimum clearance**: 0.15 mm (JLCPCB standard)
   - **Minimum track width**: 0.15 mm (JLCPCB standard)
   - **Minimum annular width**: 0.15 mm
3. Click **OK**

These prevent you from accidentally drawing things JLCPCB can't fab.

---

## 3. Board outline (draw the PCB shape)

The board outline lives on the **Edge.Cuts** layer.

### 3.1 Recommended dimensions

**80 mm × 90 mm rectangle** as a starting point. We'll shrink later
if there's extra space after placement.

### 3.2 Draw the rectangle

1. Click the **"Edge.Cuts"** layer in the right Layer panel to make
   it active
2. **Place → Add Graphic Lines** (or look for the line tool in the
   right toolbar — pencil icon)
3. Click to set the first corner of your board (e.g., origin 0,0)
4. Click to set each subsequent corner — 4 clicks for a rectangle
5. End back at the starting corner to close the shape
6. Press `Esc` to exit drawing mode

Alternatively for a perfect rectangle:
1. **Place → Add Rectangle** (or click rectangle tool)
2. Drag from corner to corner

### 3.3 Set the board origin

The "drill origin" is the reference point JLCPCB uses for drill
positions. Set it at a board corner:

1. **Place → Drill/Place File Origin**
2. Click on the bottom-left corner of your board outline
3. The origin marker (a small target) snaps there

### 3.4 Verify

Press `F5` to open the 3D viewer — you should see a green rectangle
representing your board. If it's not closed (a polygon, not a
rectangle), you'll see weird shapes. Go back and fix the edges.

---

## 4. Mounting holes (4 corners — CRITICAL)

Replace the current MH1–MH4 (which are in a vertical line) with 4
corner-mounted ones.

### 4.1 Delete the current MH1–MH4

1. Click on MH1 to select it
2. Press `Del` to remove it
3. Repeat for MH2, MH3, MH4

### 4.2 Add 4 corner mounting holes

1. Press `A` (or **Place → Add Footprint**)
2. In the search box type "**MountingHole_3.2mm_M3**"
3. Pick `MountingHole:MountingHole_3.2mm_M3` from the list
4. Click in the top-left corner of your board, ~5 mm in from each edge
5. The footprint places. KiCad immediately offers to place another —
   click in the top-right corner, ~5 mm in
6. Click in the bottom-left and bottom-right corners similarly
7. `Esc` when done

### 4.3 Annotate references

The new mounting holes need ref designators. After placement:

1. **Tools → Update Schematic from PCB** (so the schematic shows MH1–MH4
   in the right positions when you re-import the schematic)
2. Or manually: click each new mounting hole, press `E`, set Reference
   to MH1, MH2, MH3, MH4

### 4.4 Verify alignment

Press `F5` for 3D view. You should see 4 holes at the 4 corners of
the green board. **Measure** (in 2D view, press `Ctrl+Shift+M` for
the measurement tool) that they're all 5 mm in from their respective
edges.

---

## 5. Component placement (move into zones)

This is the meat of the layout. We've defined 6 zones in §6 below
based on the schematic. Now you actually move components into them.

### 5.1 Tips for moving components

- Click once to select a component (highlights in the standard color)
- Press `M` to start moving — the component follows your cursor
- Click to drop, or `Esc` to cancel
- Press `R` while moving to rotate 90° CCW
- Press `F` to flip to bottom layer (rarely needed for through-hole)
- Hold `Ctrl` while clicking to select multiple components
- Right-click → **Position** → **Set Position** to type exact coordinates

### 5.2 Snap to grid

With grid at 0.5 mm, components snap to that grid. Press `S` to
toggle grid visibility on/off if you want to see the snap points.

### 5.3 Use the 3D view as a sanity check

After each major component move, press `F5` to see how it looks in
3D. Catches collisions and orientation issues quickly.

---

## 6. Component placement zones

Here's where each component goes. Move them one zone at a time, then
sanity-check before moving on.

### 6.1 Zone A — M1 (Lipo Rider Plus) — TOP RIGHT corner of the PCB

M1's footprint is ~38 × 23 mm. It has 8 through-holes for the pin
header + 4 corner non-plated mounting holes for the daughterboard.

**Place it**:

1. Click M1 in the 2D view
2. Press `M`
3. Move it to the top-right area of the board
4. Press `R` to rotate so M1's 8-pin row points toward the BOTTOM
   (which means the USB-C jack and slide switch face the top edge of
   the PCB — and the panel/enclosure side wall)
5. Click to drop, leaving ~5 mm clearance from the top edge

**Now place these next to M1**:

- **C1, C2** (bulk caps): place within 10 mm of M1 pin 4 (the "5V"
  pin). Use the 0805 pad orientation that minimizes trace length.
- **R14, R15, C12** (battery monitor): place within 15 mm of M1 pin 6
  (the "BAT" pad).

### 6.2 Zone B — ESP32-DevKitC socket (U2) — LEFT side of PCB

U2 is the symbol for the two 1×19 female header sockets that the
DevKitC plugs into.

**Place it**:

1. Click U2, press `M`
2. Move to the left side of the board, oriented vertically (so the
   DevKitC's USB micro-B connector points to the top or bottom edge)
3. Click to drop, leaving ~10 mm clearance from the left edge

**Now place these on the right edge of U2** (near the S0–S7 GPIO pins
on the J3-side socket):

- **R1–R8** (row pullups): stack them vertically just to the right of
  U2's right edge, near pins 26–37 of the DevKitC (S0–S7 inputs).
  Each pullup connects from its Sx net to +3V3.
- **D2** (Schottky): place immediately above U2's pin 19 (the "5V"
  pin on the right strip). Anode toward where +5V_LED comes from
  (likely the top of the board near M1), cathode connecting to U2
  pin 19.

### 6.3 Zone C — Column driver (U6) — BETWEEN U2 and J1

U6 (TBD62783A) is a DIP-18 or SOIC-18W.

**Place it**:

1. Click U6, press `M`
2. Move it to roughly the center of the board
3. Press `R` if needed so U6's outputs (pins 11–18) point TOWARD J1
4. Click to drop

**Now place C11**:

- **C11** (100 nF bypass): place within 5 mm of U6 pin 9 (VCC)

### 6.4 Zone D — Matrix connector (J1) — BOTTOM of the PCB

J1 is the 2×13 male pin header that mates with the matrix board.

**Place it**:

1. Click J1, press `M`
2. Move to the bottom-center of the board (or wherever it will mate
   with the matrix board's J_CTRL on the back side)
3. Orient horizontally so the pin rows are parallel to the bottom edge
4. Click to drop, leaving ~5 mm clearance from the bottom edge

**Pin 1 should be near U6's pin 18 (output O1)** so the column
outputs flow straight down to J1's column-power pins.

### 6.5 Zone E — Level shifter (U3) — BETWEEN U2 and J1

U3 (74AHCT125) is SOIC-14.

**Place it**:

1. Click U3, press `M`
2. Move it to between U2 (LED_DATA source) and J1 (LED_DATA_5V dest)
3. Orient so the input pins face U2 and the output pin faces J1
4. Click to drop

**Now place C5 and R11**:

- **C5** (100 nF bypass): within 5 mm of U3 pin 14 (VCC)
- **R11** (33 Ω LED series): immediately to the right of U3's gate A
  output (pin 3), oriented so its other end becomes the LED_DATA_5V
  net going to J1

### 6.6 Zone F — Panel connector + test points — BOTTOM EDGE

**J3** (J_PANEL JST XH 10-pin):

1. Click J3, press `M`
2. Move to one corner of the bottom edge (probably opposite from M1's
   USB-C side, but adjacent to it works too)
3. Orient so the harness exits clean

**R36, R37** (button pullups): place within 10 mm of J3 pins 6 and 7

**Test points TP1–TPn**:

- For a hobby build: keep TP1, TP3, TP6 (3V3 hidden — covered by power
  ports) — the most useful 5–10 TPs. Delete the rest.
- To delete a TP: click it, press `Del`. Or click the schematic and
  re-sync.
- Place the remaining TPs along an unused board edge, in a row, with
  the silkscreen label visible

### 6.7 Fiducials

If you're going to JLCPCB assembly, keep FID1–FID3 placed in a
non-collinear triangle on the top face of the board (at least ~5 mm
in from any board edge).

If you're hand-soldering everything: delete FID1–FID3.

### 6.8 Verify after each zone

After moving a zone's components, press `F5` for the 3D view. Verify:

- No components overlap
- All pads are within the board outline
- Component orientations look sensible (e.g., USB-C jacks face the
  right way, pin 1 markers visible)

---

## 7. Route the traces

Now connect everything. KiCad has TWO routers:

- **Manual routing**: you draw each trace by clicking. Fine control.
- **Interactive routing**: same but with automatic via insertion when
  switching layers (`Tab` during routing). Recommended.

### 7.1 Pick a router mode

**Route → Interactive Router** mode — leave it at the default.

### 7.2 Start a trace

1. Make sure the **F.Cu** layer is active (click "F.Cu" in the right
   Layer panel)
2. Hover over the pad you want to start from
3. Press `X` (or click the route track icon in the toolbar)
4. Click on the start pad
5. Move the cursor along your planned path. Click to set bend points
6. Click on the end pad to finish
7. `Esc` to exit routing

### 7.3 Switch layers during routing

While routing on F.Cu, if you need to drop to B.Cu (e.g., to route
under another trace):

1. Press `Tab` — KiCad auto-inserts a via and continues on B.Cu
2. Press `Tab` again to switch back

You can also use `V` to manually drop a via.

### 7.4 Trace widths

KiCad uses the net's class to set width automatically. If you set up
the Power class in §2.1, then routing `+5V_LED` uses 0.75 mm wide
traces. Other nets use 0.25 mm.

To check: while routing, press `W` to cycle through the available
widths for the current net.

### 7.5 Routing order

Route in this priority order:

#### Step 1: Power rails first

1. Route `+5V_LED` from M1 pin 4 → C1 → C2 → U6 pin 9 → U3 pin 14
   → D2 anode → J1 power pins (any of pins 1, 3, 5, 25)
   - Use F.Cu (top layer)
   - Aim for star routing where possible (all branches from one node
     near M1)
   - 0.75 mm width

2. Route `+3V3` from M1 pin 1 → R1 (through R1...R8 connection) →
   R36 → R37 → J3 pin 1
   - F.Cu, 0.4 mm width

3. **Don't** route GND yet — we'll use a plane (§8).

#### Step 2: High-speed signals

4. Route `LED_DATA` from U2 pin 7 (GPIO32) to U3 pin 2
   - Short trace, ~20–30 mm
   - F.Cu, 0.25 mm

5. Route `LED_DATA_5V` from U3 pin 3 → R11 → J1 pin 7
   - Short trace, ~30 mm max
   - F.Cu, 0.25 mm
   - **Don't break GND plane underneath this trace**

#### Step 3: D2 path

6. Route from D2's cathode to U2 pin 19
   - Short trace
   - 0.4 mm width (it's the path from boost to AMS1117, carries ~150 mA)
   - Add a PWR_FLAG-equivalent — wait, that's a schematic thing, not
     layout. Just route the trace.

7. Route the M1 BAT pad (pin 6) → R14 → R15/C12 junction → U2 pin 5
   (GPIO34/VBAT_MON sense)
   - Short trace, microamp-current
   - 0.25 mm

#### Step 4: Matrix scan signals

8. Route column drives: 8 traces from U2's column-drive GPIOs to U6's
   inputs (I1–I8, pins 1–8)
   - Run them as a parallel bus across the middle of the board
   - 0.25 mm

9. Route U6 outputs (O1–O8) to J1's column-power pins (CA_PWR–CH_PWR,
   pins 17–24). Short, parallel traces.

10. Route row sense (S0–S7) from R1–R8 / U2 GPIOs to J1 pins 9–16.
    - Run as another bus on top of the column drive bus (different
      pin order)

#### Step 5: I²C and buttons

11. Route I2C_SDA and I2C_SCL from U2 to J3 pins 3 and 4. **AVOID
    routing under M1** — go around the module.
12. Route BTN_POWER, BTN_MODE, BTN_SELECT from J3 to U2.

### 7.6 Watch the ratsnest

The thin lines that show "this should be connected" disappear as you
route. When all the ratsnest lines are gone, you've routed everything.

### 7.7 Edit a trace

If you placed a bad trace:

1. Click on the trace segment
2. Press `Del` to delete it, or `M` to move it
3. Or right-click the trace → **Properties** to change width/layer

---

## 8. Ground plane (B.Cu layer)

The whole bottom layer becomes a ground pour. This gives clean return
currents and shielding.

### 8.1 Switch to B.Cu

1. Click "**B.Cu**" in the right Layer panel to make it active
2. (You can also toggle visibility of F.Cu by clicking its eye icon
   to see the bottom clearly)

### 8.2 Draw the GND zone

1. **Place → Add Filled Zone** (or click the zone tool in the right
   toolbar)
2. A "Copper Zone Properties" dialog opens
3. Set:
   - **Net**: `GND`
   - **Layer**: `B.Cu`
   - **Pad connection**: Thermal reliefs (default)
4. Click **OK**
5. Click corners of the zone to define its outline — typically you
   want the zone to follow the board outline. Click the 4 board
   corners, then double-click to close.

### 8.3 Fill the zone

The zone shows as an outlined area, not filled yet.

1. Press `B` to fill all zones
2. The zone fills with green copper, leaving gaps around components
   and traces (cleanly)

### 8.4 Verify GND connectivity

1. Click on a GND pad somewhere on the board (e.g., GND pin of C1)
2. The ratsnest line should now be **gone** — connected via the plane

If you see ratsnest lines still going to GND pads, that means the
GND plane didn't reach them. Common reasons:

- The pad is isolated by other traces blocking copper flow → route a
  short trace from the pad to a nearby GND-plane area, or add a via
  to jump to the B.Cu plane

### 8.5 Re-fill after every change

The zone doesn't update automatically when you move components or
add traces. Press `B` after any change to re-fill, or `U` to unfill
temporarily.

---

## 9. Silkscreen + labels

Component refs are auto-placed but often overlap with the part body.
Clean them up:

### 9.1 Adjust ref designators

For each component:

1. Click the silkscreen text (e.g., "M1", "U2", "R1")
2. Press `M` to move it
3. Place it just outside the component body, readable orientation
4. Click to drop

Or use the **Tools → Edit Component References** dialog to
batch-adjust.

### 9.2 Add custom labels

1. Click "**F.Silks**" in the Layer panel
2. **Place → Add Text** (`T`)
3. Type your label text
4. Click to place

Useful labels to add:

- "OpenChess Controller rev 0.1" — in a corner
- "USB-C" arrow pointing at M1's USB-C jack
- "Pin 1" dots at J1, U2, M1 pin 1 positions
- Test point net names if not already silkscreened

### 9.3 Avoid silkscreen on pads

KiCad usually keeps silkscreen off pads automatically, but check:
in DRC (§10), watch for "silkscreen overlapping pad" warnings.

---

## 10. Run DRC

Design Rule Check verifies your layout is fab-ready.

### 10.1 Run DRC

1. **Inspect → Design Rules Checker** (or `Ctrl+Shift+B`)
2. Click **Run DRC**
3. Watch the message panel

### 10.2 Common errors

| Error | Meaning | Fix |
|---|---|---|
| **Clearance violation** | Two copper features too close | Move one farther apart |
| **Unconnected items** | A net has unrouted ratsnest lines | Route the missing trace |
| **Silkscreen overlapping pad** | Text touches a copper pad | Move text or shrink it |
| **Annular ring too small** | Via/pad annular ring < minimum | Increase pad diameter |
| **Hole drill smaller than min** | Drill smaller than rule allows | Increase drill size |

### 10.3 Verify

Click each DRC error in the list to highlight the location on the
board. Fix and re-run DRC.

Target: **0 errors**. Warnings can sometimes be accepted (e.g.,
"footprint type mismatch" for footprints you intentionally chose).

---

## 11. Mechanical verification

Press `F5` for 3D view and check:

- 4 corner mounting holes visible at the right positions
- M1 footprint area looks correct
- U2 (DevKit socket) — the 2×1×19 female headers should be visible
- All ICs (U3, U6) are placed and oriented sensibly
- No components extend beyond the board edge
- Pin 1 markers are present on connectors

---

## 12. Export fab files

When DRC is clean:

### 12.1 Generate gerbers

1. **File → Plot**
2. In the dialog:
   - **Output directory**: `gerbers/`
   - **Layers to plot**: Check F.Cu, B.Cu, F.Mask, B.Mask, F.Silks, B.Silks, Edge.Cuts
   - **Use Protel filename extensions**: ON (JLCPCB prefers)
3. Click **Plot**
4. Click **Close**

This creates a folder with 7 files (one per layer).

### 12.2 Generate drill file

1. Back in **File → Plot**
2. Click **Generate Drill Files**
3. In the dialog:
   - **Drill units**: Inches (or mm — both work at JLCPCB)
   - **Drill origin**: Drill/place file origin
   - **Output**: same `gerbers/` folder
4. Click **Generate Drill File**

### 12.3 Zip the gerbers folder

In Finder or Terminal:

```bash
cd /Users/paolonessim/Projects/openchess/hardware/hardware-controller
zip -r openchess-controller-gerbers.zip gerbers/
```

### 12.4 Generate BOM (Bill of Materials)

1. **Tools → Generate BOM**
2. Or use the schematic editor's BOM tool
3. Save as CSV — include reference, value, footprint, and ideally
   LCSC part numbers if you plan to use JLCPCB assembly

### 12.5 Generate CPL (Component Placement)

For JLCPCB assembly:

1. **File → Fabrication Outputs → Component Placement (.pos)**
2. Output: `gerbers/` folder
3. **Units**: mm
4. **Files**: separate for front and back, or combined
5. Click **Generate Position File**

---

## 13. Send to JLCPCB

1. Go to jlcpcb.com
2. Click **PCB Manufacture**
3. Upload your gerber ZIP
4. Settings:
   - Material: FR-4
   - Layers: 2
   - Thickness: 1.6 mm
   - Color: Green (cheapest) or whatever
   - Surface finish: HASL (cheapest) or ENIG ($+ for flatter pads)
5. (Optional) Add SMD assembly: upload BOM.csv and CPL.csv
6. Quote + checkout

Total cost for a single 80×90 mm board, 5 pieces, no assembly: ~$5
+ shipping (~$15–25 depending on speed).

With assembly: add ~$15–30 depending on parts count.

---

## 14. After the boards arrive — first power-on

**Before plugging anything into M1's USB-C**:

1. Multimeter continuity check: probe between adjacent pads on M1's
   pin header to verify no shorts. Especially:
   - `+5V_LED` ↔ `GND` should read open (no short)
   - `+3V3` ↔ `GND` should read open
2. Visual inspection: look for solder bridges between SMD IC pins
3. Solder the M1 daughterboard and DevKit sockets last (after SMD
   work is done)

**First power-on**:

1. Solder M1 in place. **Verify M1's slide switch is set to "ON"**.
2. Plug in the LiPo battery to M1's JST 2.0
3. Multimeter on `+5V_LED` test point → should read ~5.1 V
4. Multimeter on `+3V3` test point → should read ~3.3 V
5. If voltages are right: plug in DevKit, watch for power LED on DevKit
6. Connect OLED + buttons harness, write firmware to scan I²C and
   show "Hello" on the OLED

If any voltage is wrong, **unplug the battery** and re-check before
proceeding.

---

## 15. Common mistakes to avoid

- ❌ Mounting holes in the middle instead of corners
- ❌ Forgetting to set net classes → traces are all default width
- ❌ Not filling GND zone (press `B` after every change)
- ❌ Routing high-speed signals over a GND plane break
- ❌ Forgetting decoupling caps near IC VCC pins
- ❌ Putting D2 nowhere near U2 pin 19
- ❌ Forgetting to mark pin 1 on connectors
- ❌ Submitting gerbers with leftover ratsnest lines (= unrouted nets)

---

## 16. References

- **`SCHEMATIC_GUIDE.md`** — net list, what connects to what
- **`hardware/DESIGN_NOTES.md`** — overall design + assembly mechanics
- **`docs/inter-board-connector.md`** — J_MAIN ↔ J_CTRL contract
- **JLCPCB Capabilities**: https://jlcpcb.com/capabilities/Capabilities
- **KiCad PCB Editor docs**: https://docs.kicad.org/8.0/en/pcbnew/pcbnew.html

---

## 17. Iteration loop

After each placement/routing pass:

1. Save the file (`Ctrl+S`)
2. Run DRC (`Ctrl+Shift+B`)
3. Fix errors
4. Re-fill zones (`B`)
5. Re-run DRC
6. 3D view (`F5`) — sanity check
7. Repeat

When all errors are gone and the 3D view looks right, send me a
screenshot of the 3D view before exporting to JLCPCB. I'll spot-check.
