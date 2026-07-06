import { useRouter } from 'expo-router';
import { Pressable, StyleSheet, View } from 'react-native';

import { BoardGrid, Button, Card, Screen, Text } from '@/ui';
import { boardCells, START_FEN } from '@/chess/board';
import { colors, radius } from '@/theme/tokens';

const FIX_ITEMS: { text: string; sq: string }[] = [
  { text: 'Place a piece on', sq: 'e2' },
  { text: 'Remove the piece on', sq: 'b8' },
];

const READY_COUNT = '30 / 32';
const PROGRESS_PCT = '94%';

/** 07 · SET UP BOARD */
export default function SetupBoardScreen() {
  const router = useRouter();
  const cells = boardCells(START_FEN, 'w', { error: ['e2', 'b8'] });

  return (
    <Screen contentStyle={styles.screen}>
      <View>
        <Text mono size={11} color={colors.muted3} spacing={2}>
          BEFORE WE START
        </Text>
        <Text weight="extrabold" size={27} spacing={-0.5} style={styles.title}>
          Set up the board
        </Text>
        <Text size={14.5} color={colors.muted} style={styles.sub}>
          Two squares are lit{' '}
          <Text weight="semibold" size={14.5} color={colors.red}>
            red
          </Text>{' '}
          on the board. Match the diagram, then play.
        </Text>
      </View>

      <BoardGrid cells={cells} />

      <Card padded={false} style={styles.card}>
        <View style={styles.cardHead}>
          <Text weight="semibold" size={14} style={styles.cardHeadLabel}>
            Pieces detected
          </Text>
          <Text mono size={13} color={colors.muted2}>
            {READY_COUNT}
          </Text>
        </View>
        <View style={styles.track}>
          <View style={[styles.fill, { width: PROGRESS_PCT }]} />
        </View>
      </Card>

      <View style={styles.fixList}>
        {FIX_ITEMS.map((fx) => (
          <View key={fx.sq} style={styles.fixRow}>
            <View style={styles.fixIcon}>
              <View style={styles.fixDot} />
            </View>
            <Text size={14} color={colors.text2} style={styles.fixText}>
              {fx.text}{' '}
              <Text mono weight="semibold" size={14} color={colors.text}>
                {fx.sq}
              </Text>
            </Text>
          </View>
        ))}
      </View>

      <View style={styles.footer}>
        <Button variant="disabled" label="Waiting for the board…" />
        <Pressable
          onPress={() => router.push('/live-game')}
          style={({ pressed }) => [styles.skip, pressed && styles.skipPressed]}>
          <Text mono size={12.5} color={colors.muted2} center>
            Skip — board is ready
          </Text>
        </Pressable>
      </View>
    </Screen>
  );
}

const styles = StyleSheet.create({
  screen: { gap: 16 },
  title: { marginTop: 6, lineHeight: 30 },
  sub: { marginTop: 8, lineHeight: 21 },
  card: { borderRadius: 16, paddingHorizontal: 16, paddingVertical: 14 },
  cardHead: { flexDirection: 'row', alignItems: 'center', marginBottom: 10 },
  cardHeadLabel: { flex: 1 },
  track: {
    height: 6,
    borderRadius: 4,
    backgroundColor: colors.track,
    overflow: 'hidden',
  },
  fill: { height: '100%', backgroundColor: colors.green },
  fixList: { gap: 9 },
  fixRow: { flexDirection: 'row', alignItems: 'center', gap: 11 },
  fixIcon: {
    width: 22,
    height: 22,
    borderRadius: 7,
    backgroundColor: colors.redTint,
    alignItems: 'center',
    justifyContent: 'center',
  },
  fixDot: { width: 8, height: 8, borderRadius: radius.pill, backgroundColor: colors.red },
  fixText: { flex: 1 },
  footer: { marginTop: 'auto', gap: 10, paddingTop: 8 },
  skip: { paddingVertical: 6, alignItems: 'center' },
  skipPressed: { opacity: 0.6 },
});
