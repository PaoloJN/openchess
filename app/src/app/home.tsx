import { useRouter } from 'expo-router';
import { Pressable, StyleSheet, View } from 'react-native';

import { useBoard } from '@/board/BoardProvider';
import { Button, Card, ChevronRight, DarkCard, Divider, Gear, Screen, StatusDot, Text } from '@/ui';
import { colors, onInk, radius, shadow } from '@/theme/tokens';

type Recent = { tag: string; tagBg: string; tagFg: string; opp: string; by: string; when: string };

const RECENTS: Recent[] = [
  { tag: 'W', tagBg: colors.greenTint, tagFg: colors.green, opp: 'Stockfish L5', by: 'by you', when: '2h' },
  { tag: 'D', tagBg: 'rgba(214,158,63,0.14)', tagFg: colors.amber, opp: '@maria', by: 'by Lichess', when: 'yesterday' },
  { tag: 'L', tagBg: colors.redTint, tagFg: colors.red, opp: 'Stockfish L7', by: 'by you', when: '2d' },
];

/** 03 · HOME */
export default function HomeScreen() {
  const router = useRouter();
  const { status } = useBoard();

  const connected = status.connection === 'connected';
  const connecting = status.connection === 'pairing';

  const boardName = (status.name ?? 'OpenChess').toUpperCase();
  const conn = connected
    ? { label: 'Connected', color: colors.greenBright }
    : connecting
      ? { label: 'Connecting…', color: colors.amber }
      : { label: 'Disconnected', color: colors.red };

  // Live values only when actually connected — no invented fallbacks.
  const battery = connected ? status.battery : null;
  const firmware = connected && status.firmware ? status.firmware : null;
  const wifi = connected ? status.wifi : undefined;

  return (
    <Screen scroll>
      {/* Header */}
      <View style={styles.header}>
        <View>
          <Text mono size={11} spacing={2} color={colors.muted3}>
            {boardName}
          </Text>
          <Text weight="extrabold" size={28} spacing={-0.6} style={styles.title}>
            Your board
          </Text>
        </View>
        <Pressable
          onPress={() => router.push('/settings')}
          style={({ pressed }) => [styles.gearBtn, pressed && styles.pressed]}>
          <Gear size={20} />
        </Pressable>
      </View>

      {/* Status card */}
      <DarkCard padded={false} style={styles.statusCard}>
        <View style={styles.statusRow}>
          <StatusDot color={conn.color} size={9} />
          <Text weight="semibold" size={14} color={conn.color}>
            {conn.label}
          </Text>
          {firmware ? (
            <Text mono size={13} color={onInk.muted2} style={styles.idle}>
              {firmware}
            </Text>
          ) : null}
        </View>

        <View style={styles.stats}>
          <View style={styles.stat}>
            <Text mono weight="semibold" size={26} color={onInk.text}>
              {battery ?? '—'}
              {battery != null ? (
                <Text mono weight="semibold" size={15} color="rgba(243,241,236,0.6)">
                  %
                </Text>
              ) : null}
            </Text>
            <Text size={12} color={onInk.muted2} style={styles.statLabel}>
              Battery
            </Text>
            <View style={styles.track}>
              <View style={[styles.fill, { width: `${battery ?? 0}%` }]} />
            </View>
          </View>

          <View style={styles.statDivider} />

          <View style={styles.stat}>
            <Text mono weight="semibold" size={wifi ? 26 : 17} color={wifi ? onInk.text : onInk.muted}>
              {wifi ? wifi.ssid : connected ? 'Not on Wi-Fi' : '—'}
            </Text>
            <Text size={12} color={onInk.muted2} style={styles.statLabel}>
              {wifi ? (wifi.lichessReady ? 'Wi-Fi · Lichess ready' : 'Wi-Fi') : 'Online play unavailable'}
            </Text>
            <View style={styles.bars}>
              {[0, 1, 2, 3].map((i) => (
                <View
                  key={i}
                  style={[styles.bar, { backgroundColor: wifi && i < wifi.strength ? colors.greenBright : 'rgba(255,255,255,0.2)' }]}
                />
              ))}
            </View>
          </View>
        </View>
      </DarkCard>

      {/* Connect / reconnect when the board isn't linked */}
      {!connected ? (
        <View style={styles.connectRow}>
          <Button
            label={connecting ? 'Connecting…' : 'Connect board'}
            variant={connecting ? 'disabled' : 'primary'}
            onPress={() => router.push('/pair')}
          />
        </View>
      ) : null}

      {/* New game action */}
      <Pressable
        onPress={() => router.push('/new-game')}
        style={({ pressed }) => [styles.newGame, pressed && styles.pressed]}>
        <Text size={26} color={colors.white}>
          ♞
        </Text>
        <View style={styles.newGameText}>
          <Text weight="bold" size={17} color={colors.white}>
            New game
          </Text>
          <Text size={13} color="rgba(255,255,255,0.8)">
            Lichess or Stockfish
          </Text>
        </View>
        <ChevronRight size={16} color={colors.white} />
      </Pressable>

      {/* Recent games */}
      <Card padded={false} style={styles.recentCard}>
        <View style={styles.recentHeader}>
          <Text weight="bold" size={15}>
            Recent games
          </Text>
          <Text weight="semibold" size={13} color={colors.green}>
            All
          </Text>
        </View>
        {RECENTS.map((g) => (
          <Pressable
            key={g.tag + g.opp}
            onPress={() => router.push('/analysis')}
            style={({ pressed }) => [styles.recentRow, pressed && styles.pressedRow]}>
            <View style={[styles.tag, { backgroundColor: g.tagBg }]}>
              <Text weight="bold" size={14} color={g.tagFg}>
                {g.tag}
              </Text>
            </View>
            <View style={styles.recentInfo}>
              <Text weight="semibold" size={14.5} numberOfLines={1}>
                {g.opp}
              </Text>
              <Text size={12} color={colors.muted2}>
                {g.by}
              </Text>
            </View>
            <Text mono size={12} color={colors.muted4}>
              {g.when}
            </Text>
          </Pressable>
        ))}
      </Card>
    </Screen>
  );
}

const styles = StyleSheet.create({
  header: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' },
  title: { marginTop: 3 },
  gearBtn: {
    width: 42,
    height: 42,
    borderRadius: 999,
    backgroundColor: colors.white,
    borderWidth: 1,
    borderColor: colors.cardBorder,
    alignItems: 'center',
    justifyContent: 'center',
    shadowColor: '#000',
    shadowOpacity: 0.04,
    shadowRadius: 12,
    shadowOffset: { width: 0, height: 4 },
    elevation: 2,
  },

  statusCard: { padding: 20, marginTop: 18 },
  connectRow: { marginTop: 14 },
  statusRow: { flexDirection: 'row', alignItems: 'center', gap: 9 },
  idle: { marginLeft: 'auto' },
  stats: { flexDirection: 'row', gap: 14, marginTop: 20 },
  stat: { flex: 1 },
  statLabel: { marginTop: 2 },
  statDivider: { width: 1, backgroundColor: 'rgba(255,255,255,0.1)' },
  track: {
    height: 5,
    borderRadius: 3,
    backgroundColor: 'rgba(255,255,255,0.14)',
    marginTop: 8,
    overflow: 'hidden',
  },
  fill: { height: '100%', backgroundColor: colors.greenBright },
  bars: { flexDirection: 'row', gap: 4, marginTop: 9, alignItems: 'flex-end', height: 5 },
  bar: { flex: 1, height: '100%', borderRadius: 2 },

  newGame: {
    backgroundColor: colors.green,
    borderRadius: radius.xl,
    paddingVertical: 18,
    paddingHorizontal: 20,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 14,
    marginTop: 18,
    ...shadow.green,
  },
  newGameText: { flex: 1 },

  recentCard: { padding: 16, marginTop: 18 },
  recentHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginBottom: 12,
  },
  recentRow: { flexDirection: 'row', alignItems: 'center', gap: 12, paddingVertical: 9 },
  tag: {
    width: 30,
    height: 30,
    borderRadius: 9,
    alignItems: 'center',
    justifyContent: 'center',
  },
  recentInfo: { flex: 1, minWidth: 0 },
  pressed: { opacity: 0.85 },
  pressedRow: { opacity: 0.6 },
});
