# WROOM Core Snippet — Paste Instructions

Snippet file: `scripts/snippets/wroom_core.kicad_sch`

## Step 1 — Delete v1 symbols from the main schematic

Open `hardware/hardware-controller-v2/openchess-controller.kicad_sch` in KiCad.

Delete these three symbols (click each, press Delete):

- **U2** — ESP32-DevKitC (large 38-pin module symbol)
- **M1** — Lipo Rider Plus pin socket
- **D2** — SS14 Schottky diode

Leave any dangling global labels in place. Task 9 will rewire them. Ignore ERC errors for now.

## Step 2 — Open the snippet in a second window

In KiCad Schematic Editor: **File → Open** and navigate to:

```
hardware/hardware-controller-v2/scripts/snippets/wroom_core.kicad_sch
```

This opens the snippet in a new schematic editor window.

## Step 3 — Copy all snippet contents

In the snippet window: **Edit → Select All** (Ctrl+A), then **Edit → Copy** (Ctrl+C).

## Step 4 — Paste into main schematic

Switch back to the main schematic window. Click on a **clear area of canvas** (away from existing circuitry — the bottom-right quadrant is typically free).

**Edit → Paste** (Ctrl+V), then click to place.

## Step 5 — Assign references (if prompted)

KiCad may ask about reference conflicts. Choose **"Keep existing references"** so U2, C13–C15, R20, SW_EN, SW_BOOT keep their designators.

## Step 6 — Save

**File → Save** (Ctrl+S).

## Notes

- Dangling labels left over from deleting U2/M1/D2 are intentional — Task 9 will wire them to the new U2.
- The snippet uses `+3.3V` and `GND` power nets matching the rest of the v2 schematic.
- SW_EN and SW_BOOT use `SW_Push` footprints; update to your chosen tactile switch footprint (e.g. `SW_SPST_SKQG_WithoutStem`) when assigning footprints.
- C13 (100nF) uses 0402, C14 (10µF) uses 0805, C15 (1µF) uses 0402, R20 (10k) uses 0402 — adjust if you prefer different sizes.
