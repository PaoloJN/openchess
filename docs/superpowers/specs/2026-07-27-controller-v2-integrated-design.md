# Controller v2: Integrated ESP32 + Battery Design

Date: 2026-07-27
Status: Approved design, pending implementation plan

## Goal

Redesign `hardware-controller` from a "motherboard for two daughterboards"
(ESP32-DevKitC + Seeed Lipo Rider Plus) into a single self-contained PCB with
a soldered ESP32 module and integrated battery charging/power. Motivations:
smaller and flatter for the case, cheaper, cleaner assembly (JLC assembles
nearly everything), learning value of designing a real MCU + power board, and
eliminating the Lipo Rider Plus, which has power-bank-style load detection
that auto-cuts the boost output and prevented reliable battery-only operation.

The v1 prototype worked with the original controller, so the matrix, scan,
LEDs, and firmware are proven. v2 replaces only what the two modules did.

## Non-goals

- No change to the matrix PCB, the 3x3 board, or the matrix interconnect.
- No 5V microcontroller. All ESP32s are 3.3V parts; 5V MCUs (ATmega class)
  have no BLE, which the firmware and companion app require. The only 5V need
  is the WS2812B data line, already solved by the 74AHCT125.
- No ESP32-S3 port. The WROOM-32E is the same chip as the DevKitC, so working
  firmware carries over with only pin-constant changes.
- No soft power (button-controlled latch). A slide switch is enough for v2.

## Design rules

1. **Proven circuitry doesn't move.** The matrix-facing blocks are copied
   from v1 unchanged: 74AHCT125 level shifter, TBD62783A column driver,
   row/button pullups, battery divider, and J1 (2x13 matrix connector) with
   an identical pinout. The existing matrix board plugs in as-is.
2. **New blocks are reference designs.** ESP32 + USB section copies
   Espressif's public DevKitC v4 schematic; charger and boost copy their
   datasheet reference circuits and layouts. No invented circuits.
3. **"Real product" power behavior.** Runs from battery, runs while
   charging, switches sources glitch-free, and never auto-powers-off under
   light load. One USB-C port serves both charging and flashing.

## Architecture

```
USB-C ──┬─► [BQ24074-class charger, power path] ──► SYS rail
        │           │                                │
        │       [1S LiPo, JST-PH]              [5V boost ~3A] ─► +5V_LED ─► J1
        │           │                                │
        │       220k/100k divider ─► VBAT_MON   [3.3V LDO] ─► ESP32, sensors, OLED
        │
        └─► [CP2102N USB-serial + auto-program] ─► ESP32-WROOM-32E

Unchanged: 74AHCT125, TBD62783A, pullups, J1 (2x13) pinout.
Changed: single J3 XH-10 panel connector splits into J_OLED (XH-4)
         and J_BTN (XH-5).
```

## Block descriptions

### ESP32 section (replaces DevKitC)

- **ESP32-WROOM-32E** soldered on-board. Antenna end overhangs the board
  edge or sits over a full copper keepout on all layers. This is the most
  important placement constraint on the board.
- **USB-C receptacle** with 5.1k pulldowns on both CC pins so USB-C
  chargers enumerate and deliver 5V.
- **CP2102N** USB-to-serial bridge plus the standard two-transistor
  auto-program circuit, and manual EN/BOOT pushbuttons as fallback.
  Flashing workflow is identical to the DevKitC.
- **3.3V LDO**, 500mA class, powering the ESP32, DRV5032 sensors (via J1),
  and the OLED.

### Power section (replaces Lipo Rider Plus)

- **Charger with power path** (BQ24074 class): when USB is present the
  system runs from USB while the battery charges independently; on unplug
  it switches to battery seamlessly. Charge-status LED on board.
- **5V boost converter**, ~3A class (e.g. TPS61022), always on when the
  board is on, feeding `+5V_LED` to J1. Sized so full-board bright LED
  animations do not sag the rail. No load-detection auto-off.
- **Power switch**: slide switch in the battery path. Off = zero drain.
- **Battery**: protected 1S LiPo on a JST-PH connector (PH, not XH,
  because protected packs ship with PH plugs).
- **Battery monitor**: existing 220k/100k divider into an ADC1 pin,
  unchanged.

### Connectors

- **J1 matrix, 2x13 PinSocket**: pinout identical to v1.
- **J_OLED, JST-XH 4-pin**: GND, 3.3V, SCL, SDA in the same order as the
  SSD1306 module header, so the cable is straight-through.
- **J_BTN, JST-XH 5-pin**: GND, BTN_POWER, BTN_MODE, BTN_SELECT, spare.
- The v1 J3 XH-10 harness is retired; the panel harness is re-crimped into
  the two new cables.

## GPIO changes

Now that pins are freely assignable (no DevKitC header constraint):

- **OLED I2C moves off GPIO1/3** (UART0) to two free general-purpose pins,
  restoring serial debug logging alongside the OLED.
- **COL_DRV_G/H move off GPIO5/15** (bootstrap pins) to free pins,
  eliminating possible column-driver glitching at boot.
- All other assignments carry over from `docs/gpio-map.md` where possible.
- Firmware impact: pin constants only (~4 lines). No logic changes.
- `docs/gpio-map.md` and `docs/inter-board-connector.md` must be updated as
  part of implementation.

## Risks and mitigations

| Risk | Mitigation |
|---|---|
| Antenna detuned by nearby copper | Module antenna overhangs board edge; keepout on all layers; follow Espressif hardware design guide |
| Boost converter layout (first switching regulator) | Copy datasheet reference layout exactly: tight input cap, short switch loop, ground pour |
| USB auto-program circuit quirks | Copied 1:1 from DevKitC v4 schematic; manual EN/BOOT buttons as fallback |
| Bad first spin | Worst case is one JLC re-spin; matrix and firmware remain proven and untouched |

## Verification plan (bring-up order)

1. Power section alone: battery in, switch on, check 3.3V and 5V rails
   unloaded; plug USB, verify charge LED and play-while-charging.
2. USB flashing: PlatformIO upload + serial monitor (now available
   concurrently with OLED).
3. Panel: OLED and buttons via the new XH cables.
4. Matrix: plug proven matrix board into J1; run existing scan and LED
   benches; verify no boot glitch on column drivers and no rail sag at
   full brightness.

## Decisions log

- Keep ESP32 (BLE required); rejected 5V MCU.
- WROOM-32E over ESP32-S3: zero firmware risk beats fewer parts.
- Full integration over power-only board: learning + size goals.
- Power path charger over simple TP4056: "like a phone" behavior.
- Slide switch over soft power: simplicity.
- Split panel connector into XH-4 + XH-5: cleaner dedicated cables,
  accepted harness re-crimp.
- Battery stays JST-PH: matches off-the-shelf protected packs.
