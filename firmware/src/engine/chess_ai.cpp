#include "chess_ai.h"
#include "chess_utils.h"
#include <Arduino.h>
#include <string.h>

// Centipawn piece values (Michniewski's simplified evaluation).
static int pieceValue(char p) {
  switch (toupper(p)) {
    case 'P': return 100;
    case 'N': return 320;
    case 'B': return 330;
    case 'R': return 500;
    case 'Q': return 900;
    case 'K': return 20000;
  }
  return 0;
}

// Piece-square tables from Tomasz Michniewski's Simplified Evaluation
// Function (chessprogramming.org/Simplified_Evaluation_Function).
// Indexed [row*8+col] with row 0 = rank 8, from White's side; mirror the row
// for Black. ~450 bytes total, lives in flash.
static const int8_t PST_PAWN[64] = {
     0,  0,  0,  0,  0,  0,  0,  0,
    50, 50, 50, 50, 50, 50, 50, 50,
    10, 10, 20, 30, 30, 20, 10, 10,
     5,  5, 10, 25, 25, 10,  5,  5,
     0,  0,  0, 20, 20,  0,  0,  0,
     5, -5,-10,  0,  0,-10, -5,  5,
     5, 10, 10,-20,-20, 10, 10,  5,
     0,  0,  0,  0,  0,  0,  0,  0};
static const int8_t PST_KNIGHT[64] = {
   -50,-40,-30,-30,-30,-30,-40,-50,
   -40,-20,  0,  0,  0,  0,-20,-40,
   -30,  0, 10, 15, 15, 10,  0,-30,
   -30,  5, 15, 20, 20, 15,  5,-30,
   -30,  0, 15, 20, 20, 15,  0,-30,
   -30,  5, 10, 15, 15, 10,  5,-30,
   -40,-20,  0,  5,  5,  0,-20,-40,
   -50,-40,-30,-30,-30,-30,-40,-50};
static const int8_t PST_BISHOP[64] = {
   -20,-10,-10,-10,-10,-10,-10,-20,
   -10,  0,  0,  0,  0,  0,  0,-10,
   -10,  0,  5, 10, 10,  5,  0,-10,
   -10,  5,  5, 10, 10,  5,  5,-10,
   -10,  0, 10, 10, 10, 10,  0,-10,
   -10, 10, 10, 10, 10, 10, 10,-10,
   -10,  5,  0,  0,  0,  0,  5,-10,
   -20,-10,-10,-10,-10,-10,-10,-20};
static const int8_t PST_ROOK[64] = {
     0,  0,  0,  0,  0,  0,  0,  0,
     5, 10, 10, 10, 10, 10, 10,  5,
    -5,  0,  0,  0,  0,  0,  0, -5,
    -5,  0,  0,  0,  0,  0,  0, -5,
    -5,  0,  0,  0,  0,  0,  0, -5,
    -5,  0,  0,  0,  0,  0,  0, -5,
    -5,  0,  0,  0,  0,  0,  0, -5,
     0,  0,  0,  5,  5,  0,  0,  0};
static const int8_t PST_QUEEN[64] = {
   -20,-10,-10, -5, -5,-10,-10,-20,
   -10,  0,  0,  0,  0,  0,  0,-10,
   -10,  0,  5,  5,  5,  5,  0,-10,
    -5,  0,  5,  5,  5,  5,  0, -5,
     0,  0,  5,  5,  5,  5,  0, -5,
   -10,  5,  5,  5,  5,  5,  0,-10,
   -10,  0,  5,  0,  0,  0,  0,-10,
   -20,-10,-10, -5, -5,-10,-10,-20};
static const int8_t PST_KING_MG[64] = {
   -30,-40,-40,-50,-50,-40,-40,-30,
   -30,-40,-40,-50,-50,-40,-40,-30,
   -30,-40,-40,-50,-50,-40,-40,-30,
   -30,-40,-40,-50,-50,-40,-40,-30,
   -20,-30,-30,-40,-40,-30,-30,-20,
   -10,-20,-20,-20,-20,-20,-20,-10,
    20, 20,  0,  0,  0,  0, 20, 20,
    20, 30, 10,  0,  0, 10, 30, 20};
static const int8_t PST_KING_EG[64] = {
   -50,-40,-30,-20,-20,-30,-40,-50,
   -30,-20,-10,  0,  0,-10,-20,-30,
   -30,-10, 20, 30, 30, 20,-10,-30,
   -30,-10, 30, 40, 40, 30,-10,-30,
   -30,-10, 30, 40, 40, 30,-10,-30,
   -30,-10, 20, 30, 30, 20,-10,-30,
   -30,-30,  0,  0,  0,  0,-30,-30,
   -50,-30,-30,-30,-30,-30,-30,-50};

static const int8_t* pstFor(char upperPiece, bool endgame) {
  switch (upperPiece) {
    case 'P': return PST_PAWN;
    case 'N': return PST_KNIGHT;
    case 'B': return PST_BISHOP;
    case 'R': return PST_ROOK;
    case 'Q': return PST_QUEEN;
    case 'K': return endgame ? PST_KING_EG : PST_KING_MG;
  }
  return PST_PAWN;
}

int ChessAi::depthForLevel(int level) {
  static const int8_t D[8] = {2, 3, 4, 5, 5, 6, 6, 7};
  if (level < 1) level = 1;
  if (level > 8) level = 8;
  return D[level - 1];
}

uint32_t ChessAi::budgetMsForLevel(int level) {
  static const uint16_t B[8] = {200, 400, 700, 1200, 2000, 3000, 4500, 6000};
  if (level < 1) level = 1;
  if (level > 8) level = 8;
  return B[level - 1];
}

int ChessAi::evaluate(const char board[8][8], char color) {
  // Michniewski's endgame rule: both queens gone -> king walks to the center.
  bool endgame = true;
  for (int r = 0; r < 8 && endgame; r++)
    for (int c = 0; c < 8; c++)
      if (toupper(board[r][c]) == 'Q') { endgame = false; break; }

  int score = 0;   // from White's perspective
  for (int r = 0; r < 8; r++)
    for (int c = 0; c < 8; c++) {
      char p = board[r][c];
      if (p == ' ') continue;
      const int8_t* pst = pstFor(toupper(p), endgame);
      if (ChessUtils::isWhitePiece(p)) score += pieceValue(p) + pst[r * 8 + c];
      else                             score -= pieceValue(p) + pst[(7 - r) * 8 + c];
    }
  return (color == 'w') ? score : -score;   // side-to-move perspective (negamax)
}

void ChessAi::applyMove(char board[8][8], int fr, int fc, int tr, int tc) {
  char p = board[fr][fc];
  // En passant: pawn moves diagonally to an empty square — remove the victim.
  if (toupper(p) == 'P' && fc != tc && board[tr][tc] == ' ')
    board[fr][tc] = ' ';
  // Castling: move the rook too, so the search evaluates the real position.
  if (toupper(p) == 'K' && abs(tc - fc) == 2) {
    if (tc > fc) { board[fr][5] = board[fr][7]; board[fr][7] = ' '; }
    else         { board[fr][3] = board[fr][0]; board[fr][0] = ' '; }
  }
  board[fr][fc] = ' ';
  // Auto-queen promotions in search (the common case).
  if (toupper(p) == 'P' && (tr == 0 || tr == 7))
    p = ChessUtils::isWhitePiece(p) ? 'Q' : 'q';
  board[tr][tc] = p;
}

// Generate legal moves for `color`. Captures (and promotions) come first,
// ordered MVV-LVA — most valuable victim, least valuable attacker — which is
// what makes alpha-beta prune well. capturesOnly=true is the quiescence set.
int ChessAi::genMoves(char board[8][8], char color, int moves[][4], bool capturesOnly) {
  static int quiet[128][4];    // static: keep buffers off the recursion stack
  static int cscore[96];
  int nc = 0, nq = 0;
  for (int r = 0; r < 8; r++)
    for (int c = 0; c < 8; c++) {
      char p = board[r][c];
      if (p == ' ' || ChessUtils::getPieceColor(p) != color) continue;
      int dst[32][2];
      int m = 0;
      eng.getPossibleMoves(board, r, c, m, dst);
      for (int i = 0; i < m; i++) {
        int tr = dst[i][0], tc = dst[i][1];
        char victim = board[tr][tc];
        bool isPawn = (toupper(p) == 'P');
        bool ep = (isPawn && tc != c && victim == ' ');
        bool promo = (isPawn && (tr == 0 || tr == 7));
        bool noisy = (victim != ' ') || ep || promo;
        if (noisy) {
          if (nc >= 96) continue;
          int score = (ep ? 100 : pieceValue(victim)) * 8 - pieceValue(p) / 100 + (promo ? 800 : 0);
          // insertion sort by descending score
          int j = nc++;
          while (j > 0 && cscore[j - 1] < score) {
            memcpy(moves[j], moves[j - 1], sizeof(moves[0]));
            cscore[j] = cscore[j - 1];
            j--;
          }
          moves[j][0] = r; moves[j][1] = c; moves[j][2] = tr; moves[j][3] = tc;
          cscore[j] = score;
        } else if (!capturesOnly) {
          if (nq >= 128) continue;
          quiet[nq][0] = r; quiet[nq][1] = c; quiet[nq][2] = tr; quiet[nq][3] = tc; nq++;
        }
      }
    }
  if (capturesOnly) return nc;
  for (int i = 0; i < nq && nc + i < 128; i++) memcpy(moves[nc + i], quiet[i], sizeof(quiet[0]));
  int total = nc + nq;
  return total > 128 ? 128 : total;
}

// Per-ply move buffers (static, so recursion doesn't pile them on the stack —
// that overflowed the ESP32 loop task and rebooted the chip). MAX_PLY covers
// the deepest main search we run; quiescence has its own smaller buffers.
#define MAX_PLY 8
#define QMAX_PLY 6
static int g_moves[MAX_PLY][128][4];
static int q_moves[QMAX_PLY][96][4];

bool ChessAi::outOfTime() {
  if (aborted) return true;
  if ((++nodeCount & 0x3F) == 0 && (int32_t)(millis() - deadline) >= 0)
    aborted = true;
  return aborted;
}

// Quiescence search: at the depth horizon, keep resolving captures until the
// position is quiet, so the engine never stops mid-exchange and misjudges
// (the classic "grabs a defended pawn" blunder).
int ChessAi::qsearch(char board[8][8], char color, int alpha, int beta, int qply) {
  if (outOfTime()) return alpha;
  int stand = evaluate(board, color);
  if (stand >= beta) return beta;
  if (stand > alpha) alpha = stand;
  if (qply >= QMAX_PLY) return alpha;

  int (*moves)[4] = q_moves[qply];
  int n = genMoves(board, color, moves, true);
  for (int i = 0; i < n; i++) {
    char nb[8][8];
    memcpy(nb, board, 64);
    applyMove(nb, moves[i][0], moves[i][1], moves[i][2], moves[i][3]);
    int sc = -qsearch(nb, ChessUtils::oppositeColor(color), -beta, -alpha, qply + 1);
    if (aborted) return alpha;
    if (sc >= beta) return beta;
    if (sc > alpha) alpha = sc;
  }
  return alpha;
}

int ChessAi::search(char board[8][8], char color, int depth, int alpha, int beta) {
  if (outOfTime()) return 0;
  if (depth <= 0) return qsearch(board, color, alpha, beta, 0);

  int ply = MAX_PLY - depth;
  if (ply < 0) ply = 0; else if (ply >= MAX_PLY) ply = MAX_PLY - 1;
  int (*moves)[4] = g_moves[ply];
  int n = genMoves(board, color, moves, false);
  if (n == 0) {
    if (eng.isKingInCheck(board, color)) return -30000 - depth;   // checkmated (deeper mates score lower)
    return 0;                                                     // stalemate
  }

  int best = -32000;
  for (int i = 0; i < n; i++) {
    char nb[8][8];
    memcpy(nb, board, 64);
    applyMove(nb, moves[i][0], moves[i][1], moves[i][2], moves[i][3]);
    int sc = -search(nb, ChessUtils::oppositeColor(color), depth - 1, -beta, -alpha);
    if (aborted) return best > -32000 ? best : 0;
    if (sc > best) best = sc;
    if (best > alpha) alpha = best;
    if (alpha >= beta) break;
  }
  return best;
}

AiMove ChessAi::bestMove(const char board[8][8], char color, int maxDepth, uint32_t budgetMs) {
  char b[8][8];
  memcpy(b, board, 64);
  static int moves[128][4];
  int n = genMoves(b, color, moves, false);

  AiMove result{0, 0, 0, 0, false};
  if (n == 0) return result;

  deadline = millis() + budgetMs;
  aborted = false;
  nodeCount = 0;
  if (maxDepth < 1) maxDepth = 1;
  if (maxDepth > MAX_PLY) maxDepth = MAX_PLY;

  // Iterative deepening: each depth reuses the previous best move first (best
  // ordering there is), and the last fully useful iteration wins. If the
  // budget expires mid-iteration, completed root moves still count — they were
  // searched at full depth.
  for (int depth = 1; depth <= maxDepth && !aborted; depth++) {
    int best = -32000, alpha = -32000, beta = 32000, bestIdx = -1;
    for (int i = 0; i < n; i++) {
      char nb[8][8];
      memcpy(nb, b, 64);
      applyMove(nb, moves[i][0], moves[i][1], moves[i][2], moves[i][3]);
      int sc = -search(nb, ChessUtils::oppositeColor(color), depth - 1, -beta, -alpha);
      if (aborted) break;   // sc is garbage — don't use it
      if (sc > best || bestIdx < 0) { best = sc; bestIdx = i; }
      if (best > alpha) alpha = best;
    }
    if (bestIdx >= 0) {
      result = {moves[bestIdx][0], moves[bestIdx][1], moves[bestIdx][2], moves[bestIdx][3], true};
      // Rotate the best move to the front for the next iteration.
      if (bestIdx > 0) {
        int keep[4];
        memcpy(keep, moves[bestIdx], sizeof(keep));
        memmove(moves[1], moves[0], bestIdx * sizeof(moves[0]));
        memcpy(moves[0], keep, sizeof(keep));
      }
      if (best > 29000) break;   // forced mate found — no need to look deeper
    }
  }
  return result;
}
