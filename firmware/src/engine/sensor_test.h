#ifndef SENSOR_TEST_H
#define SENSOR_TEST_H

#include "board_driver.h"

// ---------------------------
// Sensor Test Mode Class
// ---------------------------
class SensorTest {
 private:
  BoardDriver* boardDriver;
  bool visited[8][8]; // Track which squares have been visited
  bool complete;      // True when all squares visited

 public:
  SensorTest(BoardDriver* bd);
  void begin();
  void update();
  bool isComplete() const { return complete; }
};

#endif // SENSOR_TEST_H