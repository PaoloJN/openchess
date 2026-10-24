// board_read.cpp — PHASE 0 bench: read the full 8x8 board THROUGH BoardDriver.
// Build:  pio run -e bench_board -t upload   (serial @115200)
//
// Proves the adapted engine hardware layer works on our board: the direct-GPIO
// column scan (TBD62783A) + fixed corner-LED map let BoardDriver read all 64
// squares and light the correct corners. Place magnets; watch the serial grid
// update and the occupied squares' 4 corners light white.
//
// Uses the real engine BoardDriver (not a bench reimplementation), so a pass
// here means the chess engine can read/drive this board.
#include <Arduino.h>
#include "engine/board_driver.h"
#include "engine/led_colors.h"

static BoardDriver driver;
static bool prevOcc[NUM_ROWS][NUM_COLS];
static bool firstPrint = true;

void setup() {
  Serial.begin(115200);
  delay(300);
  Serial.println("\n=== PHASE 0: BoardDriver full-board read ===");
  driver.beginHardware();
  driver.setBrightness(40);   // keep current safe
  Serial.println("Place magnets. Grid: '#'=occupied '.'=empty. Occupied squares light white.");
  Serial.println("row index = rank (S0..S7), column = file a..h.");
}

static void printBoard() {
  Serial.println();
  Serial.println("    a b c d e f g h");
  for (int row = 0; row < NUM_ROWS; row++) {
    Serial.printf(" %d ", row);
    for (int col = 0; col < NUM_COLS; col++)
      Serial.printf(" %c", driver.getSensorState(row, col) ? '#' : '.');
    Serial.println();
  }
}

void loop() {
  driver.readSensors();

  // Light the corners of every occupied square (white).
  driver.clearAllLEDs(false);
  for (int row = 0; row < NUM_ROWS; row++)
    for (int col = 0; col < NUM_COLS; col++)
      if (driver.getSensorState(row, col))
        driver.setSquareLED(row, col, LedColors::White);
  driver.showLEDs();

  // Print only when occupancy changes (keeps the serial readable).
  bool changed = firstPrint;
  for (int row = 0; row < NUM_ROWS; row++)
    for (int col = 0; col < NUM_COLS; col++) {
      bool s = driver.getSensorState(row, col);
      if (s != prevOcc[row][col]) changed = true;
      prevOcc[row][col] = s;
    }
  if (changed) { printBoard(); firstPrint = false; }

  driver.updateSensorPrev();
  delay(60);
}
