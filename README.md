# OpenChess

A physical chess board with magnetic piece detection and corner-LED move
feedback. Plays online via Lichess and offline against Stockfish. ESP32-
powered, LiPo-battery / USB-C, with an SSD1306 OLED + 3 panel-mount
buttons for local UI.

**This is a one-off personal learning project, not a product.** The goal
is to learn through hands-on PCB design and build **one** chess board
that works first try. When it works on Paolo's desk, the project is done
— no v2, no scaling, no support burden. Design choices optimize for
first-build reliability and learning value over BOM cost, ergonomics for
volume, or production manufacturability.

This file is the project-level source of truth and entry point. For the
authoritative hardware design see [`hardware/DESIGN_NOTES.md`](hardware/DESIGN_NOTES.md);
for current progress see [`STATUS.md`](STATUS.md).

Last meaningful revision: **2026-06-06**.

---

## 1. What it does

| Capability | How |
|---|---|
| Detect pieces | 64× A3144 Hall sensors in an 8×8 grid under the playing surface; every piece carries a magnet |
| Indicate moves | 81× WS2812B RGB LEDs at the corners of the squares (9×9 grid) |
| Online play | Lichess Board API over WiFi |
| Offline play | Stockfish bot running on the ESP32 |
| Local UI | SSD1306 0.96" 128×64 OLED + 3 panel-mount buttons (POWER, MODE, SELECT) |
| Web UI | Captive-portal WiFi setup + web admin from the ESP32 (firmware feature) |
| Power | 1S LiPo (1500 mAh, protected) with USB-C charging via Seeed Lipo Rider Plus module |

---

## 2. System architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                       MATRIX PCB (chessboard)                    │
│                                                                  │
│   front face:   64× A3144 Hall  +  81× WS2812B corner LEDs       │
│   back face:    J_CTRL (2×13 keyed socket)                       │
│                                                                  │
│                              ▲                                   │
│         board-to-board stack │  (no ribbon cable)                │
│                              ▼                                   │
│                                                                  │
│   ┌─────────────────────────────────────────────────────────┐    │
│   │                   CONTROLLER PCB                        │    │
│   │                                                         │    │
│   │   J_MAIN (2×13 keyed header)                            │    │
│   │   ESP32-DevKitC v4 socket                               │    │
│   │   M1 Seeed Lipo Rider Plus (USB-C + LiPo + 5V + 3V3)    │    │
│   │   U3 74AHCT125 level shifter                            │    │
│   │   U6 TBD62783A 8-ch column driver                       │    │
│   │   D2 SS14 Schottky (ESP32 power path)                   │    │
│   │   R1..R8 row pullups · R14/R15/C12 VBAT_MON divider     │    │
│   │   J3 (J_PANEL, JST XH 10-pin)                           │    │
│   └────────────────┬────────────────────────────┬───────────┘    │
│                    │                            │                │
│                    │ JST PH                     │ JST XH 10      │
│                    ▼                            ▼                │
│              ┌──────────┐         ┌─────────────────────────┐    │
│              │ LiPo 1S  │         │   PANEL COMPONENTS      │    │
│              │ 1500 mAh │         │   (flying leads, no PCB)│    │
│              │ protected│         │   OLED · POWER · MODE · │    │
│              └──────────┘         │   SELECT · USB-C        │    │
│                                   └─────────────────────────┘    │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

Two PCBs + one cable-mounted component group. The controller PCB
stacks directly underneath the matrix PCB via mating 2×13 connectors
(no ribbon cable); 4× M3 corner standoffs hold the stack at ~11 mm
spacing. The LiPo battery sits alongside the controller in the space
between the matrix back and the enclosure floor. Panel components are
panel-mount parts on flying leads, mounted in the enclosure side wall.

A visual rendering of the assembly lives at
[`docs/images/system-overview.html`](docs/images/system-overview.html).

---

## 3. Hardware

| Subsystem | Path | Summary |
|---|---|---|
| Matrix PCB | [`hardware/hardware-board/`](hardware/hardware-board/) | Passive: 64× A3144 + 81× WS2812B + per-LED caps + row bulk caps + entry cap + J_CTRL. 236 components. **Script-generated** schematic. |
| Controller PCB | [`hardware/hardware-controller/`](hardware/hardware-controller/) | Active: ESP32 socket, Lipo Rider Plus power module, 74AHCT125 level shifter, TBD62783A column driver, Schottky power-path diode, pullups, divider, connectors. **Hand-drawn** in KiCad GUI. |
| Panel components | (no PCB) | SSD1306 OLED module + 3× 12 mm panel-mount pushbuttons + USB-C panel-mount extension cable, on a flying-lead harness to the controller's J_PANEL. |

The **authoritative hardware design** lives in
[`hardware/DESIGN_NOTES.md`](hardware/DESIGN_NOTES.md). Highlights:

- **Connector contracts**: 2×13 keyed IDC for matrix↔controller, JST XH
  10-pin for controller↔panel — pin-by-pin tables in DESIGN_NOTES §3.
- **Power**: single Seeed Lipo Rider Plus module ($4) handles USB-C
  charging, 5V/2.4A boost, and 3V3/250mA — see DESIGN_NOTES §7.
- **GPIO map**: full table in [`docs/gpio-map.md`](docs/gpio-map.md).
- **BOM**: high-level in DESIGN_NOTES §9, prototype shopping list in
  [`docs/bom.md`](docs/bom.md).

---

## 4. Firmware

Forked from [joojoooo/OpenChess](https://github.com/joojoooo/OpenChess),
adapted for this board's 9×9 corner-LED layout and split-board IO. Runs
on the ESP32-DevKitC via PlatformIO.

What works unchanged upstream:

- Hall sensor matrix scan (rewired to our row/column nets)
- Lichess Board API client
- Stockfish bot
- WiFi captive portal + web admin
- OTA firmware updates
- Move history persistence to flash

What we adapt:

- LED count: 64 (squares) → 81 (corners), `board_driver.cpp`
- LED chain mapping: square-centered → corner-grid
- GPIO assignments: match [`docs/gpio-map.md`](docs/gpio-map.md)
- Display layer: 3 status LEDs → SSD1306 OLED via I²C
- Buttons: re-mapped to POWER / MODE / SELECT semantics
- Battery state-of-charge: ADC read on GPIO34 via the R14/R15 divider

See [`firmware/README.md`](firmware/README.md) for setup, build, and
adaptation notes.

---

## 5. Mechanical / enclosure

Enclosure CAD has not started — see [`mechanical/README.md`](mechanical/README.md)
for current state. Constraints from the hardware design:

- 4× M3 mounting holes per PCB; ~11 mm standoffs between matrix and
  controller.
- Side-wall cutouts: 1× transparent window for the OLED (~27×27 mm),
  3× 12 mm holes for the panel buttons, 1× rectangular cutout for a
  USB-C panel-mount jack (~10×8 mm), 1× pinhole or recessed access to
  the DevKitC's EN reset button, 1× cutout or removable panel for the
  DevKitC's micro-USB programming port.
- LiPo pouch (~50×35×6 mm for 1500 mAh) sits in the gap between the
  matrix back and the enclosure floor.

Magnet selection + chess piece assembly are open questions — to be
resolved with a 4×4 mini-matrix prototype before committing the full 8×8
fab.

---

## 6. Repository layout

```text
openchess/
├── README.md                  ← this file
├── STATUS.md                  ← current phase + next actions
├── CLAUDE.md                  ← durable project context for agents
├── WORKSPACE.md               ← workspace conventions
│
├── hardware/
│   ├── DESIGN_NOTES.md        ← authoritative hardware design
│   ├── README.md
│   ├── hardware-board/        ← matrix PCB (script-generated)
│   │   ├── SCHEMATIC_GUIDE.md
│   │   └── scripts/sch/
│   └── hardware-controller/   ← controller PCB (hand-drawn)
│       └── SCHEMATIC_GUIDE.md
│
├── firmware/
│   ├── README.md
│   ├── platformio.ini
│   └── src/
│
├── mechanical/
│   ├── README.md
│   ├── case/
│   ├── pieces/
│   └── fab/
│
├── docs/
│   ├── README.md
│   ├── assembly.md
│   ├── bom.md
│   ├── design-decisions.md
│   ├── gpio-map.md
│   ├── inter-board-connector.md
│   ├── kicad-routing-playbook.md
│   ├── images/
│   │   └── system-overview.html
│   └── archive/
│
└── references/                ← upstream projects + datasheets
```

---

## 7. Where to look

| If you want to… | Read this |
|---|---|
| See current progress + next actions | [`STATUS.md`](STATUS.md) |
| Understand the hardware design | [`hardware/DESIGN_NOTES.md`](hardware/DESIGN_NOTES.md) |
| Build the controller schematic | [`hardware/hardware-controller/SCHEMATIC_GUIDE.md`](hardware/hardware-controller/SCHEMATIC_GUIDE.md) |
| Reference matrix board components | [`hardware/hardware-board/SCHEMATIC_GUIDE.md`](hardware/hardware-board/SCHEMATIC_GUIDE.md) |
| Check connector pinouts | [`docs/inter-board-connector.md`](docs/inter-board-connector.md) |
| Check ESP32 pin assignments | [`docs/gpio-map.md`](docs/gpio-map.md) |
| Buy prototype parts | [`docs/bom.md`](docs/bom.md) |
| Read fixed design decisions | [`docs/design-decisions.md`](docs/design-decisions.md) |
| Layout / routing playbook | [`docs/kicad-routing-playbook.md`](docs/kicad-routing-playbook.md) |
| Build + assembly walkthrough | [`docs/assembly.md`](docs/assembly.md) |
| Visualize the assembly | [`docs/images/system-overview.html`](docs/images/system-overview.html) |
| Set up firmware build | [`firmware/README.md`](firmware/README.md) |
| Brief an agent session | [`CLAUDE.md`](CLAUDE.md) |

---

## 8. Build & assembly workflow

High level — full per-step instructions live in
[`docs/assembly.md`](docs/assembly.md).

1. **Source parts** — see DESIGN_NOTES §9. Long-lead items: Seeed Lipo
   Rider Plus, protected 1S LiPo, ESP32-DevKitC v4, A3144 (×64),
   WS2812B (×81), TBD62783A.
2. **Verify schematics ERC-clean** — matrix board via its scripts;
   controller hand-drawn in KiCad GUI.
3. **Lay out PCBs** — see [`docs/kicad-routing-playbook.md`](docs/kicad-routing-playbook.md).
   Consider panelizing the two PCBs onto one JLCPCB order to share fab
   cost.
4. **Fab + assemble** — JLCPCB SMD assembly for matrix components; hand-
   solder the Lipo Rider Plus module and DevKitC sockets on the
   controller (JLC doesn't assemble modules).
5. **Bring-up** — power the controller alone first, verify rails, then
   stack with the matrix. Smoke-test one matrix column before scanning
   the full 8×8.
6. **Flash firmware** — see [`firmware/README.md`](firmware/README.md).
   Adapt LED count + GPIO map.
7. **Validate** — 4×4 mini-matrix prototype first (open question, see
   STATUS.md) before committing the full 8×8 if magnet selection or
   scan timing is uncertain.

---

## 9. Status

For current phase, in-progress work, and next concrete actions, see
[`STATUS.md`](STATUS.md). For the design-affecting change log with
dates, see [`hardware/DESIGN_NOTES.md`](hardware/DESIGN_NOTES.md) §15.

---

## 10. Inspiration

- [Olivier Mercier's chessboard project](https://omerc.github.io/) — the
  physical smart-board concept this is loosely modeled on.
- [joojoooo/OpenChess](https://github.com/joojoooo/OpenChess) — firmware
  ancestor.

This redesign keeps the physical smart-board idea while using Hall
sensors, addressable LEDs, and a modular hardware split (matrix +
controller + flying-lead panel) to reduce PCB risk and make per-
subsystem testing easier.

---

## 11. License

Mixed license:
- Hardware (KiCad projects, schematics, board files): **CERN-OHL-S v2**
- Firmware: upstream's license (initially MIT from joojoooo/OpenChess)
- Documentation: **CC-BY-4.0**

See the `LICENSE-*` files at the repository root.
