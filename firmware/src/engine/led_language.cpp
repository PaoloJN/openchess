#include "led_language.h"
#include <Arduino.h>
#include <math.h>

// Faint trail along a sliding piece's path, and a dim marker for other pieces.
static const LedRGB TRAIL = {55, 55, 55};
static const LedRGB PIECE = {6, 6, 16};   // dim bluish "a piece sits here"
// Soft white used for the power on/off ripple (dimmer than full white, so it's
// gentle and low-current across the whole board).
static const LedRGB RIPPLE = {70, 70, 70};

static int sgn(int x) { return (x > 0) - (x < 0); }

// Physical position (0..8 grid units) of each of the 81 corner LEDs, derived
// once from the square->corner map so ripples radiate from the TRUE board
// center regardless of the LED chain wiring.
static float RPX[LED_COUNT], RPY[LED_COUNT];
static bool  rmapDone = false;
static void buildRippleMap(BoardDriver* bd) {
  if (rmapDone) return;
  int cnt[LED_COUNT];
  for (int i = 0; i < LED_COUNT; i++) { RPX[i] = 0; RPY[i] = 0; cnt[i] = 0; }
  for (int r = 0; r < 8; r++)
    for (int c = 0; c < 8; c++) {
      int corners[4];
      bd->cornersOf(r, c, corners);
      for (int k = 0; k < 4; k++) {
        int idx = corners[k];
        if (idx < 0 || idx >= LED_COUNT) continue;
        RPX[idx] += c + 0.5f; RPY[idx] += r + 0.5f; cnt[idx]++;
      }
    }
  for (int i = 0; i < LED_COUNT; i++) { if (cnt[i]) { RPX[i] /= cnt[i]; RPY[i] /= cnt[i]; } else { RPX[i] = 4; RPY[i] = 4; } }
  rmapDone = true;
}

// One frame of a soft radial ring at radius R (per-LED, smooth falloff).
static void rippleFrame(BoardDriver* bd, float R) {
  const float cx = 4.0f, cy = 4.0f, W = 1.8f;   // ring half-width
  for (int i = 0; i < LED_COUNT; i++) {
    float dx = RPX[i] - cx, dy = RPY[i] - cy;
    float d = sqrtf(dx * dx + dy * dy);
    float diff = fabsf(d - R);
    if (diff < W) {
      float t = 1.0f - diff / W;                 // brightest at the wavefront
      uint8_t v = (uint8_t)(RIPPLE.r * t);
      bd->setPixelRaw(i, LedRGB{v, v, v});
    } else {
      bd->setPixelRaw(i, LedColors::Off);
    }
  }
  bd->showLEDs();
}

void LedLanguage::clear() { bd->clearAllLEDs(true); }

// Power ON: a soft white ring swells outward from the board's center.
void LedLanguage::rippleOn() {
  buildRippleMap(bd);
  for (float R = 0.0f; R <= 7.0f; R += 0.22f) { rippleFrame(bd, R); delay(52); }
  bd->clearAllLEDs(true);
}

// Power OFF: the ring draws inward and collapses to the center, then dark.
void LedLanguage::rippleOff() {
  buildRippleMap(bd);
  for (float R = 7.0f; R >= -0.5f; R -= 0.22f) { rippleFrame(bd, R); delay(52); }
  bd->clearAllLEDs(true);
}

// Idle in-game state: board is DARK. Coaching (showMoves) lights the board only
// when a piece is lifted — cleaner and brighter than a dim all-pieces glow
// (which read as patchy/one-row at low brightness across shared corner LEDs).
void LedLanguage::showPosition(const char board[8][8]) {
  (void)board;
  bd->clearAllLEDs(true);
}

void LedLanguage::showMoves(const char board[8][8], int fromRow, int fromCol, ChessEngine& eng) {
  int moves[32][2];
  int n = 0;
  eng.getPossibleMoves(board, fromRow, fromCol, n, moves);

  LedRGB target[8][8];
  int dist[8][8];
  int maxd = 1;
  for (int r = 0; r < 8; r++)
    for (int c = 0; c < 8; c++) { target[r][c] = LedColors::Off; dist[r][c] = -1; }

  for (int i = 0; i < n; i++) {
    int tr = moves[i][0], tc = moves[i][1];
    bool capture = (board[tr][tc] != ' ');
    target[tr][tc] = capture ? LedColors::Red : LedColors::White;
    dist[tr][tc]   = max(abs(tr - fromRow), abs(tc - fromCol));
    if (dist[tr][tc] > maxd) maxd = dist[tr][tc];
    // For sliding lines, light the empty squares walked through as a faint trail.
    bool line = (tr == fromRow) || (tc == fromCol) || (abs(tr - fromRow) == abs(tc - fromCol));
    if (line) {
      int dr = sgn(tr - fromRow), dc = sgn(tc - fromCol);
      int r = fromRow + dr, c = fromCol + dc;
      while (r != tr || c != tc) {
        if (dist[r][c] < 0) { target[r][c] = TRAIL; dist[r][c] = max(abs(r - fromRow), abs(c - fromCol)); }
        r += dr; c += dc;
      }
    }
  }

  // "Walk" the highlights outward from the source, ring by ring. Each frame is
  // rebuilt from a cleared buffer so the compositor renders full, clean corners.
  // The final frame (all targets lit) persists so the player can study it.
  for (int radius = 1; radius <= maxd; radius++) {
    bd->clearAllLEDs(false);
    bd->setSquareLED(fromRow, fromCol, LedColors::Cyan);   // the lifted piece
    for (int r = 0; r < 8; r++)
      for (int c = 0; c < 8; c++)
        if (dist[r][c] >= 0 && dist[r][c] <= radius)
          bd->setSquareLED(r, c, target[r][c]);
    bd->showLEDs();
    delay(55);
  }
}

void LedLanguage::confirm(int row, int col) {
  for (int i = 0; i < 2; i++) {
    bd->clearAllLEDs(false); bd->setSquareLED(row, col, LedColors::Green); bd->showLEDs(); delay(140);
    bd->clearAllLEDs(true);  delay(110);
  }
}

void LedLanguage::reject(int row, int col) {
  for (int i = 0; i < 2; i++) {
    bd->clearAllLEDs(false); bd->setSquareLED(row, col, LedColors::Red); bd->showLEDs(); delay(120);
    bd->clearAllLEDs(true);  delay(100);
  }
}
