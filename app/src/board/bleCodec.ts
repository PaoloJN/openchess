/**
 * Pure (radio-free) JSON codec for the OpenChess BLE GATT contract.
 * Mirrors firmware/src/shell/ble_board.cpp. No dependency on react-native-ble-plx
 * so it can be unit-tested without a Bluetooth stack.
 */
import type { LedCell, WifiNetwork } from './types';

// ── GATT identifiers (must match firmware ble_board.cpp) ──────────────────────
export const SVC_UUID = '6f00c0de-b5a3-f393-e0a9-e50e24dcca01';
export const CMD_UUID = '6f00c0de-b5a3-f393-e0a9-e50e24dcca02'; // app -> board (write)
export const EVT_UUID = '6f00c0de-b5a3-f393-e0a9-e50e24dcca03'; // board -> app (notify)

// ── App -> board commands (written to CMD) ────────────────────────────────────
export function encodeSetLEDs(cells: LedCell[]): string {
  return JSON.stringify({ t: 'setLEDs', cells });
}

export function encodeScanWifi(): string {
  return JSON.stringify({ t: 'scanWifi' });
}

export function encodeProvisionWifi(ssid: string, password: string): string {
  return JSON.stringify({ t: 'provisionWifi', ssid, password });
}

// ── Board -> app events (notified on EVT) ─────────────────────────────────────
export type BoardEvent =
  | {
      kind: 'status';
      battery: number;
      firmware: string;
      wifi?: { ssid: string; strength: 0 | 1 | 2 | 3; lichessReady: boolean };
    }
  | { kind: 'move'; square: string; moveKind: 'lift' | 'place' }
  | { kind: 'wifiList'; networks: WifiNetwork[] }
  | { kind: 'unknown' };

const clampStrength = (n: unknown): 0 | 1 | 2 | 3 => {
  const v = Math.max(0, Math.min(3, Math.round(Number(n) || 0)));
  return v as 0 | 1 | 2 | 3;
};

export function decodeEvent(json: string): BoardEvent {
  let doc: Record<string, unknown>;
  try {
    doc = JSON.parse(json) as Record<string, unknown>;
  } catch {
    return { kind: 'unknown' };
  }
  if (!doc || typeof doc !== 'object') return { kind: 'unknown' };

  switch (doc.t) {
    case 'status': {
      const w = (doc.wifi ?? {}) as Record<string, unknown>;
      const ssid = typeof w.ssid === 'string' ? w.ssid : '';
      return {
        kind: 'status',
        battery: Number(doc.battery) || 0,
        firmware: typeof doc.firmware === 'string' ? doc.firmware : '',
        wifi: ssid
          ? { ssid, strength: clampStrength(w.strength), lichessReady: Boolean(w.lichessReady) }
          : undefined,
      };
    }
    case 'move': {
      const kind = doc.kind === 'place' ? 'place' : 'lift';
      return { kind: 'move', square: String(doc.square ?? ''), moveKind: kind };
    }
    case 'wifiList': {
      const raw = Array.isArray(doc.networks) ? doc.networks : [];
      const networks: WifiNetwork[] = raw.map((n) => {
        const o = (n ?? {}) as Record<string, unknown>;
        return {
          name: typeof o.name === 'string' ? o.name : '',
          lock: Boolean(o.lock),
          strength: clampStrength(o.strength),
        };
      });
      return { kind: 'wifiList', networks };
    }
    default:
      return { kind: 'unknown' };
  }
}
