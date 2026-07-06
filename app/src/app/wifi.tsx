import { useRouter } from 'expo-router';
import { useEffect, useRef, useState } from 'react';
import { Animated, StyleSheet, View } from 'react-native';

import { Button, Card, Lock, Screen, Text, WifiGlyph } from '@/ui';
import { useBoard } from '@/board/BoardProvider';
import type { WifiNetwork } from '@/board/types';
import { colors } from '@/theme/tokens';

/** Design fallback list, also what MockBoard.scanWifi() returns. */
const FALLBACK_NETWORKS: WifiNetwork[] = [
  { name: 'Paolo-Studio', lock: true, strength: 3 },
  { name: 'Home-5G', lock: true, strength: 3 },
  { name: 'Home-2.4G', lock: true, strength: 2 },
  { name: 'Neighbor-Guest', lock: false, strength: 1 },
];

/** 02 · WI-FI SETUP */
export default function WifiScreen() {
  const router = useRouter();
  const { board } = useBoard();
  const [networks, setNetworks] = useState<WifiNetwork[]>(FALLBACK_NETWORKS);
  const [joining, setJoining] = useState(false);

  useEffect(() => {
    let alive = true;
    board.scanWifi().then((nets) => {
      if (alive) setNetworks(nets);
    });
    return () => {
      alive = false;
    };
  }, [board]);

  async function join() {
    setJoining(true);
    try {
      await board.provisionWifi('Paolo-Studio', '');
      router.push('/home');
    } finally {
      setJoining(false);
    }
  }

  return (
    <Screen>
      <Text mono size={11} color={colors.muted3} spacing={2} style={styles.eyebrow}>
        SETUP · STEP 2 OF 2
      </Text>
      <Text weight="bold" size={29} spacing={-0.5} style={styles.title}>
        Connect to Wi-Fi
      </Text>
      <Text size={14.5} color={colors.muted} style={styles.sub}>
        The board joins your network to reach Lichess and pull firmware updates.
      </Text>

      <Card padded={false} style={styles.networkCard}>
        <Text size={12} weight="semibold" color={colors.muted3}>
          NETWORK
        </Text>
        <Text size={16.5} weight="semibold" style={styles.networkName}>
          Paolo-Studio
        </Text>
        <View style={styles.cardDivider} />
        <Text size={12} weight="semibold" color={colors.muted3}>
          PASSWORD
        </Text>
        <View style={styles.passwordRow}>
          <View style={styles.dots}>
            {Array.from({ length: 7 }).map((_, i) => (
              <View key={i} style={styles.dot} />
            ))}
          </View>
          <BlinkingCaret />
        </View>
      </Card>

      <Text mono size={11} color={colors.muted3} spacing={1.5} style={styles.otherLabel}>
        OTHER NETWORKS
      </Text>
      <Card padded={false} style={styles.listCard}>
        {networks.map((net, i) => (
          <View key={net.name} style={[styles.netRow, i < networks.length - 1 && styles.netRowDivider]}>
            <Text size={15.5} weight="medium" style={styles.netName}>
              {net.name}
            </Text>
            {net.lock ? <Lock /> : null}
            <WifiGlyph strength={net.strength} />
          </View>
        ))}
      </Card>

      <View style={styles.cta}>
        <Button label="Join network" loading={joining} onPress={join} />
      </View>
    </Screen>
  );
}

/** Thin green text caret that blinks on/off (steps, ~1.1s period). */
function BlinkingCaret() {
  const opacity = useRef(new Animated.Value(1)).current;

  useEffect(() => {
    const loop = Animated.loop(
      Animated.sequence([
        Animated.timing(opacity, { toValue: 1, duration: 0, useNativeDriver: true }),
        Animated.delay(550),
        Animated.timing(opacity, { toValue: 0, duration: 0, useNativeDriver: true }),
        Animated.delay(550),
      ]),
    );
    loop.start();
    return () => loop.stop();
  }, [opacity]);

  return <Animated.View style={[styles.caret, { opacity }]} />;
}

const styles = StyleSheet.create({
  eyebrow: {},
  title: { marginTop: 12, lineHeight: 33 },
  sub: { marginTop: 9, lineHeight: 21 },

  networkCard: { marginTop: 20, paddingVertical: 15, paddingHorizontal: 16 },
  networkName: { marginTop: 5 },
  cardDivider: { height: 1, backgroundColor: 'rgba(0,0,0,0.07)', marginVertical: 13 },
  passwordRow: { flexDirection: 'row', alignItems: 'center', gap: 2, marginTop: 7, height: 22 },
  dots: { flexDirection: 'row', alignItems: 'center', gap: 5 },
  dot: { width: 7, height: 7, borderRadius: 3.5, backgroundColor: colors.inkDots },
  caret: { width: 2, height: 20, backgroundColor: colors.green, marginLeft: 3 },

  otherLabel: { marginTop: 20, marginHorizontal: 4, marginBottom: 8 },
  listCard: { borderRadius: 18, overflow: 'hidden' },
  netRow: { flexDirection: 'row', alignItems: 'center', gap: 12, paddingVertical: 13, paddingHorizontal: 15 },
  netRowDivider: { borderBottomWidth: 1, borderBottomColor: 'rgba(0,0,0,0.05)' },
  netName: { flex: 1 },

  cta: { marginTop: 18 },
});
