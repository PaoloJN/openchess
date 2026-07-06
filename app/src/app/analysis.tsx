import { useRouter } from 'expo-router';
import { Pressable, StyleSheet, View } from 'react-native';
import Svg, { Path, Rect } from 'react-native-svg';

import { BoardGrid, Pill, Screen, StatusDot, Text } from '@/ui';
import { boardCells } from '@/chess/board';
import { colors, onInk, radius, shadow } from '@/theme/tokens';

// Plausible mid-game position (Italian Game), with the last move g8-f6 highlighted.
const FEN = 'r1bqk2r/pppp1ppp/2n2n2/2b1p3/2B1P3/2P2N2/PP1P1PPP/RNBQK2R w KQkq - 0 1';

type Move = { n: string; w: string; wnag?: string; b: string; bnag?: string; hi?: boolean };

const MOVES: Move[] = [
  { n: '11', w: 'Re1', b: 'd6' },
  { n: '12', w: 'd4', b: 'exd4' },
  { n: '13', w: 'cxd4', b: 'Bb6', hi: true },
  { n: '14', w: 'd5', wnag: '?!', b: 'Ne7' },
  { n: '15', w: 'Bg5', b: 'h6', bnag: '??' },
];

/** 09 · ANALYSIS */
export default function AnalysisScreen() {
  const router = useRouter();
  const cells = boardCells(FEN, 'w', { last: ['g8', 'f6'] });

  return (
    <Screen>
      <View style={styles.root}>
        {/* Header */}
        <View style={styles.header}>
          <Text weight="extrabold" size={26} spacing={-0.6} style={styles.headerTitle}>
            Analysis
          </Text>
          <Pill mono>+1.2</Pill>
        </View>

        {/* Eval bar + board */}
        <View style={styles.boardRow}>
          <View style={styles.evalBar}>
            <View style={styles.evalFill} />
            <View style={styles.evalMarker} />
          </View>
          <View style={styles.boardWrap}>
            <BoardGrid cells={cells} />
          </View>
        </View>

        {/* Best move */}
        <View style={styles.bestBar}>
          <Text mono size={11} spacing={1} color={colors.greenBright}>
            BEST
          </Text>
          <Text mono weight="semibold" size={14} color={onInk.text}>
            14. dxe5
          </Text>
          <Text size={13} color={onInk.muted2} style={styles.bestNote}>
            wins a pawn
          </Text>
        </View>

        {/* Move list */}
        <View style={styles.movesCard}>
          {MOVES.map((m) => (
            <View key={m.n} style={[styles.moveRow, m.hi && styles.moveRowHi]}>
              <Text mono size={13.5} color={colors.muted5} style={styles.moveNum}>
                {m.n}
              </Text>
              <Text mono weight="medium" size={13.5} color={colors.text}>
                {m.w}
              </Text>
              {m.wnag ? (
                <Text mono weight="bold" size={13.5} color={colors.red}>
                  {m.wnag}
                </Text>
              ) : null}
              <Text mono size={13.5} color={colors.muted} style={styles.moveBlack}>
                {m.b}
              </Text>
              {m.bnag ? (
                <Text mono weight="bold" size={13.5} color={colors.red}>
                  {m.bnag}
                </Text>
              ) : null}
            </View>
          ))}
        </View>

        {/* Bottom: nav controls + replay CTA */}
        <View style={styles.bottom}>
          <View style={styles.navCard}>
            <Pressable hitSlop={8}>
              <Svg width={16} height={14} viewBox="0 0 16 14">
                <Path
                  d="M15 1L6 7l9 6V1zM2 1v12"
                  stroke={colors.muted}
                  strokeWidth={1.8}
                  fill="none"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                />
              </Svg>
            </Pressable>
            <Pressable style={styles.playButton} hitSlop={8}>
              <Svg width={14} height={16} viewBox="0 0 14 16">
                <Rect x={1} y={1} width={4} height={14} rx={1} fill={colors.white} />
                <Rect x={9} y={1} width={4} height={14} rx={1} fill={colors.white} />
              </Svg>
            </Pressable>
            <Pressable hitSlop={8}>
              <Svg width={16} height={14} viewBox="0 0 16 14">
                <Path
                  d="M1 1l9 6-9 6V1zM14 1v12"
                  stroke={colors.muted}
                  strokeWidth={1.8}
                  fill="none"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                />
              </Svg>
            </Pressable>
            <Text mono size={13} color={colors.muted2} style={styles.navCount}>
              24 / 41
            </Text>
          </View>

          <Pressable style={styles.replay} onPress={() => router.push('/live-game')}>
            <StatusDot color={colors.green} size={8} />
            <Text weight="bold" size={15} color={colors.greenDeep}>
              Replay this game on the board
            </Text>
          </Pressable>
        </View>
      </View>
    </Screen>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1, gap: 14 },

  header: { flexDirection: 'row', alignItems: 'center' },
  headerTitle: { flex: 1 },

  boardRow: { flexDirection: 'row', alignItems: 'stretch', gap: 9 },
  evalBar: {
    width: 12,
    borderRadius: 6,
    overflow: 'hidden',
    backgroundColor: colors.inkSoft,
    flexShrink: 0,
    shadowColor: '#000',
    shadowOpacity: 0.12,
    shadowRadius: 12,
    shadowOffset: { width: 0, height: 4 },
    elevation: 3,
  },
  evalFill: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    height: '60%',
    backgroundColor: colors.screen,
  },
  evalMarker: {
    position: 'absolute',
    top: '40%',
    left: 0,
    right: 0,
    height: 2,
    backgroundColor: colors.green,
  },
  boardWrap: { flex: 1 },

  bestBar: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
    backgroundColor: colors.ink,
    borderRadius: radius.md,
    paddingVertical: 10,
    paddingHorizontal: 14,
  },
  bestNote: { marginLeft: 'auto' },

  movesCard: {
    backgroundColor: colors.card,
    borderWidth: 1,
    borderColor: colors.cardBorder,
    borderRadius: radius.md,
    padding: 8,
    ...shadow.card,
  },
  moveRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 10,
    paddingVertical: 7,
    paddingHorizontal: 10,
    borderRadius: 8,
  },
  moveRowHi: { backgroundColor: colors.greenTint },
  moveNum: { width: 22 },
  moveBlack: { marginLeft: 6 },

  bottom: { marginTop: 'auto', gap: 11 },
  navCard: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 14,
    backgroundColor: colors.card,
    borderWidth: 1,
    borderColor: 'rgba(0,0,0,0.07)',
    borderRadius: radius.md,
    padding: 12,
  },
  playButton: {
    width: 44,
    height: 44,
    borderRadius: 999,
    backgroundColor: colors.ink,
    alignItems: 'center',
    justifyContent: 'center',
  },
  navCount: { marginLeft: 6 },

  replay: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 9,
    backgroundColor: colors.greenTint,
    borderRadius: radius.md,
    padding: 13,
  },
});
