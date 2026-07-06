import type {
  BoardInfo,
  BoardMove,
  BoardStatus,
  BoardTransport,
  LedCell,
  WifiNetwork,
} from './types';

const delay = (ms: number) => new Promise<void>((r) => setTimeout(r, ms));

/**
 * In-memory simulator standing in for a real OpenChess board. Fakes discovery,
 * status telemetry, LED echo, and can emit simulated physical moves so the
 * gameplay screens feel alive with no hardware attached.
 */
export class MockBoard implements BoardTransport {
  private status: BoardStatus = {
    connection: 'disconnected',
    name: 'OpenChess-4A2F',
    battery: 82,
    firmware: 'v1.4.2',
  };

  private leds: LedCell[] = [];
  private statusSubs = new Set<(s: BoardStatus) => void>();
  private moveSubs = new Set<(m: BoardMove) => void>();

  async scan(): Promise<BoardInfo[]> {
    await delay(900);
    return [{ id: '4A2F', name: 'OpenChess-4A2F', rssi: -48 }];
  }

  async connect(id: string): Promise<void> {
    this.patch({ connection: 'pairing' });
    await delay(700);
    this.patch({ connection: 'connected', name: `OpenChess-${id}` });
  }

  async disconnect(): Promise<void> {
    this.patch({ connection: 'disconnected', wifi: undefined });
  }

  async scanWifi(): Promise<WifiNetwork[]> {
    await delay(600);
    return [
      { name: 'Paolo-Studio', lock: true, strength: 3 },
      { name: 'Home-5G', lock: true, strength: 3 },
      { name: 'Home-2.4G', lock: true, strength: 2 },
      { name: 'Neighbor-Guest', lock: false, strength: 1 },
    ];
  }

  async provisionWifi(ssid: string): Promise<void> {
    await delay(1100);
    this.patch({
      wifi: { ssid, strength: 3, lichessReady: true },
    });
  }

  setLEDs(cells: LedCell[]): void {
    this.leds = cells;
  }

  getLEDs(): LedCell[] {
    return this.leds;
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

  /** Test hook: pretend a physical move happened. */
  emitMove(m: BoardMove): void {
    this.moveSubs.forEach((cb) => cb(m));
  }

  private patch(next: Partial<BoardStatus>) {
    this.status = { ...this.status, ...next };
    this.statusSubs.forEach((cb) => cb(this.status));
  }
}
