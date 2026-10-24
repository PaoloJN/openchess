#ifndef OPENCHESS_ENGINE_IGAME_HOST_H
#define OPENCHESS_ENGINE_IGAME_HOST_H

#include <Arduino.h>

// Abstract interface that the shell implements to mediate
// engine <-> outside-world state for game modes.
//
// Method signatures mirror the original WiFiManagerESP32 surface
// that engine code calls (chess_game.cpp, chess_bot.cpp,
// chess_lichess.cpp, chess_moves.cpp).
class IGameHost {
 public:
  virtual ~IGameHost() = default;

  // Returns true if WiFi (or whatever transport the shell uses) is up.
  // Implementations may attempt a reconnect.
  virtual bool ensureConnected() = 0;

  // Push the current board state (FEN + evaluation in pawns, positive = white).
  virtual void updateBoardState(const String& fen, float evaluation = 0.0f) = 0;

  // Begin waiting for the web client to pick a promotion piece.
  // color: 'w' or 'b' — color of the promoting pawn.
  virtual void startPromotionWait(char color) = 0;

  // True while the engine is awaiting a promotion choice from the shell.
  virtual bool isPromotionPending() const = 0;

  // The choice supplied by the shell: 'q','r','b','n' (or ' ' if none yet).
  virtual char getPromotionChoice() const = 0;

  // Clear the pending promotion state.
  virtual void clearPromotion() = 0;
};

#endif
