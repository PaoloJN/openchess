# Design Decisions

Why the current OpenChess hardware is shaped this way.

## Use Two PCBs Plus A Panel Harness

The active hardware is the matrix board, the controller board, and a
flying-lead panel harness. This keeps the large repetitive sensor/LED matrix
separate from the controller, power, and UI wiring while avoiding a separate
small panel PCB.

Current active boards:

- `hardware-board`: full 8x8 matrix PCB
- `hardware-board-3x3`: low-cost validation PCB
- `hardware-controller`: ESP32, power, drivers, connectors

The panel is an SSD1306 OLED plus 3 buttons wired to controller `J3`.

## Validate With 3x3 Before Ordering 8x8

The 3x3 board validates the risky assumptions cheaply: DRV5032FC sensing,
WS2812B chain behavior, connector mating, controller scan behavior, and
firmware timing. The full 8x8 board should wait until that path is proven.

## Use DRV5032FC SOT-23 Hall Sensors

The current matrix PCBs use DRV5032FC SOT-23 sensors. They are compact,
JLC-assemblable, and suitable for validating magnetic piece detection without
hand-soldering 64 through-hole Hall sensors.

## Keep WS2812B Corner LEDs

WS2812B LEDs reduce LED routing to a data chain and support per-corner RGB
feedback. The 8x8 chessboard uses a 9x9 LED corner grid, and the 3x3 validation
board uses 16 LEDs around its validation squares.

## Keep Scan Support On The Controller

The matrix board carries the repeated Hall/LED hardware. The controller carries
the ESP32, row pullups, column driver, LED data level shifter, battery monitor,
and external connectors. This keeps matrix variants simpler and makes bring-up
easier.

## Use A Harness For Panel UI

Panel components are mechanically tied to the enclosure, not the matrix. A
flying-lead harness lets the OLED, buttons, and USB access be placed where the
case needs them without respinning a panel PCB.

## Keep Matrix Generation Scripted

The matrix boards contain many repeated components. Scripted generation remains
the right workflow for Hall sensors, LEDs, caps, and related repetitive layout
because it reduces copy/paste errors and keeps variants such as 3x3 and 8x8
aligned.
