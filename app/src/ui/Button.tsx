import { ActivityIndicator, Pressable, StyleSheet, View, ViewStyle } from 'react-native';

import { colors, radius, shadow } from '@/theme/tokens';
import { Text } from './Text';

type Variant = 'primary' | 'secondary' | 'ghost' | 'destructive' | 'disabled';

type ButtonProps = {
  label: string;
  onPress?: () => void;
  variant?: Variant;
  sublabel?: string;
  loading?: boolean;
  style?: ViewStyle;
};

/** Primary CTA and its variants, matching the design's pill buttons. */
export function Button({ label, onPress, variant = 'primary', sublabel, loading, style }: ButtonProps) {
  const v = VARIANTS[variant];
  const disabled = variant === 'disabled' || loading;
  return (
    <Pressable
      onPress={disabled ? undefined : onPress}
      style={({ pressed }) => [
        styles.base,
        { backgroundColor: v.bg, borderColor: v.border, borderWidth: v.border ? 1.5 : 0 },
        variant === 'primary' && shadow.green,
        pressed && !disabled && styles.pressed,
        style,
      ]}>
      {loading ? (
        <ActivityIndicator color={v.fg} />
      ) : (
        <View style={styles.inner}>
          <Text weight="bold" size={16.5} color={v.fg} center>
            {label}
          </Text>
          {sublabel ? (
            <Text mono size={12.5} color={colors.muted2} center style={styles.sub}>
              {sublabel}
            </Text>
          ) : null}
        </View>
      )}
    </Pressable>
  );
}

const VARIANTS: Record<Variant, { bg: string; fg: string; border?: string }> = {
  primary: { bg: colors.green, fg: colors.white },
  secondary: { bg: colors.greenTint, fg: colors.green },
  ghost: { bg: 'transparent', fg: colors.muted },
  destructive: { bg: colors.redTint, fg: colors.red },
  disabled: { bg: '#EFEBE3', fg: colors.muted4, border: colors.divider },
};

const styles = StyleSheet.create({
  base: {
    borderRadius: radius.lg,
    paddingVertical: 17,
    paddingHorizontal: 18,
    alignItems: 'center',
    justifyContent: 'center',
  },
  inner: { alignItems: 'center' },
  sub: { marginTop: 4 },
  pressed: { opacity: 0.85 },
});
