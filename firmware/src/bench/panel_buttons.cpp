// panel_buttons.cpp — BENCH: read the 3 panel buttons on J3
// Build:  pio run -e bench_buttons -t upload   (then open serial @115200)
//
// This test does NOT touch the OLED, so USB-serial works normally — it's the
// easy first step for the panel. You'll see a line print each time a button
// changes.
//
// Wiring (controller J3, flying leads) — each button connects its signal pin
// to GND (any GND lead works). Pressed = shorted to GND = active LOW.
//   J3.5  BTN_SELECT  --[ button ]-- GND
//   J3.6  BTN_POWER   --[ button ]-- GND
//   J3.7  BTN_MODE    --[ button ]-- GND
//
// POWER (GPIO36) and MODE (GPIO39) are input-only pins with external board
// pull-ups (R36/R37). SELECT (GPIO2) uses the ESP32 internal pull-up.
#include <Arduino.h>
#include "pins.h"

static bool prevP = false, prevM = false, prevS = false;

static bool pressed(int pin) { return digitalRead(pin) == LOW; }

void setup() {
  Serial.begin(115200);
  delay(300);
  Serial.println("\n=== BENCH: panel buttons (J3) ===");
  pinMode(PIN_BTN_POWER,  INPUT);         // ext pull-up R36 (input-only pin)
  pinMode(PIN_BTN_MODE,   INPUT);         // ext pull-up R37 (input-only pin)
  pinMode(PIN_BTN_SELECT, INPUT_PULLUP);  // internal pull-up
  Serial.println("Press each button — expect PRESS / release lines.\n");
}

void loop() {
  bool p = pressed(PIN_BTN_POWER);
  bool m = pressed(PIN_BTN_MODE);
  bool s = pressed(PIN_BTN_SELECT);
  if (p != prevP) { Serial.printf("POWER  %s\n", p ? "PRESS"   : "release"); prevP = p; }
  if (m != prevM) { Serial.printf("MODE   %s\n", m ? "PRESS"   : "release"); prevM = m; }
  if (s != prevS) { Serial.printf("SELECT %s\n", s ? "PRESS"   : "release"); prevS = s; }
  delay(15);   // simple debounce
}
