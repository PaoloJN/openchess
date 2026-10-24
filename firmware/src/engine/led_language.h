#ifndef LED_LANGUAGE_H
#define LED_LANGUAGE_H

// The OpenChess "light language": one place that owns all board lighting so the
// board speaks a coherent, premium visual vocabulary (not gamer RGB). Every
// behavior is functional — it communicates game state.
//
// Built on BoardDriver's per-square LED primitive (setSquareLED/showLEDs).
#include "board_driver.h"
#include "chess_engine.h"
#include "led_colors.h"

class LedLanguage {
 public:
  explicit LedLanguage(BoardDriver* bd) : bd(bd) {}

  // Power transitions: a bloom that ripples out from the board center.
  void rippleOn();    // bloom outward, then settle to dark (ready)
  void rippleOff();   // all-on, collapse inward to center, then dark

  // Show the current position faintly (so the player can see where pieces are).
  void showPosition(const char board[8][8]);

  // Move coaching: light the legal destinations of the piece on (fromRow,fromCol)
  // with a path that "walks" outward from the source. White = quiet move,
  // Red = capture, Cyan = the source square. Sliding lines show a faint trail.
  void showMoves(const char board[8][8], int fromRow, int fromCol, ChessEngine& eng);

  // Feedback pulses.
  void confirm(int row, int col);   // soft green (move completed)
  void reject(int row, int col);    // red flash (illegal / wrong turn)
  void clear();

 private:
  BoardDriver* bd;
};

#endif // LED_LANGUAGE_H
