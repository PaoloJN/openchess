# Assembly Guide

How to build a openchess from the files in this repo.

> **Status: stub.** This guide will be fleshed out after the first board is fabricated, populated, and tested. Today it captures the intended flow.

## 1. Order the PCB

See `hardware/fab/README.md` for the JLCPCB ordering recipe.

What you upload:
- `hardware/fab/gerbers/openchess-gerbers.zip`
- `hardware/fab/bom.csv`
- `hardware/fab/cpl.csv`

Suggested fab options: 2 layers, ~280×280 mm, 1.6 mm thickness, HASL lead-free, PCBA on back side only.

## 2. Source the through-hole parts

The 64 hall sensors and 81 WS2812 LEDs are best hand-soldered on the
front side for prototypes (cheaper than PCBA for this density of
identical small parts). See `docs/bom.md` for vendors.

## 3. Populate & solder

1. Back side first (PCBA from fab, or hand-solder support components).
2. Front side: 81 WS2812B LEDs, then 64 A3144 hall sensors. Test the
   LED chain after every row — one bad LED kills the chain downstream.
3. Solder the ESP32-WROOM-32 dev board onto its 2×19 pin header.

## 4. Flash firmware

```bash
cd firmware/
# pio run --target upload   (once the firmware fork is set up)
```

## 5. First boot & web setup

1. Power on. The board exposes a WiFi captive portal.
2. Connect with your phone, join your home WiFi.
3. Open the board's web UI (mDNS or shown IP).
4. Configure GPIO pins to match `docs/gpio-map.md` (the firmware allows runtime pin config).
5. Pair with Lichess via OAuth.

## 6. Mechanical assembly

1. Mount the PCB into the wooden case (`mechanical/case/`).
2. Place the wooden chess board overlay on top.
3. Print chess pieces with embedded magnets (`mechanical/pieces/`).

## Troubleshooting (to be populated)

- LED chain stops at LED N → bad solder on LED N+1 (most common)
- Hall sensor not detecting a piece → check magnet polarity
- USB upload fails → C2 (2.2µF on EN pin) may not be populated
