import { useRouter } from 'expo-router';
import { Pressable, ScrollView, StyleSheet, View } from 'react-native';

import { boardCells } from '@/chess/board';
import { colors, radius } from '@/theme/tokens';
import { BoardGrid, Screen, StatusDot, Text } from '@/ui';

const LIVE_FEN = 'rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2';

const MOVES: { n: string; w: string; b: string }[] = [
  { n: '1', w: 'e4', b: 'e5' },
  { n: '2', w: 'Nf3', b: 'Nc6' },
  { n: '3', w: 'Bb5', b: 'a6' },
  { n: '4', w: 'Ba4', b: 'Nf6' },
];

/** 05 · LIVE GAME */
export default function LiveGameScreen() {
  const router = useRouter();
  const cells = boardCells(LIVE_FEN, 'w', { selected: ['g1'], led: ['f3'] });

  return (
    <Screen>
      <View style={styles.root}>
        {/* Opponent row */}
        <View style={styles.playerRow}>
          <View style={[styles.avatar, styles.avatarDark]}>
            <Text size={20} color={colors.screen}>
              ♚
            </Text>
          </View>
          <View style={styles.playerInfo}>
            <Text weight="bold" size={15}>
              Stockfish
            </Text>
            <Text size={12} color={colors.muted2}>
              Level 5 · ≈2050
            </Text>
          </View>
          <View style={styles.clockLight}>
            <Text mono weight="semibold" size={19} color={colors.muted}>
              9:41
            </Text>
          </View>
        </View>

        {/* Board */}
        <BoardGrid cells={cells} />

        {/* Hint bar */}
        <View style={styles.hintBar}>
          <StatusDot color={colors.green} size={8} />
          <Text weight="semibold" size={13} color={colors.greenDeep} style={styles.hintText}>
            Board LEDs are lighting your move
          </Text>
          <Text mono weight="semibold" size={13} color={colors.green}>
            Nf3
          </Text>
        </View>

        {/* Player row */}
        <View style={styles.playerRow}>
          <View style={[styles.avatar, styles.avatarLight]}>
            <Text size={20} color={colors.inkSoft}>
              ♔
            </Text>
          </View>
          <View style={styles.playerInfo}>
            <Text weight="bold" size={15}>
              You
            </Text>
            <Text weight="semibold" size={12} color={colors.green}>
              Your move
            </Text>
          </View>
          <View style={styles.clockDark}>
            <Text mono weight="semibold" size={19} color={colors.white}>
              9:58
            </Text>
          </View>
        </View>

        {/* Move list */}
        <ScrollView
          horizontal
          showsHorizontalScrollIndicator={false}
          contentContainerStyle={styles.moveList}>
          {MOVES.map((m) => (
            <View key={m.n} style={styles.moveGroup}>
              <Text mono size={12.5} color={colors.muted5}>
                {m.n}
              </Text>
              <Text mono size={12.5} color={colors.text}>
                {m.w}
              </Text>
              <Text mono size={12.5} color={colors.muted}>
                {m.b}
              </Text>
            </View>
          ))}
        </ScrollView>

        {/* Actions */}
        <View style={styles.actions}>
          <ActionButton label="Flip" variant="white" />
          <ActionButton label="Hint" variant="green" />
          <ActionButton label="Draw" variant="white" />
          <ActionButton label="Resign" variant="red" onPress={() => router.push('/game-over')} />
        </View>
      </View>
    </Screen>
  );
}

function ActionButton({
  label,
  variant,
  onPress,
}: {
  label: string;
  variant: 'white' | 'green' | 'red';
  onPress?: () => void;
}) {
  const v = ACTION_VARIANTS[variant];
  return (
    <Pressable
      onPress={onPress}
      style={({ pressed }) => [
        styles.action,
        { backgroundColor: v.bg },
        v.border ? styles.actionBorder : null,
        pressed && onPress ? styles.pressed : null,
      ]}>
      <Text weight={v.weight} size={13} color={v.fg}>
        {label}
      </Text>
    </Pressable>
  );
}

const ACTION_VARIANTS: Record<
  'white' | 'green' | 'red',
  { bg: string; fg: string; weight: 'semibold' | 'bold'; border?: boolean }
> = {
  white: { bg: colors.white, fg: colors.muted, weight: 'semibold', border: true },
  green: { bg: colors.greenTint, fg: colors.green, weight: 'bold' },
  red: { bg: colors.redTint, fg: colors.red, weight: 'bold' },
};

const styles = StyleSheet.create({
  root: { flex: 1, gap: 12 },

  playerRow: { flexDirection: 'row', alignItems: 'center', gap: 11 },
  avatar: {
    width: 38,
    height: 38,
    borderRadius: 11,
    alignItems: 'center',
    justifyContent: 'center',
  },
  avatarDark: { backgroundColor: colors.inkSoft },
  avatarLight: {
    backgroundColor: colors.pieceWhite,
    borderWidth: 1,
    borderColor: 'rgba(0,0,0,0.1)',
  },
  playerInfo: { flex: 1 },
  clockLight: {
    backgroundColor: colors.white,
    borderWidth: 1,
    borderColor: 'rgba(0,0,0,0.07)',
    paddingVertical: 6,
    paddingHorizontal: 13,
    borderRadius: 11,
  },
  clockDark: {
    backgroundColor: colors.ink,
    paddingVertical: 6,
    paddingHorizontal: 13,
    borderRadius: 11,
    borderWidth: 2,
    borderColor: 'rgba(63,143,99,0.5)',
    shadowColor: colors.green,
    shadowOpacity: 0.5,
    shadowRadius: 6,
    shadowOffset: { width: 0, height: 0 },
    elevation: 4,
  },

  hintBar: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
    backgroundColor: colors.greenTint,
    borderRadius: 12,
    paddingVertical: 9,
    paddingHorizontal: 13,
  },
  hintText: { flex: 1 },

  moveList: { gap: 8, alignItems: 'center' },
  moveGroup: { flexDirection: 'row', gap: 5 },

  actions: { flexDirection: 'row', gap: 8, marginTop: 'auto' },
  action: {
    flex: 1,
    borderRadius: 13,
    paddingVertical: 12,
    alignItems: 'center',
    justifyContent: 'center',
  },
  actionBorder: { borderWidth: 1, borderColor: 'rgba(0,0,0,0.07)' },
  pressed: { opacity: 0.85 },
});
