// pins.h — OpenChess controller GPIO map (v0.1 hardware)
// Extracted from hardware-controller/openchess-controller.kicad_sch — the real board.
// Do not guess pins; this is the source of truth.
#pragma once

// ── LED chain (WS2812B) ───────────────────────────────────────────────
// Data goes 3.3V GPIO -> 74AHCT125 level shifter -> 5V -> J1 -> matrix D1..D81.
#define PIN_LED_DATA       32   // GPIO32  (/LED_DATA)

// ── Matrix column drive (high-side via TBD62783A) ─────────────────────
// One column powered at a time. Order A..H = files A..H.
static const int PIN_COL_DRV[8] = {
    13,  // A  GPIO13 (/COL_DRV_A)
    14,  // B  GPIO14 (/COL_DRV_B)
    27,  // C  GPIO27 (/COL_DRV_C)
    26,  // D  GPIO26 (/COL_DRV_D)
    25,  // E  GPIO25 (/COL_DRV_E)
    33,  // F  GPIO33 (/COL_DRV_F)
     5,  // G  GPIO5  (/COL_DRV_G)   *strapping pin — OK, internal pull-up high at boot
    15,  // H  GPIO15 (/COL_DRV_H)   *strapping pin — OK
};

// ── Matrix row sense (hall OUT, open-drain, pulled up to 3.3V) ─────────
// S0..S7 = ranks. Read these while a column is powered. (digital inputs)
static const int PIN_ROW_SENSE[8] = {
     4,  // S0  GPIO4
    16,  // S1  GPIO16
    17,  // S2  GPIO17
    18,  // S3  GPIO18
    19,  // S4  GPIO19
    21,  // S5  GPIO21
    22,  // S6  GPIO22
    23,  // S7  GPIO23
};

// ── Panel I2C (OLED SSD1306) ──────────────────────────────────────────
// NOTE: these are UART0 pins. Serial-over-USB and the OLED share them,
// so: (a) you can't use Serial debug while the OLED is connected, and
// (b) disconnect the OLED from these pins when flashing firmware.
#define PIN_I2C_SDA         1   // GPIO1  (U0TXD)
#define PIN_I2C_SCL         3   // GPIO3  (U0RXD)

// ── Panel buttons / rotary encoder ────────────────────────────────────
// Board originally wired for 3 buttons. If using a ROTARY ENCODER instead,
// wire it as noted below (A/B already have pull-ups via R36/R37).
#define PIN_BTN_POWER      36   // GPIO36 (input-only, ext pull-up R36)  | ENCODER A
#define PIN_BTN_MODE       39   // GPIO39 (input-only, ext pull-up R37)  | ENCODER B
#define PIN_BTN_SELECT      2   // GPIO2  (internal pull-up)             | ENCODER PUSH
#define PIN_PANEL_SPARE    35   // GPIO35 (input-only, NO pull-up)       | spare / power btn

// Functional mapping — use THESE in firmware, not the raw net names above.
// 2026-08 incident: a solder bridge between the GPIO2 and GPIO36 lines made
// OK presses read as DOWN *and* blocked download mode (GPIO2 is a strapping
// pin). If OK still acts as DOWN after the joints are fixed, the caps are
// cross-wired — just swap OK and DOWN here.
#define PIN_BTN_UP         PIN_BTN_MODE    // GPIO39, ext pull-up
#define PIN_BTN_DOWN       PIN_BTN_POWER   // GPIO36, ext pull-up R36
#define PIN_BTN_OK         PIN_BTN_SELECT  // GPIO2, needs INPUT_PULLUP

// ── Battery monitor ───────────────────────────────────────────────────
// Divider R14/R15 = 0.3125x. ADC1 (works during WiFi). 4.2V batt -> ~1.31V.
#define PIN_VBAT_MON       34   // GPIO34 (ADC1_CH6)

// ── Counts ────────────────────────────────────────────────────────────
#define MATRIX_COLS         8
#define MATRIX_ROWS         8
#define LED_COUNT          81   // 9x9 corners
