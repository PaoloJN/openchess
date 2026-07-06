import { useRouter } from 'expo-router';
import { useState } from 'react';
import { StyleSheet, View } from 'react-native';

import { useBoard } from '@/board/BoardProvider';
import { colors, radius } from '@/theme/tokens';
import { Card, ListRow, Screen, SectionLabel, Text, Toggle } from '@/ui';

const HINT_COLORS = [colors.green, colors.blue, colors.amber];

/** 06 · SETTINGS */
export default function SettingsScreen() {
  const router = useRouter();
  const { board } = useBoard();

  const [brightness] = useState(70);
  const [showHints, setShowHints] = useState(true);
  const [hintColor, setHintColor] = useState<string>(colors.green);
  const [moveSounds, setMoveSounds] = useState(true);

  const disconnect = async () => {
    await board.disconnect();
    router.replace('/');
  };

  return (
    <Screen scroll>
      <Text weight="extrabold" size={28} spacing={-0.6} style={styles.title}>
        Settings
      </Text>

      <View style={styles.group}>
        <SectionLabel style={styles.label}>BOARD</SectionLabel>
        <Card padded={false} style={styles.card}>
          <ListRow label="Board name" divider right={<MonoValue>4A2F</MonoValue>} />
          <ListRow label="Firmware" divider right={<MonoValue>v1.4.2</MonoValue>} />
          <ListRow label="Disconnect board" labelColor={colors.red} onPress={disconnect} />
        </Card>
      </View>

      <View style={styles.group}>
        <SectionLabel style={styles.label}>LED FEEDBACK</SectionLabel>
        <Card padded={false} style={styles.card}>
          <View style={[styles.customRow, styles.rowDivider]}>
            <View style={styles.brightnessHead}>
              <Text weight="medium" size={15} style={styles.flex}>
                Brightness
              </Text>
              <Text mono size={13} color={colors.muted2}>
                {brightness}%
              </Text>
            </View>
            <View style={styles.sliderTrack}>
              <View style={[styles.sliderFill, { width: `${brightness}%` }]} />
              <View style={[styles.sliderKnob, { left: `${brightness}%` }]} />
            </View>
          </View>

          <ListRow
            label="Show move hints"
            divider
            right={<Toggle value={showHints} onToggle={setShowHints} />}
          />

          <ListRow
            label="Hint color"
            right={
              <View style={styles.swatches}>
                {HINT_COLORS.map((c) => (
                  <Swatch
                    key={c}
                    color={c}
                    selected={hintColor === c}
                    onPress={() => setHintColor(c)}
                  />
                ))}
              </View>
            }
          />
        </Card>
      </View>

      <View style={styles.group}>
        <SectionLabel style={styles.label}>SOUND</SectionLabel>
        <Card padded={false} style={styles.card}>
          <ListRow
            label="Move sounds"
            right={<Toggle value={moveSounds} onToggle={setMoveSounds} />}
          />
        </Card>
      </View>

      <View style={styles.group}>
        <SectionLabel style={styles.label}>MAINTENANCE</SectionLabel>
        <Card padded={false} style={styles.card}>
          <ListRow label="Calibrate sensors" chevron divider />
          <ListRow label="Test all LEDs" chevron />
        </Card>
      </View>
    </Screen>
  );
}

function MonoValue({ children }: { children: React.ReactNode }) {
  return (
    <Text mono size={14} color={colors.muted2}>
      {children}
    </Text>
  );
}

function Swatch({
  color,
  selected,
  onPress,
}: {
  color: string;
  selected: boolean;
  onPress: () => void;
}) {
  if (selected) {
    return (
      <View style={[styles.swatchRing, { backgroundColor: color }]} onTouchEnd={onPress}>
        <View style={styles.swatchGap}>
          <View style={[styles.swatchDot, { backgroundColor: color }]} />
        </View>
      </View>
    );
  }
  return <View style={[styles.swatchDot, { backgroundColor: color }]} onTouchEnd={onPress} />;
}

const styles = StyleSheet.create({
  title: { marginBottom: 4 },
  group: { marginTop: 22 },
  label: { marginLeft: 4 },
  card: { borderRadius: 18, overflow: 'hidden' },

  flex: { flex: 1 },
  customRow: { paddingHorizontal: 16, paddingVertical: 14 },
  rowDivider: { borderBottomWidth: 1, borderBottomColor: colors.divider },
  brightnessHead: { flexDirection: 'row', alignItems: 'center', marginBottom: 11 },

  sliderTrack: {
    height: 6,
    borderRadius: 4,
    backgroundColor: colors.track,
    justifyContent: 'center',
  },
  sliderFill: { height: 6, borderRadius: 4, backgroundColor: colors.green },
  sliderKnob: {
    position: 'absolute',
    marginLeft: -10,
    width: 20,
    height: 20,
    borderRadius: 10,
    backgroundColor: '#fff',
    shadowColor: '#000',
    shadowOpacity: 0.25,
    shadowRadius: 4,
    shadowOffset: { width: 0, height: 1 },
    elevation: 3,
  },

  swatches: { flexDirection: 'row', gap: 8, alignItems: 'center' },
  swatchDot: { width: 22, height: 22, borderRadius: 11 },
  swatchRing: {
    width: 29,
    height: 29,
    borderRadius: radius.pill,
    alignItems: 'center',
    justifyContent: 'center',
  },
  swatchGap: {
    width: 26,
    height: 26,
    borderRadius: 13,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
