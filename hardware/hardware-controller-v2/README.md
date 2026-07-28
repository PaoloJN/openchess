# hardware-controller-v2

Integrated controller: soldered ESP32-WROOM-32E + USB-C (CH340C) + BQ24074
power-path charger + TPS61022 5V boost + AMS1117-3.3. Replaces the v1
DevKitC + Lipo Rider Plus daughterboards.

- Spec: `docs/superpowers/specs/2026-07-27-controller-v2-integrated-design.md`
- Plan: `docs/superpowers/plans/2026-07-27-controller-v2-integrated.md`
- GPIO map: `docs/gpio-map.md` (v2 table)
- Part sourcing + design values: `SOURCING.md`

The KiCad files keep their original names (`openchess-controller.*`) within this
directory; the directory name itself (`hardware-controller-v2/`) distinguishes v2
from frozen v1.

v1 (`../hardware-controller/`) is frozen — boards exist physically.
