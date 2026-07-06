import { useRouter } from 'expo-router';
import { useEffect, useRef, useState } from 'react';
import { Animated, Easing, StyleSheet, View } from 'react-native';

import { useBoard } from '@/board/BoardProvider';
import { Button, Card, CheckCircle, Screen, Text } from '@/ui';
import { colors, radius } from '@/theme/tokens';

/** 01 · PAIR BOARD */
export default function PairScreen() {
  const router = useRouter();
  const { board } = useBoard();
  const [connecting, setConnecting] = useState(false);

  const onConnect = async () => {
    setConnecting(true);
    try {
      await board.connect('4A2F');
      router.push('/wifi');
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

      <Card radiusToken="xxl" elevated style={styles.card}>
        <View style={styles.row}>
          <PulseDot />
          <View style={styles.info}>
            <Text mono weight="semibold" size={16} spacing={-0.2}>
              OpenChess-4A2F
            </Text>
            <Text size={12.5} color={colors.muted2} style={styles.subtitle}>
              Found nearby · strong signal
            </Text>
          </View>
          <CheckCircle size={22} />
        </View>
      </Card>

      <View style={styles.actions}>
        <Button label="Connect board" loading={connecting} onPress={onConnect} />
        <Button label="Enter board ID manually" variant="ghost" onPress={() => {}} />
      </View>
    </Screen>
  );
}

/** Green status dot with an expanding, fading ring behind it. */
function PulseDot() {
  const ring = useRef(new Animated.Value(0)).current;

  useEffect(() => {
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
  }, [ring]);

  const scale = ring.interpolate({ inputRange: [0, 1], outputRange: [0.7, 2.2] });
  const opacity = ring.interpolate({ inputRange: [0, 1], outputRange: [0.6, 0] });

  return (
    <View style={styles.dotWrap}>
      <Animated.View style={[styles.ring, { opacity, transform: [{ scale }] }]} />
      <View style={styles.dot} />
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
