# OpenChess Hardware

One KiCad project per board. v0.1 is what exists; v2 is a shelved design.

```text
hardware-board/          8x8 matrix PCB, 282 x 282 mm. Built and verified.
hardware-controller/     controller v0.1, 58 x 71 mm. Built. Frozen, boards exist.
hardware-controller-v2/  shelved v2 design: integrated ESP32 + USB-C + charger + boost. Schematic only.
DESIGN_NOTES.md          design rationale and history for the v0.1 boards
```

Each built board directory carries its KiCad files, `scripts/` for generated
placement and routing, `production/` with the Fabrication Toolkit exports that
went to JLCPCB, and `gerbers/`.

Connector contracts are in `../docs/inter-board-connector.md`, the GPIO map in
`../docs/gpio-map.md`. The v2 folder keeps its own `README.md` and
`SOURCING.md` in case the idea is ever picked back up.
