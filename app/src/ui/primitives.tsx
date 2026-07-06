import { Pressable, StyleSheet, TextStyle, View } from 'react-native';

import { colors, radius } from '@/theme/tokens';
import { Chevron } from './Icons';
import { Text } from './Text';

/** Mono uppercase section label, e.g. "OPPONENT". */
export function SectionLabel({ children, style }: { children: React.ReactNode; style?: TextStyle }) {
  return (
    <Text mono size={11} color={colors.muted3} spacing={1.5} style={[styles.section, style]}>
      {typeof children === 'string' ? children.toUpperCase() : children}
    </Text>
  );
}

/** Small rounded status/eval chip. */
export function Pill({
  children,
  bg = colors.greenTint,
  fg = colors.green,
  mono,
}: {
  children: React.ReactNode;
  bg?: string;
  fg?: string;
  mono?: boolean;
}) {
  return (
    <View style={[styles.pill, { backgroundColor: bg }]}>
      <Text mono={mono} weight="semibold" size={14} color={fg}>
        {children}
      </Text>
    </View>
  );
}

/** Glowing round status indicator. */
export function StatusDot({ color = colors.green, size = 9 }: { color?: string; size?: number }) {
  return (
    <View
      style={{
        width: size,
        height: size,
        borderRadius: size,
        backgroundColor: color,
        shadowColor: color,
        shadowOpacity: 0.9,
        shadowRadius: 8,
        shadowOffset: { width: 0, height: 0 },
        elevation: 4,
      }}
    />
  );
}

export function Divider({ dark }: { dark?: boolean }) {
  return <View style={[styles.divider, dark && { backgroundColor: 'rgba(255,255,255,0.1)' }]} />;
}

/** Static iOS-style switch (visual only unless onToggle provided). */
export function Toggle({ value, onToggle }: { value: boolean; onToggle?: (v: boolean) => void }) {
  return (
    <Pressable onPress={onToggle ? () => onToggle(!value) : undefined}>
      <View style={[styles.track, { backgroundColor: value ? colors.green : '#D8D3C8' }]}>
        <View style={[styles.knob, { left: value ? 21 : 3 }]} />
      </View>
    </Pressable>
  );
}

/** Settings/list row: label on the left, arbitrary right content, optional chevron + divider. */
export function ListRow({
  label,
  labelColor = colors.text,
  right,
  chevron,
  divider,
  onPress,
}: {
  label: string;
  labelColor?: string;
  right?: React.ReactNode;
  chevron?: boolean;
  divider?: boolean;
  onPress?: () => void;
}) {
  return (
    <Pressable onPress={onPress} style={({ pressed }) => [styles.row, divider && styles.rowDivider, pressed && onPress ? { opacity: 0.6 } : null]}>
      <Text weight="medium" size={15} color={labelColor} style={styles.rowLabel}>
        {label}
      </Text>
      {right}
      {chevron ? <Chevron /> : null}
    </Pressable>
  );
}

const styles = StyleSheet.create({
  section: { marginBottom: 8 },
  pill: {
    borderRadius: radius.sm,
    paddingHorizontal: 11,
    paddingVertical: 5,
    alignSelf: 'flex-start',
  },
  divider: { height: 1, backgroundColor: colors.divider },
  track: { width: 46, height: 28, borderRadius: 999, justifyContent: 'center' },
  knob: {
    position: 'absolute',
    top: 3,
    width: 22,
    height: 22,
    borderRadius: 999,
    backgroundColor: '#fff',
    shadowColor: '#000',
    shadowOpacity: 0.25,
    shadowRadius: 3,
    shadowOffset: { width: 0, height: 1 },
    elevation: 2,
  },
  row: { flexDirection: 'row', alignItems: 'center', paddingHorizontal: 16, paddingVertical: 14, gap: 8 },
  rowDivider: { borderBottomWidth: 1, borderBottomColor: colors.divider },
  rowLabel: { flex: 1 },
});
