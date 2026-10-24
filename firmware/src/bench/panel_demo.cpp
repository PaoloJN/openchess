// panel_demo.cpp — the interactive shell: OLED menu + buttons + LED effects.
// Build:  pio run -e bench_demo -t upload
//
// This is the first "whole machine" firmware: the OLED shows a menu, the panel
// buttons drive it, and the 81-LED board runs the selected effect. It's the
// skeleton the chess engine will later plug into (a mode becomes "Play").
//
//   MODE   button = cycle to the next mode
//   SELECT button = run / stop the highlighted mode
//   POWER  button = TAP to toggle standby (screen + LEDs off/on, brief effect);
//                   HOLD ~1.2s for full power-off (deep sleep), tap again to wake
//
// Modes:  Sensor (magnet -> corner LEDs) | Rainbow | Sweep | Breathe | Off
//
// ⚠ GPIO1/GPIO3 (OLED SDA/SCL) are the USB-serial pins:
//   • UNPLUG the OLED's SDA+SCL leads while flashing, then reconnect + reset.
//   • No serial debug here.
//   • Keep the matrix board connected (effects + sensor need the 5V rail).
#include <Arduino.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <NeoPixelBus.h>
#include <esp_sleep.h>
#include "pins.h"

// ── Display ───────────────────────────────────────────────────────────
// Set to the panel's REAL height. If text looks stretched/distorted it's a
// 128x32 module (0.91"); if text only fills the top half it's a true 128x64.
#define OLED_W    128
#define OLED_H     32          // <- try 64 if your panel is the taller 0.96"
#define OLED_ADDR 0x3C         // a few modules are 0x3D

static Adafruit_SSD1306 oled(OLED_W, OLED_H, &Wire, -1);
static NeoPixelBus<NeoGrbFeature, NeoEsp32Rmt0Ws2812xMethod> strip(LED_COUNT, PIN_LED_DATA);

// Brightness cap. 81 LEDs at full white = ~4.9A; the M1 gives ~2.4A. Keep
// channel values <= this and we stay safe.
static const uint8_t BRIGHT = 40;

// ── Modes ─────────────────────────────────────────────────────────────
enum Mode { M_SENSOR = 0, M_RAINBOW, M_SWEEP, M_BREATHE, M_OFF, M_COUNT };
static const char* MODE_NAME[M_COUNT] = { "Sensor", "Rainbow", "Sweep", "Breathe", "Off" };

enum Ui { UI_MENU, UI_RUNNING };
static Ui   ui  = UI_MENU;
static int  sel = 0;                 // highlighted mode
static bool oledDirty = true;
static bool standby   = false;       // true = screen + LEDs off (soft power)

// square [file][rank] -> its 4 corner LED indices. Derived from the PCB.
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
// Per-column settle (ms). Column A (index 0) holds sensor U5, a slow-starter.
static const int SETTLE_MS[MATRIX_COLS] = { 50, 8, 8, 8, 8, 8, 8, 8 };

// ── Buttons ───────────────────────────────────────────────────────────
struct Btn { int pin; bool down; uint32_t t; };
static Btn bMode   = { PIN_BTN_MODE,   false, 0 };
static Btn bSelect = { PIN_BTN_SELECT, false, 0 };

// Returns true once on the press edge (with ~40ms debounce).
static bool tapped(Btn& b) {
  bool s = (digitalRead(b.pin) == LOW);
  if (s && !b.down && millis() - b.t > 40) { b.down = true;  b.t = millis(); return true; }
  if (!s && b.down)                        { b.down = false; b.t = millis(); }
  return false;
}

// ── LED helpers ───────────────────────────────────────────────────────
static void ledsOff() {
  for (int i = 0; i < LED_COUNT; i++) strip.SetPixelColor(i, RgbColor(0, 0, 0));
  strip.Show();
}

// color wheel 0..255 -> RGB, scaled to `bright`.
static RgbColor wheel(uint8_t pos, uint8_t bright) {
  pos = 255 - pos;
  if (pos < 85)  return RgbColor((255 - pos * 3) * bright / 255, 0, (pos * 3) * bright / 255);
  if (pos < 170) { pos -= 85;  return RgbColor(0, (pos * 3) * bright / 255, (255 - pos * 3) * bright / 255); }
  pos -= 170;    return RgbColor((pos * 3) * bright / 255, (255 - pos * 3) * bright / 255, 0);
}

// Brief power-transition flourishes on the whole board.
static void fxPowerDown() {                          // red fade-out
  for (int b = BRIGHT; b >= 0; b -= 4) {
    for (int i = 0; i < LED_COUNT; i++) strip.SetPixelColor(i, RgbColor(b, 0, 0));
    strip.Show(); delay(12);
  }
  ledsOff();
}
static void fxPowerUp() {                             // green fade-in
  for (int b = 0; b <= BRIGHT; b += 4) {
    for (int i = 0; i < LED_COUNT; i++) strip.SetPixelColor(i, RgbColor(0, b, 0));
    strip.Show(); delay(12);
  }
  delay(80);
  ledsOff();
}

// ── Power / battery ───────────────────────────────────────────────────
static void powerOff() {
  ledsOff();
  oled.clearDisplay();
  oled.setTextSize(2);
  oled.setCursor(8, (OLED_H >= 64) ? 24 : 8);
  oled.print("Bye");
  oled.display();
  for (int c = 0; c < MATRIX_COLS; c++) digitalWrite(PIN_COL_DRV[c], LOW);
  delay(700);
  oled.clearDisplay();
  oled.display();                                  // blank the screen
  while (digitalRead(PIN_BTN_POWER) == LOW) delay(10);   // wait for release
  esp_sleep_enable_ext0_wakeup(GPIO_NUM_36, 0);    // wake on POWER (GPIO36) low
  esp_deep_sleep_start();
}

// POWER: quick tap -> PWR_SHORT (toggle standby); hold >1.2s -> deep sleep.
enum PwrEvt { PWR_NONE, PWR_SHORT };
static PwrEvt pollPower() {
  static uint32_t held = 0;
  static bool     wasDown = false;
  bool down = (digitalRead(PIN_BTN_POWER) == LOW);
  if (down) {
    if (!wasDown) { held = millis(); wasDown = true; }
    else if (millis() - held > 1200) powerOff();     // long hold -> full power-off
  } else if (wasDown) {
    wasDown = false;
    if (millis() - held > 40) return PWR_SHORT;      // released quickly -> a tap
  }
  return PWR_NONE;
}

// Low-battery guard: protect the LiPo from over-discharge.
static void checkBattery() {
  static int n = 0, low = 0;
  if (++n < 200) return;
  n = 0;
  float vb = (analogRead(PIN_VBAT_MON) / 4095.0f) * 3.3f / 0.3125f;
  if (vb < 3.30f) { if (++low >= 3) powerOff(); }
  else            { low = 0; }
}

// ── Effects ───────────────────────────────────────────────────────────
static uint8_t  phase   = 0;
static uint32_t lastFrame = 0;

static void fxRainbow() {
  for (int i = 0; i < LED_COUNT; i++)
    strip.SetPixelColor(i, wheel((i * 256 / LED_COUNT + phase) & 255, BRIGHT));
  strip.Show();
}

static void fxSweep() {
  ledsOff();
  int head = phase % LED_COUNT;
  for (int t = 0; t < 6; t++) {                    // lit head + fading trail
    int idx = (head - t + LED_COUNT) % LED_COUNT;
    int b = BRIGHT - t * 6; if (b < 0) b = 0;
    strip.SetPixelColor(idx, RgbColor(0, b, b));
  }
  strip.Show();
}

static void fxBreathe() {
  uint8_t tri = (phase < 128) ? (phase * 2) : ((255 - phase) * 2);   // 0..255..0
  uint8_t b = tri * BRIGHT / 255;
  RgbColor c(b, 0, b);                             // soft purple pulse
  for (int i = 0; i < LED_COUNT; i++) strip.SetPixelColor(i, c);
  strip.Show();
}

// Magnet -> light that square's 4 corner LEDs (dim white). Scan-paced.
static void fxSensor() {
  RgbColor white(25, 25, 25), off(0, 0, 0);
  for (int i = 0; i < LED_COUNT; i++) strip.SetPixelColor(i, off);
  for (int c = 0; c < MATRIX_COLS; c++) {
    digitalWrite(PIN_COL_DRV[c], HIGH);
    delay(SETTLE_MS[c]);
    for (int r = 0; r < MATRIX_ROWS; r++) {
      if (digitalRead(PIN_ROW_SENSE[r]) == LOW)
        for (int k = 0; k < 4; k++) strip.SetPixelColor(SQ_LED[c][r][k], white);
    }
    digitalWrite(PIN_COL_DRV[c], LOW);
  }
  strip.Show();
}

static void runEffect(int m) {
  if (m == M_SENSOR) { fxSensor(); return; }       // self-paced (~106ms/scan)
  if (m == M_OFF)    { ledsOff(); return; }
  if (millis() - lastFrame < 33) return;           // ~30 fps for the animations
  lastFrame = millis();
  phase += 3;
  switch (m) {
    case M_RAINBOW: fxRainbow(); break;
    case M_SWEEP:   fxSweep();   break;
    case M_BREATHE: fxBreathe(); break;
  }
}

// ── OLED screens ──────────────────────────────────────────────────────
static void drawScreen(const char* top, const char* hint) {
  oled.clearDisplay();
  oled.setTextColor(SSD1306_WHITE);
  oled.setTextSize(1);
  oled.setCursor(0, 0);
  oled.print(top);
  oled.setTextSize(2);                             // big mode name
  oled.setCursor(0, (OLED_H >= 64) ? 26 : 11);
  oled.print(MODE_NAME[sel]);
  oled.setTextSize(1);
  oled.setCursor(0, OLED_H - 8);
  oled.print(hint);
  oled.display();
}

static void draw() {
  if (ui == UI_MENU) drawScreen("OpenChess  - mode",  "MODE:next  SEL:go");
  else               drawScreen("running...",         "MODE:next SEL:back");
}

// ── Boot animation ────────────────────────────────────────────────────
static void bootAnim() {
  oled.clearDisplay();
  oled.setTextColor(SSD1306_WHITE);
  oled.setTextSize(2);
  oled.setCursor(0, (OLED_H >= 64) ? 20 : 8);
  oled.print("OpenChess");
  oled.display();
  for (int p = 0; p < 256; p += 4) {               // one rainbow wash over the board
    for (int i = 0; i < LED_COUNT; i++)
      strip.SetPixelColor(i, wheel((i * 256 / LED_COUNT + p) & 255, BRIGHT));
    strip.Show();
    delay(6);
  }
  ledsOff();
}

// ── Setup / loop ──────────────────────────────────────────────────────
void setup() {
  strip.Begin();
  strip.Show();
  for (int c = 0; c < MATRIX_COLS; c++) { pinMode(PIN_COL_DRV[c], OUTPUT); digitalWrite(PIN_COL_DRV[c], LOW); }
  for (int r = 0; r < MATRIX_ROWS; r++)   pinMode(PIN_ROW_SENSE[r], INPUT);
  pinMode(PIN_BTN_POWER,  INPUT);
  pinMode(PIN_BTN_MODE,   INPUT);
  pinMode(PIN_BTN_SELECT, INPUT_PULLUP);

  Wire.begin(PIN_I2C_SDA, PIN_I2C_SCL);
  if (!oled.begin(SSD1306_SWITCHCAPVCC, OLED_ADDR)) {
    // OLED not found: fall back to a red status LED so it's not a silent fail.
    strip.SetPixelColor(0, RgbColor(30, 0, 0));
    strip.Show();
    while (true) delay(500);
  }
  oled.setRotation(2);                             // module mounted upside-down
  bootAnim();
}

void loop() {
  if (pollPower() == PWR_SHORT) {                    // tap POWER -> toggle standby
    standby = !standby;
    if (standby) {                                   // going off
      fxPowerDown();                                 // red fade-out
      oled.ssd1306_command(SSD1306_DISPLAYOFF);      // screen truly off
    } else {                                         // coming back on
      oled.ssd1306_command(SSD1306_DISPLAYON);
      fxPowerUp();                                   // green fade-in
      oledDirty = true;
    }
  }
  checkBattery();                                    // always guard the LiPo
  if (standby) { delay(10); return; }                // in standby only POWER matters

  if (tapped(bMode))   { sel = (sel + 1) % M_COUNT; oledDirty = true; }
  if (tapped(bSelect)) { ui = (ui == UI_MENU) ? UI_RUNNING : UI_MENU; oledDirty = true; }

  if (oledDirty) { draw(); oledDirty = false; }

  if (ui == UI_RUNNING) runEffect(sel);
  else                  ledsOff();
}
