import { Buffer } from 'buffer';
import { PermissionsAndroid, Platform } from 'react-native';
import { BleManager, Device, Subscription } from 'react-native-ble-plx';

import {
  CMD_UUID,
  EVT_UUID,
  SVC_UUID,
  decodeEvent,
  encodeProvisionWifi,
  encodeScanWifi,
  encodeSetLEDs,
} from './bleCodec';
import type {
  BoardInfo,
  BoardMove,
  BoardStatus,
  BoardTransport,
  LedCell,
  WifiNetwork,
} from './types';

const b64 = (s: string) => Buffer.from(s, 'utf8').toString('base64');
const unb64 = (s: string) => Buffer.from(s, 'base64').toString('utf8');

const SCAN_MS = 4000;
const WIFI_LIST_TIMEOUT_MS = 8000;

/**
 * Real BLE transport to the OpenChess board (firmware ble_board.cpp), using
 * react-native-ble-plx. Requires a native dev build — see createBoard.ts for
 * the MockBoard fallback in Expo Go.
 */
export class BleBoard implements BoardTransport {
  private manager = new BleManager();
  private device: Device | null = null;
  private evtSub: Subscription | null = null;
  private disconnectSub: Subscription | null = null;

  private status: BoardStatus = { connection: 'disconnected', battery: 0 };
  private statusSubs = new Set<(s: BoardStatus) => void>();
  private moveSubs = new Set<(m: BoardMove) => void>();
  private wifiWaiters: ((n: WifiNetwork[]) => void)[] = [];

  async scan(): Promise<BoardInfo[]> {
    await this.ensureReady();
    const found = new Map<string, BoardInfo>();

    return new Promise<BoardInfo[]>((resolve, reject) => {
      this.manager.startDeviceScan([SVC_UUID], null, (error, device) => {
        if (error) {
          this.manager.stopDeviceScan();
          reject(error);
          return;
        }
        if (device && !found.has(device.id)) {
          found.set(device.id, {
            id: device.id,
            name: device.name ?? device.localName ?? 'OpenChess board',
            rssi: device.rssi ?? -100,
          });
        }
      });

      setTimeout(() => {
        this.manager.stopDeviceScan();
        resolve([...found.values()].sort((a, b) => b.rssi - a.rssi));
      }, SCAN_MS);
    });
  }

  async connect(id: string): Promise<void> {
    this.patch({ connection: 'pairing' });
    try {
      const device = await this.manager.connectToDevice(id, { requestMTU: 517 });
      await device.discoverAllServicesAndCharacteristics();
      this.device = device;

      this.evtSub = device.monitorCharacteristicForService(
        SVC_UUID,
        EVT_UUID,
        (error, ch) => {
          if (error || !ch?.value) return;
          this.handleEvent(unb64(ch.value));
        },
      );

      this.disconnectSub = device.onDisconnected(() => this.handleDisconnect());
      this.patch({ connection: 'connected', name: device.name ?? this.status.name });
    } catch (e) {
      this.patch({ connection: 'disconnected' });
      throw e;
    }
  }

  async disconnect(): Promise<void> {
    const id = this.device?.id;
    this.evtSub?.remove();
    this.disconnectSub?.remove();
    this.evtSub = null;
    this.disconnectSub = null;
    if (id) {
      try {
        await this.manager.cancelDeviceConnection(id);
      } catch {
        // already gone
      }
    }
    this.handleDisconnect();
  }

  async scanWifi(): Promise<WifiNetwork[]> {
    await this.write(encodeScanWifi());
    return new Promise<WifiNetwork[]>((resolve, reject) => {
      const timer = setTimeout(() => {
        this.wifiWaiters = this.wifiWaiters.filter((w) => w !== waiter);
        reject(new Error('Timed out waiting for the board to scan Wi-Fi'));
      }, WIFI_LIST_TIMEOUT_MS);
      const waiter = (nets: WifiNetwork[]) => {
        clearTimeout(timer);
        resolve(nets);
      };
      this.wifiWaiters.push(waiter);
    });
  }

  async provisionWifi(ssid: string, password: string): Promise<void> {
    await this.write(encodeProvisionWifi(ssid, password));
    // The board joins the network and reports the result via later status events.
  }

  setLEDs(cells: LedCell[]): void {
    // Fire-and-forget; ignore transient write errors while (dis)connecting.
    void this.write(encodeSetLEDs(cells)).catch(() => {});
  }

  getStatus(): BoardStatus {
    return this.status;
  }

  subscribeStatus(cb: (s: BoardStatus) => void): () => void {
    this.statusSubs.add(cb);
    cb(this.status);
    return () => this.statusSubs.delete(cb);
  }

  subscribeMove(cb: (m: BoardMove) => void): () => void {
    this.moveSubs.add(cb);
    return () => this.moveSubs.delete(cb);
  }

  // ── internals ───────────────────────────────────────────────────────────────

  private async write(json: string): Promise<void> {
    if (!this.device) throw new Error('Not connected to a board');
    await this.device.writeCharacteristicWithoutResponseForService(SVC_UUID, CMD_UUID, b64(json));
  }

  private handleEvent(json: string): void {
    const ev = decodeEvent(json);
    switch (ev.kind) {
      case 'status':
        this.patch({ battery: ev.battery, firmware: ev.firmware, wifi: ev.wifi });
        break;
      case 'move':
        this.moveSubs.forEach((cb) => cb({ square: ev.square, kind: ev.moveKind }));
        break;
      case 'wifiList': {
        const waiters = this.wifiWaiters;
        this.wifiWaiters = [];
        waiters.forEach((w) => w(ev.networks));
        break;
      }
    }
  }

  private handleDisconnect(): void {
    this.device = null;
    this.patch({ connection: 'disconnected', wifi: undefined });
  }

  private patch(next: Partial<BoardStatus>): void {
    this.status = { ...this.status, ...next };
    this.statusSubs.forEach((cb) => cb(this.status));
  }

  /** Wait for the adapter to be powered on and (Android) permissions granted. */
  private async ensureReady(): Promise<void> {
    await this.requestAndroidPermissions();
    const state = await this.manager.state();
    if (state === 'PoweredOn') return;
    await new Promise<void>((resolve, reject) => {
      const sub = this.manager.onStateChange((s) => {
        if (s === 'PoweredOn') {
          sub.remove();
          resolve();
        } else if (s === 'Unsupported' || s === 'Unauthorized') {
          sub.remove();
          reject(new Error(`Bluetooth ${s}`));
        }
      }, true);
    });
  }

  private async requestAndroidPermissions(): Promise<void> {
    if (Platform.OS !== 'android') return;
    const perms = [
      PermissionsAndroid.PERMISSIONS.BLUETOOTH_SCAN,
      PermissionsAndroid.PERMISSIONS.BLUETOOTH_CONNECT,
      PermissionsAndroid.PERMISSIONS.ACCESS_FINE_LOCATION,
    ].filter(Boolean) as string[];
    await PermissionsAndroid.requestMultiple(perms as never);
  }
}
