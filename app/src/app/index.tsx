import { useRouter } from 'expo-router';
import { View, StyleSheet } from 'react-native';

import { BarsGlyph, Button, Screen, StatusDot, Text } from '@/ui';
import { colors, radius } from '@/theme/tokens';

/** 00 · WELCOME */
export default function WelcomeScreen() {
  const router = useRouter();
  return (
    <Screen>
      <View style={styles.brand}>
        <View style={styles.logo}>
          <Text size={23} color={colors.greenBright}>
            ♞
          </Text>
        </View>
        <Text mono weight="semibold" size={14} spacing={2.5}>
          OPENCHESS
        </Text>
      </View>

      <Text weight="extrabold" size={34} spacing={-1} style={styles.title}>
        Welcome to{'\n'}OpenChess.
      </Text>
      <Text size={15.5} color={colors.muted} style={styles.sub}>
        The companion app for your smart board. Let&apos;s get you set up — it takes about two minutes.
      </Text>

      <View style={styles.features}>
        <Feature title="Play anyone." body="Lichess online or Stockfish offline." glyph="♞" />
        <Feature title="Move hints on the board." body="The LEDs light your options." dot />
        <Feature title="Review every game." body="Engine analysis, replayed on the board." bars />
      </View>

      <View style={styles.actions}>
        <Button label="Get started" onPress={() => router.push('/pair')} />
        <Button label="My board is already set up" variant="ghost" onPress={() => router.push('/home')} />
      </View>
    </Screen>
  );
}

function Feature({
  title,
  body,
  glyph,
  dot,
  bars,
}: {
  title: string;
  body: string;
  glyph?: string;
  dot?: boolean;
  bars?: boolean;
}) {
  return (
    <View style={styles.feature}>
      <View style={styles.featureIcon}>
        {glyph ? (
          <Text size={19} color={colors.greenDeep}>
            {glyph}
          </Text>
        ) : null}
        {dot ? <StatusDot color={colors.green} size={11} /> : null}
        {bars ? <BarsGlyph /> : null}
      </View>
      <Text size={14.5} color={colors.text2} style={styles.featureText}>
        <Text weight="semibold" size={14.5} color={colors.text}>
          {title}
        </Text>{' '}
        {body}
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  brand: { flexDirection: 'row', alignItems: 'center', gap: 11 },
  logo: {
    width: 42,
    height: 42,
    borderRadius: 12,
    backgroundColor: colors.ink,
    alignItems: 'center',
    justifyContent: 'center',
  },
  title: { marginTop: 44, lineHeight: 36 },
  sub: { marginTop: 13, lineHeight: 23 },
  features: { marginTop: 38, gap: 15 },
  feature: { flexDirection: 'row', alignItems: 'center', gap: 13 },
  featureIcon: {
    width: 36,
    height: 36,
    borderRadius: radius.sm,
    backgroundColor: colors.greenTint,
    alignItems: 'center',
    justifyContent: 'center',
  },
  featureText: { flex: 1, lineHeight: 20 },
  actions: { marginTop: 'auto', gap: 13, paddingTop: 32 },
});
