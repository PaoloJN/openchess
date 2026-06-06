# Prototype BOM

This is a human-readable planning BOM for the current split-board prototype.
The schematic remains the source of truth for exact refs and machine exports.

Last refreshed: 2026-06-05.

## Matrix Board (`hardware-board`)

| Part | Qty | Refs / Notes |
|---|---:|---|
| A3144 Hall sensor, TO-92 | 64 | `U1..U64`; cheap prototype choice |
| WS2812B 5050 LED | 81 | `D1..D81`; PCBA strongly preferred |
| 100nF capacitor, 0805 | 81 | `C10..C90`; one per WS2812B |
| 47uF capacitor, 1206 | 9 | `C1..C9`; one per LED row |
| 470uF electrolytic, 10V | 1 | `C91`; `+5V_LED` entry cap |
| 2x13 connector | 1 | `J_CTRL`; mates to controller `J_MAIN` |
| Test pads, fiducials, M3 holes | as scripted | For bring-up, assembly, mounting |

## Controller Board (`hardware-controller`)

Already scripted:

| Part | Qty | Refs / Notes |
|---|---:|---|
| 2x13 connector | 1 | `J_MAIN`; matrix connector |
| 10k resistor, 0805 | 8 | `R1..R8`; row pullups to `+3V3` |
| Test pads, fiducials, M3 holes | as scripted | Current schematic chunk |

Still to decide/script:

| Block | Likely Parts |
|---|---|
| ESP32 | Devkit/socket for prototype, or bare ESP32-WROOM module |
| Power | USB/5V input first, or LiPo charger/boost immediately |
| Column drivers | Direct GPIOs if possible, or 74HC595 + transistor switches |
| LED data level shifter | Single-channel 3.3V -> 5V shifter preferred |
| Control-panel connector | Matching `J_PANEL` connector |

## Control Panel (`hardware-control-panel`)

| Part | Qty | Refs / Notes |
|---|---:|---|
| 1x10 connector | 1 | `J_PANEL`; cable to controller |
| Normal LED, 0805 | 3 | `D1..D3`: PWR, CONN, BATT |
| 1k resistor, 0805 | 3 | `R1..R3`; LED current limit |
| Momentary pushbutton | 3 | `SW1..SW3`: POWER, MODE, RESET |
| Test pads, fiducials, M3 holes | as scripted | Bring-up and mounting |

## Buying Notes

- Buy 100 A3144 sensors if using AliExpress; test a sample before soldering all 64.
- Buy WS2812B from LCSC/Worldsemi or another reputable source for the real board.
- Use JLCPCB/LCSC basic passives where possible for PCBA.
- Keep through-hole A3144 hand-soldered for the first prototype.
- Use PCBA for WS2812B LEDs, LED caps, and small passives where practical.

## Not Current

Old BOM lines for `BATT_LED1`, `D2..D82`, `led_chain.kicad_sch`, TP4056/MT3608
module headers, and one integrated PCB belong to the archived rev0.1 design and
should not be used as current ordering guidance.
