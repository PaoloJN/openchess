// signs_of_life.cpp — BENCH TEST 0: ESP32 is alive + reads inputs
// Build:  pio run -e bench_alive -t upload   (serial @115200)
// Needs NOTHING but the ESP32 + its USB. Matrix board stays DISCONNECTED.
#include <Arduino.h>
#include "pins.h"

void setup() {
  Serial.begin(115200);
  delay(800);
  Serial.println("\n====================================");
  Serial.println("  OpenChess controller — ALIVE :)   ");
  Serial.println("====================================");
  Serial.println("Jumper GPIO36 / 39 / 2 to GND -> watch its value flip 1->0.");

  pinMode(PIN_BTN_POWER,  INPUT);         // GPIO36 (ext pull-up R36)
  pinMode(PIN_BTN_MODE,   INPUT);         // GPIO39 (ext pull-up R37)
  pinMode(PIN_BTN_SELECT, INPUT_PULLUP);  // GPIO2  (internal pull-up)
}

void loop() {
  int p = digitalRead(PIN_BTN_POWER);
  int m = digitalRead(PIN_BTN_MODE);
  int s = digitalRead(PIN_BTN_SELECT);
  int raw = analogRead(PIN_VBAT_MON);
  float vbat = (raw / 4095.0f) * 3.3f / 0.3125f;
  Serial.printf("POWER/A=%d  MODE/B=%d  SELECT/PUSH=%d   |   Vbat ~%.2f V (raw %d)\n",
                p, m, s, vbat, raw);
  delay(200);
}
