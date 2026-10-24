#include "game_controller.h"
#include "chess_utils.h"
#include "../ui/ui_oled.h"
#include "pins.h"
#include <string.h>

// row 0 = rank 8 (black back rank) ... row 7 = rank 1 (white back rank)
static const char INIT[8][8] = {
    {'r', 'n', 'b', 'q', 'k', 'b', 'n', 'r'},
    {'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'},
    {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
    {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
    {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
    {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
    {'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'},
    {'R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R'},
};

// Buttons: functional mapping from pins.h (same as the OLED UI).
#define BTN_UP_PIN    PIN_BTN_UP
#define BTN_DOWN_PIN  PIN_BTN_DOWN
#define BTN_OK_PIN    PIN_BTN_OK
#define OK_HOLD_MS    1000   // OK held this long = quit-confirm (keep in sync with ui_oled HOLD_MS)

static String algSquare(int r, int c) {
  char s[3] = {(char)('a' + c), (char)('8' - r), 0};
  return String(s);
}

// Live debug: forward one line to the BLE debug stream if wired.
#define DBG(...)  do { if (onDebug) { char _b[80]; snprintf(_b, sizeof(_b), __VA_ARGS__); onDebug(String(_b)); } } while (0)

// Breathing brightness over `period` ms. Sine wave + squared easing: WS2812s
// don't dim linearly to the eye, so a plain triangle "snaps" bright and drags
// dim — the squared sine dwells softly at the bottom and swells naturally.
static uint8_t breath(uint32_t now, uint32_t period) {
  float t = (now % period) / (float)period;
  float w = 0.5f - 0.5f * cosf(t * 6.2831853f);
  w = w * w;
  return (uint8_t)(12 + w * 243.0f);
}

static LedRGB scaleColor(LedRGB c, uint8_t v) {
  return LedRGB{(uint8_t)((c.r * v) / 255), (uint8_t)((c.g * v) / 255), (uint8_t)((c.b * v) / 255)};
}

void GameController::pollButtons(uint32_t now, bool& okTap, bool& okHold, bool& upE, bool& downE) {
  okTap = okHold = upE = downE = false;
  bool u = (digitalRead(BTN_UP_PIN) == LOW);
  if (u && !upDown) upE = true;
  upDown = u;
  bool d = (digitalRead(BTN_DOWN_PIN) == LOW);
  if (d && !downDown) downE = true;
  downDown = d;
  bool o = (digitalRead(BTN_OK_PIN) == LOW);
  if (o && !okDown) { okDown = true; okDownAt = now; okConsumed = false; }
  else if (o && okDown) { if (!okConsumed && now - okDownAt >= OK_HOLD_MS) { okHold = true; okConsumed = true; } }
  else if (!o && okDown) { okDown = false; if (!okConsumed && now - okDownAt < OK_HOLD_MS) okTap = true; }
  // Crosstalk guard (partial GPIO2/GPIO36 bridge): OK-line low mutes UP/DOWN.
  if (o) upE = downE = false;
}

void GameController::begin(BoardDriver* bd_, LedLanguage* lights_, UiOled* ui_) {
  bd = bd_; lights = lights_; ui = ui_;
}

void GameController::start(const GameConfig& cfg) {
  vsComputer = cfg.vsComputer;
  level = cfg.level;
  int col = cfg.humanColor;
  if (col == 2) col = (int)(millis() & 1);   // random
  humanCol = (col == 0) ? 'w' : 'b';
  eng.reset();
  memcpy(board, INIT, sizeof(board));
  turn = 'w';
  phase = SETUP;
  liftShown = -1;
  matchSince = 0;
  dipMask = 0;
  lastResult = 0;
  checkCached = false;
  DBG("START vsC=%d lvl=%d human=%c", vsComputer, level, humanCol);
}

void GameController::snapshotOcc(bool occ[8][8]) {
  for (int r = 0; r < 8; r++)
    for (int c = 0; c < 8; c++) occ[r][c] = bd->getSensorState(r, c);
}

bool GameController::occEquals(const char b[8][8], const bool occ[8][8]) {
  for (int r = 0; r < 8; r++)
    for (int c = 0; c < 8; c++)
      if ((b[r][c] != ' ') != occ[r][c]) return false;
  return true;
}

int GameController::legalMoves(char color, int16_t moves[][4]) {
  int n = 0;
  for (int r = 0; r < 8; r++)
    for (int c = 0; c < 8; c++) {
      char p = board[r][c];
      if (p == ' ' || ChessUtils::getPieceColor(p) != color) continue;
      int dst[32][2];
      int m = 0;
      eng.getPossibleMoves(board, r, c, m, dst);
      for (int i = 0; i < m && n < 220; i++) { moves[n][0] = r; moves[n][1] = c; moves[n][2] = dst[i][0]; moves[n][3] = dst[i][1]; n++; }
    }
  return n;
}

bool GameController::sideHasNoMove(char color) {
  int16_t m[220][4];
  return legalMoves(color, m) == 0;
}

// Find the single legal move whose resulting occupancy matches the physical board.
bool GameController::findSettledMove(const bool occ[8][8], char color, int& fr, int& fc, int& tr, int& tc) {
  int16_t moves[220][4];
  int n = legalMoves(color, moves);
  for (int i = 0; i < n; i++) {
    // A capture only vacates the from-square (the destination reads occupied
    // throughout), so lifting a piece that HAS a capture looks identical to
    // that capture completed. Only accept it once the victim was seen leaving.
    if (board[moves[i][2]][moves[i][3]] != ' ' && !((dipMask >> (moves[i][2] * 8 + moves[i][3])) & 1))
      continue;
    char cand[8][8];
    memcpy(cand, board, sizeof(cand));
    applyToBoard(cand, moves[i][0], moves[i][1], moves[i][2], moves[i][3]);
    if (occEquals(cand, occ)) { fr = moves[i][0]; fc = moves[i][1]; tr = moves[i][2]; tc = moves[i][3]; return true; }
  }
  return false;
}

// Board-only move application (promotion auto-queens, en passant, castling
// rook). No engine state — safe for candidate/preview boards.
void GameController::applyToBoard(char b[8][8], int fr, int fc, int tr, int tc) {
  char orig = b[fr][fc];
  bool ep = (toupper(orig) == 'P' && fc != tc && b[tr][tc] == ' ');
  char p = orig;
  b[fr][fc] = ' ';
  if (toupper(p) == 'P' && (tr == 0 || tr == 7)) p = ChessUtils::isWhitePiece(orig) ? 'Q' : 'q';
  b[tr][tc] = p;
  if (ep) b[fr][tc] = ' ';
  if (toupper(orig) == 'K' && abs(tc - fc) == 2) {
    if (tc > fc) { b[fr][5] = b[fr][7]; b[fr][7] = ' '; }
    else         { b[fr][3] = b[fr][0]; b[fr][0] = ' '; }
  }
}

void GameController::applyMove(int fr, int fc, int tr, int tc) {
  char orig = board[fr][fc];
  bool ep = (toupper(orig) == 'P' && fc != tc && board[tr][tc] == ' ');
  char victim = ep ? board[fr][tc] : board[tr][tc];
  eng.updateHalfmoveClock(orig, victim);
  applyToBoard(board, fr, fc, tr, tc);

  // Keep the engine's move-generation state in sync (it otherwise offers
  // castling forever and never generates en passant).
  if (toupper(orig) == 'P' && abs(tr - fr) == 2) eng.setEnPassantTarget((fr + tr) / 2, fc);
  else eng.clearEnPassantTarget();
  uint8_t rights = eng.getCastlingRights();
  if (orig == 'K') rights &= ~(0x01 | 0x02);
  else if (orig == 'k') rights &= ~(0x04 | 0x08);
  // Any move from or to a corner means that rook moved or was captured.
  if ((fr == 7 && fc == 7) || (tr == 7 && tc == 7)) rights &= ~0x01;
  if ((fr == 7 && fc == 0) || (tr == 7 && tc == 0)) rights &= ~0x02;
  if ((fr == 0 && fc == 7) || (tr == 0 && tc == 7)) rights &= ~0x04;
  if ((fr == 0 && fc == 0) || (tr == 0 && tc == 0)) rights &= ~0x08;
  eng.setCastlingRights(rights);
}

void GameController::afterMove(int fr, int fc, int tr, int tc) {
  if (onMove) onMove(algSquare(fr, fc), algSquare(tr, tc));
  turn = (turn == 'w') ? 'b' : 'w';
  liftShown = -1;
  dipMask = 0;
  checkCached = false;
  eng.recordPosition(board, turn);
  if (sideHasNoMove(turn)) {
    lastResult = eng.isKingInCheck(board, turn) ? (turn == 'w' ? 2 : 1) : 3;
    phase = OVER;
    DBG("GAME OVER result=%d", lastResult);
    showStatus();
    return;
  }
  if (eng.isThreefoldRepetition() || eng.isFiftyMoveRule() || eng.isInsufficientMaterial(board)) {
    lastResult = 3;
    phase = OVER;
    DBG("GAME OVER draw (rep/50/material)");
    showStatus();
    return;
  }
  phase = (vsComputer && turn != humanCol) ? THINK : HUMAN;
  DBG("AFTER move -> turn=%c phase=%s chk=%d", turn, phase == THINK ? "THINK" : "HUMAN", eng.isKingInCheck(board, turn));
  lights->showPosition(board);
  showStatus();
}

void GameController::showStatus() {
  if (!ui) return;
  if (phase == OVER) { ui->showResult(lastResult == 3 ? "DRAW" : (lastResult == 1 ? "WHITE WINS" : "BLACK WINS")); return; }
  if (phase == THINK) { ui->showBanner("COMPUTER", "THINKING"); return; }
  if (phase == GUIDE) {   // human executes the computer's move (was: stale "THINKING")
    char mv[8];
    snprintf(mv, sizeof(mv), "%c%d-%c%d", 'A' + pending.fromCol, 8 - pending.fromRow, 'A' + pending.toCol, 8 - pending.toRow);
    ui->showBanner("MAKE MY MOVE", mv);
    return;
  }
  bool chk = eng.isKingInCheck(board, turn);
  ui->showBanner(turn == 'w' ? "WHITE" : "BLACK", chk ? "CHECK!" : "TO MOVE");
}

// Light the computer's pending move for the human to execute: cyan = pick up
// here, white = place here (red if it's a capture).
void GameController::drawGuide() {
  lights->showPosition(board);
  bd->setSquareLED(pending.fromRow, pending.fromCol, LedColors::Cyan);
  bool cap = board[pending.toRow][pending.toCol] != ' ';
  bd->setSquareLED(pending.toRow, pending.toCol, cap ? LedColors::Red : LedColors::White);
  bd->showLEDs();
}

void GameController::tick() {
  uint32_t now = millis();
  bool okTap, okHold, upE, downE;
  pollButtons(now, okTap, okHold, upE, downE);

  // OK-hold during play -> "QUIT GAME?" confirm.
  if ((phase == SETUP || phase == HUMAN || phase == THINK || phase == GUIDE) && okHold) {
    savedPhase = phase;
    quitSel = 0;
    phase = QUIT_CONFIRM;
    ui->showConfirm("EXIT TO MENU?", "YES", "NO", quitSel);
    return;
  }
  if (phase == QUIT_CONFIRM) {
    if (upE || downE) { quitSel ^= 1; ui->showConfirm("EXIT TO MENU?", "YES", "NO", quitSel); }
    if (okTap) {
      if (quitSel == 0) { phase = IDLE; lights->clear(); ui->goHome(); }   // -> home menu
      else {
        phase = savedPhase;
        // GUIDE's frame is drawn once at THINK end and never re-drawn, so a
        // plain showPosition here would wipe the move guide permanently.
        if (phase == GUIDE) drawGuide(); else lights->showPosition(board);
        showStatus();
      }
    }
    return;   // buttons only; don't scan the board while paused
  }

  // Periodic frame resend: a corrupted LED transmission (flash-stall, supply
  // transient) otherwise persists until the next game event. 500 ms heals it
  // before it reads as "the board froze".
  if (now - lastLedRefresh > 500) { lastLedRefresh = now; bd->refreshLEDs(); }

  bool occ[8][8];
  bd->readSensors();
  snapshotOcc(occ);

  // Track every square seen empty since the board last matched the logical
  // position (feeds the capture gating in findSettledMove / GUIDE).
  if (phase == HUMAN || phase == GUIDE) {
    if (occEquals(board, occ)) dipMask = 0;
    else
      for (int r = 0; r < 8; r++)
        for (int c = 0; c < 8; c++)
          if (!occ[r][c]) dipMask |= 1ULL << (r * 8 + c);
  }

  switch (phase) {
    case SETUP: {
      // Count + light mismatches so setup is a live guide, not a silent wait.
      int wrong = 0;
      bd->clearAllLEDs(false);
      for (int r = 0; r < 8; r++)
        for (int c = 0; c < 8; c++) {
          bool want = (INIT[r][c] != ' ');
          if (occ[r][c] != want) {
            wrong++;
            // occupied-but-shouldn't-be = RED (remove); empty-but-should = WHITE (place here)
            bd->setSquareLED(r, c, occ[r][c] ? LedColors::Red : LedRGB{160, 160, 160});
          }
        }
      bd->showLEDs();

      static int lastWrong = -1;
      if (wrong != lastWrong) { DBG("SETUP %d off", wrong); lastWrong = wrong; }
      if (wrong == 0) {
        if (matchSince == 0) matchSince = now;
        if (now - matchSince > 400) {
          memcpy(board, INIT, sizeof(board));
          turn = 'w'; matchSince = 0;
          eng.recordPosition(board, turn);
          lights->showPosition(board);
          phase = (vsComputer && turn != humanCol) ? THINK : HUMAN;
          DBG("SETUP done -> %s", phase == THINK ? "THINK" : "HUMAN");
          showStatus();
        }
      } else {
        matchSince = 0;
        char cnt[12];
        snprintf(cnt, sizeof(cnt), "%d OFF", wrong);
        ui->showBanner("SET UP", cnt);   // e.g. "3 OFF" = 3 squares wrong
      }
      break;
    }

    case HUMAN: {
      int fr, fc, tr, tc;
      if (findSettledMove(occ, turn, fr, fc, tr, tc)) {
        if (matchSince == 0) { matchSince = now; DBG("HUMAN settle %s%s", algSquare(fr,fc).c_str(), algSquare(tr,tc).c_str()); }
        if (now - matchSince > 250) { DBG("HUMAN move %s%s", algSquare(fr,fc).c_str(), algSquare(tr,tc).c_str()); applyMove(fr, fc, tr, tc); lights->confirm(tr, tc); matchSince = 0; afterMove(fr, fc, tr, tc); }
      } else {
        matchSince = 0;
        // coaching: exactly one own piece lifted, nothing else disturbed
        int lifted = -1; bool other = false;
        for (int r = 0; r < 8; r++)
          for (int c = 0; c < 8; c++) {
            bool logical = board[r][c] != ' ';
            if (occ[r][c] != logical) {
              if (logical && !occ[r][c] && ChessUtils::getPieceColor(board[r][c]) == turn) { if (lifted < 0) lifted = r * 8 + c; else other = true; }
              else other = true;
            }
          }
        if (!other && lifted >= 0) { if (liftShown != lifted) { DBG("LIFT %s -> coach", algSquare(lifted/8, lifted%8).c_str()); lights->showMoves(board, lifted / 8, lifted % 8, eng); liftShown = lifted; } }
        else if (other && liftShown != -2) { DBG("HUMAN board disturbed (multi)"); liftShown = -2; }
        else if (!other && lifted < 0) {
          if (liftShown != -1) { lights->showPosition(board); liftShown = -1; checkCached = false; }
          // Check alarm: the threatened king breathes red until a move is made.
          if (!checkCached) {
            inCheckNow = eng.isKingInCheck(board, turn);
            if (inCheckNow) eng.findKingPosition(board, turn, chkKingR, chkKingC);
            checkCached = true;
            lastPulseV = 0;
          }
          if (inCheckNow) {
            uint8_t v = breath(now, 900);
            if (v != lastPulseV) {
              lastPulseV = v;
              bd->clearAllLEDs(false);
              bd->setSquareLED(chkKingR, chkKingC, LedRGB{v, 0, 0});
              bd->showLEDs();
            }
          }
        }
      }
      break;
    }

    case THINK: {
      showStatus();
      DBG("THINK depth=%d budget=%lums", ChessAi::depthForLevel(level), (unsigned long)ChessAi::budgetMsForLevel(level));
      uint32_t t0 = millis();
      pending = ai.bestMove(board, turn, ChessAi::depthForLevel(level), ChessAi::budgetMsForLevel(level));
      DBG("AI %s%s found=%d %lums", algSquare(pending.fromRow,pending.fromCol).c_str(), algSquare(pending.toRow,pending.toCol).c_str(), pending.found, (unsigned long)(millis()-t0));
      if (!pending.found) { lastResult = eng.isKingInCheck(board, turn) ? (turn == 'w' ? 2 : 1) : 3; phase = OVER; showStatus(); break; }
      // light the computer's move for the human to make
      drawGuide();
      matchSince = 0;
      phase = GUIDE;
      showStatus();   // "MAKE MY MOVE" — without this the banner stays "THINKING"
      break;
    }

    case GUIDE: {
      char cand[8][8];
      memcpy(cand, board, sizeof(cand));
      applyToBoard(cand, pending.fromRow, pending.fromCol, pending.toRow, pending.toCol);
      // Same capture ambiguity as findSettledMove: prefer to see the victim
      // leave the destination square before accepting. But a quick victim-swap
      // can slip between scans (each scan is ~126 ms, and the AI think blocks
      // sensing entirely), and then the dip bit NEVER sets — the old hard gate
      // dead-ended here forever with the guide LEDs and banner frozen. Unlike
      // HUMAN, the expected move is known, so a long stable exact match is
      // unambiguous: accept it after 1200 ms even without the dip.
      bool isCap = board[pending.toRow][pending.toCol] != ' ';
      bool dipSeen = !isCap || ((dipMask >> (pending.toRow * 8 + pending.toCol)) & 1);
      if (occEquals(cand, occ)) {
        if (matchSince == 0) matchSince = now;
        if (now - matchSince > (dipSeen ? 250u : 1200u)) {
          applyMove(pending.fromRow, pending.fromCol, pending.toRow, pending.toCol);
          lights->confirm(pending.toRow, pending.toCol);
          matchSince = 0;
          afterMove(pending.fromRow, pending.fromCol, pending.toRow, pending.toCol);
        }
      } else {
        matchSince = 0;
      }
      break;
    }

    case OVER: {
      // Result pulse: the whole board breathes in the outcome color until OK.
      // Red = the AI beat you; green = you beat the AI; white/blue = the
      // winning side in 2-player; cyan = draw.
      LedRGB base;
      if (lastResult == 3) base = LedRGB{0, 90, 110};
      else {
        char winner = (lastResult == 1) ? 'w' : 'b';
        if (vsComputer && winner != humanCol)      base = LedRGB{200, 0, 0};
        else if (vsComputer)                       base = LedRGB{0, 180, 50};
        else if (winner == 'w')                    base = LedRGB{170, 170, 170};
        else                                       base = LedRGB{40, 80, 220};
      }
      uint8_t v = breath(now, 2200);
      if (v != lastPulseV) {
        lastPulseV = v;
        LedRGB c = scaleColor(base, v);
        bd->clearAllLEDs(false);
        for (int r = 0; r < 8; r++)
          for (int cc = 0; cc < 8; cc++) bd->setSquareLED(r, cc, c);
        bd->showLEDs();
      }
      if (okTap) { phase = IDLE; lights->clear(); ui->goHome(); }   // -> home menu
      break;
    }

    default: break;
  }
}
