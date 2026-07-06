import { useEffect, useRef } from 'react';
import { Animated, StyleSheet, View, ViewStyle } from 'react-native';

import type { Cell } from '@/chess/board';
import { colors, radius, shadow } from '@/theme/tokens';
import { Text } from './Text';

type BoardGridProps = {
  cells: Cell[]; // exactly 64, top-left first
  size?: number; // board edge in px; defaults to fill container width
  style?: ViewStyle;
};

/**
 * Renders an 8x8 board from pre-computed cells (see chess/board.ts).
 * Handles the design's three overlays: selection ring, green LED hint dot,
 * and pulsing red error square. Purely presentational — it mirrors board
 * state, it does not own game logic.
 */
export function BoardGrid({ cells, size, style }: BoardGridProps) {
  return (
    <View style={[styles.frame, style, size ? { width: size, height: size } : undefined]}>
      <View style={styles.grid}>
        {cells.map((c) => (
          <Square key={c.square} cell={c} />
        ))}
      </View>
    </View>
  );
}

function Square({ cell }: { cell: Cell }) {
  const bg = cell.light ? colors.boardLight : colors.boardDark;
  return (
    <View style={[styles.cell, { backgroundColor: bg }]}>
      {cell.last ? <View style={styles.last} /> : null}
      {cell.sel ? <View style={styles.sel} /> : null}
      {cell.err ? <ErrorPulse /> : null}
      {cell.led ? <View style={styles.led} /> : null}
      {cell.glyph ? (
        <Text size={26} color={cell.pieceColor} style={styles.piece}>
          {cell.glyph}
        </Text>
      ) : null}
    </View>
  );
}

function ErrorPulse() {
  const anim = useRef(new Animated.Value(0)).current;
  useEffect(() => {
    const loop = Animated.loop(
      Animated.sequence([
        Animated.timing(anim, { toValue: 1, duration: 700, useNativeDriver: true }),
        Animated.timing(anim, { toValue: 0, duration: 700, useNativeDriver: true }),
      ]),
    );
    loop.start();
    return () => loop.stop();
  }, [anim]);
  const opacity = anim.interpolate({ inputRange: [0, 1], outputRange: [0.5, 1] });
  return <Animated.View style={[styles.err, { opacity }]} />;
}

const styles = StyleSheet.create({
  frame: {
    borderRadius: radius.md,
    overflow: 'hidden',
    ...shadow.board,
  },
  grid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    aspectRatio: 1,
  },
  cell: {
    width: `${100 / 8}%`,
    aspectRatio: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  piece: {
    textShadowColor: 'rgba(0,0,0,0.25)',
    textShadowOffset: { width: 0, height: 1 },
    textShadowRadius: 1,
  },
  sel: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    borderWidth: 3,
    borderColor: 'rgba(63,143,99,0.95)',
  },
  last: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: 'rgba(63,143,99,0.18)',
  },
  led: {
    position: 'absolute',
    width: '32%',
    height: '32%',
    borderRadius: 999,
    backgroundColor: 'rgba(63,143,99,0.9)',
    shadowColor: colors.green,
    shadowOpacity: 0.7,
    shadowRadius: 8,
    shadowOffset: { width: 0, height: 0 },
    elevation: 6,
  },
  err: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    borderWidth: 3,
    borderColor: colors.red,
    backgroundColor: 'rgba(196,85,61,0.18)',
  },
});
