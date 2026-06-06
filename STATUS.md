# Project Status

Last updated: 2026-06-05

## Current Direction

The old integrated hardware project has been archived. Active hardware now
lives under `hardware/` as three separate KiCad projects:

| Board | Status | Notes |
|---|---|---|
| `hardware-board` | Schematic scripted, ERC clean | Matrix board: 64 Hall sensors, 81 WS2812B LEDs, caps, `J_CTRL`, test/mech |
| `hardware-controller` | Power chunk (USB-C + LDO) scripted, pending KiCad verification | Skeleton, `J_MAIN`, row pullups, power flags, test/mech done. ESP32 socket / level shifter / column drivers / `J_PANEL` designed but not yet scripted. |
| `hardware-control-panel` | Schematic scripted, ERC clean | `J_PANEL`, 3 status LEDs, 3 buttons, test/mech done |

## Done Recently

- Archived old top-level `hardware/` and `hardware-controller/` into `delete/old-hardware-2026-06-04/`.
- Renamed the clean split-board workspace to `hardware/`.
- Created scripted schematic pipelines for all three boards.
- Updated active docs to remove the old single-PCB assumptions.
- Archived old rev0.1 schematic review/walkthrough docs under `docs/archive/rev0.1/`.
- Locked controller design decisions (2026-06-05): USB-C 5V only with AP2112K-3.3 LDO, ESP32-DevKitC v4 on 2x 1x19 sockets, 74AHCT125 WS2812 level shifter, AO3401A PMOS + MMBT3904 NPN column drivers, finalized GPIO map.
- Revised controller decisions (2026-06-05, later same session): switched to battery-backed power architecture — added BQ24074RGT USB-C charger + power-path, MT3608 boost converter, 1S LiPo via JST PH; AP2112K LDO now derives from boost output. Column drivers consolidated from 40 discrete parts to a single TBD62783A 8-channel high-side driver IC. Added `VBAT_MON` ADC monitor on GPIO34. Hand-drawing the controller in KiCad GUI; scripts archived.

## Next Hardware Work

1. Verify the scripted controller power chunk (USB-C + LDO) generates and passes ERC.
2. Script and verify the ESP32-DevKitC socket chunk with finalized GPIO assignments.
3. Script and verify the 74AHCT125 LED level-shifter chunk.
4. Script and verify the 8-channel PMOS/NPN column driver chunk.
5. Script and verify the controller-side `J_PANEL` connector chunk.
6. Create a 4x4 matrix prototype variant before paying for the full 8x8 board.

## Firmware Status

Firmware Phase A foundations exist from earlier work, but hardware pin names and
LED indexing need to be rechecked against the new split-board connector contracts
before any real-board validation.

## Open Questions

- How many physical controls should stay on the control panel beyond POWER,
  MODE, and RESET?
- Should controller-to-panel be a pin header, JST cable, or FFC in PCB layout?
