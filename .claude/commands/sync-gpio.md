# /sync-gpio — Verify GPIO map is consistent across all sources of truth

The ESP32 GPIO assignments need to match in 4 places:

1. **`docs/gpio-map.md`** — authoritative reference
2. **`CLAUDE.md`** — used by Claude sessions
3. **`hardware/openchess.kicad_sch`** — schematic net labels on ESP32 pins
4. **`firmware/src/board_driver.h`** — when firmware is forked

When one is updated, the others can drift. This command checks for drift and reports mismatches.

## What to do

1. **Read `docs/gpio-map.md`** — that's the authoritative source.

2. **Cross-check against `CLAUDE.md`** — if CLAUDE.md still has a pin table (it shouldn't after the restructure pointed at `docs/gpio-map.md`), flag the duplication and suggest removing the table from CLAUDE.md.

3. **Cross-check against the schematic.** For each ESP32 pin in the GPIO map, grep `hardware/openchess.kicad_sch` for the expected net label:

```bash
grep -n "label \"<SIGNAL_NAME>\"" ~/Projects/openchess/hardware/openchess.kicad_sch
```

Report any signal name in the GPIO map that isn't found in the schematic (might mean the schematic uses a different name).

4. **If `firmware/src/board_driver.h` exists**, cross-check it too:

```bash
grep -E "^#define (LED_PIN|SR_CLK_PIN|SR_LATCH_PIN|SR_SER_DATA_PIN|ROW_PIN_[0-7])" ~/Projects/openchess/firmware/src/board_driver.h
```

Compare to GPIO map. Report any mismatch.

5. **Summarize findings:** list of (signal, gpio_map_value, schematic_value, firmware_value) for any signal where they don't agree. If all agree, say "GPIO map is in sync across all sources."

## Notes

- This is a verification-only command. It does NOT edit anything. If drift is found, the user decides which source to update.
- Run this after touching any pin assignment, and again before generating Gerbers.
