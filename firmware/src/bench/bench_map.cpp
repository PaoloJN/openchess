// bench_map.cpp — PHASE 0 LED-MAP check, OLED-driven (NO serial, no unplugging).
// Build:  pio run -e bench_map -t upload   (leave the OLED plugged in!)
//
// Lights ONE square's 4 corner LEDs at a time, through the REAL engine
// BoardDriver map, and shows that square's coordinate on the OLED. Watch which
// PHYSICAL square lights for each coordinate to verify/fix the square->LED map.
//
//   MODE   button = next square (a..h then next rank)
//   SELECT button = toggle auto-advance (steps every ~1.2s)
//   POWER  button = jump back to r0 f:a
//
// Uses the OLED (GPIO1/3) for output, so nothing prints to serial and you never
// unplug. This also tests whether flashing works with the OLED connected.
#include <Arduino.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include "engine/board_driver.h"
#include "engine/led_colors.h"
#include "pins.h"

#define OLED_W    128
#define OLED_H     32
#define OLED_ADDR 0x3C

static Adafruit_SSD1306 oled(OLED_W, OLED_H, &Wire, -1);
static BoardDriver driver;

static int  r = 0, c = 0;          // engine row (rank 0..7), col (file 0..7)
static bool autoAdv = false;
static uint32_t lastStep = 0;
static bool prevMode = false, prevSel = false, prevPwr = false;

static bool tapped(int pin, bool& prev) {
  bool s = (digitalRead(pin) == LOW);
  bool t = (s && !prev);
  prev = s;
  return t;
}

static void draw() {
  oled.clearDisplay();
  oled.setTextColor(SSD1306_WHITE);
  oled.setTextSize(1);
  oled.setCursor(0, 0);
  oled.print("LED map check");
  oled.setTextSize(2);
  oled.setCursor(0, 14);
  oled.printf("r%d  f:%c", r, 'a' + c);
  oled.display();
}

static void showSquare() {
  driver.clearAllLEDs(false);
  driver.setSquareLED(r, c, LedColors::White);
  driver.showLEDs();
}

void setup() {
  driver.beginHardware();
  driver.setBrightness(40);
  pinMode(PIN_BTN_MODE,   INPUT);          // ext pull-up
  pinMode(PIN_BTN_SELECT, INPUT_PULLUP);
  pinMode(PIN_BTN_POWER,  INPUT);          // ext pull-up
  Wire.begin(PIN_I2C_SDA, PIN_I2C_SCL);
  oled.begin(SSD1306_SWITCHCAPVCC, OLED_ADDR);
  oled.setRotation(2);
  draw();
  showSquare();
}

void loop() {
  bool step = false;
  if (tapped(PIN_BTN_MODE, prevMode))   step = true;
  if (tapped(PIN_BTN_SELECT, prevSel))  autoAdv = !autoAdv;
  if (tapped(PIN_BTN_POWER, prevPwr))   { r = 0; c = 0; draw(); showSquare(); }
  if (autoAdv && millis() - lastStep > 1200) step = true;

  if (step) {
    lastStep = millis();
    c++;
    if (c >= 8) { c = 0; r++; if (r >= 8) r = 0; }
    draw();
    showSquare();
  }
  delay(20);
}
