# Fabrication outputs

Files in this directory are **generated** from the KiCad sources in
`hardware/`. Do not edit them by hand — re-export from KiCad instead.

## Contents

- `gerbers/` — Gerber + drill files (zipped for upload to JLCPCB/PCBWay)
- `bom.csv` — machine-readable BOM (export from KiCad → Tools → BOM)
- `cpl.csv` — pick-and-place / centroid file (for assembly)
- `schematic.pdf` — rendered schematic for non-KiCad readers
- `freerouting.dsn` — DSN export consumed by the Freerouting plugin

## Regenerating

```bash
cd hardware/scripts
python3 export_gerbers.py
```

Then upload `gerbers/openchess-gerbers.zip` to your fab house with the BOM and CPL.

## Ordering recipe (JLCPCB, as of 2026-06-03)

1. Upload `gerbers/openchess-gerbers.zip`
2. Layers: 2; Dimensions: ~280×280mm; Thickness: 1.6mm; Surface finish: HASL (lead-free)
3. Assembly: enable for back side only (PCBA — pop. the support components, not the 64 sensors + 81 LEDs which are cheaper hand-soldered for prototypes)
4. Upload `bom.csv` and `cpl.csv` when prompted
