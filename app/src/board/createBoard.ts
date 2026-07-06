import Constants, { ExecutionEnvironment } from 'expo-constants';
import { Platform } from 'react-native';

import { MockBoard } from './MockBoard';
import type { BoardTransport } from './types';

type Override = 'ble' | 'mock' | null;
let override: Override = null;

/** Dev hook: force a transport before the BoardProvider mounts (e.g. from a
 *  developer toggle). Null = auto-detect. */
export function setTransportOverride(v: Override): void {
  override = v;
}

/**
 * Picks the transport: real BleBoard on a native dev build, MockBoard in Expo
 * Go / on web / when the native BLE module fails to load. Keeps the app usable
 * everywhere.
 */
export function createBoard(): BoardTransport {
  if (shouldUseBle()) {
    try {
      // Lazy require so Expo Go never touches the native BLE module.
      const { BleBoard } = require('./BleBoard') as typeof import('./BleBoard');
      return new BleBoard();
    } catch (e) {
      console.warn('[board] BLE unavailable, falling back to MockBoard:', e);
    }
  }
  return new MockBoard();
}

function shouldUseBle(): boolean {
  if (override) return override === 'ble';
  if (Platform.OS === 'web') return false;
  // Expo Go (StoreClient) cannot load custom native modules like ble-plx.
  return Constants.executionEnvironment !== ExecutionEnvironment.StoreClient;
}
