#ifndef CHESS_AI_H
#define CHESS_AI_H

// Offline on-device chess opponent — alpha-beta search over the existing
// ChessEngine move generator + a material/piece-square evaluation. Fully
// self-contained (no WiFi, no cloud). Difficulty = search depth.
//
// Replaces the cloud-Stockfish ChessBot for offline play.
#include "chess_engine.h"

struct AiMove {
  int fromRow, fromCol, toRow, toCol;
  bool found;
};

class ChessAi {
 public:
  // Difficulty -> max search depth / time budget. Tuned for the ESP32.
  static int depthForLevel(int level);          // level 1..8
  static uint32_t budgetMsForLevel(int level);  // level 1..8

  // Best move for `color` ('w'/'b'): iterative deepening up to maxDepth,
  // stopping when budgetMs is spent (the last fully searched depth wins).
  // found=false if the side to move has no legal move (checkmate/stalemate).
  AiMove bestMove(const char board[8][8], char color, int maxDepth, uint32_t budgetMs);

  // Static evaluation from `color`'s perspective (material + piece-square).
  static int evaluate(const char board[8][8], char color);

 private:
  ChessEngine eng;
  uint32_t deadline = 0;    // millis() timestamp when the search must stop
  uint32_t nodeCount = 0;
  bool aborted = false;
  bool outOfTime();
  int  search(char board[8][8], char color, int depth, int alpha, int beta);
  int  qsearch(char board[8][8], char color, int alpha, int beta, int qply);
  // Returns count; captures/promotions first in MVV-LVA order.
  int  genMoves(char board[8][8], char color, int moves[][4], bool capturesOnly = false);
  static void applyMove(char board[8][8], int fr, int fc, int tr, int tc);
};

#endif // CHESS_AI_H
