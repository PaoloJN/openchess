# Mechanical

3D models for the wooden case and printed chess pieces. Phase 3 of the project — not yet started.

## Layout

- `case/` — wooden case CAD (.step, .stl, .f3d). Houses the PCB, hides cabling, USB-C cutout, power switch cutout.
- `pieces/` — 3D-printed chess pieces with embedded neodymium magnets (the things the hall sensors detect).
- `fab/` — STLs / DXFs ready for printing or CNC.

## Constraints to design against

- PCB outer dimensions: ~280 × 280 mm
- Mounting holes: see `hardware/openchess.kicad_pcb` for hole positions
- USB-C and power switch live on the PCB edge — case must expose them
- Wooden chess board overlay sits ON TOP of the PCB silkscreen (which is just a placement guide)
- Chess pieces: magnet polarity matters (A3144 is sensitive to a single direction)
