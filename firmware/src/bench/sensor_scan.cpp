// sensor_scan.cpp — BENCH TEST 2: hall sensor matrix (serial)
// Build:  pio run -e bench_sensor -t upload   (then open serial @115200)
//
// What it proves: the 64 DRV5032FC halls read correctly. Wave a magnet over
// a square -> that cell flips to [#]. This is THE test that matters most.
//
// How the scan works: power ONE column at a time via the TBD62783A high-side
// driver (input HIGH -> 5V on that column), wait for the sensor to settle,
// then read all 8 row-sense lines. Hall output is open-drain pulled up to
// 3.3V, so a magnet pulls the line LOW -> "present".
//
//   columns = files A..H  (PIN_COL_DRV)
//   rows    = ranks S0..S7 (PIN_ROW_SENSE)
//
// NOTE: the DRV5032FC samples its field at 20Hz, so give each column ~50ms
// after powering before reading. Full board scan ~= 8 * 50ms = 400ms.
#include <Arduino.h>
#include "pins.h"

static const int SETTLE_MS = 55;   // per-column wait (>= one 20Hz sample); tune down later

static bool present[MATRIX_COLS][MATRIX_ROWS];  // [file][rank]

void setup() {
  Serial.begin(115200);
  delay(500);
  Serial.println("\n=== BENCH 2: sensor scan ===");

  for (int c = 0; c < MATRIX_COLS; c++) {
    pinMode(PIN_COL_DRV[c], OUTPUT);
    digitalWrite(PIN_COL_DRV[c], LOW);     // all columns off
  }
  for (int r = 0; r < MATRIX_ROWS; r++) {
    pinMode(PIN_ROW_SENSE[r], INPUT);      // 3.3V pull-ups are on the board (R1..R8)
  }
  Serial.println("Wave a magnet over a square -> it shows [#]. Cols=files A-H, rows=ranks 1-8.");
}

static void scan() {
  for (int c = 0; c < MATRIX_COLS; c++) {
    digitalWrite(PIN_COL_DRV[c], HIGH);    // power this column
    delay(SETTLE_MS);
    for (int r = 0; r < MATRIX_ROWS; r++) {
      // active-low: LOW = magnet present
      present[c][r] = (digitalRead(PIN_ROW_SENSE[r]) == LOW);
    }
    digitalWrite(PIN_COL_DRV[c], LOW);     // column off before next
  }
}

static void printBoard() {
  Serial.println("\n     A   B   C   D   E   F   G   H");
  for (int r = MATRIX_ROWS - 1; r >= 0; r--) {     // rank 8 at top
    Serial.printf(" %d  ", r + 1);
    for (int c = 0; c < MATRIX_COLS; c++) {
      Serial.print(present[c][r] ? "[#] " : " .  ");
    }
    Serial.println();
  }
}

void loop() {
  scan();
  printBoard();
  delay(150);
}
