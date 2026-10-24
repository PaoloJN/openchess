#ifndef BOARD_DRIVER_H
#define BOARD_DRIVER_H

#include "led_colors.h"
#include <NeoPixelBusLg.h>
#include <atomic>
#include <freertos/FreeRTOS.h>
#include <freertos/queue.h>
#include <freertos/semphr.h>
#include <freertos/task.h>

// ---------------------------
// Default Hardware Configuration
// These defaults are used if no pin configuration is saved in NVS.
// Users with pre-built firmware can change pins via the web UI at runtime.
// ---------------------------

// ---------------------------
// WS2812B LED Data IN GPIO Pin
// The strip doesn't need to have a specific layout, calibration will map it correctly
// ---------------------------
#define LED_PIN 32
// Hall-sensor matrix: 8 rows x 8 cols (one sensor per chess square).
#define NUM_ROWS 8
#define NUM_COLS 8
// Board orientation: 1 rotates the physical matrix 180° relative to the
// engine's convention (row 0 = rank 8), i.e. White sets up on the opposite
// physical side. Applied on top of the stored calibration in readSensors()
// and squareCornerLEDs(); if you ever RE-RUN calibration, set this to 0 first.
#define BOARD_ROTATE_180 1
// WS2812 LED grid: 9 x 9 LEDs sitting on the corners of the 8x8 squares (81 LEDs total).
// Indexing: row 0 = top, col 0 = left. Chain index = row * LED_GRID_COLS + col.
// D1 (BATT_LED) is on a separate chain and is NOT part of these 81 LEDs.
#define LED_GRID_ROWS 9
#define LED_GRID_COLS 9
#define LED_COUNT (LED_GRID_ROWS * LED_GRID_COLS)
#define BRIGHTNESS 60 // Default LED brightness: 0-255. Kept low: 81 LEDs at full white ~4.9A > M1's 2.4A. (can be raised later from settings)

// ---------------------------
// Column Drive Pins (THIS board)
// 8 direct ESP32 GPIOs -> TBD62783A high-side driver (active-HIGH inputs).
// One column powered at a time. Order index 0..7 = files a..h. Source of truth:
// hardware-controller schematic / src/pins.h (PIN_COL_DRV).
// ---------------------------
#define COL_PIN_0 13 // file a  (/COL_DRV_A)
#define COL_PIN_1 14 // file b  (/COL_DRV_B)
#define COL_PIN_2 27 // file c  (/COL_DRV_C)
#define COL_PIN_3 26 // file d  (/COL_DRV_D)
#define COL_PIN_4 25 // file e  (/COL_DRV_E)
#define COL_PIN_5 33 // file f  (/COL_DRV_F)
#define COL_PIN_6 5  // file g  (/COL_DRV_G)
#define COL_PIN_7 15 // file h  (/COL_DRV_H)

// ---------------------------
// Shift Register (74HC595) Pins — LEGACY / UNUSED on this board.
// Kept only so the dormant upstream calibration code still compiles; our board
// has NO shift register (columns are the direct GPIOs above).
// ---------------------------
#define SR_CLK_PIN 14
#define SR_LATCH_PIN 26
#define SR_SER_DATA_PIN 33
#define SR_INVERT_OUTPUTS 0

// ---------------------------
// Row and column pins don't need to be in any particular order, calibration will map them correctly
// ---------------------------

// ---------------------------
// Row Input Pins (Safe GPIOs for ESP32: 4, 13, 14, [16-17], 18, 19, 21, 22, 23, 25, 26, 27, 32, 33)
// ---------------------------
#define ROW_PIN_0 4
#define ROW_PIN_1 16
#define ROW_PIN_2 17
#define ROW_PIN_3 18
#define ROW_PIN_4 19
#define ROW_PIN_5 21
#define ROW_PIN_6 22
#define ROW_PIN_7 23

// ---------------------------
// Runtime hardware configuration (loaded from NVS, editable via web UI)
// Falls back to the #define defaults above if no NVS data exists.
// ---------------------------
struct HardwareConfig {
  uint8_t ledPin;
  uint8_t srClkPin;   // legacy/unused (no shift register on this board)
  uint8_t srLatchPin; // legacy/unused
  uint8_t srDataPin;  // legacy/unused
  bool srInvertOutputs;
  uint8_t colPins[NUM_COLS]; // direct column-drive GPIOs -> TBD62783A
  uint8_t rowPins[NUM_ROWS];

  // Initialize with compile-time defaults
  static HardwareConfig defaults() {
    return {LED_PIN, SR_CLK_PIN, SR_LATCH_PIN, SR_SER_DATA_PIN, SR_INVERT_OUTPUTS != 0,
            {COL_PIN_0, COL_PIN_1, COL_PIN_2, COL_PIN_3, COL_PIN_4, COL_PIN_5, COL_PIN_6, COL_PIN_7},
            {ROW_PIN_0, ROW_PIN_1, ROW_PIN_2, ROW_PIN_3, ROW_PIN_4, ROW_PIN_5, ROW_PIN_6, ROW_PIN_7}};
  }
};

// ---------------------------
// Sensor Polling Delay and Debounce
// ---------------------------
#define SENSOR_READ_DELAY_MS 40
#define DEBOUNCE_MS 100  // must stay < full scan time (~126ms) — see enableCol()
#define CALIBRATION_WARNING_INTERVAL_MS 4000

// Animation job types for async queue
enum class AnimationType : uint8_t { CAPTURE,
                                     PROMOTION,
                                     BLINK,
                                     WAITING,
                                     THINKING,
                                     FIREWORK,
                                     FLASH };

// Animation job with parameters union for queue
struct AnimationJob {
  AnimationType type;
  std::atomic<bool>* stopFlag; // For cancellable animations
  union {
    struct {
      int row, col;
    } capture;
    struct {
      int row, col;
    } promotion;
    struct {
      int row, col;
      LedRGB color;
      int times;
      bool clearAfter;
    } blink;
    struct {
      LedRGB color;
      int times;
    } flash;
    struct {
      LedRGB color;
    } firework;
  } params;
};

// ---------------------------
// Board Driver Class
// Logical board coordinates: row 0 = rank 8, column 0 = file a
// ---------------------------
class BoardDriver {
 private:
  // I2S0 DMA method. The RMT method (used through bring-up) refills its tiny
  // hardware buffer from a non-IRAM interrupt, so any flash write mid-frame
  // (NimBLE bond/CCCD persist, WiFi config save) stalls it and latches a
  // corrupted frame on the chain. I2S pre-encodes the whole frame into a DMA
  // buffer up front and is immune to those windows (~8 KB RAM for 81 LEDs).
  NeoPixelBusLg<NeoGrbFeature, NeoEsp32I2s0Ws2812xMethod, NeoGammaNullMethod>* strip;

  // Animation queue system
  static QueueHandle_t animationQueue;
  static TaskHandle_t animationTaskHandle;
  static SemaphoreHandle_t ledMutex;
  static BoardDriver* instance;
  static void animationWorkerTask(void* param);
  void executeAnimation(const AnimationJob& job);
  void doCapture(int row, int col);
  void doPromotion(int row, int col);
  void doBlink(int row, int col, LedRGB color, int times, bool clearAfter);
  void doWaiting(std::atomic<bool>* stopFlag);
  void doThinking(std::atomic<bool>* stopFlag);
  void doFirework(LedRGB color);
  void doFlash(LedRGB color, int times);
  bool sensorState[NUM_ROWS][NUM_COLS];
  bool sensorPrev[NUM_ROWS][NUM_COLS];
  bool sensorRaw[NUM_ROWS][NUM_COLS];
  unsigned long sensorDebounceTime[NUM_ROWS][NUM_COLS];
  int lastEnabledCol; // Tracks last enabled column for efficient sequential shifting

  // Per-LED frame buffer (81 corner LEDs). setSquareLED composites into this
  // with "brightest wins" so that squares sharing a corner never erase each
  // other (the shared-corner problem). clearAllLEDs resets it; showLEDs flushes.
  LedRGB frame[LED_COUNT];

  enum Axis {
    RowsAxis = 0,
    ColsAxis = 1,
    UnknownAxis = 2,
  };
  // LED settings (persisted in NVS)
  uint8_t brightness;                       // Global brightness 0-255
  uint8_t dimMultiplier;                    // Dark square dim factor 0-100 (stored as percentage)
  LedRGB currentColors[NUM_ROWS][NUM_COLS]; // Track current colors for dim multiplier updates

  // Runtime hardware pin configuration (persisted in NVS)
  HardwareConfig hwConfig;

  // True while interactive calibration is running (guards concurrent web handler access)
  std::atomic<bool> calibrating;
  bool calibrated;

  // Calibration data
  uint8_t swapAxes;
  uint8_t toLogicalRow[NUM_ROWS];
  uint8_t toLogicalCol[NUM_COLS];
  // 9x9 corner-LED grid -> chain index. Default identity: row*9 + col.
  // A square at (sensor row r, sensor col c) is bounded by 4 corner LEDs.
  // See squareCornerLEDs() for the mapping.
  uint8_t cornerLedIndex[LED_GRID_ROWS][LED_GRID_COLS];

  bool loadCalibration();
  void saveCalibration();
  bool runCalibration();
  void loadLedSettings();
  void loadHardwareConfig();
  void readRawSensors(bool rawState[NUM_ROWS][NUM_COLS]);
  bool waitForBoardEmpty(unsigned long stableMs = 500);
  bool waitForSingleRawPress(int& rawRow, int& rawCol, unsigned long stableMs = 500);
  void showCalibrationError();
  bool calibrateAxis(Axis axis, uint8_t* axisPinsOrder, size_t NUM_PINS, bool firstAxisSwapped);
  String axisToChessRankFile(Axis axis) const { return (axis == RowsAxis) ? "Rank" : ((axis == ColsAxis) ? "File" : "Unknown"); };

  void loadShiftRegister(byte data, int bits = 8);
  void disableAllCols();
  void enableCol(int col);
  // Returns the 4 corner-LED chain indices for sensor-square (row,col).
  // out[0]=top-left, out[1]=top-right, out[2]=bottom-left, out[3]=bottom-right.
  void squareCornerLEDs(int row, int col, int out[4]) const;
  // Representative pixel for a square (top-left corner). Prefer
  // squareCornerLEDs() for new code.
  int getPixelIndex(int row, int col);

 public:
  BoardDriver();
  void beginHardware();
  void checkCalibration();
  void readSensors();
  bool getSensorState(int row, int col);
  bool getSensorPrev(int row, int col);
  void updateSensorPrev();

  // LED Control (use acquireLEDs/releaseLEDs for multi-call sequences)
  void acquireLEDs(); // Block until LED strip available
  void releaseLEDs(); // Release LED strip
  void clearAllLEDs(bool show = true, bool acquireLedMutex = false);
  void setSquareLED(int row, int col, LedRGB color);
  void setPixelRaw(int index, LedRGB color);   // set one chain LED directly (effects/ripple)
  void cornersOf(int row, int col, int out[4]) const { squareCornerLEDs(row, col, out); }   // public accessor
  void showPromotionChoice(int choiceIndex, bool rotate, int kingRow, int kingCol, int promotionRow, int promotionCol);
  void showLEDs();
  // Re-send the current frame even though nothing changed. The chain has no
  // memory-refresh of its own: LED writes are event-driven, so a single
  // corrupted transmission would otherwise stay visible until the next game
  // event. Called periodically during a game to make corruption self-heal.
  void refreshLEDs();

  // Animation Functions (queued for async execution)
  void fireworkAnimation(LedRGB color = LedColors::White);
  void captureAnimation(int row, int col);
  void promotionAnimation(int row, int col);
  void blinkSquare(int row, int col, LedRGB color, int times = 3, bool clearAfter = true);
  void showConnectingAnimation();
  void flashBoardAnimation(LedRGB color, int times = 3);

  // Start a cancellable animation. Returns a non-owning pointer to a stop flag.
  // Ownership: the animation task owns and deletes the flag after the animation loop exits.
  // Caller must ONLY call store(true) to signal stop, never delete the pointer.
  std::atomic<bool>* startThinkingAnimation();
  std::atomic<bool>* startWaitingAnimation();

  // Board settings
  uint8_t getBrightness() const { return brightness; }
  uint8_t getDimMultiplier() const { return dimMultiplier; }
  void setBrightness(uint8_t value);
  void setDimMultiplier(uint8_t value);
  void saveLedSettings();
  void triggerCalibration();

  // Hardware pin configuration (runtime, persisted in NVS)
  const HardwareConfig& getHardwareConfig() const { return hwConfig; }
  void saveHardwareConfig(const HardwareConfig& config);
};

#endif // BOARD_DRIVER_H
