// diag_a5.cpp — DIAGNOSE a stuck/glitchy hall sensor (originally A5/U5)
// Build:  pio run -e bench_diag -t upload   (serial @115200)
// Set DIAG_COL/DIAG_ROW below to the suspect square (0-based file/rank).
//
// Powers the suspect column, then samples ALL 8 row-sense lines every 2ms for 100ms,
// and prints a timeline per line. '#' = line LOW (= "magnet/asserted"),
// '.' = HIGH (idle). Run with NO magnet anywhere.
//
// READING IT (focus on S4 = A5 = U5):
//   .......................................   idle the whole time   -> healthy
//   ####.................................     low at start, then settles -> SLOW STARTUP (timing).
//                                               set SETTLE_MS just past the last '#'.
//   ..#..#....#...#..#...#................     random scattered lows  -> NOISE / bad joint on U5.
//                                               reflow U5 (pins OUT & GND).
// Compare S4's row against the other S rows — if only S4 misbehaves, it's U5.
#include <Arduino.h>
#include "pins.h"

// Suspect square: D2 -> file D = col 3, rank 2 = row line S1
static const int DIAG_COL = 3;
static const int DIAG_ROW = 1;
static const char* DIAG_NAME = "[D2]";

static const int N = 50;       // samples
static const int STEP_MS = 2;  // 50 * 2ms = 100ms window
static char trace[MATRIX_ROWS][N + 1];

void setup() {
  Serial.begin(115200);
  delay(500);
  Serial.printf("\n=== DIAG: %s (column %c) — run with NO magnet/piece ===\n", DIAG_NAME, 'A' + DIAG_COL);
  for (int c = 0; c < MATRIX_COLS; c++) { pinMode(PIN_COL_DRV[c], OUTPUT); digitalWrite(PIN_COL_DRV[c], LOW); }
  for (int r = 0; r < MATRIX_ROWS; r++)   pinMode(PIN_ROW_SENSE[r], INPUT);
}

void loop() {
  // make sure all columns are off and lines have settled to idle
  for (int c = 0; c < MATRIX_COLS; c++) digitalWrite(PIN_COL_DRV[c], LOW);
  delay(200);

  // power ONLY the suspect column, capture the first 100ms
  digitalWrite(PIN_COL_DRV[DIAG_COL], HIGH);
  for (int i = 0; i < N; i++) {
    for (int r = 0; r < MATRIX_ROWS; r++)
      trace[r][i] = (digitalRead(PIN_ROW_SENSE[r]) == LOW) ? '#' : '.';
    delayMicroseconds(STEP_MS * 1000);
  }
  digitalWrite(PIN_COL_DRV[DIAG_COL], LOW);

  for (int r = 0; r < MATRIX_ROWS; r++) trace[r][N] = 0;

  Serial.println("\n     time -> (each char = 2ms, total 100ms)");
  for (int r = 0; r < MATRIX_ROWS; r++) {
    Serial.printf(" S%d %s %s\n", r, (r == DIAG_ROW) ? DIAG_NAME : "    ", trace[r]);
  }
  delay(1500);
}
