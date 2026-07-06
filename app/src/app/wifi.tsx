import { useRouter } from 'expo-router';
import { useEffect, useState } from 'react';
import { StyleSheet, View } from 'react-native';

import { Button, Card, Lock, Screen, Text, WifiGlyph } from '@/ui';
import { useBoard } from '@/board/BoardProvider';
import type { WifiNetwork } from '@/board/types';
import { colors } from '@/theme/tokens';

/**
 * 02 · WI-FI SETUP (optional).
 *
 * Wi-Fi is only needed for online play (Lichess / Chess.com) and OTA updates —
 * none of which exists yet — so this is a skippable step. The board's live
 * scan is shown when it comes through; full network-select + password entry
 * and real provisioning are a later task. See the "deferred" note in
 * docs/superpowers/specs/2026-07-06-ble-transport-design.md.
 */
export default function WifiScreen() {
  const router = useRouter();
  const { board } = useBoard();
  const [networks, setNetworks] = useState<WifiNetwork[]>([]);
  const [scanning, setScanning] = useState(true);

  useEffect(() => {
    let alive = true;
    setScanning(true);
    board
      .scanWifi()
      .then((nets) => alive && setNetworks(nets))
      .catch(() => alive && setNetworks([]))
      .finally(() => alive && setScanning(false));
    return () => {
      alive = false;
    };
  }, [board]);

  return (
    <Screen>
      <Text mono size={11} color={colors.muted3} spacing={2}>
        OPTIONAL · WI-FI
      </Text>
      <Text weight="bold" size={29} spacing={-0.5} style={styles.title}>
        Connect to Wi-Fi
      </Text>
      <Text size={14.5} color={colors.muted} style={styles.sub}>
        Only needed later for online play (Lichess, Chess.com) and firmware updates. Your board is
        already connected over Bluetooth — you can skip this and set it up anytime.
      </Text>

      <Text mono size={11} color={colors.muted3} spacing={1.5} style={styles.otherLabel}>
        NETWORKS THE BOARD SEES
      </Text>
      <Card padded={false} style={styles.listCard}>
        {scanning ? (
          <View style={styles.stateRow}>
            <Text size={15} color={colors.muted2}>
              Scanning…
            </Text>
          </View>
        ) : networks.length ? (
          networks.map((net, i) => (
            <View
              key={net.name}
              style={[styles.netRow, i < networks.length - 1 && styles.netRowDivider]}>
              <Text size={15.5} weight="medium" style={styles.netName}>
                {net.name}
              </Text>
              {net.lock ? <Lock /> : null}
              <WifiGlyph strength={net.strength} />
            </View>
          ))
        ) : (
          <View style={styles.stateRow}>
            <Text size={15} color={colors.muted2}>
              No networks found
            </Text>
          </View>
        )}
      </Card>

      <View style={styles.cta}>
        <Button label="Skip for now" onPress={() => router.push('/home')} />
        <Text mono size={12} color={colors.muted3} center style={styles.footnote}>
          Set up Wi-Fi later in Settings
        </Text>
      </View>
    </Screen>
  );
}

const styles = StyleSheet.create({
  title: { marginTop: 12, lineHeight: 33 },
  sub: { marginTop: 9, lineHeight: 21 },
  otherLabel: { marginTop: 26, marginHorizontal: 4, marginBottom: 8 },
  listCard: { borderRadius: 18, overflow: 'hidden' },
  stateRow: { paddingVertical: 16, paddingHorizontal: 15 },
  netRow: { flexDirection: 'row', alignItems: 'center', gap: 12, paddingVertical: 13, paddingHorizontal: 15 },
  netRowDivider: { borderBottomWidth: 1, borderBottomColor: 'rgba(0,0,0,0.05)' },
  netName: { flex: 1 },
  cta: { marginTop: 'auto', paddingTop: 24 },
  footnote: { marginTop: 12 },
});
