# RoArm-M2-S UART / USB Serial Control

Sources (fetched 2026-07-28):
- https://www.waveshare.com/wiki/RoArm-M2-S_Python_UART_Communication
- https://www.waveshare.com/wiki/RoArm-M2-S_JSON_Command_Meaning (UART/USB section)
- https://www.waveshare.com/wiki/General_Driver_for_Robots

## Basics

- **Default baud rate: 115200**, 8N1, 3.3 V TTL logic on the pins.
- Bidirectional: send one JSON command per line (newline-terminated); the arm
  prints JSON feedback (feedback verbosity via `{"T":605,"cmd":0|1|2}`).
- Two wired paths, both ending at ESP32 UART0:
  1. **USB Type-C port** (board port #9, labeled USB — not the LADAR Type-C):
     goes through the onboard CP2102 USB-UART bridge. On a PC it appears as a
     COM/tty port (install the CP210x driver if unrecognized).
  2. **Direct RX/TX pins**: the wiki: "connect it to other devices directly
     via RX/TX pin". These are broken out on the board's 40-pin
     Raspberry-Pi-style expansion header (this is how Waveshare's UGV
     products let a mounted Pi talk to the same board's ESP32 at 115200).
     Cross-connect: your TX → arm RX, your RX → arm TX, plus common GND.
     3.3 V logic only.
     Caution: this is the same UART0 that the CP2102/USB uses — do not drive
     both at once. Exact header pin positions: check the board silkscreen or
     the schematic PDF
     (https://files.waveshare.com/wiki/RoArm-M2-S/General_Driver_for_Robots.pdf).
- The LADAR Type-C port and its CP2102 are a separate lidar-to-USB channel —
  not for JSON control.

## Python demo (serial_simple_ctrl.py)

```python
import serial
import argparse
import threading

def read_serial():
    while True:
        data = ser.readline().decode('utf-8')
        if data:
            print(f"Received: {data}", end='')

def main():
    global ser
    parser = argparse.ArgumentParser(description='Serial JSON Communication')
    parser.add_argument('port', type=str, help='Serial port name (e.g., COM1 or /dev/ttyUSB0)')
    args = parser.parse_args()

    ser = serial.Serial(args.port, baudrate=115200, dsrdtr=None)
    ser.setRTS(False)
    ser.setDTR(False)

    serial_recv_thread = threading.Thread(target=read_serial)
    serial_recv_thread.daemon = True
    serial_recv_thread.start()

    try:
        while True:
            command = input("")
            ser.write(command.encode() + b'\n')
    except KeyboardInterrupt:
        pass
    finally:
        ser.close()

if __name__ == "__main__":
    main()
```

Run: `python serial_simple_ctrl.py /dev/ttyUSB0` (or `COMx`), then type JSON
commands, e.g. `{"T":105}`.

Note the `setRTS(False)` / `setDTR(False)`: the board's auto-download circuit
uses DTR/RTS, so leaving them asserted can hold the ESP32 in reset/boot mode.
Any serial terminal works too (Arduino Serial Monitor @115200, newline).

## HTTP alternative (WiFi)

`GET http://<arm-ip>/js?json=<url-encoded JSON>` — e.g. with the arm's AP
(SSID `RoArm-M2`, pass `12345678`, IP `192.168.4.1`):

```python
import requests
requests.get("http://192.168.4.1/js?json=" + '{"T":105}')
```

## From another ESP32 (e.g. an OpenChess controller)

- Wire a spare UART (e.g. `Serial1`/`Serial2` on your ESP32) to the arm's
  RX/TX at 115200, common ground; send the same newline-terminated JSON.
- This is the most deterministic ESP32→arm link (no pairing, no RF); ESP-NOW
  (see `20-esp-now.md`) is the wireless alternative.

## Troubleshooting (wiki FAQ)

- No response to JSON: check arm power + power switch, correct Type-C port
  (#9 USB), correct COM port.
- No COM port: install CP210x driver.
- Flash tool stuck "Connecting...": hold BOOT, tap EN, release BOOT.
- WiFi/NVS weirdness after reflash: `{"T":604}` then power-cycle.
