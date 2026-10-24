#include "chess_moves.h"
#include "chess_utils.h"
#include "led_colors.h"
#include "move_history.h"
#include "igame_host.h"
#include "log.h"
#include <Arduino.h>

ChessMoves::ChessMoves(BoardDriver* bd, ChessEngine* ce, IGameHost* host, MoveHistory* mh) : ChessGame(bd, ce, host, mh) {}

void ChessMoves::begin() {
  engineLog.println("=== Starting Chess Moves Mode ===");
  initializeBoard();
  if (moveHistory->hasLiveGame()) {
    if (!resumeLiveGameIfBoardMatches()) {
      gameOver = true;
      return;
    }
  } else {
    moveHistory->startGame(GAME_MODE_CHESS_MOVES);
    moveHistory->addFen(ChessUtils::boardToFEN(board, currentTurn, chessEngine));
  }
  waitForBoardSetup(board);
}

void ChessMoves::update() {
  boardDriver->readSensors();

  // Check for physical resign/draw gesture (both kings lifted)
  if (checkPhysicalResignOrDraw()) return;

  int fromRow, fromCol, toRow, toCol;
  if (tryPlayerMove(currentTurn, fromRow, fromCol, toRow, toCol)) {
    applyMove(fromRow, fromCol, toRow, toCol);
    updateGameStatus();
    host->updateBoardState(ChessUtils::boardToFEN(board, currentTurn, chessEngine), ChessUtils::evaluatePosition(board));
  }

  boardDriver->updateSensorPrev();
}
