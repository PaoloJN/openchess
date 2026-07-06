import { useRouter } from 'expo-router';
import { useCallback, useEffect, useRef, useState } from 'react';
import { Animated, Easing, Pressable, StyleSheet, View } from 'react-native';

import { useBoard } from '@/board/BoardProvider';
import type { BoardInfo } from '@/board/types';
import { Button, Card, CheckCircle, Screen, Text } from '@/ui';
import { colors, radius } from '@/theme/tokens';

function signalLabel(rssi: number): string {
  if (rssi >= -55) return 'strong signal';
  if (rssi >= -70) return 'good signal';
  return 'weak signal';
}

/** 01 · PAIR BOARD */
export default function PairScreen() {
  const router = useRouter();
  const { board } = useBoard();

  const [scanning, setScanning] = useState(false);
  const [devices, setDevices] = useState<BoardInfo[]>([]);
  const [connecting, setConnecting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const found = devices[0];

  const scan = useCallback(async () => {
    setError(null);
    setScanning(true);
    try {
      setDevices(await board.scan());
    } catch (e) {
      setError(e instanceof Error ? e.message : 'Scan failed');
    } finally {
      setScanning(false);
    }
  }, [board]);

  useEffect(() => {
    scan();
  }, [scan]);

  const onConnect = async () => {
    if (!found) return;
    setConnecting(true);
    try {
      await board.connect(found.id);
      router.push('/wifi');
    } catch (e) {
      setError(e instanceof Error ? e.message : 'Could not connect');
    } finally {
      setConnecting(false);
    }
  };

  return (
    <Screen>
      <Text mono size={11} color={colors.muted3} spacing={2}>
        SETUP · STEP 1 OF 2
      </Text>
      <Text weight="bold" size={29} spacing={-0.5} style={styles.title}>
        Pair your board
      </Text>
      <Text size={15} color={colors.muted} style={styles.instruction}>
        Power on the board and hold{' '}
        <Text mono size={13} color={colors.text2} style={styles.chip}>
          MODE
        </Text>{' '}
        for 3 seconds until the corner LEDs pulse green.
      </Text>

      <Pressable onPress={!found && !scanning ? scan : undefined}>
        <Card radiusToken="xxl" elevated style={styles.card}>
          <View style={styles.row}>
            <PulseDot active={scanning || !found} />
            <View style={styles.info}>
              <Text mono weight="semibold" size={16} spacing={-0.2}>
                {found ? found.name : scanning ? 'Searching…' : 'No board found'}
              </Text>
              <Text size={12.5} color={colors.muted2} style={styles.subtitle}>
                {found
                  ? `Found nearby · ${signalLabel(found.rssi)}`
                  : scanning
                    ? 'Make sure the board is on and pulsing green'
                    : 'Tap to scan again'}
              </Text>
            </View>
            {found ? <CheckCircle size={22} /> : null}
          </View>
        </Card>
      </Pressable>

      {error ? (
        <Text size={13} color={colors.red} style={styles.error}>
          {error}
        </Text>
      ) : null}

      <View style={styles.actions}>
        <Button
          label={found ? 'Connect board' : 'Scanning…'}
          variant={found ? 'primary' : 'disabled'}
          loading={connecting}
          onPress={onConnect}
        />
        <Button label="Enter board ID manually" variant="ghost" onPress={() => {}} />
      </View>
    </Screen>
  );
}

/** Green status dot with an expanding, fading ring behind it (when active). */
function PulseDot({ active }: { active: boolean }) {
  const ring = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    if (!active) return;
    const loop = Animated.loop(
      Animated.timing(ring, {
        toValue: 1,
        duration: 1800,
        easing: Easing.out(Easing.ease),
        useNativeDriver: true,
      }),
    );
    loop.start();
    return () => loop.stop();
  }, [active, ring]);

  const scale = ring.interpolate({ inputRange: [0, 1], outputRange: [0.7, 2.2] });
  const opacity = ring.interpolate({ inputRange: [0, 1], outputRange: [0.6, 0] });

  return (
    <View style={styles.dotWrap}>
      {active ? <Animated.View style={[styles.ring, { opacity, transform: [{ scale }] }]} /> : null}
      <View style={[styles.dot, !active && { backgroundColor: colors.muted3 }]} />
    </View>
  );
}

const styles = StyleSheet.create({
  title: { marginTop: 12, lineHeight: 32 },
  instruction: { marginTop: 10, lineHeight: 22 },
  chip: {
    backgroundColor: colors.chip,
    borderRadius: 5,
    paddingHorizontal: 6,
    paddingVertical: 1,
  },
  card: { marginTop: 26 },
  row: { flexDirection: 'row', alignItems: 'center', gap: 13 },
  info: { flex: 1, minWidth: 0 },
  subtitle: { marginTop: 2 },
  error: { marginTop: 14 },
  actions: { marginTop: 'auto', gap: 14, paddingTop: 32 },
  dotWrap: { width: 12, height: 12, alignItems: 'center', justifyContent: 'center' },
  dot: {
    position: 'absolute',
    width: 12,
    height: 12,
    borderRadius: radius.pill,
    backgroundColor: colors.green,
  },
  ring: {
    position: 'absolute',
    width: 12,
    height: 12,
    borderRadius: radius.pill,
    borderWidth: 2,
    borderColor: colors.green,
  },
});
