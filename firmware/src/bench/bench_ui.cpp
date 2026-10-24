// bench_ui.cpp — the OLED UI shell (Claude Design "Board OLED" spec).
// Build:  pio run -e bench_ui -t upload   (leave the OLED plugged in — no serial)
//
// Walk every screen with the 3 buttons:
//   UP / DOWN = move the cursor (or +/- on pickers)
//   OK  tap   = enter / confirm
//   OK  hold  = back one level (hold at Home = power off)
// The Play flow (Vs Computer -> level -> color -> set up) then previews the
// in-game screens (last move / thinking / check / game over). No LEDs, no
// serial — pure OLED, so it never fights the serial pins.
#include <Arduino.h>
#include "ui/ui_oled.h"

static UiOled ui;

void setup() {
  ui.begin();
}

void loop() {
  ui.tick(millis());
  GameStart gs;
  if (ui.pollGameStart(gs)) {
    // Later: hand this to the game engine. For now the UI just previews.
  }
  delay(12);
}
