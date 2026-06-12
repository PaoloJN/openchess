# Project Cleanup Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Synchronize non-hardware OpenChess documentation with the current KiCad schematic and PCB state while leaving `hardware/` read-only.

**Architecture:** Treat active KiCad schematic and PCB files as the hardware evidence, then update root docs, active docs, and firmware docs to match. Keep source trees in place; the cleanup is orientation and accuracy, not a code reorganization.

**Tech Stack:** Markdown documentation, KiCad file inspection, ripgrep verification, git diff checks.

---

### Task 1: Root Orientation Docs

**Files:**
- Modify: `README.md`
- Modify: `STATUS.md`
- Modify: `WORKSPACE.md`
- Modify: `CLAUDE.md`

- [ ] **Step 1: Update root README**

Edit `README.md` so it says:

- Hardware truth for this cleanup comes from the active KiCad `.kicad_sch` and `.kicad_pcb` files.
- Active hardware projects are `hardware-board`, `hardware-board-3x3`, and `hardware-controller`.
- The 8x8 matrix is 282 mm by 282 mm.
- The 3x3 validation board is 132 mm by 132 mm.
- The controller is 58 mm by 71 mm.
- Matrix sensors are DRV5032FC SOT-23.
- The panel is an OLED and 3 buttons on a flying-lead harness.
- `firmware/` and `web/` are populated and active.
- `planning/` is planning context, not the current hardware truth.

- [ ] **Step 2: Update status snapshot**

Edit `STATUS.md` so it reflects:

- 3x3 validation board first, not a 4x4 prototype.
- Current component counts from the PCB files.
- Controller PCB component set from the PCB file.
- All active 2x13 matrix/controller `J` connectors are intended to be `PinSocket_2x13`.
- `hardware/` remains read-only during this cleanup.
- Firmware and web are present but still need hardware validation.

- [ ] **Step 3: Update workspace guide**

Edit `WORKSPACE.md` so it:

- Lists the active KiCad projects currently present.
- Removes `hardware-control-panel` as an active project.
- Removes stale schematic-script commands for removed controller/control-panel flows.
- Says hardware files can be inspected read-only during this cleanup.
- Says active docs should not rely on archived or planning files as hardware truth.

- [ ] **Step 4: Update agent context**

Edit `CLAUDE.md` so it:

- Points to KiCad schematic/PCB files as the immediate hardware truth.
- Uses DRV5032FC SOT-23 for matrix sensors.
- Removes the `C91` entry cap from active reference mapping.
- Describes `firmware/` and `web/` as populated.
- Keeps the one-off project intent unchanged.

### Task 2: Active Docs

**Files:**
- Modify: `docs/README.md`
- Modify: `docs/bom.md`
- Modify: `docs/assembly.md`
- Modify: `docs/design-decisions.md`
- Modify: `docs/inter-board-connector.md`
- Modify: `docs/gpio-map.md`
- Modify: `docs/kicad-routing-playbook.md`

- [ ] **Step 1: Update docs index**

Edit `docs/README.md` so active docs point to current split hardware, the 3x3 validation board, controller, firmware, and web. Keep archive notes clearly historical.

- [ ] **Step 2: Update BOM**

Edit `docs/bom.md` so it lists:

- 8x8 matrix: 64 DRV5032FC SOT-23, 81 WS2812B, 81 100 nF, 9 47 uF, 2x13 connector, 4 mounting holes, 3 fiducials.
- 3x3 validation board: 9 DRV5032FC SOT-23, 16 WS2812B, 16 100 nF, 4 47 uF, 2x13 connector.
- Controller: ESP32-DevKitC, Lipo Rider Plus, 74AHCT125, TBD62783A DIP-18, SS14-or-BAT60A, row pullups, button pullups, 33 ohm LED data resistor, battery divider, caps, J1, J3.
- Panel harness: SSD1306 OLED, 3 buttons, wiring harness.

Remove active A3144, control-panel PCB, and 470 uF entry-cap guidance.

- [ ] **Step 3: Update assembly guide**

Edit `docs/assembly.md` so build order is:

1. Inspect/export current KiCad files.
2. Order/bring up 3x3 validation board and controller.
3. Build panel harness.
4. Validate power, OLED/buttons, LED chain, and Hall sensing.
5. Order/bring up 8x8 board after 3x3 validation.
6. Continue firmware/web integration.
7. Design enclosure around validated boards.

- [ ] **Step 4: Update design decisions**

Edit `docs/design-decisions.md` so it describes the current two-PCB plus harness design, DRV5032FC choice, WS2812B corner LEDs, controller-side pullups, panel harness, and matrix script workflow.

- [ ] **Step 5: Update connector docs**

Edit `docs/inter-board-connector.md` so it:

- Describes two PCBs plus panel harness.
- Uses `PinSocket_2x13` as the intended active 2x13 footprint family.
- Keeps the existing 26-pin net contract.
- Describes `J_PANEL` as controller `J3` to OLED/buttons harness.
- Removes active control-panel PCB language.

- [ ] **Step 6: Update GPIO map**

Edit `docs/gpio-map.md` so it:

- Keeps the current ESP32 pin map.
- Uses `+3.3V` where matching the controller PCB nets, while noting docs may refer to the rail as 3V3.
- Keeps DRV5032FC push-pull row-sense notes.
- Does not imply firmware is already validated on real hardware.

- [ ] **Step 7: Update routing playbook**

Edit `docs/kicad-routing-playbook.md` so it reflects actual routed/current PCBs, removes separate control-panel PCB guidance, and keeps only future-check guidance useful before fab or re-export.

### Task 3: Firmware And Web Notes

**Files:**
- Modify: `firmware/README.md`
- Modify: `firmware/AUDIT.md`
- Modify: `firmware/CLAUDE.md`

- [ ] **Step 1: Update firmware README**

Edit `firmware/README.md` so it no longer says the directory is unpopulated. Describe the current PlatformIO firmware shell, WebSocket protocol, embedded web artifact, and remaining hardware-validation work.

- [ ] **Step 2: Update firmware audit**

Edit `firmware/AUDIT.md` so it removes active panel status LED guidance and replaces it with OLED plus 3 button harness facts.

- [ ] **Step 3: Update firmware CLAUDE context**

Edit `firmware/CLAUDE.md` so it points to KiCad files, `docs/gpio-map.md`, and current OLED/button panel hardware.

### Task 4: Verification

**Files:**
- Inspect: non-hardware tree
- Inspect: git diff

- [ ] **Step 1: Search stale terms outside hardware**

Run:

```bash
rg -n "A3144|hardware-control-panel|4x4|C91|470uF|status LEDs|PowerBoost" -g '!hardware/**'
```

Expected: no active stale guidance remains. Any hits should be in historical/archive/spec/plan context or explicitly marked as stale.

- [ ] **Step 2: Confirm hardware unchanged**

Run:

```bash
git diff -- hardware
```

Expected: no output.

- [ ] **Step 3: Review changed files**

Run:

```bash
git diff --stat
git diff -- README.md STATUS.md WORKSPACE.md CLAUDE.md docs firmware
```

Expected: only non-hardware docs and superpowers plan/spec files changed.
