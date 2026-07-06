import { useRouter } from 'expo-router';
import { Pressable, StyleSheet, View } from 'react-native';

import { Button, Screen, Text } from '@/ui';
import { colors, onInk, radius, shadow } from '@/theme/tokens';

const GAME_STATS: { v: string; k: string }[] = [
  { v: '34', k: 'Moves' },
  { v: '91%', k: 'Accuracy' },
  { v: '14:22', k: 'Time' },
  { v: 'Nf3', k: 'Best move' },
];

/** 08 · GAME OVER */
export default function GameOverScreen() {
  const router = useRouter();
  return (
    <Screen background={colors.ink}>
      <View style={styles.root}>
        {/* Result header */}
        <View style={styles.header}>
          <View style={styles.ring}>
            <View style={styles.crownCircle}>
              <Text size={42} color={colors.inkSoft}>
                ♔
              </Text>
            </View>
          </View>
          <Text mono size={11} spacing={2} color={colors.greenBright} style={styles.checkmate}>
            CHECKMATE
          </Text>
          <Text weight="extrabold" size={34} spacing={-0.8} color={onInk.text} style={styles.wonTitle}>
            You won
          </Text>
          <Text size={14.5} color={onInk.muted} style={styles.wonSub}>
            vs Stockfish · Level 5
          </Text>
        </View>

        {/* Score row */}
        <View style={styles.scoreRow}>
          <Text mono size={15} color={onInk.text}>
            You
          </Text>
          <Text mono weight="semibold" size={24} color={colors.greenBright}>
            1 <Text mono weight="semibold" size={24} color={onInk.faint}>
              –
            </Text>{' '}
            0
          </Text>
          <Text mono size={15} color={onInk.muted}>
            Stockfish
          </Text>
        </View>

        {/* Stat grid */}
        <View style={styles.statGrid}>
          {GAME_STATS.map((st) => (
            <View key={st.k} style={styles.statCard}>
              <Text mono weight="semibold" size={24} color={onInk.text}>
                {st.v}
              </Text>
              <Text size={12.5} color={onInk.muted2} style={styles.statLabel}>
                {st.k}
              </Text>
            </View>
          ))}
        </View>

        {/* Opening row */}
        <View style={styles.openingRow}>
          <Text size={18} color={onInk.text}>
            ♟
          </Text>
          <Text size={14} color="rgba(243,241,236,0.75)">
            Opening
          </Text>
          <Text weight="semibold" size={14} color={onInk.text} style={styles.openingValue}>
            Italian Game{' '}
            <Text mono size={14} color={onInk.muted2}>
              C50
            </Text>
          </Text>
        </View>

        {/* Actions */}
        <View style={styles.actions}>
          <Button label="Rematch" onPress={() => router.push('/setup-board')} />
          <Pressable
            onPress={() => router.push('/analysis')}
            style={({ pressed }) => [styles.outlined, pressed && styles.pressed]}>
            <Text weight="bold" size={15.5} color={colors.greenBright} center>
              Analyze game
            </Text>
          </Pressable>
          <Pressable
            onPress={() => router.replace('/home')}
            style={({ pressed }) => [styles.backHome, pressed && styles.pressed]}>
            <Text weight="medium" size={14} color={onInk.muted2} center>
              Back to home
            </Text>
          </Pressable>
        </View>
      </View>
    </Screen>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1, gap: 18 },

  header: { alignItems: 'center', marginTop: 14 },
  ring: {
    width: 90,
    height: 90,
    borderRadius: 45,
    backgroundColor: 'rgba(94,196,137,0.25)',
    alignItems: 'center',
    justifyContent: 'center',
    ...shadow.dark,
  },
  crownCircle: {
    width: 78,
    height: 78,
    borderRadius: 39,
    backgroundColor: colors.pieceWhite,
    alignItems: 'center',
    justifyContent: 'center',
  },
  checkmate: { marginTop: 16 },
  wonTitle: { marginTop: 6 },
  wonSub: { marginTop: 4 },

  scoreRow: { flexDirection: 'row', alignItems: 'center', justifyContent: 'center', gap: 16 },

  statGrid: { flexDirection: 'row', flexWrap: 'wrap', gap: 10 },
  statCard: {
    flexGrow: 1,
    flexBasis: 0,
    minWidth: '45%',
    backgroundColor: onInk.fill,
    borderWidth: 1,
    borderColor: onInk.hairline,
    borderRadius: 15,
    padding: 15,
  },
  statLabel: { marginTop: 3 },

  openingRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 9,
    backgroundColor: onInk.fill,
    borderWidth: 1,
    borderColor: onInk.hairline,
    borderRadius: 13,
    paddingVertical: 12,
    paddingHorizontal: 15,
  },
  openingValue: { marginLeft: 'auto' },

  actions: { marginTop: 'auto', gap: 11, paddingTop: 8 },
  outlined: {
    backgroundColor: 'transparent',
    borderWidth: 1.5,
    borderColor: 'rgba(94,196,137,0.5)',
    borderRadius: radius.lg,
    paddingVertical: 15,
    paddingHorizontal: 18,
    alignItems: 'center',
    justifyContent: 'center',
  },
  backHome: { paddingTop: 2, paddingVertical: 6, alignItems: 'center' },
  pressed: { opacity: 0.85 },
});
