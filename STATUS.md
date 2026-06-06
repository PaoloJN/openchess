# Project Status

A snapshot of where the project is right now. **For design details,
the source of truth is `hardware/DESIGN_NOTES.md`.** This file tracks
progress, not decisions.

This is a **one-off personal learning project**, not for sale. Goal:
build one board that works first try. When it works on Paolo's desk,
the project is done.

Last updated: 2026-06-05

## Canonical references

| Document | What lives there |
|---|---|
| `hardware/DESIGN_NOTES.md` | **Source of truth** — full design, connector contracts, BOM, known issues, change log |
| `hardware/hardware-board/SCHEMATIC_GUIDE.md` | Matrix board build sheet |
| `hardware/hardware-controller/SCHEMATIC_GUIDE.md` | Controller hand-draw build sheet |
| `docs/gpio-map.md` | ESP32 GPIO assignments |
| `docs/inter-board-connector.md` | Formal cable contracts |
| `CLAUDE.md` | Project intent + durable context |

## Current state

| Subsystem | Schematic | PCB layout | Notes |
|---|---|---|---|
| `hardware-board` (matrix) | Script-generated, ERC clean | Not started | 236 components; keep using scripts. Need to verify J_CTRL footprint is the shrouded/keyed IDC variant. |
| `hardware-controller` | **Hand-drawing in progress** (KiCad GUI) | Not started | Migrating to PowerBoost module + TBD62783A + OLED panel labels. See `SCHEMATIC_GUIDE.md` for the deltas. |
| Panel components (no PCB) | N/A — discrete OLED module + 3 panel-mount buttons on flying leads | N/A | Plugged into controller `J3` via JST XH 10-pin harness. See DESIGN_NOTES §6. |

## Next actions

1. **Controller — finish the hand-drawn schematic**. Pending deltas:
   delete the old discrete power chain (BQ24074, TPS63060, etc.) AND
   the brief AP2112K LDO; add M1 Lipo Rider Plus as a 1×8 header; add
   D2 Schottky (SS14) between `+5V_LED` and DevKit pin 19; add U6
   TBD62783A column driver; relabel ESP32 module pins for I²C/BTN_SELECT;
   place NC flags (including the now-unused GPIO34 pin); add PWR_FLAG
   symbols; change J3 footprint to JST XH 10-pin. Run ERC, commit.
2. **Matrix — verify J_CTRL footprint is shrouded/keyed IDC** (not
   plain 1×10 pin header). Trivial edit if it isn't.
3. **Source the parts**. Key items: Seeed Lipo Rider Plus ($4 DigiKey),
   protected 1S LiPo, ESP32-DevKitC v4, SSD1306 OLED module, 3×
   12mm panel-mount pushbuttons, TBD62783A, 74AHCT125, SS14 Schottky,
   A3144 (×64), WS2812B (×81), USB-C panel-mount extension cable
   (~$5, routes M1's USB-C to the enclosure wall). JST XH connectors +
   crimp tool already on hand. See `DESIGN_NOTES.md` §9 for the full BOM.
4. **Build a 4×4 mini matrix prototype** before paying for the full
   8×8 fab. Use the same controller; just a smaller matrix PCB.
   Validates magnet selection, Hall behavior, and firmware
   scan/timing on real hardware.
5. **Lay out the PCBs** once both schematics are ERC-clean. Consider
   panelizing matrix + controller onto one JLCPCB order to share fab
   cost.

## Firmware status

Firmware Phase A foundations exist from earlier work, but pin
assignments and LED indexing need to be re-verified against the
current `docs/gpio-map.md` and the matrix board chain order before any
real-board validation.

Firmware-author heads-up items (no UART debug, Hall settling timing,
LED brightness limits, battery-state visual indicator on the Lipo Rider
Plus, etc.) are documented in `hardware/DESIGN_NOTES.md` §12.

## Open questions

- Magnet form factor and orientation for chess pieces (need to test on
  the 4×4 prototype before committing).
- Panelize the matrix + controller PCBs into one JLCPCB order to save
  fab cost?
- Enclosure design — material (3D printed vs laser cut vs CNC),
  cable routing for the matrix ribbon, OLED window, button hole
  positions.

## Recent activity

For the full change log (design-affecting decisions with dates), see
`hardware/DESIGN_NOTES.md` §15. The TL;DR of 2026-06-05:

- Switched from monolithic single-PCB to a 2-PCB + flying-leads layout
  (matrix board + controller; panel components in the enclosure).
- Consolidated 40 discrete column-driver parts into one TBD62783A.
- Replaced 3 panel status LEDs with an SSD1306 I²C OLED.
- Replaced the entire discrete power chain (~25 parts: BQ24074 +
  TPS63060 + protection block) with one daughterboard module —
  initially the Adafruit PowerBoost 1000C, later switched to the
  **Seeed Lipo Rider Plus** ($4 on DigiKey, USB-C, 5V/2.4A boost +
  3V3/250mA output) because it's cheaper, USB-C, and lets us drop
  the AP2112K LDO too. Added a Schottky diode (SS14) between +5V_LED
  and DevKit pin 19 so the ESP32 can run on battery.
- Added analog battery state-of-charge monitor: R14/R15 voltage divider
  on M1's raw BAT pad (pin 6) → VBAT_MON → ESP32 GPIO34 ADC. Firmware
  shows battery percentage on the OLED. Cleaned up the leftover
  PowerBoost 1000C lib files from `hardware-controller/lib/`.
- **Locked the assembly layout** based on the user's enclosure mockup:
  controller PCB stacks directly underneath the matrix PCB via mating
  2×13 pin header (controller J_MAIN, male) + 2×13 socket (matrix J_CTRL,
  female), held at ~11 mm spacing by M3 corner standoffs. **No ribbon
  cable** between matrix and controller. LiPo battery sits alongside the
  controller PCB in the space between the matrix back and the enclosure
  floor. Side-mounted panel (OLED + 3 buttons + USB-C panel-mount) on
  one wall of the enclosure.
- **Dropped the panel PCB entirely** — OLED + 3 panel-mount buttons
  on flying leads to the controller's `J3` (JST XH 10-pin).
- Kept the shrouded/keyed IDC footprint for the matrix cable.
- Rebrandled the project intent: this is a one-off learning project,
  not a product.
