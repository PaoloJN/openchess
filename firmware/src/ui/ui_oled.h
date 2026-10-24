#ifndef UI_OLED_H
#define UI_OLED_H

// OpenChess board OLED UI — the "no-phone face".
// Implements the Claude Design spec ("OpenChess Board OLED"): a 128x32 SSD1306
// with a 3-button UP / DOWN / OK model (OK tap = enter, OK hold = back). All
// 13 screens: boot, main menu, play, difficulty, color, setup, in-game status
// (last move / thinking / check / game over), status, pair, settings, power off.
//
// This is the reusable UI shell. Game logic (AI, move detection) hooks in later
// via the setters + the GameStart intent; for now it fully self-navigates so
// every screen is reachable/visible on hardware.
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

// A completed "start a game" choice the UI emits when the player finishes the
// Play -> difficulty -> color -> setup flow.
struct GameStart {
  bool vsComputer;   // false = local 2-player
  int  level;        // 1..8 (computer only)
  int  color;        // 0 = white, 1 = black, 2 = random
};

class UiOled {
 public:
  void begin();                 // init the OLED (128x32, rotated)
  void tick(uint32_t nowMs);    // read buttons, advance state, render

  // Did the player just start a game? Returns true once, fills `out`.
  bool pollGameStart(GameStart& out);

  // Live sensor-test debug mode (driven by main): request/exit + render.
  bool pollSensorTest();          // true once when the user opens SENSOR TEST
  bool sensorTestActive() const { return inSensorTest; }
  void exitSensorTest() { inSensorTest = false; enter(S_MAIN); }
  void showSensorCount(int count);

  // Status inputs (shown on the Status screen).
  void setStatus(int batteryPct, bool appPaired, const char* wifiName);

  // In-game screens driven by the GameController (immediate render).
  void showBanner(const String& top, const String& big);
  void showResult(const String& result);
  void showConfirm(const String& title, const String& a, const String& b, int sel);
  void goHome();   // reset to the main menu

  // Power off is handled by main (so it can run the LED ripple first).
  bool pollPowerOff();     // true once when the user confirms power off
  void sleepDisplay();     // blank + turn the OLED panel off

 private:
  Adafruit_SSD1306 d{128, 32, &Wire, -1};

  enum Screen {
    S_BOOT, S_MAIN, S_PLAY, S_DIFF, S_COLOR, S_SETUP,
    S_INGAME, S_THINKING, S_CHECK, S_GAMEOVER,
    S_STATUS, S_PAIR, S_SETTINGS, S_ABOUT, S_POWEROFF, S_CONFIRM_HOME
  };
  Screen screen = S_BOOT;
  Screen prevScreen = S_MAIN;   // where to return if the user cancels "to menu?"
  int  confirmSel = 0;          // 0 = YES (return), 1 = NO (stay)
  bool powerOffReq = false;
  bool sensorTestReq = false;
  bool inSensorTest = false;
  int  cursor = 0;          // menu cursor / picker index
  int  level = 5;           // difficulty 1..8
  int  colorSel = 0;        // 0 white / 1 black / 2 random
  int  powerSel = 0;        // 0 off / 1 cancel
  bool vsComputer = true;
  uint32_t bootAt = 0;
  uint8_t brightness = 60;

  // status data (demo defaults until the app/battery feed them)
  int  battPct = 82;
  bool paired = true;
  char wifiName[12] = "HOME-5G";

  bool gameStartPending = false;
  GameStart pendingStart{};

  // button state
  struct Btn { uint8_t pin; bool pullup; bool down; uint32_t downAt; uint32_t lastRepeat; bool okConsumed; };
  Btn up{0, false, false, 0, 0, false};
  Btn down{0, false, false, 0, 0, false};
  Btn ok{0, true, false, 0, 0, false};

  bool edgeRepeat(Btn& b, uint32_t now);   // UP/DOWN: edge + auto-repeat
  void readOk(uint32_t now, bool& tap, bool& back);

  void enter(Screen s);
  void navMenu(int count, bool upE, bool downE);

  // renderers
  void render();
  void drawBoot();
  void drawMenu(const char* const* items, int count, int sel, bool scrollbar);
  void drawDifficulty();
  void drawColor();
  void drawSetup();
  void drawLastMove();
  void drawThinking();
  void drawCheck();
  void drawGameOver();
  void drawStatus();
  void drawPair();
  void drawSettings();
  void drawAbout();
  void drawPowerOff();
  void drawConfirmHome();
};

#endif // UI_OLED_H
