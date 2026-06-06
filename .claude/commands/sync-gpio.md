# /sync-gpio — Verify GPIO Map Consistency

The GPIO map is provisional until the controller ESP32 and driver chunks are
finished. Use this command as a drift check once those chunks exist.

## Sources

1. `docs/gpio-map.md`
2. `hardware/hardware-controller/openchess-controller.kicad_sch`
3. `firmware/src/board_driver.h` if firmware is present

## What To Do

1. Read `docs/gpio-map.md`.
2. Grep the controller schematic for each non-TBD signal:

```bash
grep -n 'label "<SIGNAL_NAME>"' ~/Projects/openchess/hardware/hardware-controller/openchess-controller.kicad_sch
```

3. If firmware exists, compare against `firmware/src/board_driver.h`.
4. Report mismatches and TBDs. Do not edit automatically.
