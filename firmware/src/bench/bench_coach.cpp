// bench_coach.cpp — PHASE 1 demo: the LED "light language" on the real engine.
// Build:  pio run -e bench_coach -t upload   (leave the OLED plugged in — no serial)
//
// Shows the ChessUp-style move coaching: a small position is set up in memory;
// step through its pieces and watch each piece's LEGAL moves light up with the
// path-walk language — WHITE = quiet move, RED = capture, CYAN = the piece,
// faint trail along sliding lines. Uses ChessEngine::getPossibleMoves (real
// chess rules). Power ripple on boot.
//
//   MODE   button = next piece
//   SELECT button = replay the power-on ripple
//   POWER  button = ripple off / on (standby toggle)
//
// The OLED names the selected piece (e.g. "d4 Queen"), so you can also check the
// LED map: does the lit square match the square the OLED names?
#include <Arduino.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include "engine/board_driver.h"
#include "engine/chess_engine.h"
#include "engine/led_language.h"
#include "engine/led_colors.h"
#include "pins.h"

#define OLED_W    128
#define OLED_H     32
#define OLED_ADDR 0x3C

static Adafruit_SSD1306 oled(OLED_W, OLED_H, &Wire, -1);
static BoardDriver driver;
static ChessEngine engine;
static LedLanguage lights(&driver);

static char board[8][8];        // row 0 = rank 8, col 0 = file a
static int  pieceSq[32][2];
static int  pieceCount = 0;
static int  sel = 0;
static bool standby = false;
static bool prevMode = false, prevSel = false, prevPwr = false;

static bool tapped(int pin, bool& prev) {
  bool s = (digitalRead(pin) == LOW);
  bool t = (s && !prev);
  prev = s;
  return t;
}

// A small demo position with quiet moves AND captures to show white vs red.
static void setupPosition() {
  for (int r = 0; r < 8; r++)
    for (int c = 0; c < 8; c++) board[r][c] = ' ';
  board[7][4] = 'K';   // white king  e1
  board[0][4] = 'k';   // black king  e8
  board[4][3] = 'Q';   // white queen d4  -> long rays + captures
  board[5][6] = 'N';   // white knight g3 -> L jumps
  board[3][4] = 'p';   // black pawn  e5  (Qd4 x e5)
  board[1][3] = 'r';   // black rook  d7  (Qd4 up the d-file, capture)
  board[2][6] = 'b';   // black bishop g6
  board[6][2] = 'P';   // white pawn  c2
}

static void indexPieces() {
  pieceCount = 0;
  for (int r = 0; r < 8; r++)
    for (int c = 0; c < 8; c++)
      if (board[r][c] != ' ') { pieceSq[pieceCount][0] = r; pieceSq[pieceCount][1] = c; pieceCount++; }
}

static const char* pieceName(char p) {
  switch (toupper(p)) {
    case 'K': return "King";   case 'Q': return "Queen"; case 'R': return "Rook";
    case 'B': return "Bishop"; case 'N': return "Knight"; case 'P': return "Pawn";
  }
  return "?";
}

static void drawOled() {
  int r = pieceSq[sel][0], c = pieceSq[sel][1];
  char p = board[r][c];
  oled.clearDisplay();
  oled.setTextColor(SSD1306_WHITE);
  oled.setTextSize(1);
  oled.setCursor(0, 0);
  oled.print("Move coaching");
  oled.setTextSize(2);
  oled.setCursor(0, 14);
  oled.printf("%c%d %s", 'a' + c, 8 - r, pieceName(p));   // file+rank, piece
  oled.display();
}

static void showSelection() {
  lights.showMoves(board, pieceSq[sel][0], pieceSq[sel][1], engine);
  drawOled();
}

void setup() {
  driver.beginHardware();
  driver.setBrightness(45);
  pinMode(PIN_BTN_MODE,   INPUT);
  pinMode(PIN_BTN_SELECT, INPUT_PULLUP);
  pinMode(PIN_BTN_POWER,  INPUT);
  Wire.begin(PIN_I2C_SDA, PIN_I2C_SCL);
  oled.begin(SSD1306_SWITCHCAPVCC, OLED_ADDR);
  oled.setRotation(2);

  engine.reset();
  setupPosition();
  indexPieces();
  lights.rippleOn();
  showSelection();
}

void loop() {
  if (tapped(PIN_BTN_POWER, prevPwr)) {
    standby = !standby;
    if (standby) { lights.rippleOff(); oled.clearDisplay(); oled.display(); }
    else         { lights.rippleOn(); showSelection(); }
  }
  if (standby) { delay(20); return; }

  if (tapped(PIN_BTN_MODE, prevMode)) { sel = (sel + 1) % pieceCount; showSelection(); }
  if (tapped(PIN_BTN_SELECT, prevSel)) { lights.rippleOn(); showSelection(); }
  delay(20);
}
