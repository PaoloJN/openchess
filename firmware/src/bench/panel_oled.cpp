// panel_oled.cpp — BENCH: SSD1306 OLED on J3, showing live button states
// Build:  pio run -e bench_oled -t upload
//
// ⚠ GPIO1/GPIO3 (the OLED's SDA/SCL) ARE the USB-serial pins. Therefore:
//   • DISCONNECT the OLED's SDA + SCL leads while flashing, then reconnect them.
//   • There is NO serial debug here. Status is reported on the MATRIX LEDs
//     (which we already trust), on LED #0:
//         GREEN = OLED found and drawing
//         RED   = OLED not found  -> check wiring, or try address 0x3D below
//   Keep the matrix board plugged in so the status LED works.
//
// Wiring (controller J3):
//   J3.1 +3.3V -> OLED VCC        J3.2 GND -> OLED GND
//   J3.3 SDA   -> OLED SDA        J3.4 SCL -> OLED SCL
//   J3.5 SELECT / J3.6 POWER / J3.7 MODE -> each button -> GND
#include <Arduino.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <NeoPixelBus.h>
#include "pins.h"

#define OLED_W    128
#define OLED_H     64
#define OLED_ADDR 0x3C   // most 0.96" modules use 0x3C; a few are 0x3D

static Adafruit_SSD1306 oled(OLED_W, OLED_H, &Wire, -1);
static NeoPixelBus<NeoGrbFeature, NeoEsp32Rmt0Ws2812xMethod> strip(LED_COUNT, PIN_LED_DATA);

static void status(uint8_t r, uint8_t g, uint8_t b) {
  strip.SetPixelColor(0, RgbColor(r, g, b));
  strip.Show();
}

static bool pressed(int pin) { return digitalRead(pin) == LOW; }

void setup() {
  strip.Begin();
  strip.Show();
  pinMode(PIN_BTN_POWER,  INPUT);
  pinMode(PIN_BTN_MODE,   INPUT);
  pinMode(PIN_BTN_SELECT, INPUT_PULLUP);

  Wire.begin(PIN_I2C_SDA, PIN_I2C_SCL);
  if (!oled.begin(SSD1306_SWITCHCAPVCC, OLED_ADDR)) {
    status(30, 0, 0);                 // RED: OLED not found
    while (true) { delay(500); }      // stop here — fix wiring or try 0x3D
  }
  status(0, 25, 0);                   // GREEN: OLED alive

  oled.setRotation(2);                // module is mounted upside-down -> rotate 180
  oled.clearDisplay();
  oled.setTextColor(SSD1306_WHITE);
  oled.setTextSize(2);
  oled.setCursor(0, 0);
  oled.println("OpenChess");
  oled.setTextSize(1);
  oled.setCursor(0, 26);
  oled.println("panel OLED ok");
  oled.display();
  delay(1200);
}

void loop() {
  oled.clearDisplay();
  oled.setTextSize(1);
  oled.setCursor(0, 0);  oled.println("Buttons:");
  oled.setCursor(0, 18); oled.printf("POWER  %s", pressed(PIN_BTN_POWER)  ? "[DOWN]" : ".  up");
  oled.setCursor(0, 32); oled.printf("MODE   %s", pressed(PIN_BTN_MODE)   ? "[DOWN]" : ".  up");
  oled.setCursor(0, 46); oled.printf("SELECT %s", pressed(PIN_BTN_SELECT) ? "[DOWN]" : ".  up");
  oled.display();
  delay(40);
}
