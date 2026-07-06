/// <reference types="jest" />
import {
  decodeEvent,
  encodeProvisionWifi,
  encodeScanWifi,
  encodeSetLEDs,
} from './bleCodec';

describe('bleCodec — encode (app -> board)', () => {
  it('encodes setLEDs with the cells array', () => {
    const json = encodeSetLEDs([{ file: 5, rank: 2, r: 63, g: 143, b: 99 }]);
    expect(JSON.parse(json)).toEqual({
      t: 'setLEDs',
      cells: [{ file: 5, rank: 2, r: 63, g: 143, b: 99 }],
    });
  });

  it('encodes an empty setLEDs (clear)', () => {
    expect(JSON.parse(encodeSetLEDs([]))).toEqual({ t: 'setLEDs', cells: [] });
  });

  it('encodes scanWifi', () => {
    expect(JSON.parse(encodeScanWifi())).toEqual({ t: 'scanWifi' });
  });

  it('encodes provisionWifi with credentials', () => {
    expect(JSON.parse(encodeProvisionWifi('Paolo-Studio', 'hunter2'))).toEqual({
      t: 'provisionWifi',
      ssid: 'Paolo-Studio',
      password: 'hunter2',
    });
  });
});

describe('bleCodec — decode (board -> app)', () => {
  it('decodes a status event with wifi', () => {
    const ev = decodeEvent(
      JSON.stringify({
        t: 'status',
        battery: 82,
        firmware: 'v1.4.2',
        wifi: { ssid: 'Home-5G', strength: 3, lichessReady: true },
      }),
    );
    expect(ev).toEqual({
      kind: 'status',
      battery: 82,
      firmware: 'v1.4.2',
      wifi: { ssid: 'Home-5G', strength: 3, lichessReady: true },
    });
  });

  it('treats an empty ssid as no wifi', () => {
    const ev = decodeEvent(
      JSON.stringify({ t: 'status', battery: 50, firmware: 'v1', wifi: { ssid: '', strength: 0, lichessReady: false } }),
    );
    expect(ev).toMatchObject({ kind: 'status', wifi: undefined });
  });

  it('clamps out-of-range wifi strength', () => {
    const ev = decodeEvent(
      JSON.stringify({ t: 'status', battery: 1, firmware: 'v1', wifi: { ssid: 'X', strength: 9, lichessReady: true } }),
    );
    expect(ev).toMatchObject({ kind: 'status', wifi: { strength: 3 } });
  });

  it('decodes a move event (lift/place)', () => {
    expect(decodeEvent(JSON.stringify({ t: 'move', square: 'e2', kind: 'lift' }))).toEqual({
      kind: 'move',
      square: 'e2',
      moveKind: 'lift',
    });
    expect(decodeEvent(JSON.stringify({ t: 'move', square: 'e4', kind: 'place' }))).toMatchObject({
      moveKind: 'place',
    });
  });

  it('defaults an unknown move kind to lift', () => {
    expect(decodeEvent(JSON.stringify({ t: 'move', square: 'a1', kind: 'wat' }))).toMatchObject({
      moveKind: 'lift',
    });
  });

  it('decodes a wifiList event', () => {
    const ev = decodeEvent(
      JSON.stringify({
        t: 'wifiList',
        networks: [
          { name: 'Paolo-Studio', lock: true, strength: 3 },
          { name: 'Guest', lock: false, strength: 1 },
        ],
      }),
    );
    expect(ev).toEqual({
      kind: 'wifiList',
      networks: [
        { name: 'Paolo-Studio', lock: true, strength: 3 },
        { name: 'Guest', lock: false, strength: 1 },
      ],
    });
  });

  it('returns unknown for malformed JSON', () => {
    expect(decodeEvent('{not json')).toEqual({ kind: 'unknown' });
  });

  it('returns unknown for an unrecognized type', () => {
    expect(decodeEvent(JSON.stringify({ t: 'nope' }))).toEqual({ kind: 'unknown' });
  });
});
