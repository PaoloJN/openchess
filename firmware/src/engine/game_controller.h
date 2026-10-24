#ifndef GAME_CONTROLLER_H
#define GAME_CONTROLLER_H

// Tick-based offline game controller — plays a full game on the board with no
// phone and no blocking loops (so it coexists with BLE + the OLED UI on one
// main loop). It reuses ChessEngine (rules), ChessAi (opponent), and
// LedLanguage (coaching lights).
//
// Move detection is robust: instead of tracking lift/place order, each turn it
// watches for the physical board to SETTLE into "current position + exactly one
// legal move." That naturally handles captures, promotions, and hesitation.
#include <Arduino.h>
#include <functional>
#include "board_driver.h"
#include "chess_engine.h"
#include "chess_ai.h"
#include "led_language.h"

class UiOled;

struct GameConfig {
  bool vsComputer;
  int  level;       // 1..8 (computer only)
  int  humanColor;  // 0 white / 1 black / 2 random
};

class GameController {
 public:
  void begin(BoardDriver* bd, LedLanguage* lights, UiOled* ui);
  void start(const GameConfig& cfg);
  void tick();
  bool active() const { return phase != IDLE; }

  // Emitted for every applied move (for BLE mirroring): (uci, fromSquare, toSquare).
  std::function<void(const String& from, const String& to)> onMove;
  // Live debug sink — main wires this to the BLE debug stream.
  std::function<void(const String&)> onDebug;

 private:
  enum Phase { IDLE, SETUP, HUMAN, THINK, GUIDE, OVER, QUIT_CONFIRM };
  BoardDriver* bd = nullptr;
  LedLanguage* lights = nullptr;
  UiOled* ui = nullptr;
  ChessEngine eng;
  ChessAi ai;

  char board[8][8];
  char turn;            // 'w' / 'b'
  char humanCol;        // 'w' / 'b'
  bool vsComputer;
  int  level;
  Phase phase = IDLE;

  AiMove pending;       // computer's chosen move, awaiting the human to make it
  int liftShown = -1;   // square index whose coaching is currently shown (-1 none)
  uint32_t matchSince = 0;
  uint32_t lastLedRefresh = 0;  // periodic frame resend (corruption self-heal)
  // Breathing-pulse effects (non-blocking, rendered per tick):
  // check -> the threatened king breathes red; game over -> whole board
  // breathes in the result color. Cached so tick stays cheap.
  bool checkCached = false;
  bool inCheckNow = false;
  int  chkKingR = 0, chkKingC = 0;
  uint8_t lastPulseV = 0;
  // Squares observed empty since the board last matched the logical position.
  // A capture's destination stays occupied the whole time (victim -> capturer),
  // so occupancy alone can't confirm it — the victim must be SEEN leaving.
  uint64_t dipMask = 0;
  int lastResult = 0;   // 0 none, 1 white wins, 2 black wins, 3 draw

  // OK-hold-to-quit confirmation
  Phase savedPhase = IDLE;
  int   quitSel = 0;    // 0 = QUIT, 1 = RESUME
  bool  okDown = false, upDown = false, downDown = false, okConsumed = false;
  uint32_t okDownAt = 0;
  void pollButtons(uint32_t now, bool& okTap, bool& okHold, bool& upE, bool& downE);

  void snapshotOcc(bool occ[8][8]);
  bool occEquals(const char b[8][8], const bool occ[8][8]);
  // int16_t move lists: the 220-entry buffers live on the loop-task stack in
  // findSettledMove/sideHasNoMove; at int they were 3.5 KB each on an 8 KB
  // stack that has overflowed before (see chess_ai.cpp buffer note).
  int  legalMoves(char color, int16_t moves[][4]);
  bool findSettledMove(const bool occ[8][8], char color, int& fr, int& fc, int& tr, int& tc);
  static void applyToBoard(char b[8][8], int fr, int fc, int tr, int tc);
  void applyMove(int fr, int fc, int tr, int tc);
  bool sideHasNoMove(char color);
  void afterMove(int fr, int fc, int tr, int tc);
  void showStatus();
  void drawGuide();     // cyan from-square + white/red to-square for `pending`
};

#endif // GAME_CONTROLLER_H
