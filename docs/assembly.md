# Assembly Guide

Status: early prototype guide. Update after the 4x4 and full-board prototypes
are physically built.

## Build Order

1. Generate and review schematics for all active boards.
2. Build a 4x4 matrix prototype variant before ordering the full 8x8 matrix.
3. Confirm Hall sensor orientation, magnet strength, LED chain behavior, and
   connector pinout on the small prototype.
4. Layout/order the full matrix board.
5. Layout/order the controller board.
6. Layout/order or hand-build the control panel.
7. Integrate firmware against real hardware.
8. Design the enclosure around the boards and cable exits.

## Matrix Board Notes

- Hand-solder A3144 TO-92 sensors for prototype boards.
- Prefer PCBA for WS2812B LEDs and their 100nF caps.
- Test LED continuity by row; one bad WS2812B can break all downstream LEDs.
- Confirm `+5V_LED`, `GND`, `LED_DATA_5V`, `S0..S7`, and `CA_PWR..CH_PWR` at
  `J_CTRL` before connecting the controller.

## Controller Board Notes

- Do not connect to the matrix until `J_MAIN` pinout has been checked against
  `docs/inter-board-connector.md`.
- Verify row pullups are to `+3V3`, not `+5V_LED`.
- Verify LED data is level-shifted before it leaves the controller.
- Power approach is still pending, so power-on steps must be updated once that
  circuit is chosen.

## Control Panel Notes

- LEDs are active-low: controller sinks `LED_*_N` nets.
- Buttons short `BTN_*` nets to `GND`; controller provides pullups.
- Cable orientation matters; mark pin 1 clearly on PCB and enclosure.

## Firmware Bring-Up

1. Flash ESP32 with a minimal board-test firmware.
2. Verify control-panel buttons and LEDs first.
3. Verify row sense pullups and column drive sequencing without the full matrix.
4. Connect the 4x4 matrix prototype.
5. Only then test the full 8x8 matrix.
