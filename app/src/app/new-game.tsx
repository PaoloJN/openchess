import { useRouter } from 'expo-router';
import { useState } from 'react';
import { Pressable, StyleSheet, View } from 'react-native';

import { Button, Screen, SectionLabel, StatusDot, Text } from '@/ui';
import { colors, radius } from '@/theme/tokens';

type Opponent = 'lichess' | 'stockfish';
type PlayColor = 'white' | 'black' | 'random';

const COLOR_OPTIONS: { key: PlayColor; label: string; glyph: string }[] = [
  { key: 'white', label: 'White', glyph: '♔' },
  { key: 'black', label: 'Black', glyph: '♚' },
  { key: 'random', label: 'Random', glyph: '◐' },
];

const TIME_OPTIONS: { key: string; chip: string; summary: string }[] = [
  { key: '5+0', chip: '5+0', summary: '5+0' },
  { key: '10+0', chip: '10+0', summary: '10+0' },
  { key: '15+10', chip: '15+10', summary: '15+10' },
  { key: 'unlimited', chip: '∞', summary: 'Unlimited' },
];

const LEVELS = [1, 2, 3, 4, 5, 6, 7, 8];

/** Stockfish level → approximate ELO (level 5 ≈ 2050 per the design). */
function eloFor(level: number): string {
  return `≈${1350 + (level - 1) * 175}`;
}

/** Selection styling: green tint + green border + green text, else white card. */
function selStyle(selected: boolean) {
  return {
    bg: selected ? colors.greenTint : colors.card,
    fg: selected ? colors.green : colors.text,
    bd: selected ? colors.green : colors.cardBorder,
  };
}

/** 04 · NEW GAME */
export default function NewGameScreen() {
  const router = useRouter();
  const [opponent, setOpponent] = useState<Opponent>('stockfish');
  const [level, setLevel] = useState(5);
  const [playColor, setPlayColor] = useState<PlayColor>('white');
  const [time, setTime] = useState('10+0');

  const isStockfish = opponent === 'stockfish';

  const colorLabel = COLOR_OPTIONS.find((c) => c.key === playColor)!.label;
  const timeSummary = TIME_OPTIONS.find((t) => t.key === time)!.summary;
  const oppSummary = isStockfish ? `Stockfish · Level ${level}` : 'Lichess';
  const startSummary = `${oppSummary} · ${colorLabel} · ${timeSummary}`;

  return (
    <Screen scroll>
      <Text weight="extrabold" size={28} spacing={-0.6}>
        New game
      </Text>

      {/* OPPONENT */}
      <View style={styles.section}>
        <SectionLabel>OPPONENT</SectionLabel>
        <View style={styles.oppRow}>
          <OpponentCard
            glyph="♛"
            label="Lichess"
            sub="Online"
            selected={opponent === 'lichess'}
            onPress={() => setOpponent('lichess')}
          />
          <OpponentCard
            glyph="♞"
            label="Stockfish"
            sub="Offline bot"
            selected={opponent === 'stockfish'}
            onPress={() => setOpponent('stockfish')}
          />
        </View>
      </View>

      {/* DIFFICULTY (Stockfish) or account card (Lichess) */}
      {isStockfish ? (
        <View style={styles.section}>
          <View style={styles.diffHead}>
            <Text mono size={11} color={colors.muted3} spacing={1.5}>
              DIFFICULTY
            </Text>
            <Text mono weight="semibold" size={12} color={colors.green}>
              {eloFor(level)}
            </Text>
          </View>
          <View style={styles.levelGrid}>
            {LEVELS.map((lv) => {
              const s = selStyle(lv === level);
              return (
                <Pressable
                  key={lv}
                  onPress={() => setLevel(lv)}
                  style={[styles.levelCell, { backgroundColor: s.bg, borderColor: s.bd }]}>
                  <Text mono weight="semibold" size={14} color={s.fg}>
                    {lv}
                  </Text>
                </Pressable>
              );
            })}
          </View>
        </View>
      ) : (
        <View style={[styles.section, styles.account]}>
          <View style={styles.avatar}>
            <Text weight="bold" size={15} color={colors.green}>
              P
            </Text>
          </View>
          <View style={styles.accountText}>
            <Text weight="semibold" size={14.5}>
              @paolo
            </Text>
            <Text size={12} color={colors.muted2}>
              Signed in · Rapid 1624
            </Text>
          </View>
          <StatusDot color={colors.greenBright} size={9} />
        </View>
      )}

      {/* YOU PLAY */}
      <View style={styles.section}>
        <SectionLabel>YOU PLAY</SectionLabel>
        <View style={styles.oppRow}>
          {COLOR_OPTIONS.map((c) => {
            const s = selStyle(c.key === playColor);
            return (
              <Pressable
                key={c.key}
                onPress={() => setPlayColor(c.key)}
                style={[styles.colorCard, { backgroundColor: s.bg, borderColor: s.bd }]}>
                <Text size={22} color={s.fg} style={styles.glyph}>
                  {c.glyph}
                </Text>
                <Text weight="semibold" size={12.5} color={s.fg} style={styles.colorLabel}>
                  {c.label}
                </Text>
              </Pressable>
            );
          })}
        </View>
      </View>

      {/* TIME CONTROL */}
      <View style={styles.section}>
        <SectionLabel>TIME CONTROL</SectionLabel>
        <View style={styles.timeWrap}>
          {TIME_OPTIONS.map((t) => {
            const s = selStyle(t.key === time);
            return (
              <Pressable
                key={t.key}
                onPress={() => setTime(t.key)}
                style={[styles.timeChip, { backgroundColor: s.bg, borderColor: s.bd }]}>
                <Text weight="semibold" size={14} color={s.fg}>
                  {t.chip}
                </Text>
              </Pressable>
            );
          })}
        </View>
      </View>

      {/* START */}
      <View style={styles.footer}>
        <Button label="Start game" onPress={() => router.push('/setup-board')} />
        <Text mono size={12.5} color={colors.muted2} center style={styles.summary}>
          {startSummary}
        </Text>
      </View>
    </Screen>
  );
}

function OpponentCard({
  glyph,
  label,
  sub,
  selected,
  onPress,
}: {
  glyph: string;
  label: string;
  sub: string;
  selected: boolean;
  onPress: () => void;
}) {
  const s = selStyle(selected);
  return (
    <Pressable onPress={onPress} style={[styles.oppCard, { backgroundColor: s.bg, borderColor: s.bd }]}>
      <Text size={22} color={s.fg} style={styles.glyph}>
        {glyph}
      </Text>
      <Text weight="semibold" size={14.5} color={s.fg} style={styles.oppLabel}>
        {label}
      </Text>
      <Text size={11} color={s.fg} style={styles.oppSub}>
        {sub}
      </Text>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  section: { marginTop: 20 },

  oppRow: { flexDirection: 'row', gap: 9 },
  oppCard: {
    flex: 1,
    borderRadius: 15,
    borderWidth: 1.5,
    paddingVertical: 14,
    paddingHorizontal: 10,
    alignItems: 'center',
  },
  oppLabel: { marginTop: 6 },
  oppSub: { marginTop: 1, opacity: 0.7 },
  glyph: { lineHeight: 24 },

  diffHead: {
    flexDirection: 'row',
    alignItems: 'baseline',
    justifyContent: 'space-between',
    marginBottom: 9,
    paddingHorizontal: 2,
  },
  levelGrid: { flexDirection: 'row', gap: 6 },
  levelCell: {
    flex: 1,
    aspectRatio: 1,
    borderRadius: 10,
    borderWidth: 1.5,
    alignItems: 'center',
    justifyContent: 'center',
  },

  account: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
    backgroundColor: colors.card,
    borderWidth: 1,
    borderColor: colors.cardBorder,
    borderRadius: radius.md,
    paddingVertical: 14,
    paddingHorizontal: 16,
  },
  avatar: {
    width: 34,
    height: 34,
    borderRadius: 999,
    backgroundColor: colors.greenTint,
    alignItems: 'center',
    justifyContent: 'center',
  },
  accountText: { flex: 1 },

  colorCard: {
    flex: 1,
    borderRadius: 13,
    borderWidth: 1.5,
    paddingVertical: 13,
    paddingHorizontal: 6,
    alignItems: 'center',
  },
  colorLabel: { marginTop: 5 },

  timeWrap: { flexDirection: 'row', flexWrap: 'wrap', gap: 8 },
  timeChip: {
    borderRadius: 11,
    borderWidth: 1.5,
    paddingVertical: 10,
    paddingHorizontal: 15,
  },

  footer: { marginTop: 28 },
  summary: { marginTop: 9 },
});
