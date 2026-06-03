# Bill of Materials

## Sensors & LEDs
| Qty | Part | Notes |
|---|---|---|
| 64 | A3144 hall effect sensor (TO-92 or SOT-23 SMD) | One per square |
| 81 | WS2812B 5050 SMD LED | At each corner of 9×9 grid |

## Microcontroller & matrix scan
| Qty | Part | Notes |
|---|---|---|
| 1 | ESP32-WROOM-32 dev board (38-pin) | Or bare module with USB-UART |
| 1 | 74HC595 shift register (DIP-16 or SOIC-16) | Drives 8 column-power lines |
| 8 | 2N3906 PNP transistor (TO-92 or SOT-23) | High-side switch for each column |
| 1 | 4-channel level shifter (3.3V ↔ 5V) | TXS0104E or similar |

## Resistors
| Qty | Value | Purpose |
|---|---|---|
| 8 | 1 kΩ | PNP base resistors |
| 8 | 10 kΩ | Row sense pull-ups |

## Power management
| Qty | Part | Notes |
|---|---|---|
| 1 | USB-C receptacle (USB 2.0) | Charging + serial debug |
| 1 | TP4056 charger IC | Li-Po charging with USB input |
| 1 | DW01A + 8205A protection IC | Over/under-voltage + short protection |
| 1 | MT3608 boost converter | 3.7V → 5V for LEDs + hall sensors |
| 1 | Li-Po battery 4000mAh, 3.7V | With JST connector (replaceable) |
| 1 | Latching push button | Power on/off |
| 1 | WS2812 mini (or similar RGB) | Battery indicator LED |

## Decoupling & misc
| Qty | Value | Notes |
|---|---|---|
| ~10 | 100 nF ceramic | Decoupling caps, one per IC near VCC |
| 2 | 10 µF tantalum/ceramic | Bulk decoupling on 5V and 3.3V rails |
| 1 | 1000 µF electrolytic | WS2812 inrush protection |

## Pieces & accessories
| Qty | Part |
|---|---|
| 32 | 8×2mm neodymium magnets (for chess pieces) |
| 32 | Optional iron disks for piece weight |

## Estimated cost

| Category | Cost |
|---|---|
| PCB fab (4-layer, 30×30cm) | $80 |
| PCBA service (SMD assembly) | $60 |
| Active components | $25 |
| Passives + connectors | $10 |
| Battery + charging | $18 |
| Magnets + pieces | $15 |
| Enclosure (wood/3D print) | $30 |
| **Total** | **~$240** |
