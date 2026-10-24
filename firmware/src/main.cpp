// OpenChess board firmware — the integrated product.
//
//   • Plays offline on its own: OLED menu (ui_oled) + 3 buttons + the offline
//     AI (chess_ai) + the coaching light language, run by GameController.
//   • Talks to the companion app over BLE (shell/ble_board, matching the app's
//     board/types.ts): streams moves, takes LED commands, reports status,
//     provisions WiFi. WiFi is only for board -> internet (Lichess/OTA) later.
//
// One non-blocking main loop drives UI, game, and BLE together. Bench/test
// sketches live under src/bench/ and are built by their own PlatformIO envs.
#include <Arduino.h>
#include <WiFi.h>
#include <esp_sleep.h>
#include <driver/rtc_io.h>
#include "engine/board_driver.h"
#include "engine/led_language.h"
#include "engine/game_controller.h"
#include "ui/ui_oled.h"
#include "shell/ble_board.h"
#include "pins.h"

static BoardDriver  driver;
static LedLanguage  lights(&driver);
static GameController game;
static UiOled        ui;

// Auto-sleep: power down after this long with no button presses, no piece
// movement, and no phone connected. Deep sleep wipes RAM, so sleeping mid-game
// abandons the game — the longer in-game window is the accepted trade-off.
static const uint32_t SLEEP_IDLE_MS = 10UL * 60 * 1000;
static const uint32_t SLEEP_GAME_MS = 30UL * 60 * 1000;
static uint32_t lastActivity = 0;

static bool occ[NUM_ROWS][NUM_COLS];
static volatile bool wifiScanReq = false;
static String provSsid, provPass;
static volatile bool provReq = false;
static uint32_t lastStatus = 0;

static String boardName() {
  uint8_t mac[6];
  WiFi.macAddress(mac);
  char nm[20];
  snprintf(nm, sizeof(nm), "OpenChess-%02X%02X", mac[4], mac[5]);
  return String(nm);
}

// White ripple-off, blank the OLED, then deep sleep until OK is pressed.
// Shared by the menu's Power Off and the auto-sleep timeout.
static void powerDown() {
  lights.rippleOff();
  ui.sleepDisplay();
  // OK = GPIO2: its internal pull-up is digital-domain and dies in deep
  // sleep; hold the line high with the RTC-domain pull-up or the pin
  // floats (phantom wakes / dead OK button behind a closed case).
  rtc_gpio_pullup_en((gpio_num_t)PIN_BTN_OK);
  rtc_gpio_pulldown_dis((gpio_num_t)PIN_BTN_OK);
  esp_sleep_enable_ext0_wakeup((gpio_num_t)PIN_BTN_OK, 0);   // wake on OK
  esp_deep_sleep_start();
}

static int batteryPercent() {
  float v = (analogRead(PIN_VBAT_MON) / 4095.0f) * 3.3f / 0.3125f;
  int pct = (int)((v - 3.30f) / (4.20f - 3.30f) * 100.0f);
  return pct < 0 ? 0 : (pct > 100 ? 100 : pct);
}

void setup() {
  driver.beginHardware();
  driver.setBrightness(70);        // uniform now (no dark-square dimming)
  for (int r = 0; r < NUM_ROWS; r++)
    for (int c = 0; c < NUM_COLS; c++) occ[r][c] = false;

  lights.rippleOn();          // white power-on ripple from the center
  ui.begin();
  game.begin(&driver, &lights, &ui);
  game.onMove = [](const String& from, const String& to) {
    bleBoard.pushMove(from, "lift");
    bleBoard.pushMove(to, "place");
  };
  game.onDebug = [](const String& line) { bleBoard.pushDebug(line); };

  WiFi.mode(WIFI_STA);
  WiFi.disconnect();

  // App -> board
  bleBoard.onSetLEDs = [](const std::vector<LedCellMsg>& cells) {
    if (game.active()) return;                 // the game owns the LEDs while playing
    driver.clearAllLEDs(false);
    for (const auto& c : cells) {
      int row = 7 - c.rank, col = c.file;
      if (row >= 0 && row < 8 && col >= 0 && col < 8)
        driver.setSquareLED(row, col, LedRGB{(uint8_t)c.r, (uint8_t)c.g, (uint8_t)c.b});
    }
    driver.showLEDs();
  };
  bleBoard.onScanWifi = []() { wifiScanReq = true; };
  bleBoard.onProvisionWifi = [](const String& ssid, const String& pass) { provSsid = ssid; provPass = pass; provReq = true; };

  bleBoard.begin(boardName());
}

void loop() {
  uint32_t now = millis();

  // Auto-sleep: any button, any piece change, or a connected phone counts as
  // activity. The sensor cache is refreshed by whichever mode is running (idle
  // loop, game tick, sensor test), so diffing it here sees pieces in every mode.
  {
    bool active = bleBoard.connected()
               || digitalRead(PIN_BTN_OK) == LOW
               || digitalRead(PIN_BTN_UP) == LOW
               || digitalRead(PIN_BTN_DOWN) == LOW;
    static bool occSeen[NUM_ROWS][NUM_COLS];
    for (int r = 0; r < NUM_ROWS; r++)
      for (int c = 0; c < NUM_COLS; c++) {
        bool s = driver.getSensorState(r, c);
        if (s != occSeen[r][c]) { occSeen[r][c] = s; active = true; }
      }
    if (active) lastActivity = now;
    if (now - lastActivity > (game.active() ? SLEEP_GAME_MS : SLEEP_IDLE_MS))
      powerDown();
  }

  // Live sensor-test debug: light every detected square green + show the count.
  if (ui.sensorTestActive()) {
    driver.readSensors();
    int count = 0;
    driver.clearAllLEDs(false);
    for (int r = 0; r < NUM_ROWS; r++)
      for (int c = 0; c < NUM_COLS; c++)
        if (driver.getSensorState(r, c)) { driver.setSquareLED(r, c, LedRGB{0, 120, 0}); count++; }
    driver.showLEDs();
    ui.showSensorCount(count);
    if (digitalRead(PIN_BTN_OK) == LOW) {    // hold OK to exit
      delay(600);
      if (digitalRead(PIN_BTN_OK) == LOW) { driver.clearAllLEDs(true); ui.exitSensorTest(); }
    }
    delay(40);
    return;
  }

  if (game.active()) {
    game.tick();                                // offline game owns board + OLED
  } else {
    ui.tick(now);                               // menu / status / pairing
    if (ui.pollSensorTest()) { /* entered above next loop */ }
    if (ui.pollPowerOff()) powerDown();
    GameStart gs;
    if (ui.pollGameStart(gs)) game.start({gs.vsComputer, gs.level, gs.color});

    // While idle, mirror raw piece events to the app (live board view / setup).
    driver.readSensors();
    for (int r = 0; r < NUM_ROWS; r++)
      for (int c = 0; c < NUM_COLS; c++) {
        bool s = driver.getSensorState(r, c);
        if (s != occ[r][c]) {
          occ[r][c] = s;
          char sq[3] = {(char)('a' + c), (char)('8' - r), 0};
          bleBoard.pushMove(String(sq), s ? "place" : "lift");
        }
      }
  }

  // Deferred WiFi work (kept off the BLE task).
  if (wifiScanReq) {
    wifiScanReq = false;
    int n = WiFi.scanNetworks();
    std::vector<WifiNet> nets;
    for (int i = 0; i < n && i < 12; i++) {
      int rssi = WiFi.RSSI(i);
      int strength = rssi > -55 ? 3 : rssi > -70 ? 2 : rssi > -85 ? 1 : 0;
      nets.push_back({WiFi.SSID(i), WiFi.encryptionType(i) != WIFI_AUTH_OPEN, strength});
    }
    bleBoard.pushWifiList(nets);
    WiFi.scanDelete();
  }
  if (provReq) { provReq = false; WiFi.begin(provSsid.c_str(), provPass.c_str()); }

  // Periodic status push.
  if (now - lastStatus > 2000) {
    lastStatus = now;
    bool wifiUp = (WiFi.status() == WL_CONNECTED);
    int rssi = wifiUp ? WiFi.RSSI() : -100;
    int strength = rssi > -55 ? 3 : rssi > -70 ? 2 : rssi > -85 ? 1 : 0;
    bleBoard.pushStatus(batteryPercent(), "v0.1", wifiUp ? WiFi.SSID() : String(""), wifiUp ? strength : 0, false);
    ui.setStatus(batteryPercent(), bleBoard.connected(), wifiUp ? WiFi.SSID().c_str() : "--");
  }
}
