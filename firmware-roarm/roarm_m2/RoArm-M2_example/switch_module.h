int switch_pwm_A = 0;
int switch_pwm_B = 0;

// --- DIY PWM gripper servo (local patch, not upstream) ---
// Hobby servo signal on GPIO4 (the board's spare IO4 breakout).
// Controlled by {"T":117,"angle":0..180} — see CMD_PWM_SERVO.
// Uses the core LEDC API directly (same allocator as the H-bridge PWM
// above) instead of ESP32Servo, whose independent channel bookkeeping
// clashes with the firmware's ledcAttach() calls and corrupts both
// signals (severe servo jitter).
#define PWM_GRIPPER_PIN 4
#define PWM_GRIPPER_FREQ 50
#define PWM_GRIPPER_RES 16
bool pwmGripperAttached = false;

void pwmGripperInit() {
  // Nothing at boot on purpose: the servo stays limp (no pulses, no
  // stall against the gripper linkage) until the first {"T":117}.
}

void pwmGripperCtrl(int angle) {
  if (angle < 0) angle = 0;
  if (angle > 180) angle = 180;
  if (!pwmGripperAttached) {
    pwmGripperAttached = ledcAttach(PWM_GRIPPER_PIN, PWM_GRIPPER_FREQ, PWM_GRIPPER_RES);
    if (!pwmGripperAttached) {
      Serial.println("pwmGripper: ledcAttach failed");
      return;
    }
  }
  // 1000-2000us over 0-180 deg; 20000us frame at 16-bit resolution
  uint32_t us = 1000 + ((uint32_t)angle * 1000) / 180;
  ledcWrite(PWM_GRIPPER_PIN, (uint32_t)((uint64_t)us * 65535 / 20000));
}
// --- end DIY gripper patch ---

void switchPinInit(){
  pinMode(AIN1, OUTPUT);
  pinMode(AIN2, OUTPUT);
  pinMode(PWMA, OUTPUT);
  pinMode(BIN1, OUTPUT);
  pinMode(BIN2, OUTPUT);
  pinMode(PWMB, OUTPUT);

  // ledcSetup(channel_A, freq, ANALOG_WRITE_BITS);
  // ledcAttachPin(PWMA, channel_A);

  ledcAttach(PWMA, freq, ANALOG_WRITE_BITS);

  // ledcSetup(channel_B, freq, ANALOG_WRITE_BITS);
  // ledcAttachPin(PWMB, channel_B);

  ledcAttach(PWMB, freq, ANALOG_WRITE_BITS);

  digitalWrite(AIN1, LOW);
  digitalWrite(AIN2, LOW);
  digitalWrite(BIN1, LOW);
  digitalWrite(BIN2, LOW);
}


void switchEmergencyStop(){
  switch_pwm_A = 0;
  switch_pwm_B = 0;
  
  digitalWrite(AIN1, LOW);
  digitalWrite(AIN2, LOW);

  digitalWrite(BIN1, LOW);
  digitalWrite(BIN2, LOW);
}


void switchPortCtrlA(float pwmInputA){
  int pwmIntA = round(pwmInputA);
  if(abs(pwmIntA) < 1e-6){
    digitalWrite(AIN1, LOW);
    digitalWrite(AIN2, LOW);
    return;
  }

  if(pwmIntA > 0){
    digitalWrite(AIN1, LOW);
    digitalWrite(AIN2, HIGH);
    ledcWrite(PWMA, pwmIntA);
  }
  else{
    digitalWrite(AIN1, HIGH);
    digitalWrite(AIN2, LOW);
    ledcWrite(PWMA,-pwmIntA);
  }
}


void switchPortCtrlB(float pwmInputB){
  int pwmIntB = round(pwmInputB);
  if(abs(pwmIntB) < 1e-6){
    digitalWrite(BIN1, LOW);
    digitalWrite(BIN2, LOW);
    return;
  }

  if(pwmIntB > 0){
    digitalWrite(BIN1, LOW);
    digitalWrite(BIN2, HIGH);
    ledcWrite(PWMB, pwmIntB);
  }
  else{
    digitalWrite(BIN1, HIGH);
    digitalWrite(BIN2, LOW);
    ledcWrite(PWMB,-pwmIntB);
  }
}


void switchCtrl(int pwmIntA, int pwmIntB) {
    switch_pwm_A = pwmIntA;
    switch_pwm_B = pwmIntB;
    switchPortCtrlA(switch_pwm_A);
    switchPortCtrlB(switch_pwm_B);
}


void lightCtrl(int pwmIn) {
  switch_pwm_A = pwmIn;
  switchPortCtrlA(-abs(switch_pwm_A));
}