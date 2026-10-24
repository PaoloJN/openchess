// bench_signs_of_life.ino — OpenChess first bring-up test
// Flash this to the ESP32 (DevKitC). Open Serial Monitor @ 115200.
// Proves: chip runs, you can read the button/encoder pins, battery ADC works.
// Needs NOTHING connected but the ESP32 + USB. OLED stays OUT for this one
// (OLED shares the USB-serial pins — that's a separate test).

// Pins (from pins.h) — inlined so this flashes with zero setup.
const int PIN_BTN_POWER  = 36;  // GPIO36  | also ENCODER A
const int PIN_BTN_MODE   = 39;  // GPIO39  | also ENCODER B
const int PIN_BTN_SELECT = 2;   // GPIO2   | also ENCODER PUSH
const int PIN_VBAT_MON   = 34;  // GPIO34  (battery divider, ADC1)

void setup() {
  Serial.begin(115200);
  delay(800);
  Serial.println();
  Serial.println("====================================");
  Serial.println("  OpenChess controller — ALIVE :)   ");
  Serial.println("====================================");
  Serial.println("Press buttons / turn encoder and watch values change.");

  pinMode(PIN_BTN_POWER,  INPUT);         // GPIO36 input-only (ext pull-up R36)
  pinMode(PIN_BTN_MODE,   INPUT);         // GPIO39 input-only (ext pull-up R37)
  pinMode(PIN_BTN_SELECT, INPUT_PULLUP);  // GPIO2  internal pull-up
}

void loop() {
  int p = digitalRead(PIN_BTN_POWER);   // 1 = released, 0 = pressed (active-low)
  int m = digitalRead(PIN_BTN_MODE);
  int s = digitalRead(PIN_BTN_SELECT);

  int raw = analogRead(PIN_VBAT_MON);                 // 0..4095
  float vbat = (raw / 4095.0f) * 3.3f / 0.3125f;      // undo the R14/R15 divider

  Serial.printf("POWER/A=%d  MODE/B=%d  SELECT/PUSH=%d   |   Vbat ~%.2f V (raw %d)\n",
                p, m, s, vbat, raw);
  delay(200);
}
