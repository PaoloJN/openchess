/**
 * Board transport contract — the stable interface between the app UI and
 * whatever talks to the physical OpenChess board.
 *
 * The design uses two real transports (BLE for phone <-> board, Wi-Fi for
 * board <-> internet). This build ships only `MockBoard`; real `BleBoard` /
 * `WifiBoard` implement this same interface later with zero UI changes.
 *
 * This file is also the reference contract for the firmware agent.
 */

/** file 0-7 (A-H), rank 0-7 (1-8), RGB 0-255. Mirrors firmware SetLedPayload. */
export type LedCell = {
  file: number;
  rank: number;
  r: number;
  g: number;
  b: number;
};

/** A physical piece event reported by the board's Hall matrix. */
export type BoardMove = {
  square: string; // algebraic, e.g. "e2"
  kind: 'lift' | 'place';
};

export type ConnectionState = 'disconnected' | 'pairing' | 'connected';

export type WifiStatus = {
  ssid: string;
  strength: 0 | 1 | 2 | 3;
  lichessReady: boolean;
};

export type BoardStatus = {
  connection: ConnectionState;
  name?: string; // "OpenChess-4A2F"
  battery: number; // 0..100
  firmware?: string; // "v1.4.2"
  wifi?: WifiStatus;
};

/** A board discovered during scan (BLE advertisement in the real transport). */
export type BoardInfo = {
  id: string;
  name: string;
  rssi: number; // signal strength, dBm-ish
};

export type WifiNetwork = {
  name: string;
  lock: boolean;
  strength: 0 | 1 | 2 | 3;
};

export interface BoardTransport {
  scan(): Promise<BoardInfo[]>;
  connect(id: string): Promise<void>;
  disconnect(): Promise<void>;

  /** Networks the board can see, for the Wi-Fi provisioning screen. */
  scanWifi(): Promise<WifiNetwork[]>;
  provisionWifi(ssid: string, password: string): Promise<void>;

  /** Light the board's corner LEDs. Empty array clears. */
  setLEDs(cells: LedCell[]): void;

  getStatus(): BoardStatus;
  subscribeStatus(cb: (s: BoardStatus) => void): () => void;
  subscribeMove(cb: (m: BoardMove) => void): () => void;
}
