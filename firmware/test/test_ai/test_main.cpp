// Native tests for the offline AI (chess_ai) — quiescence, piece-square
// evaluation, and iterative deepening with a time budget.
#include <unity.h>
#include <string.h>
#include <Arduino.h>   // native stub (test/support) — millis()
#include "engine/chess_ai.h"
#include "engine/chess_engine.h"

void setUp(void) {}
void tearDown(void) {}

// row 0 = rank 8 ... row 7 = rank 1 (same layout as the firmware)
static void emptyBoard(char b[8][8]) { memset(b, ' ', 64); }

// Quiescence: at depth 1 a fixed-depth search sees "queen takes pawn = +1"
// and stops before the recapture. The quiescence search must resolve the
// exchange and refuse the poisoned pawn.
void test_quiescence_avoids_defended_pawn_grab(void) {
  char b[8][8];
  emptyBoard(b);
  b[7][4] = 'K';   // white Ke1
  b[0][4] = 'k';   // black Ke8
  b[7][3] = 'Q';   // white Qd1
  b[3][3] = 'p';   // black pawn d5 ...
  b[2][4] = 'p';   // ... defended by black pawn e6

  ChessAi ai;
  AiMove m = ai.bestMove(b, 'w', 1, 5000);
  TEST_ASSERT_TRUE(m.found);
  bool tookPoisonedPawn = (m.fromRow == 7 && m.fromCol == 3 && m.toRow == 3 && m.toCol == 3);
  TEST_ASSERT_FALSE_MESSAGE(tookPoisonedPawn, "Qxd5 loses the queen to exd5 — quiescence should refuse it");
}

// Piece-square tables: a pawn one step from promotion must be worth more than
// a pawn still at home (the old center-bonus table scored e3 above e7).
void test_eval_prefers_advanced_pawn(void) {
  char home[8][8], advanced[8][8];
  emptyBoard(home);
  home[7][4] = 'K'; home[0][4] = 'k';
  memcpy(advanced, home, 64);
  home[6][4]     = 'P';   // pawn e2
  advanced[1][4] = 'P';   // pawn e7

  TEST_ASSERT_GREATER_THAN_MESSAGE(ChessAi::evaluate(home, 'w'), ChessAi::evaluate(advanced, 'w'),
                                   "pawn on e7 must evaluate above pawn on e2");
}

// Iterative deepening: a deep request with a small budget must return quickly
// with the best move from the last completed depth — not run to full depth.
void test_bestmove_respects_time_budget(void) {
  char b[8][8] = {
      {'r', 'n', 'b', 'q', 'k', 'b', 'n', 'r'},
      {'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'},
      {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
      {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
      {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
      {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
      {'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'},
      {'R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R'},
  };
  ChessAi ai;
  uint32_t t0 = millis();
  AiMove m = ai.bestMove(b, 'w', 8, 250);
  uint32_t elapsed = millis() - t0;

  TEST_ASSERT_TRUE(m.found);
  TEST_ASSERT_LESS_THAN_MESSAGE(2000, elapsed, "must stop near the 250ms budget, not search to depth 8");
  ChessEngine eng;
  TEST_ASSERT_TRUE_MESSAGE(eng.isValidMove(b, m.fromRow, m.fromCol, m.toRow, m.toCol, 'w'),
                           "budgeted search must still return a legal move");
}

// Back-rank mate in one must be found through the new budgeted entry point.
void test_finds_back_rank_mate(void) {
  char b[8][8];
  emptyBoard(b);
  b[0][6] = 'k';                            // black Kg8
  b[1][5] = 'p'; b[1][6] = 'p'; b[1][7] = 'p';   // pawns f7 g7 h7
  b[7][0] = 'R';                            // white Ra1
  b[7][6] = 'K';                            // white Kg1

  ChessAi ai;
  AiMove m = ai.bestMove(b, 'w', 4, 5000);
  TEST_ASSERT_TRUE(m.found);
  TEST_ASSERT_EQUAL_MESSAGE(7, m.fromRow, "expected Ra1-a8#");
  TEST_ASSERT_EQUAL_MESSAGE(0, m.fromCol, "expected Ra1-a8#");
  TEST_ASSERT_EQUAL_MESSAGE(0, m.toRow, "expected Ra1-a8#");
  TEST_ASSERT_EQUAL_MESSAGE(0, m.toCol, "expected Ra1-a8#");
}

int main(int, char**) {
  UNITY_BEGIN();
  RUN_TEST(test_quiescence_avoids_defended_pawn_grab);
  RUN_TEST(test_eval_prefers_advanced_pawn);
  RUN_TEST(test_bestmove_respects_time_budget);
  RUN_TEST(test_finds_back_rank_mate);
  return UNITY_END();
}
