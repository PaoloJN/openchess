#include "board_driver.h"
#include "chess_utils.h"
#include "led_colors.h"
#include "log.h"
#include <Arduino.h>
#include <Preferences.h>
#include <math.h>

// 74HC595 shift register pin mapping: bits are sent MSB first, so bit 7 shifts to QH, bit 0 stays at QA
// col 0 -> QA (pin 15), col 1 -> QB (pin 1), ..., col 7 -> QH (pin 7)
static int shiftRegPin(int col) {
  const int pins[] = {15, 1, 2, 3, 4, 5, 6, 7}; // QA=15, QB=1, QC=2, QD=3, QE=4, QF=5, QG=6, QH=7
  return (col >= 0 && col < 8) ? pins[col] : -1;
}
static char shiftRegOutput(int col) {
  return (col >= 0 && col < 8) ? (char)('A' + col) : '?'; // col 0 -> 'A' (QA), col 7 -> 'H' (QH)
}

// Static members for animation queue system
QueueHandle_t BoardDriver::animationQueue = nullptr;
TaskHandle_t BoardDriver::animationTaskHandle = nullptr;
SemaphoreHandle_t BoardDriver::ledMutex = nullptr;
BoardDriver* BoardDriver::instance = nullptr;

// ---------------------------
// LED Corner-Grid to Chain-Index mapping (default)
// 9x9 grid of WS2812 LEDs sitting on the corners of the 8x8 chess-square grid.
// Chain index follows the physical wiring: D2..D82 -> chain index 0..80,
// where chain[0] is at corner (row=0, col=0) (top-left) and chain[80] is
// at (row=8, col=8) (bottom-right). Default mapping is identity:
//   cornerLedIndex[row][col] = row * LED_GRID_COLS + col
// (Real PCB may serpentine; calibration would override this map. For now
// the LED-mapping calibration step is bypassed — see runCalibration().)
// ---------------------------

BoardDriver::BoardDriver() : strip(nullptr), lastEnabledCol(-2), brightness(BRIGHTNESS), dimMultiplier(70), swapAxes(0), hwConfig(HardwareConfig::defaults()), calibrating(false), calibrated(false) {
  for (int i = 0; i < NUM_ROWS; i++)
    toLogicalRow[i] = i;
  for (int i = 0; i < NUM_COLS; i++)
    toLogicalCol[i] = i;
  for (int row = 0; row < LED_GRID_ROWS; row++)
    for (int col = 0; col < LED_GRID_COLS; col++)
      cornerLedIndex[row][col] = (uint8_t)(row * LED_GRID_COLS + col);
  for (int row = 0; row < NUM_ROWS; row++)
    for (int col = 0; col < NUM_COLS; col++)
      currentColors[row][col] = LedColors::Off;
}

// Fixed square -> 4-corner-LED map for THIS PCB, derived and verified on the
// bench (see bench/highlight.cpp). Indexed [file][rank] where file = the column
// driven (0=a..7=h) and rank = the row sensed (0=S0..7=S7). This replaces the
// upstream identity cornerLedIndex + interactive calibration, which do not match
// our physical WS2812 chain order.
static const int SQ_LED_FILE_RANK[8][8][4] = {
  {{63,64,72,73},{54,55,63,64},{45,46,54,55},{36,37,45,46},{27,28,36,37},{18,19,27,28},{9,10,18,19},{0,1,9,10}},
  {{64,65,73,74},{55,56,64,65},{46,47,55,56},{37,38,46,47},{28,29,37,38},{19,20,28,29},{10,11,19,20},{1,2,10,11}},
  {{65,66,74,75},{56,57,65,66},{47,48,56,57},{38,39,47,48},{29,30,38,39},{20,21,29,30},{11,12,20,21},{2,3,11,12}},
  {{66,67,75,76},{57,58,66,67},{48,49,57,58},{39,40,48,49},{30,31,39,40},{21,22,30,31},{12,13,21,22},{3,4,12,13}},
  {{67,68,76,77},{58,59,67,68},{49,50,58,59},{40,41,49,50},{31,32,40,41},{22,23,31,32},{13,14,22,23},{4,5,13,14}},
  {{68,69,77,78},{59,60,68,69},{50,51,59,60},{41,42,50,51},{32,33,41,42},{23,24,32,33},{14,15,23,24},{5,6,14,15}},
  {{69,70,78,79},{60,61,69,70},{51,52,60,61},{42,43,51,52},{33,34,42,43},{24,25,33,34},{15,16,24,25},{6,7,15,16}},
  {{70,71,79,80},{61,62,70,71},{52,53,61,62},{43,44,52,53},{34,35,43,44},{25,26,34,35},{16,17,25,26},{7,8,16,17}},
};

// 180° board rotation (see BOARD_ROTATE_180 in board_driver.h).
#if BOARD_ROTATE_180
#define ROT8(x) (7 - (x))
#else
#define ROT8(x) (x)
#endif

// Map a sensor-square to its 4 corner LED chain indices.
// The engine coordinate system is (row = rank = S0..S7, col = file = a..h),
// so we transpose into our [file][rank] table: SQ_LED_FILE_RANK[col][row].
void BoardDriver::squareCornerLEDs(int row, int col, int out[4]) const {
  for (int i = 0; i < 4; i++)
    out[i] = SQ_LED_FILE_RANK[ROT8(col)][ROT8(row)][i];
}

void BoardDriver::beginHardware() {
  // Initialize animation queue system
  instance = this;
  ledMutex = xSemaphoreCreateMutex();
  animationQueue = xQueueCreate(8, sizeof(AnimationJob));
  xTaskCreatePinnedToCore(animationWorkerTask, "AnimWorker", 4096, nullptr, 1, &animationTaskHandle, 1);
  // Load hardware pin configuration from NVS (must happen before any GPIO or strip init)
  loadHardwareConfig();
  // https://github.com/Makuna/NeoPixelBus/wiki/ESP32-NeoMethods
  strip = new NeoPixelBusLg<NeoGrbFeature, NeoEsp32I2s0Ws2812xMethod, NeoGammaNullMethod>(LED_COUNT, hwConfig.ledPin);
  strip->Begin();
  showLEDs();        // turn off all LEDs
  loadLedSettings(); // Load LED settings from NVS (brightness, dim multiplier)
  strip->SetLuminance(brightness);
  // Column-drive pins as outputs (TBD62783A inputs, active-high), all off
  for (int c = 0; c < NUM_COLS; c++) {
    pinMode(hwConfig.colPins[c], OUTPUT);
    digitalWrite(hwConfig.colPins[c], LOW);
  }
  disableAllCols();
  // Row pins as inputs
  for (int c = 0; c < NUM_ROWS; c++)
    pinMode(hwConfig.rowPins[c], INPUT);
  calibrated = loadCalibration();
  if (calibrated) {
    // Initialize sensors state without debouncing to prevent brief LED flashes at boot (live game recover board setup)
    bool initialRawState[NUM_ROWS][NUM_COLS];
    readRawSensors(initialRawState);
    unsigned long now = millis();
    for (int col = 0; col < NUM_COLS; col++) {
      for (int row = 0; row < NUM_ROWS; row++) {
        uint8_t logicalRow = ROT8(toLogicalRow[swapAxes ? col : row]);
        uint8_t logicalCol = ROT8(toLogicalCol[swapAxes ? row : col]);
        sensorState[logicalRow][logicalCol] = initialRawState[row][col];
        sensorPrev[logicalRow][logicalCol] = initialRawState[row][col];
        sensorRaw[logicalRow][logicalCol] = initialRawState[row][col];
        sensorDebounceTime[logicalRow][logicalCol] = now;
      }
    }
  } else {
    for (int row = 0; row < NUM_ROWS; row++) {
      for (int col = 0; col < NUM_COLS; col++) {
        sensorState[row][col] = false;
        sensorPrev[row][col] = false;
        sensorRaw[row][col] = false;
        sensorDebounceTime[row][col] = 0;
      }
    }
  }
}

void BoardDriver::checkCalibration() {
  if (!calibrated) {
    bool wasSkipped = runCalibration();
    if (!wasSkipped)
      saveCalibration();
  }
}

// Animation worker task - processes jobs from queue
void BoardDriver::animationWorkerTask(void* param) {
  AnimationJob job;
  while (true) {
    if (xQueueReceive(animationQueue, &job, portMAX_DELAY) == pdTRUE) {
      // Skip animations while calibration is running on the main task
      if (instance->calibrating.load()) {
        if (job.stopFlag)
          delete job.stopFlag;
        continue;
      }
      xSemaphoreTake(ledMutex, portMAX_DELAY);
      instance->executeAnimation(job);
      xSemaphoreGive(ledMutex);
    }
  }
}

void BoardDriver::executeAnimation(const AnimationJob& job) {
  switch (job.type) {
    case AnimationType::CAPTURE:
      doCapture(job.params.capture.row, job.params.capture.col);
      break;
    case AnimationType::PROMOTION:
      doPromotion(job.params.promotion.row, job.params.promotion.col);
      break;
    case AnimationType::BLINK:
      doBlink(job.params.blink.row, job.params.blink.col, job.params.blink.color, job.params.blink.times, job.params.blink.clearAfter);
      break;
    case AnimationType::WAITING:
      doWaiting(job.stopFlag);
      break;
    case AnimationType::THINKING:
      doThinking(job.stopFlag);
      break;
    case AnimationType::FIREWORK:
      doFirework(job.params.firework.color);
      break;
    case AnimationType::FLASH:
      doFlash(job.params.flash.color, job.params.flash.times);
      break;
  }
}

bool BoardDriver::loadCalibration() {
  if (!ChessUtils::ensureNvsInitialized()) {
    engineLog.println("NVS init failed - calibration not loaded");
    return false;
  }
  Preferences prefs;
  prefs.begin("boardCal", false);
  uint8_t ver = prefs.getUChar("ver", 0);
  if (ver != 1) {
    prefs.end();
    return false;
  }

  // Verify pin configuration matches
  size_t rowPinsLen = prefs.getBytesLength("rowPins");
  if (rowPinsLen != NUM_ROWS) {
    prefs.end();
    return false;
  }
  uint8_t savedRowPins[NUM_ROWS];
  prefs.getBytes("rowPins", savedRowPins, sizeof(savedRowPins));
  for (int i = 0; i < NUM_ROWS; i++)
    if (savedRowPins[i] != hwConfig.rowPins[i]) {
      prefs.end();
      return false;
    }
  uint8_t savedSRPins[3];
  prefs.getBytes("srPins", savedSRPins, sizeof(savedSRPins));
  if (savedSRPins[0] != hwConfig.srClkPin || savedSRPins[1] != hwConfig.srLatchPin || savedSRPins[2] != hwConfig.srDataPin) {
    prefs.end();
    return false;
  }

  size_t rowLen = prefs.getBytesLength("row");
  size_t colLen = prefs.getBytesLength("col");
  size_t ledLen = prefs.getBytesLength("led");
  if (rowLen != NUM_ROWS || colLen != NUM_COLS || ledLen != LED_COUNT) {
    prefs.end();
    return false;
  }
  swapAxes = prefs.getUChar("swap", 0);
  prefs.getBytes("row", toLogicalRow, NUM_ROWS);
  prefs.getBytes("col", toLogicalCol, NUM_COLS);
  uint8_t ledFlat[LED_COUNT];
  prefs.getBytes("led", ledFlat, LED_COUNT);
  int idx = 0;
  for (int row = 0; row < LED_GRID_ROWS; row++)
    for (int col = 0; col < LED_GRID_COLS; col++)
      cornerLedIndex[row][col] = ledFlat[idx++];
  prefs.end();
  engineLog.println("Board calibration loaded from NVS");
  return true;
}

void BoardDriver::saveCalibration() {
  if (!ChessUtils::ensureNvsInitialized()) {
    engineLog.println("NVS init failed - calibration not saved");
    return;
  }
  Preferences prefs;
  prefs.begin("boardCal", false);
  prefs.putUChar("ver", 1);
  prefs.putBytes("rowPins", hwConfig.rowPins, sizeof(hwConfig.rowPins));
  uint8_t srPins[3] = {hwConfig.srClkPin, hwConfig.srLatchPin, hwConfig.srDataPin};
  prefs.putBytes("srPins", srPins, sizeof(srPins));
  prefs.putUChar("swap", swapAxes);
  prefs.putBytes("row", toLogicalRow, NUM_ROWS);
  prefs.putBytes("col", toLogicalCol, NUM_COLS);
  uint8_t ledFlat[LED_COUNT];
  int idx = 0;
  for (int row = 0; row < LED_GRID_ROWS; row++)
    for (int col = 0; col < LED_GRID_COLS; col++)
      ledFlat[idx++] = cornerLedIndex[row][col];
  prefs.putBytes("led", ledFlat, LED_COUNT);
  prefs.end();
  engineLog.println("Board calibration saved to NVS");
}

void BoardDriver::readRawSensors(bool rawState[NUM_ROWS][NUM_COLS]) {
  for (int row = 0; row < NUM_ROWS; row++)
    for (int col = 0; col < NUM_COLS; col++)
      rawState[row][col] = false;

  for (int col = 0; col < NUM_COLS; col++) {
    enableCol(col);
    for (int row = 0; row < NUM_ROWS; row++)
      rawState[row][col] = (digitalRead(hwConfig.rowPins[row]) == LOW);
  }
  disableAllCols();
}

bool BoardDriver::waitForBoardEmpty(unsigned long stableMs) {
  bool rawState[NUM_ROWS][NUM_COLS];
  unsigned long lastWarningTime = millis();
  unsigned long stableStart = 0;

  while (true) {
    readRawSensors(rawState);
    int pressedCount = 0;
    for (int row = 0; row < NUM_ROWS; row++)
      for (int col = 0; col < NUM_COLS; col++)
        if (rawState[row][col])
          pressedCount++;

    if (pressedCount == 0) {
      if (stableStart == 0)
        stableStart = millis();
      if (millis() - stableStart >= stableMs)
        return true;
    } else {
      stableStart = 0;
      unsigned long now = millis();
      if (now - lastWarningTime >= CALIBRATION_WARNING_INTERVAL_MS) {
        lastWarningTime = now;
        engineLog.printf("Board not empty - %d sensor(s) still detecting a magnet:\n", pressedCount);
        for (int row = 0; row < NUM_ROWS; row++)
          for (int col = 0; col < NUM_COLS; col++)
            if (rawState[row][col])
              engineLog.printf("  GPIO %d + 74HC595 Q%c (pin %d)\n", hwConfig.rowPins[row], shiftRegOutput(col), shiftRegPin(col));
      }
    }
    delay(SENSOR_READ_DELAY_MS);
  }
}

bool BoardDriver::waitForSingleRawPress(int& rawRow, int& rawCol, unsigned long stableMs) {
  bool rawState[NUM_ROWS][NUM_COLS];
  int lastRow = -1;
  int lastCol = -1;
  unsigned long stableStart = 0;
  unsigned long lastWarningTime = millis();

  while (true) {
    readRawSensors(rawState);
    int count = 0;
    int foundRow = -1;
    int foundCol = -1;
    for (int row = 0; row < NUM_ROWS; row++)
      for (int col = 0; col < NUM_COLS; col++)
        if (rawState[row][col]) {
          count++;
          foundRow = row;
          foundCol = col;
        }
    if (count == 1) {
      if (foundRow == lastRow && foundCol == lastCol) {
        if (stableStart == 0) {
          stableStart = millis();
          engineLog.printf("  Detect start: GPIO %d + 74HC595 Q%c (pin %d)\n", hwConfig.rowPins[foundRow], shiftRegOutput(foundCol), shiftRegPin(foundCol));
        }
        if (millis() - stableStart >= stableMs) {
          rawRow = foundRow;
          rawCol = foundCol;
          return true;
        }
      } else {
        // Position changed - warn about unstable detection
        if (lastRow >= 0 && lastCol >= 0) {
          engineLog.println("Sensor reading unstable - detected square changed. Hold piece steady on one square.");
          engineLog.printf("  Previous: GPIO %d + 74HC595 Q%c (pin %d), Current: GPIO %d + 74HC595 Q%c (pin %d)\n", hwConfig.rowPins[lastRow], shiftRegOutput(lastCol), shiftRegPin(lastCol), hwConfig.rowPins[foundRow], shiftRegOutput(foundCol), shiftRegPin(foundCol));
        }
        lastRow = foundRow;
        lastCol = foundCol;
        stableStart = 0;
      }
    } else {
      // Multiple presses or no presses detected
      unsigned long now = millis();
      if (now - lastWarningTime >= CALIBRATION_WARNING_INTERVAL_MS) {
        lastWarningTime = now;
        if (count == 0) {
          engineLog.println("No sensor detecting a magnet - place a piece on the requested square");
        } else {
          engineLog.printf("Multiple sensors (%d) detected simultaneously but need exactly 1:\n", count);
          for (int row = 0; row < NUM_ROWS; row++)
            for (int col = 0; col < NUM_COLS; col++)
              if (rawState[row][col])
                engineLog.printf("  GPIO %d + 74HC595 Q%c (pin %d)\n", hwConfig.rowPins[row], shiftRegOutput(col), shiftRegPin(col));
        }
      }
      stableStart = 0;
    }
    delay(SENSOR_READ_DELAY_MS);
  }
}

void BoardDriver::showCalibrationError() {
  for (int i = 0; i < LED_COUNT; i++)
    strip->SetPixelColor(i, RgbColor(LedColors::Red.r, LedColors::Red.g, LedColors::Red.b));
  showLEDs();
  delay(500);
  waitForBoardEmpty();
  clearAllLEDs();
}

bool BoardDriver::calibrateAxis(Axis axis, uint8_t* axisPinsOrder, size_t NUM_PINS, bool firstAxisSwapped) {
  if ((NUM_ROWS != NUM_COLS) || (NUM_ROWS != NUM_PINS)) {
    engineLog.println("Non-square boards not supported for calibration");
    return false;
  }

  Axis detectedAxis = UnknownAxis;
  int firstRow = -1;
  int firstCol = -1;
  uint8_t counts[NUM_PINS] = {0};
  for (int i = 0; i < NUM_PINS; i++)
    axisPinsOrder[i] = -1;

  // If this is column calibration and we already have row mapping, find expected raw row/col for rank 1
  int expectedRawPin = -1;
  bool useRow = true; // Whether to check row or col during column calibration
  if (axis == ColsAxis)
    for (int i = 0; i < NUM_ROWS; i++)
      if (toLogicalRow[i] == 7) {
        expectedRawPin = i;
        // If first axis swapped, toLogicalRow is indexed by raw cols, so we check col
        useRow = !firstAxisSwapped;
        break;
      }

  for (int i = 0; i < NUM_PINS; i++) {
    char square[3];
    if (axis == RowsAxis) {
      square[0] = 'a';
      square[1] = (char)('8' - i);
    } else {
      square[0] = (char)('a' + i);
      square[1] = '1';
    }
    square[2] = '\0';

    engineLog.printf("Place a piece on %s (%s calibration)\n", square, axisToChessRankFile(axis).c_str());
    int row = 0;
    int col = 0;
    waitForSingleRawPress(row, col);
    engineLog.printf("  Detected: row=%d (GPIO %d), col=%d (74HC595 Q%c, pin %d)\n", row, hwConfig.rowPins[row], col, shiftRegOutput(col), shiftRegPin(col));

    // Verify pin consistency for column calibration
    if (axis == ColsAxis && expectedRawPin != -1) {
      int actualPin = useRow ? row : col;
      if (actualPin != expectedRawPin) {
        if (useRow)
          engineLog.printf("[ERROR] Expected piece on rank 1 = row %d (GPIO %d) but detected on row %d (GPIO %d) which is not rank 1. Place piece on %s.\n", expectedRawPin, hwConfig.rowPins[expectedRawPin], actualPin, hwConfig.rowPins[actualPin], square);
        else
          engineLog.printf("[ERROR] Expected piece on rank 1 = col %d (74HC595 Q%c, pin %d) but detected on col %d (74HC595 Q%c, pin %d) which is not rank 1. Place piece on %s.\n", expectedRawPin, shiftRegOutput(expectedRawPin), shiftRegPin(expectedRawPin), actualPin, shiftRegOutput(actualPin), shiftRegPin(actualPin), square);
        showCalibrationError();
        i--;
        continue;
      }
    }

    if (i == 0) {
      firstRow = row;
      firstCol = col;
      engineLog.println("Remove the piece");
      waitForBoardEmpty();
      continue;
    }

    if (detectedAxis == UnknownAxis && i == 1) {
      if (row == firstRow && col != firstCol) {
        detectedAxis = ColsAxis;
        axisPinsOrder[firstCol] = i - 1;
        counts[firstCol]++;
        engineLog.printf("%s calibration using cols %s\n", axisToChessRankFile(axis).c_str(), axis != detectedAxis ? "(axis swap)" : "(no axis swap)");
      } else if (col == firstCol && row != firstRow) {
        detectedAxis = RowsAxis;
        axisPinsOrder[firstRow] = i - 1;
        counts[firstRow]++;
        engineLog.printf("%s calibration using rows %s\n", axisToChessRankFile(axis).c_str(), axis != detectedAxis ? "(axis swap)" : "(no axis swap)");
      } else {
        engineLog.printf("\n============== AMBIGUOUS %s CALIBRATION ==============\n", axisToChessRankFile(axis).c_str());
        engineLog.printf("First press:  row=%d (GPIO %d), col=%d (74HC595 Q%c, pin %d)\n", firstRow, hwConfig.rowPins[firstRow], firstCol, shiftRegOutput(firstCol), shiftRegPin(firstCol));
        engineLog.printf("Second press: row=%d (GPIO %d), col=%d (74HC595 Q%c, pin %d)\n", row, hwConfig.rowPins[row], col, shiftRegOutput(col), shiftRegPin(col));
        engineLog.printf("PROBLEM: %s\n", (row == firstRow && col == firstCol) ? "Both presses detected by the SAME sensor" : "Both row AND column changed between presses");
        engineLog.println("==========================================================\n");
        showCalibrationError();
        i = -1;
        continue;
      }
    }

    if (detectedAxis == UnknownAxis) {
      // Will never happen due to above logic, but just in case
      engineLog.printf("Ambiguous %s calibration (no orientation detected). Retry.\n", axisToChessRankFile(axis).c_str());
      showCalibrationError();
      i = -1;
      continue;
    }

    int pin = (detectedAxis == RowsAxis) ? row : col;
    if (counts[pin] > 0) {
      // Find what rank/file was already assigned to this pin
      int assignedIndex = axisPinsOrder[pin];
      char assignedRankFile[8];
      if (axis == RowsAxis)
        snprintf(assignedRankFile, sizeof(assignedRankFile), "rank %d", 8 - assignedIndex);
      else
        snprintf(assignedRankFile, sizeof(assignedRankFile), "file %c", 'a' + assignedIndex);
      if (detectedAxis == RowsAxis)
        engineLog.printf("[ERROR] Row %d (GPIO %d) already has %s assigned. Retry %s.\n", pin, hwConfig.rowPins[pin], assignedRankFile, square);
      else
        engineLog.printf("[ERROR] Col %d (74HC595 Q%c, pin %d) already has %s assigned. Retry %s.\n", pin, shiftRegOutput(pin), shiftRegPin(pin), assignedRankFile, square);
      showCalibrationError();
      i--;
      continue;
    }

    axisPinsOrder[pin] = i;
    counts[pin]++;

    engineLog.println("Remove the piece");
    waitForBoardEmpty();
  }

  return axis != detectedAxis;
}

bool BoardDriver::runCalibration() {
  calibrating.store(true);
  // Calibration animation - light up each pixel sequentially
  for (int i = 0; i < LED_COUNT; i++) {
    strip->SetPixelColor(i, RgbColor(LedColors::White.r, LedColors::White.g, LedColors::White.b));
    showLEDs();
    delay(50);
  }
  delay(500);
  clearAllLEDs();

  engineLog.println("========================== Board calibration required ==========================");
  engineLog.println("- Connect to the AP and open the web interface to configure GPIO pins if needed");
  engineLog.println("- Type 'skip' within 5 seconds to temporarily skip calibration (reboot to calibrate later)");
  engineLog.println("  LEDs and sensors won't have correct mapping until calibration is completed");
  unsigned long startTime = millis();
  while (millis() - startTime < 5000) {
    if (Serial.available()) {
      String input = Serial.readStringUntil('\n');
      input.trim();
      input.toLowerCase();
      if (input == "skip") {
        engineLog.println("[SKIP] Calibration skipped - using default mapping");
        engineLog.println("[SKIP] Sensors/LEDs will NOT work correctly!");
        engineLog.println("[SKIP] You will be asked to calibrate again on next reboot");
        // Set up identity mapping (no calibration)
        swapAxes = 0;
        for (int i = 0; i < NUM_ROWS; i++) toLogicalRow[i] = i;
        for (int i = 0; i < NUM_COLS; i++) toLogicalCol[i] = i;
        for (int row = 0; row < LED_GRID_ROWS; row++)
          for (int col = 0; col < LED_GRID_COLS; col++)
            cornerLedIndex[row][col] = (uint8_t)(row * LED_GRID_COLS + col);
        calibrating.store(false);
        return true;
      } else {
        engineLog.println("Unknown command \"" + input + "\" Type \"skip\" to skip calibration or wait 5 seconds for calibration to begin");
      }
    }
    delay(50);
  }
  engineLog.println("");
  engineLog.println("- Empty the board to begin calibration - instructions will follow once an empty board is detected");
  engineLog.println("- WARNING: Low GPIO voltage can cause unreliable shift register behavior (74HC595 needs Vih > 0.7*Vcc) use a level shifter or HCT variant");
  engineLog.println("- WARNING: Shift register outputs shouldn't power 8 sensors directly from 1 output pin, use transistors! (max 35mA per pin but each A3144 draws ~10mA");
  engineLog.println("- WARNING: If powering multiple sensors from one shift register pin, expect voltage drop and shift register failure");
  engineLog.println("- TIP: Try both magnet sides and move magnet closer if sensor doesn't trigger");
  engineLog.println("================================================================================");
  waitForBoardEmpty();

  bool swapAxes1 = calibrateAxis(Axis::RowsAxis, toLogicalRow, NUM_ROWS, false);
  bool swapAxes2 = calibrateAxis(Axis::ColsAxis, toLogicalCol, NUM_COLS, swapAxes1);
  if (swapAxes1 != swapAxes2) {
    engineLog.println("Inconsistent axis orientation detected during calibration. Restarting calibration.");
    showCalibrationError();
    return runCalibration();
  }
  swapAxes = swapAxes1 ? 1 : 0;

  // LED mapping calibration (9x9 corner grid)
  // TODO: retool the interactive LED-mapping flow for the 9x9-at-corners
  // topology. Each LED corner is shared between up to 4 chess squares, so
  // the 1-LED-per-square calibration UX from upstream doesn't directly apply.
  // For now we assume a default identity mapping that matches the PCB silk
  // (D2..D82 wired left-to-right, top-to-bottom). Override via NVS once the
  // new calibration UX lands.
  engineLog.println("LED mapping: using default identity layout (9x9 corners, row-major)");
  for (int row = 0; row < LED_GRID_ROWS; row++)
    for (int col = 0; col < LED_GRID_COLS; col++)
      cornerLedIndex[row][col] = (uint8_t)(row * LED_GRID_COLS + col);

  clearAllLEDs();
  engineLog.println("Calibration complete");
  calibrating.store(false);
  return false;
}

void BoardDriver::loadShiftRegister(byte data, int bits) {
  if (hwConfig.srInvertOutputs)
    data = ~data;
  // Make sure latch is low before shifting data
  digitalWrite(hwConfig.srLatchPin, LOW);
  // Shift bits MSB first
  for (int i = bits - 1; i >= 0; i--) {
    digitalWrite(hwConfig.srDataPin, !!(data & (1 << i)));
    delayMicroseconds(10);
    digitalWrite(hwConfig.srClkPin, HIGH);
    delayMicroseconds(10);
    digitalWrite(hwConfig.srClkPin, LOW);
    delayMicroseconds(10);
  }
  // Latch the data to output pins
  digitalWrite(hwConfig.srLatchPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(hwConfig.srLatchPin, LOW);
}

void BoardDriver::disableAllCols() {
  // Direct GPIO drive: pull every column low.
  for (int c = 0; c < NUM_COLS; c++)
    digitalWrite(hwConfig.colPins[c], LOW);
  lastEnabledCol = -1;
}

void BoardDriver::enableCol(int col) {
  // TBD62783A high-side driver is active-HIGH. Power exactly one column.
  for (int c = 0; c < NUM_COLS; c++)
    digitalWrite(hwConfig.colPins[c], (c == col) ? HIGH : LOW);
  lastEnabledCol = col;
  // Per-column settle before reading. Some DRV5032FC units are slow
  // starters: they hold their output low for ~40-45ms after column power-on
  // before their first valid sample; give those columns extra time. The rest
  // settle in a few ms. Diagnosed with bench_diag (A5/U5 ~42ms on col A,
  // D2 ~44ms on col D; all other lines clean by 4ms). Full 8-col scan
  // ~= 2*48 + 6*5 = 126ms. NOTE: DEBOUNCE_MS must stay below the scan
  // period or every change silently costs one extra full scan.
  static const uint8_t SETTLE_MS[NUM_COLS] = {48, 5, 5, 48, 5, 5, 5, 5};
  delay(SETTLE_MS[col]);
}

void BoardDriver::readSensors() {
  unsigned long currentTime = millis();

  // A frame sent at the end of the previous tick is still clocking out when
  // the scan starts (~2.4 ms for 81 LEDs, async). The column power-on edge
  // lands mid-frame on the shared 5V/ground and can flip a data bit, so wait
  // out the transmission first — negligible next to the ~126 ms scan itself.
  while (strip && !strip->CanShow()) delay(1);

  for (int col = 0; col < NUM_COLS; col++) {
    enableCol(col);
    for (int row = 0; row < NUM_ROWS; row++) {
      bool newReading = digitalRead(hwConfig.rowPins[row]) == LOW;
      uint8_t logicalRow = ROT8(toLogicalRow[swapAxes ? col : row]);
      uint8_t logicalCol = ROT8(toLogicalCol[swapAxes ? row : col]);
      // Debounce logic
      if (newReading != sensorState[logicalRow][logicalCol]) {
        if (newReading != sensorRaw[logicalRow][logicalCol]) {
          sensorRaw[logicalRow][logicalCol] = newReading;
          sensorDebounceTime[logicalRow][logicalCol] = currentTime;
        } else if (currentTime - sensorDebounceTime[logicalRow][logicalCol] >= DEBOUNCE_MS) {
          sensorState[logicalRow][logicalCol] = newReading;
        }
      } else {
        sensorRaw[logicalRow][logicalCol] = newReading;
        sensorDebounceTime[logicalRow][logicalCol] = currentTime;
      }
    }
  }
  disableAllCols();
}

bool BoardDriver::getSensorState(int row, int col) {
  return sensorState[row][col];
}

bool BoardDriver::getSensorPrev(int row, int col) {
  return sensorPrev[row][col];
}

void BoardDriver::updateSensorPrev() {
  for (int row = 0; row < NUM_ROWS; row++)
    for (int col = 0; col < NUM_COLS; col++)
      sensorPrev[row][col] = sensorState[row][col];
}

// Returns the top-left corner LED of the given sensor square.
// In the 9x9 corner layout each square has 4 corner LEDs; this helper picks
// one representative pixel (top-left). Most call sites should prefer
// squareCornerLEDs() to control all 4 corners explicitly.
int BoardDriver::getPixelIndex(int row, int col) {
  int corners[4];
  squareCornerLEDs(row, col, corners);
  return corners[0];
}

void BoardDriver::acquireLEDs() {
  xSemaphoreTake(ledMutex, portMAX_DELAY);
}

void BoardDriver::releaseLEDs() {
  xSemaphoreGive(ledMutex);
}

void BoardDriver::clearAllLEDs(bool show, bool acquireLedMutex) {
  if (acquireLedMutex)
    acquireLEDs();
  for (int row = 0; row < NUM_ROWS; row++)
    for (int col = 0; col < NUM_COLS; col++)
      currentColors[row][col] = LedColors::Off;
  for (int i = 0; i < LED_COUNT; i++) {
    frame[i] = LedColors::Off;
    strip->SetPixelColor(i, RgbColor(0));
  }
  if (show)
    showLEDs();
  if (acquireLedMutex)
    releaseLEDs();
}

// Composite one square's 4 corner LEDs into the frame buffer with "brightest
// wins" (per-channel max). Because corners are SHARED between up to 4 squares,
// a plain overwrite lets an adjacent "off"/dim square erase a lit corner — the
// cause of partial, patchy highlights. Max-blend guarantees a lit corner stays
// lit regardless of neighbor draw order. No dark-square dimming (the board's
// LEDs are on corners, not on the square faces, so there is nothing to even
// out) — every square renders at the same intensity.
void BoardDriver::setSquareLED(int row, int col, LedRGB color) {
  currentColors[row][col] = color;
  int corners[4];
  squareCornerLEDs(row, col, corners);
  for (int k = 0; k < 4; k++) {
    int i = corners[k];
    if (i < 0 || i >= LED_COUNT) continue;
    if (color.r > frame[i].r) frame[i].r = color.r;
    if (color.g > frame[i].g) frame[i].g = color.g;
    if (color.b > frame[i].b) frame[i].b = color.b;
    strip->SetPixelColor(i, RgbColor(frame[i].r, frame[i].g, frame[i].b));
  }
}

void BoardDriver::setPixelRaw(int index, LedRGB color) {
  if (index < 0 || index >= LED_COUNT) return;
  frame[index] = color;   // raw effects (ripple) own the pixel outright
  strip->SetPixelColor(index, RgbColor(color.r, color.g, color.b));
}

void BoardDriver::showLEDs() {
  strip->Show();
}

void BoardDriver::refreshLEDs() {
  strip->Dirty();   // Show() early-returns on a clean strip; force a resend
  strip->Show();
}

void BoardDriver::showConnectingAnimation() {
  acquireLEDs();
  // Save current LED state
  LedRGB savedColors[NUM_ROWS][NUM_COLS];
  memcpy(savedColors, currentColors, sizeof(currentColors));
  // Show each WiFi connection attempt with animated LEDs
  for (int i = 0; i < 8; i++) {
    setSquareLED(3, i, LedColors::Blue);
    setSquareLED(4, i, LedColors::Blue);
    showLEDs();
    delay(125);
  }
  // Restore previous LED state
  for (int r = 0; r < NUM_ROWS; r++)
    for (int c = 0; c < NUM_COLS; c++)
      setSquareLED(r, c, savedColors[r][c]);
  showLEDs();
  releaseLEDs();
}

void BoardDriver::blinkSquare(int row, int col, LedRGB color, int times, bool clearAfter) {
  AnimationJob job = {AnimationType::BLINK, nullptr, {}};
  job.params.blink = {row, col, color, times, clearAfter};
  xQueueSend(animationQueue, &job, portMAX_DELAY);
}

void BoardDriver::doBlink(int row, int col, LedRGB color, int times, bool clearAfter) {
  for (int i = 0; i < times; i++) {
    setSquareLED(row, col, color);
    showLEDs();
    vTaskDelay(pdMS_TO_TICKS(200));
    setSquareLED(row, col, LedColors::Off);
    showLEDs();
    vTaskDelay(pdMS_TO_TICKS(200));
  }
  if (!clearAfter) {
    setSquareLED(row, col, color);
    showLEDs();
  }
}

void BoardDriver::fireworkAnimation(LedRGB color) {
  AnimationJob job = {AnimationType::FIREWORK, nullptr, {}};
  job.params.firework = {color};
  xQueueSend(animationQueue, &job, portMAX_DELAY);
}

void BoardDriver::doFirework(LedRGB color) {
  clearAllLEDs(false);
  float centerX = 3.5;
  float centerY = 3.5;

  // Contraction phase:
  for (float radius = 6; radius > 0; radius -= 0.5) {
    for (int row = 0; row < 8; row++)
      for (int col = 0; col < 8; col++) {
        float dx = col - centerX;
        float dy = row - centerY;
        float dist = sqrt(dx * dx + dy * dy);
        if (fabs(dist - radius) < 0.5)
          setSquareLED(row, col, color);
        else
          setSquareLED(row, col, LedColors::Off);
      }
    showLEDs();
    vTaskDelay(pdMS_TO_TICKS(100));
  }

  // Expansion phase:
  for (float radius = 0; radius < 6; radius += 0.5) {
    for (int row = 0; row < 8; row++)
      for (int col = 0; col < 8; col++) {
        float dx = col - centerX;
        float dy = row - centerY;
        float dist = sqrt(dx * dx + dy * dy);
        if (fabs(dist - radius) < 0.5)
          setSquareLED(row, col, color);
        else
          setSquareLED(row, col, LedColors::Off);
      }
    showLEDs();
    vTaskDelay(pdMS_TO_TICKS(100));
  }

  clearAllLEDs();
}

void BoardDriver::captureAnimation(int row, int col) {
  AnimationJob job = {AnimationType::CAPTURE, nullptr, {}};
  job.params.capture = {row, col};
  xQueueSend(animationQueue, &job, portMAX_DELAY);
}

void BoardDriver::doCapture(int centerRow, int centerCol) {
  float centerX = centerCol + 0.5f;
  float centerY = centerRow + 0.5f;

  // Wave animation with multiple expanding rings in 2 colors
  const int numWaves = 3;       // Number of concurrent wave rings
  const int totalFrames = 20;   // Total animation frames
  const float waveSpeed = 0.4f; // How fast waves expand per frame
  const float waveWidth = 1.2f; // Thickness of each wave ring

  clearAllLEDs(false);
  for (int frame = 0; frame < totalFrames; frame++) {
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        float dx = col - centerX;
        float dy = row - centerY;
        float dist = sqrt(dx * dx + dy * dy);

        uint8_t finalR = 0, finalG = 0, finalB = 0;

        // Check each wave ring
        for (int w = 0; w < numWaves; w++) {
          // Stagger wave starts so they trail each other
          float waveRadius = (frame - w * 4) * waveSpeed;
          if (waveRadius < 0) continue;

          // Distance from this pixel to the wave ring
          float distToWave = fabs(dist - waveRadius);

          if (distToWave < waveWidth) {
            // Intensity based on how close to wave center (smooth falloff)
            float intensity = 1.0f - (distToWave / waveWidth);
            intensity = intensity * intensity; // Quadratic falloff for smoother look

            // Fade out as wave expands
            float fadeOut = 1.0f - (waveRadius / 6.0f);
            if (fadeOut < 0) fadeOut = 0;
            intensity *= fadeOut;

            // Alternate colors between waves
            if (w % 2 == 0) {
              finalR = max(finalR, (uint8_t)(LedColors::Red.r * intensity));
              finalG = max(finalG, (uint8_t)(LedColors::Red.g * intensity));
              finalB = max(finalB, (uint8_t)(LedColors::Red.b * intensity));
            } else {
              finalR = max(finalR, (uint8_t)(LedColors::Yellow.r * intensity));
              finalG = max(finalG, (uint8_t)(LedColors::Yellow.g * intensity));
              finalB = max(finalB, (uint8_t)(LedColors::Yellow.b * intensity));
            }
          }
        }
        setSquareLED(row, col, LedRGB{finalR, finalG, finalB});
      }
    }
    setSquareLED(centerRow, centerCol, LedColors::Red);
    showLEDs();
    vTaskDelay(pdMS_TO_TICKS(50));
  }

  clearAllLEDs();
}

void BoardDriver::promotionAnimation(int row, int col) {
  AnimationJob job = {AnimationType::PROMOTION, nullptr, {}};
  job.params.promotion.row = row;
  job.params.promotion.col = col;
  xQueueSend(animationQueue, &job, portMAX_DELAY);
}

void BoardDriver::doPromotion(int row, int col) {
  clearAllLEDs(false);
  // Column-based waterfall animation
  for (int step = 0; step < 16; step++) {
    for (int r = 0; r < 8; r++) {
      // Create a golden wave moving up and down the column
      if ((step + r) % 8 < 4)
        setSquareLED(r, col, LedColors::Yellow);
      else
        setSquareLED(r, col, LedColors::Off);
    }
    showLEDs();
    vTaskDelay(pdMS_TO_TICKS(100));
  }
  // Leave yellow LED on the promotion square to indicate a promotion piece needs to be chosen (LED will be cleared by replacing the pawn for the new piece or by any other move)
  clearAllLEDs(false);
  setSquareLED(row, col, LedColors::Yellow);
  showLEDs();
}

void BoardDriver::showPromotionChoice(int choiceIndex, bool rotate, int kingRow, int kingCol, int promotionRow, int promotionCol) {
  static const char* const PROMOTION_LETTERS[][8] = {
      {
          "........",
          "..####..",
          ".#....#.",
          ".#....#.",
          ".#....#.",
          ".#..#.#.",
          ".#...##.",
          "..####.#",
      },
      {
          "........",
          "..####..",
          "..#...#.",
          "..#...#.",
          "..####..",
          "..#.#...",
          "..#..#..",
          "..#...#.",
      },
      {
          "........",
          "..#...#.",
          "..#..#..",
          "..#.#...",
          "..##....",
          "..#.#...",
          "..#..#..",
          "..#...#.",
      },
      {
          "........",
          "..####..",
          "..#...#.",
          "..#...#.",
          "..####..",
          "..#...#.",
          "..#...#.",
          "..####..",
      },
  };
  acquireLEDs();
  clearAllLEDs(false);
  for (int row = 0; row < 8; row++) {
    for (int col = 0; col < 8; col++) {
      if (PROMOTION_LETTERS[choiceIndex][row][col] == '#')
        setSquareLED(rotate ? (7 - row) : row, rotate ? (7 - col) : col, LedColors::White);
    }
  }
  if (kingRow >= 0 && kingCol >= 0)
    setSquareLED(kingRow, kingCol, LedColors::Green);
  setSquareLED(promotionRow, promotionCol, LedColors::Yellow);
  showLEDs();
  releaseLEDs();
}

void BoardDriver::flashBoardAnimation(LedRGB color, int times) {
  AnimationJob job = {AnimationType::FLASH, nullptr, {}};
  job.params.flash = {color, times};
  xQueueSend(animationQueue, &job, portMAX_DELAY);
}

void BoardDriver::doFlash(LedRGB color, int times) {
  for (int i = 0; i < times; i++) {
    clearAllLEDs();
    vTaskDelay(pdMS_TO_TICKS(200));
    // Light up entire board with specified color
    for (int row = 0; row < 8; row++)
      for (int col = 0; col < 8; col++)
        setSquareLED(row, col, color);
    showLEDs();
    vTaskDelay(pdMS_TO_TICKS(200));
  }
  clearAllLEDs();
}

std::atomic<bool>* BoardDriver::startThinkingAnimation() {
  auto* stopFlag = new std::atomic<bool>(false);
  AnimationJob job = {AnimationType::THINKING, stopFlag, {}};
  xQueueSend(animationQueue, &job, portMAX_DELAY);
  return stopFlag;
}

void BoardDriver::doThinking(std::atomic<bool>* stopFlag) {
  static const int corners[][2] = {{0, 0}, {0, 7}, {7, 0}, {7, 7}};

  // Color configuration - center hue shown at peak brightness
  static const float HUE_CENTER = 240.0f; // Blue hue
  static const float HUE_RANGE = 10.0f;   // Shift toward purple when dim
  static const float BRIGHTNESS_MIN = 0.08f;
  static const float BRIGHTNESS_MAX = 1.0f;

  float phase = 0.0f;            // 0 to 2*PI for smooth sine wave
  const float phaseStep = 0.04f; // Controls breathing speed

  clearAllLEDs(false);
  while (!stopFlag || !stopFlag->load()) {
    // Smooth sine wave for breathing (0 to 1)
    float breathe = (sinf(phase) + 1.0f) * 0.5f;

    // Brightness follows the breathing curve
    float brightness = BRIGHTNESS_MIN + breathe * (BRIGHTNESS_MAX - BRIGHTNESS_MIN);

    // Hue synced: center hue at peak, shifts toward purple as it dims
    // Using cosine so hue is at center when brightness peaks
    float hue = HUE_CENTER + HUE_RANGE * (1.0f - breathe);

    // HSV to RGB conversion (saturation = 1.0)
    float h = fmod(hue, 360.0f) / 60.0f;
    int hi = (int)h;
    float f = h - hi;
    float v = brightness;
    float q = v * (1.0f - f);
    float t = v * f;

    uint8_t r = 0, g = 0, b = 0;
    switch (hi) {
      case 0:
        r = v * 255;
        g = t * 255;
        b = 0;
        break;
      case 1:
        r = q * 255;
        g = v * 255;
        b = 0;
        break;
      case 2:
        r = 0;
        g = v * 255;
        b = t * 255;
        break;
      case 3:
        r = 0;
        g = q * 255;
        b = v * 255;
        break;
      case 4:
        r = t * 255;
        g = 0;
        b = v * 255;
        break;
      default:
        r = v * 255;
        g = 0;
        b = q * 255;
        break;
    }

    for (auto& corner : corners)
      setSquareLED(corner[0], corner[1], LedRGB{r, g, b});
    showLEDs();

    phase += phaseStep;
    if (phase >= 2.0f * M_PI)
      phase -= 2.0f * M_PI;

    vTaskDelay(pdMS_TO_TICKS(30));
  }
  clearAllLEDs();
  delete stopFlag;
}

std::atomic<bool>* BoardDriver::startWaitingAnimation() {
  auto* stopFlag = new std::atomic<bool>(false);
  AnimationJob job = {AnimationType::WAITING, stopFlag, {}};
  xQueueSend(animationQueue, &job, portMAX_DELAY);
  return stopFlag;
}

void BoardDriver::doWaiting(std::atomic<bool>* stopFlag) {
  static const int positions[][2] = {{0, 0}, {0, 1}, {0, 2}, {0, 3}, {0, 4}, {0, 5}, {0, 6}, {0, 7}, {1, 7}, {2, 7}, {3, 7}, {4, 7}, {5, 7}, {6, 7}, {7, 7}, {7, 6}, {7, 5}, {7, 4}, {7, 3}, {7, 2}, {7, 1}, {7, 0}, {6, 0}, {5, 0}, {4, 0}, {3, 0}, {2, 0}, {1, 0}};
  static const int numPositions = sizeof(positions) / sizeof(positions[0]);

  int frame = 0;
  while (!stopFlag || !stopFlag->load()) {
    clearAllLEDs(false);
    // Light up consecutive LEDs moving around the board
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 2; j++) {
        int idx = (frame + i + (j * 14)) % numPositions;
        setSquareLED(positions[idx][0], positions[idx][1], LedColors::White);
      }
    }
    showLEDs();
    frame = (frame + 1) % numPositions;
    vTaskDelay(pdMS_TO_TICKS(200));
  }
  clearAllLEDs();
  delete stopFlag;
}

// LED settings methods
void BoardDriver::setBrightness(uint8_t value) {
  brightness = value > 255 ? 255 : (value < 10 ? 10 : value);
  if (!calibrating.load()) {
    strip->SetLuminance(brightness);
    showLEDs();
  }
}

void BoardDriver::setDimMultiplier(uint8_t value) {
  dimMultiplier = value > 100 ? 100 : (value < 20 ? 20 : value);
  if (!calibrating.load()) {
    // Re-apply all current colors with new dim multiplier
    for (int row = 0; row < NUM_ROWS; row++)
      for (int col = 0; col < NUM_COLS; col++)
        setSquareLED(row, col, currentColors[row][col]);
    showLEDs();
  }
}

void BoardDriver::loadLedSettings() {
  if (!ChessUtils::ensureNvsInitialized()) {
    engineLog.println("NVS init failed - LED settings not loaded");
    return;
  }
  Preferences prefs;
  prefs.begin("ledSettings", false);
  brightness = prefs.getUChar("brightness", BRIGHTNESS);
  dimMultiplier = prefs.getUChar("dimMult", 70);
  prefs.end();
  engineLog.printf("LED settings loaded: brightness=%d, dimMultiplier=%d\n", brightness, dimMultiplier);
}

void BoardDriver::saveLedSettings() {
  if (!ChessUtils::ensureNvsInitialized()) {
    engineLog.println("NVS init failed - LED settings not saved");
    return;
  }
  Preferences prefs;
  prefs.begin("ledSettings", false);
  prefs.putUChar("brightness", brightness);
  prefs.putUChar("dimMult", dimMultiplier);
  prefs.end();
  engineLog.printf("LED settings saved: brightness=%d, dimMultiplier=%d\n", brightness, dimMultiplier);
}

void BoardDriver::triggerCalibration() {
  // Mark calibration as needed by clearing the saved calibration
  if (!ChessUtils::ensureNvsInitialized()) {
    engineLog.println("NVS init failed - cannot trigger calibration");
    return;
  }
  Preferences prefs;
  prefs.begin("boardCal", false);
  prefs.clear();
  prefs.end();
  engineLog.println("Board calibration cleared - rebooting ...");
  ESP.restart();
}

void BoardDriver::loadHardwareConfig() {
  hwConfig = HardwareConfig::defaults();
  if (!ChessUtils::ensureNvsInitialized()) return;

  Preferences prefs;
  prefs.begin("hwConfig", false);
  if (!prefs.isKey("ver")) {
    prefs.end();
    engineLog.println("No saved hardware config, using compile-time defaults");
    return;
  }
  hwConfig.ledPin = prefs.getUChar("ledPin", LED_PIN);
  hwConfig.srClkPin = prefs.getUChar("srClk", SR_CLK_PIN);
  hwConfig.srLatchPin = prefs.getUChar("srLatch", SR_LATCH_PIN);
  hwConfig.srDataPin = prefs.getUChar("srData", SR_SER_DATA_PIN);
  hwConfig.srInvertOutputs = prefs.getBool("srInvert", SR_INVERT_OUTPUTS != 0);
  size_t len = prefs.getBytesLength("rowPins");
  if (len == sizeof(hwConfig.rowPins))
    prefs.getBytes("rowPins", hwConfig.rowPins, sizeof(hwConfig.rowPins));
  prefs.end();
  engineLog.printf("Hardware config loaded: LED=%d, SR_CLK=%d, SR_LATCH=%d, SR_DATA=%d, SR_INVERT=%d\n", hwConfig.ledPin, hwConfig.srClkPin, hwConfig.srLatchPin, hwConfig.srDataPin, hwConfig.srInvertOutputs);
}

void BoardDriver::saveHardwareConfig(const HardwareConfig& config) {
  if (!ChessUtils::ensureNvsInitialized()) {
    engineLog.println("NVS init failed - hardware config not saved");
    return;
  }
  Preferences prefs;
  prefs.begin("hwConfig", false);
  prefs.putUChar("ver", 1);
  prefs.putUChar("ledPin", config.ledPin);
  prefs.putUChar("srClk", config.srClkPin);
  prefs.putUChar("srLatch", config.srLatchPin);
  prefs.putUChar("srData", config.srDataPin);
  prefs.putBool("srInvert", config.srInvertOutputs);
  prefs.putBytes("rowPins", config.rowPins, sizeof(config.rowPins));
  prefs.end();
  // Don't update hwConfig in memory, the new config takes effect after reboot. Modifying it here would race with calibration or gameplay reading the pins.
  engineLog.println("Hardware config saved to NVS");
}