# OpenChess Hardware

Two KiCad projects are active, one is frozen.

```text
hardware-board/          8x8 matrix PCB, 282 x 282 mm. Built and verified.
hardware-controller/     controller v0.1, 58 x 71 mm. Built. Frozen, boards exist.
hardware-controller-v2/  controller v2, integrated ESP32 + USB-C + charger + boost. In design.
DESIGN_NOTES.md          design rationale and history for the v0.1 boards
```

Each board directory carries its KiCad files, `scripts/` for generated
placement and routing, `production/` with the Fabrication Toolkit exports that
went to JLCPCB, and `gerbers/`.

The matrix connector contract is identical between the v0.1 and v2
controllers, so the same matrix board plugs into both. See
`../docs/inter-board-connector.md`.

Controller v2 reads its part values from `hardware-controller-v2/SOURCING.md`
and its GPIO map from `../docs/gpio-map.md`.
