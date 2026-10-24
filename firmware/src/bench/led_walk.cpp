// led_walk.cpp — BENCH TEST 1: WS2812B LED chain
// Build:  pio run -e bench_led -t upload   (then open serial @115200)
//
// What it proves: the 81-LED chain is alive, data path works (GPIO32 ->
// 74AHCT125 level shifter -> J1 -> D1..D81), and finds chain breaks.
//
// Sequence (loops):
//   1) one white pixel walks D1 -> D81  (a break shows as "stops at LED N")
//   2) all red, all green, all blue     (dim — checks every LED + all channels)
//   3) all off
//
// SAFETY: brightness is capped LOW on purpose. 81 LEDs at full white = ~4.9A,
// but the Lipo Rider only gives 2.4A. Dim test values keep current safe.
#include <Arduino.h>
#include <NeoPixelBus.h>
#include "pins.h"

static NeoPixelBus<NeoGrbFeature, NeoEsp32Rmt0Ws2812xMethod> strip(LED_COUNT, PIN_LED_DATA);

static const uint8_t DIM = 40;  // keep low — power-safe for all-on tests

static void fill(RgbColor c) {
  for (int i = 0; i < LED_COUNT; i++) strip.SetPixelColor(i, c);
  strip.Show();
}

void setup() {
  Serial.begin(115200);
  delay(500);
  Serial.println("\n=== BENCH 1: LED walk ===");
  Serial.printf("LEDs=%d  data pin=GPIO%d\n", LED_COUNT, PIN_LED_DATA);
  strip.Begin();
  fill(RgbColor(0, 0, 0));
  Serial.println("If a color stops partway, the chain breaks at that LED.");
}

void loop() {
  // 1) walking pixel — watch it travel the whole chain
  Serial.println("walk D1..D81 (white)");
  for (int i = 0; i < LED_COUNT; i++) {
    fill(RgbColor(0, 0, 0));
    strip.SetPixelColor(i, RgbColor(DIM, DIM, DIM));
    strip.Show();
    delay(40);
  }

  // 2) full-chain color checks (dim)
  Serial.println("all RED");   fill(RgbColor(DIM, 0, 0)); delay(700);
  Serial.println("all GREEN"); fill(RgbColor(0, DIM, 0)); delay(700);
  Serial.println("all BLUE");  fill(RgbColor(0, 0, DIM)); delay(700);

  Serial.println("all OFF");   fill(RgbColor(0, 0, 0));   delay(500);
}
