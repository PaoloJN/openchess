#include "ui_oled.h"
#include <Arduino.h>
#include <string.h>
#include <esp_sleep.h>
#include "pins.h"

// Button mapping comes from pins.h (PIN_BTN_UP/DOWN/OK = the lines the
// physical caps are actually soldered to).
#define BTN_UP_PIN    PIN_BTN_UP      // GPIO39
#define BTN_DOWN_PIN  PIN_BTN_DOWN    // GPIO2
#define BTN_OK_PIN    PIN_BTN_OK      // GPIO36

#define OLED_ADDR   0x3C
#define HOLD_MS     1000     // OK held this long = "back" (short press = enter)
#define REPEAT_LAG  420      // ms before UP/DOWN auto-repeat kicks in
#define REPEAT_MS   150      // auto-repeat interval

#define WHITE SSD1306_WHITE
#define BLACK SSD1306_BLACK

// ── Small draw helpers ────────────────────────────────────────────────
static Adafruit_SSD1306* g;   // set in render() so free helpers can draw

static void textAt(int x, int y, const char* s, bool black = false) {
  g->setTextSize(1);
  g->setTextColor(black ? BLACK : WHITE);
  g->setCursor(x, y);
  g->print(s);
}
static int textW(const char* s) { return (int)strlen(s) * 6; }   // 6px/char at size 1
static void textCenter(int y, const char* s, bool black = false) {
  textAt((128 - textW(s)) / 2, y, s, black);
}
// A full-width inverted title bar (white bg, black text), 10px tall.
static void titleBar(const char* s) {
  g->fillRect(0, 0, 128, 10, WHITE);
  textAt(3, 1, s, true);
}

// ── Button reading ────────────────────────────────────────────────────
bool UiOled::edgeRepeat(Btn& b, uint32_t now) {
  bool raw = (digitalRead(b.pin) == LOW);
  bool fire = false;
  if (raw && !b.down) { b.down = true; b.downAt = now; b.lastRepeat = now; fire = true; }
  else if (raw && b.down) {
    if (now - b.downAt >= REPEAT_LAG && now - b.lastRepeat >= REPEAT_MS) { b.lastRepeat = now; fire = true; }
  } else if (!raw && b.down) { b.down = false; }
  return fire;
}

void UiOled::readOk(uint32_t now, bool& tap, bool& back) {
  tap = back = false;
  bool raw = (digitalRead(ok.pin) == LOW);
  if (raw && !ok.down) { ok.down = true; ok.downAt = now; ok.okConsumed = false; }
  else if (raw && ok.down) {
    if (!ok.okConsumed && now - ok.downAt >= HOLD_MS) { back = true; ok.okConsumed = true; }   // hold = back
  } else if (!raw && ok.down) {
    ok.down = false;
    if (!ok.okConsumed && now - ok.downAt < HOLD_MS) tap = true;                                 // short = enter
  }
}

// ── Lifecycle ─────────────────────────────────────────────────────────
void UiOled::begin() {
  up.pin = BTN_UP_PIN; down.pin = BTN_DOWN_PIN; ok.pin = BTN_OK_PIN;
  pinMode(BTN_UP_PIN, INPUT);          // GPIO39: input-only, board pull-up
  pinMode(BTN_DOWN_PIN, INPUT);        // GPIO36: input-only, board pull-up
  pinMode(BTN_OK_PIN, INPUT_PULLUP);   // GPIO2: needs the internal pull-up
  Wire.begin(PIN_I2C_SDA, PIN_I2C_SCL);
  d.begin(SSD1306_SWITCHCAPVCC, OLED_ADDR);
  d.setRotation(0);   // panel is mounted the other way up in the case
  d.clearDisplay();
  d.display();
  screen = S_BOOT;
  bootAt = millis();
}

bool UiOled::pollGameStart(GameStart& out) {
  if (!gameStartPending) return false;
  out = pendingStart;
  gameStartPending = false;
  return true;
}

void UiOled::setStatus(int batteryPct, bool appPaired, const char* wifiName_) {
  battPct = batteryPct; paired = appPaired;
  strncpy(wifiName, wifiName_, sizeof(wifiName) - 1);
  wifiName[sizeof(wifiName) - 1] = 0;
}

// Immediate in-game renders driven by the GameController.
void UiOled::showBanner(const String& top, const String& big) {
  g = &d;
  d.clearDisplay();
  d.fillRect(0, 0, 128, 10, WHITE);
  textAt(3, 1, top.c_str(), true);
  d.setTextSize(2);
  d.setTextColor(WHITE);
  int w = (int)big.length() * 12;
  d.setCursor(w < 128 ? (128 - w) / 2 : 0, 14);
  d.print(big);
  d.display();
}

void UiOled::showResult(const String& result) {
  g = &d;
  d.clearDisplay();
  textCenter(6, "GAME OVER");
  textCenter(18, result.c_str());
  d.display();
}

// Two-box confirm (QUIT / RESUME etc.), title bar on top, selected box inverts.
void UiOled::showConfirm(const String& title, const String& a, const String& b, int sel) {
  g = &d;
  d.clearDisplay();
  titleBar(title.c_str());
  const String* opt[2] = {&a, &b};
  int x = 6, boxW = 57, boxH = 16, y = 13;
  for (int i = 0; i < 2; i++) {
    bool s = (i == sel);
    if (s) d.fillRect(x, y, boxW, boxH, WHITE);
    else   d.drawRect(x, y, boxW, boxH, WHITE);
    textAt(x + (boxW - (int)opt[i]->length() * 6) / 2, y + 5, opt[i]->c_str(), s);
    x += boxW + 5;
  }
  d.display();
}

void UiOled::goHome() { enter(S_MAIN); }

bool UiOled::pollSensorTest() {
  if (!sensorTestReq) return false;
  sensorTestReq = false;
  return true;
}

// Live sensor debug readout (main feeds the detected-square count each frame).
void UiOled::showSensorCount(int count) {
  g = &d;
  d.clearDisplay();
  d.fillRect(0, 0, 128, 10, WHITE);
  textAt(3, 1, "SENSOR TEST", true);
  char buf[20];
  snprintf(buf, sizeof(buf), "%d / 64", count);
  d.setTextSize(2);
  d.setTextColor(WHITE);
  d.setCursor(6, 13);
  d.print(buf);
  d.setTextSize(1);
  textAt(70, 20, "hold OK=exit");
  d.display();
}

void UiOled::enter(Screen s) { screen = s; cursor = 0; }

// Generic cursor movement over a `count`-item list (wraps).
void UiOled::navMenu(int count, bool upE, bool downE) {
  if (upE)   cursor = (cursor - 1 + count) % count;
  if (downE) cursor = (cursor + 1) % count;
}

// ── Main loop ─────────────────────────────────────────────────────────
static const char* MAIN_ITEMS[]  = {"PLAY", "STATUS", "SENSOR TEST", "PAIR APP", "SETTINGS", "POWER OFF"};
static const char* PLAY_ITEMS[]  = {"VS COMPUTER", "2 PLAYERS", "BACK"};
static const char* SET_ITEMS[]   = {"BRIGHTNESS", "ABOUT", "BACK"};

void UiOled::tick(uint32_t now) {
  // Boot splash auto-advances.
  if (screen == S_BOOT) {
    render();
    if (now - bootAt > 1600) enter(S_MAIN);
    return;
  }

  bool upE = edgeRepeat(up, now);
  bool downE = edgeRepeat(down, now);
  bool tap = false, back = false;
  readOk(now, tap, back);
  // Crosstalk guard: if the OK line is down, ignore UP/DOWN edges — a partial
  // GPIO2/GPIO36 solder bridge otherwise turns every OK press into a scroll.
  if (ok.down) upE = downE = false;

  // Universal: hold OK = "exit to menu?" everywhere (at home it's power off).
  if (back && screen == S_MAIN) { enter(S_POWEROFF); powerSel = 0; back = false; }
  else if (back && screen != S_CONFIRM_HOME && screen != S_POWEROFF) {
    prevScreen = screen; confirmSel = 0; enter(S_CONFIRM_HOME); back = false;
  }

  switch (screen) {
    case S_CONFIRM_HOME:
      if (upE || downE) confirmSel ^= 1;
      if (back) enter(prevScreen);                                   // hold again = stay
      if (tap)  enter(confirmSel == 0 ? S_MAIN : prevScreen);        // YES -> menu, NO -> stay
      break;
    case S_MAIN:
      navMenu(6, upE, downE);
      if (back) { enter(S_POWEROFF); powerSel = 0; }         // hold at home -> power off
      if (tap) {
        switch (cursor) {
          case 0: enter(S_PLAY); break;
          case 1: enter(S_STATUS); break;
          case 2: inSensorTest = true; sensorTestReq = true; break;   // live sensor debug (main drives it)
          case 3: enter(S_PAIR); break;
          case 4: enter(S_SETTINGS); break;
          case 5: enter(S_POWEROFF); powerSel = 0; break;
        }
      }
      break;

    case S_PLAY:
      navMenu(3, upE, downE);
      if (back) enter(S_MAIN);
      if (tap) {
        if (cursor == 0) { vsComputer = true;  enter(S_DIFF); }
        else if (cursor == 1) { vsComputer = false; colorSel = 0; enter(S_COLOR); }
        else enter(S_MAIN);
      }
      break;

    case S_DIFF:
      if (upE)   level = level < 8 ? level + 1 : 8;
      if (downE) level = level > 1 ? level - 1 : 1;
      if (back)  enter(S_PLAY);
      if (tap)   { colorSel = 0; enter(S_COLOR); }
      break;

    case S_COLOR:
      if (upE)   colorSel = (colorSel + 2) % 3;
      if (downE) colorSel = (colorSel + 1) % 3;
      if (back)  enter(vsComputer ? S_DIFF : S_PLAY);
      if (tap)   enter(S_SETUP);
      break;

    case S_SETUP:
      if (back) enter(S_COLOR);
      if (tap) {                              // "pieces set" -> start the game
        pendingStart = {vsComputer, level, colorSel};
        gameStartPending = true;
        enter(S_INGAME);                      // preview the in-game screens
      }
      break;

    // In-game screens: real game feeds these later. For now OK steps through
    // them so every screen is visible; hold-OK returns to the menu.
    case S_INGAME:   if (back) enter(S_MAIN); if (tap) enter(S_THINKING); break;
    case S_THINKING: if (back) enter(S_MAIN); if (tap) enter(S_CHECK); break;
    case S_CHECK:    if (back) enter(S_MAIN); if (tap) enter(S_GAMEOVER); break;
    case S_GAMEOVER: if (tap || back) enter(S_MAIN); break;

    case S_STATUS: if (tap || back) enter(S_MAIN); break;
    case S_PAIR:   if (tap || back) enter(S_MAIN); break;

    case S_SETTINGS:
      navMenu(3, upE, downE);
      if (back) enter(S_MAIN);
      if (tap) {
        if (cursor == 0) { /* brightness adjust inline */ }
        else if (cursor == 1) enter(S_ABOUT);
        else enter(S_MAIN);
      }
      // brightness row: UP/DOWN adjusts when it's selected
      if (cursor == 0) {
        if (upE)   brightness = brightness < 250 ? brightness + 15 : 255;
        if (downE) brightness = brightness > 20 ? brightness - 15 : 10;
      }
      break;

    case S_ABOUT: if (tap || back) enter(S_SETTINGS); break;

    case S_POWEROFF:
      if (upE || downE) powerSel ^= 1;
      if (back) enter(S_MAIN);
      if (tap) { if (powerSel == 0) powerOffReq = true; else enter(S_MAIN); }   // main runs ripple + sleep
      break;

    default: break;
  }
  render();
}

// ── Render dispatch ───────────────────────────────────────────────────
void UiOled::render() {
  g = &d;
  d.clearDisplay();
  switch (screen) {
    case S_BOOT:     drawBoot(); break;
    case S_MAIN:     drawMenu(MAIN_ITEMS, 6, cursor, true); break;
    case S_PLAY:     drawMenu(PLAY_ITEMS, 3, cursor, false); break;
    case S_DIFF:     drawDifficulty(); break;
    case S_COLOR:    drawColor(); break;
    case S_SETUP:    drawSetup(); break;
    case S_INGAME:   drawLastMove(); break;
    case S_THINKING: drawThinking(); break;
    case S_CHECK:    drawCheck(); break;
    case S_GAMEOVER: drawGameOver(); break;
    case S_STATUS:   drawStatus(); break;
    case S_PAIR:     drawPair(); break;
    case S_SETTINGS: drawSettings(); break;
    case S_ABOUT:    drawAbout(); break;
    case S_POWEROFF: drawPowerOff(); break;
    case S_CONFIRM_HOME: drawConfirmHome(); break;
  }
  d.display();
}

// ── Screens ───────────────────────────────────────────────────────────
void UiOled::drawBoot() {
  textCenter(6, "OPENCHESS");
  d.drawRect(24, 22, 80, 6, WHITE);          // self-test bar frame
  d.fillRect(26, 24, 56, 2, WHITE);          // ~72%
}

// 3 rows of 10px (y = 1, 11, 21). Selected row inverts. Optional scrollbar.
void UiOled::drawMenu(const char* const* items, int count, int sel, bool scrollbar) {
  int start = 0;
  if (sel > 2) start = sel - 2;
  if (start > count - 3) start = max(0, count - 3);
  int usableW = scrollbar ? 124 : 128;
  for (int i = 0; i < 3 && start + i < count; i++) {
    int idx = start + i, y = 1 + i * 10;
    if (idx == sel) {
      d.fillRect(0, y, usableW, 10, WHITE);
      textAt(3, y + 1, items[idx], true);
    } else {
      textAt(3, y + 1, items[idx], false);
    }
  }
  if (scrollbar && count > 3) {
    d.drawFastVLine(126, 0, 32, WHITE);                        // track
    int thumbH = max(6, 32 * 3 / count);
    int thumbY = (32 - thumbH) * start / (count - 3);
    d.fillRect(125, thumbY, 3, thumbH, WHITE);                 // thumb
  }
}

void UiOled::drawDifficulty() {
  titleBar("DIFFICULTY");
  // up/down chevrons + level value, centered in the lower area
  d.fillTriangle(52, 15, 48, 20, 56, 20, WHITE);   // up
  d.fillTriangle(52, 30, 48, 25, 56, 25, WHITE);   // down
  char buf[8]; snprintf(buf, sizeof(buf), "LV %d", level);
  textAt(66, 17, buf);
}

void UiOled::drawColor() {
  titleBar("YOU PLAY");
  const char* opts[] = {"WHITE", "BLACK", "RAND"};
  int x = 4, boxW = 39, boxH = 16, y = 13;
  for (int i = 0; i < 3; i++) {
    bool seld = (i == colorSel);
    if (seld) d.fillRect(x, y, boxW, boxH, WHITE);
    else      d.drawRect(x, y, boxW, boxH, WHITE);
    textAt(x + (boxW - textW(opts[i])) / 2, y + 5, opts[i], seld);
    x += boxW + 3;
  }
}

void UiOled::drawSetup() {
  textCenter(2, "SET UP THE");
  textCenter(12, "PIECES");
  textCenter(23, "OK WHEN READY");
}

void UiOled::drawLastMove() {
  d.fillRect(0, 0, 128, 10, WHITE);
  textAt(3, 1, "BLACK MOVED", true);
  textAt(104, 1, "#12", true);
  // from -> to
  textAt(30, 16, "A5");
  d.fillRect(56, 21, 9, 2, WHITE);
  d.fillTriangle(65, 18, 65, 26, 71, 22, WHITE);   // arrow head
  textAt(80, 16, "A4");
}

void UiOled::drawThinking() {
  d.fillRect(0, 0, 128, 10, WHITE);
  char lv[8]; snprintf(lv, sizeof(lv), "VS LV %d", level);
  textAt(3, 1, lv, true);
  textAt(104, 1, "81%", true);
  // "THINKING" + animated dots
  int dots = (millis() / 400) % 4;
  char buf[16] = "THINKING";
  for (int i = 0; i < dots && i < 3; i++) strcat(buf, ".");
  textAt((128 - textW("THINKING...")) / 2, 17, buf);
}

void UiOled::drawCheck() {
  bool on = (millis() / 350) % 2;                   // flash
  if (on) {
    d.drawRect(2, 2, 124, 28, WHITE);
    d.drawRect(3, 3, 122, 26, WHITE);
    textCenter(12, "CHECK!");
  }
}

void UiOled::drawGameOver() {
  textCenter(3, "CHECKMATE");
  textCenter(15, "YOU WIN");
}

// Battery / app / wifi — three glanceable rows.
void UiOled::drawStatus() {
  // battery
  d.drawRect(3, 2, 12, 6, WHITE); d.fillRect(15, 3, 1, 4, WHITE);
  d.fillRect(5, 4, 8 * battPct / 100, 2, WHITE);
  textAt(20, 1, "BATTERY");
  char pct[6]; snprintf(pct, sizeof(pct), "%d%%", battPct);
  textAt(104, 1, pct);
  // app
  d.fillCircle(8, 15, 3, WHITE);
  textAt(20, 12, "APP");
  textAt(paired ? 92 : 86, 12, paired ? "PAIRED" : "READY");
  // wifi (3 bars)
  d.fillRect(4, 24, 2, 2, WHITE); d.fillRect(7, 22, 2, 4, WHITE); d.fillRect(10, 20, 2, 6, WHITE);
  textAt(20, 22, "WIFI");
  textAt(128 - textW(wifiName), 22, wifiName);
}

void UiOled::drawPair() {
  // phone glyph
  d.drawRect(6, 5, 14, 22, WHITE);
  d.fillRect(11, 8, 4, 1, WHITE);
  d.drawCircle(13, 23, 1, WHITE);
  textAt(28, 8, "OPEN THE");
  textAt(28, 18, "OPENCHESS APP");
}

void UiOled::drawSettings() {
  // BRIGHTNESS row shows a slider; ABOUT / BACK below. Selected row inverts.
  int y0 = 1;
  bool selB = (cursor == 0);
  if (selB) d.fillRect(0, y0, 128, 10, WHITE);
  textAt(3, y0 + 1, "BRIGHTNESS", selB);
  int barX = 88, barW = 34;
  d.drawRect(barX, y0 + 3, barW, 5, selB ? BLACK : WHITE);
  d.fillRect(barX + 1, y0 + 4, (barW - 2) * brightness / 255, 3, selB ? BLACK : WHITE);

  bool selA = (cursor == 1);
  if (selA) d.fillRect(0, 11, 128, 10, WHITE);
  textAt(3, 12, "ABOUT", selA);

  bool selBk = (cursor == 2);
  if (selBk) d.fillRect(0, 21, 128, 10, WHITE);
  textAt(3, 22, "BACK", selBk);
}

void UiOled::drawAbout() {
  textCenter(2, "OPENCHESS");
  textCenter(12, "V0.1");
  textCenter(23, "OK TO RETURN");
}

void UiOled::drawPowerOff() {
  titleBar("POWER OFF?");
  const char* opts[] = {"OFF", "CANCEL"};
  int x = 6, boxW = 57, boxH = 16, y = 13;
  for (int i = 0; i < 2; i++) {
    bool seld = (i == powerSel);
    if (seld) d.fillRect(x, y, boxW, boxH, WHITE);
    else      d.drawRect(x, y, boxW, boxH, WHITE);
    textAt(x + (boxW - textW(opts[i])) / 2, y + 5, opts[i], seld);
    x += boxW + 5;
  }
}

bool UiOled::pollPowerOff() {
  if (!powerOffReq) return false;
  powerOffReq = false;
  return true;
}

void UiOled::sleepDisplay() {
  d.clearDisplay();
  d.display();
  d.ssd1306_command(SSD1306_DISPLAYOFF);
}

void UiOled::drawConfirmHome() {
  titleBar("EXIT TO MENU?");
  const char* opts[] = {"YES", "NO"};
  int x = 6, boxW = 57, boxH = 16, y = 13;
  for (int i = 0; i < 2; i++) {
    bool s = (i == confirmSel);
    if (s) d.fillRect(x, y, boxW, boxH, WHITE);
    else   d.drawRect(x, y, boxW, boxH, WHITE);
    textAt(x + (boxW - textW(opts[i])) / 2, y + 5, opts[i], s);
    x += boxW + 5;
  }
}
