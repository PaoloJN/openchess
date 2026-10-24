// highlight.cpp — BENCH TEST 4: magnet -> light the 4 corner LEDs (dim white)
// Build:  pio run -e bench_highlight -t upload
//
// Scans the hall matrix; for every square with a magnet on it, lights that
// square's 4 corner LEDs dim white. This is the first real sensor->LED feature
// and it validates the square->LED corner mapping (derived from the PCB).
//
// Keep M1 plugged in (LEDs + sensors need the 5V rail).
#include <Arduino.h>
#include <NeoPixelBus.h>
#include <esp_sleep.h>
#include "pins.h"

// On-board BOOT button = GPIO0. Press it to toggle the board on/off:
//   press once -> LEDs off + ESP32 deep sleep (~tens of uA)
//   press again -> wakes and resumes scanning
// (Note: this sleeps the ESP32. M1 still boosts 5V to the rail, so for TRUE
//  power-off flip M1's slide switch. This is a standby that saves the most.)
#define PIN_BOOT_BTN 0

// SETTLE_MS = how long to wait after powering a column before reading it.
// Full scan = SETTLE_MS * 8. Lower = snappier. If squares start missing/
// flickering, bump it back up a few ms. (No electrical risk either way.)
//   55 = original safe value (~440ms/scan, sluggish)
// Per-column settle (ms). Sensor U5 (square A5, on column A = index 0) is a
// slow-starter — it can hold its output low for ~42ms after its column powers
// on. So column A gets extra settle; every other column stays fast. This is a
// firmware accommodation for one slow sensor — no hardware change needed.
// Full scan = 50 + 7*8 = ~106ms (still feels instant). Tune per column if
// another sensor turns out slow too.
//                                      A   B  C  D  E  F  G  H
static const int     SETTLE_MS[MATRIX_COLS] = { 50, 8, 8, 8, 8, 8, 8, 8 };
static const uint8_t W = 18;            // dim white level (lower = dimmer)

// Debounce: a square must read "present" for this many scans IN A ROW before
// it lights. Filters single-scan sensor glitches; a real piece still lights
// in ~2 scans (~16ms). Clears immediately when the magnet leaves.
static const uint8_t NEED = 2;
static uint8_t conf[8][8];   // consecutive "present" count per square

// Low-battery protection: when Vbat drops this low, warn (flash red) and sleep,
// so the LiPo never over-discharges (that's what tripped its protection today).
// Checked periodically; needs a few low readings in a row to act (noise guard).
static const float LOW_BATT_V   = 3.30f;
static int         battScan     = 0;
static int         lowBattCount = 0;

static NeoPixelBus<NeoGrbFeature, NeoEsp32Rmt0Ws2812xMethod> strip(LED_COUNT, PIN_LED_DATA);

// square [file][rank] -> its 4 corner LED indices (0-based). Derived from PCB.
static const int SQ_LED[8][8][4] = {
  {{63,64,72,73},{54,55,63,64},{45,46,54,55},{36,37,45,46},{27,28,36,37},{18,19,27,28},{9,10,18,19},{0,1,9,10}},
  {{64,65,73,74},{55,56,64,65},{46,47,55,56},{37,38,46,47},{28,29,37,38},{19,20,28,29},{10,11,19,20},{1,2,10,11}},
  {{65,66,74,75},{56,57,65,66},{47,48,56,57},{38,39,47,48},{29,30,38,39},{20,21,29,30},{11,12,20,21},{2,3,11,12}},
  {{66,67,75,76},{57,58,66,67},{48,49,57,58},{39,40,48,49},{30,31,39,40},{21,22,30,31},{12,13,21,22},{3,4,12,13}},
  {{67,68,76,77},{58,59,67,68},{49,50,58,59},{40,41,49,50},{31,32,40,41},{22,23,31,32},{13,14,22,23},{4,5,13,14}},
  {{68,69,77,78},{59,60,68,69},{50,51,59,60},{41,42,50,51},{32,33,41,42},{23,24,32,33},{14,15,23,24},{5,6,14,15}},
  {{69,70,78,79},{60,61,69,70},{51,52,60,61},{42,43,51,52},{33,34,42,43},{24,25,33,34},{15,16,24,25},{6,7,15,16}},
  {{70,71,79,80},{61,62,70,71},{52,53,61,62},{43,44,52,53},{34,35,43,44},{25,26,34,35},{16,17,25,26},{7,8,16,17}},
};

void setup() {
  Serial.begin(115200);
  delay(300);
  Serial.println("\n=== BENCH 4: magnet -> corner LEDs ===");
  for (int c = 0; c < MATRIX_COLS; c++) { pinMode(PIN_COL_DRV[c], OUTPUT); digitalWrite(PIN_COL_DRV[c], LOW); }
  for (int r = 0; r < MATRIX_ROWS; r++)   pinMode(PIN_ROW_SENSE[r], INPUT);
  pinMode(PIN_BOOT_BTN, INPUT);   // BOOT has an external pull-up on the DevKitC
  strip.Begin();
  strip.Show();   // all off
}

// Turn everything off and deep-sleep until BOOT is pressed again.
static void powerOff() {
  for (int i = 0; i < LED_COUNT; i++) strip.SetPixelColor(i, RgbColor(0, 0, 0));
  strip.Show();
  for (int c = 0; c < MATRIX_COLS; c++) digitalWrite(PIN_COL_DRV[c], LOW);
  while (digitalRead(PIN_BOOT_BTN) == LOW) delay(10);   // wait for release
  delay(80);                                            // debounce
  esp_sleep_enable_ext0_wakeup(GPIO_NUM_0, 0);          // wake on next BOOT press (LOW)
  esp_deep_sleep_start();                               // <- sleeps here; wakes = full restart
}

// Periodically check the battery; if it's genuinely low, warn + sleep.
static void checkBattery() {
  if (++battScan < 40) return;   // ~ every 40 scans
  battScan = 0;
  float vb = (analogRead(PIN_VBAT_MON) / 4095.0f) * 3.3f / 0.3125f;
  if (vb < LOW_BATT_V) {
    if (++lowBattCount >= 3) {                 // 3 low readings in a row
      for (int f = 0; f < 3; f++) {            // flash red warning
        for (int i = 0; i < LED_COUNT; i++) strip.SetPixelColor(i, RgbColor(30, 0, 0));
        strip.Show(); delay(200);
        for (int i = 0; i < LED_COUNT; i++) strip.SetPixelColor(i, RgbColor(0, 0, 0));
        strip.Show(); delay(200);
      }
      powerOff();                              // deep sleep to stop the drain
    }
  } else {
    lowBattCount = 0;
  }
}

void loop() {
  if (digitalRead(PIN_BOOT_BTN) == LOW) powerOff();   // BOOT pressed -> sleep
  checkBattery();                                     // low-battery guard

  RgbColor white(W, W, W), off(0, 0, 0);
  for (int i = 0; i < LED_COUNT; i++) strip.SetPixelColor(i, off);  // clear

  for (int c = 0; c < MATRIX_COLS; c++) {            // scan + light in one pass
    digitalWrite(PIN_COL_DRV[c], HIGH);
    delay(SETTLE_MS[c]);
    for (int r = 0; r < MATRIX_ROWS; r++) {
      bool raw = (digitalRead(PIN_ROW_SENSE[r]) == LOW);
      if (raw) { if (conf[c][r] < NEED) conf[c][r]++; }   // count consecutive hits
      else     { conf[c][r] = 0; }                        // miss -> reset
      if (conf[c][r] >= NEED) {                           // confirmed present
        for (int k = 0; k < 4; k++) strip.SetPixelColor(SQ_LED[c][r][k], white);
      }
    }
    digitalWrite(PIN_COL_DRV[c], LOW);
  }
  strip.Show();
}
