import { Text as RNText, TextProps as RNTextProps, StyleSheet } from 'react-native';

import { colors, fonts } from '@/theme/tokens';

type Weight = 'regular' | 'medium' | 'semibold' | 'bold' | 'extrabold';

const FAMILY: Record<Weight, string> = {
  regular: fonts.display,
  medium: fonts.medium,
  semibold: fonts.semibold,
  bold: fonts.bold,
  extrabold: fonts.extrabold,
};

const MONO_FAMILY: Record<'regular' | 'medium' | 'semibold', string> = {
  regular: fonts.mono,
  medium: fonts.monoMedium,
  semibold: fonts.monoSemibold,
};

export type TextProps = RNTextProps & {
  size?: number;
  weight?: Weight;
  color?: string;
  mono?: boolean;
  spacing?: number; // letterSpacing
  center?: boolean;
};

/** Typed text primitive wired to the Hanken Grotesk / IBM Plex Mono families. */
export function Text({
  size = 15,
  weight = 'regular',
  color = colors.text,
  mono = false,
  spacing,
  center,
  style,
  ...rest
}: TextProps) {
  const family = mono
    ? MONO_FAMILY[(weight === 'bold' || weight === 'extrabold' ? 'semibold' : weight) as 'regular']
    : FAMILY[weight];
  return (
    <RNText
      style={[
        { fontFamily: family, fontSize: size, color },
        spacing != null && { letterSpacing: spacing },
        center && styles.center,
        style,
      ]}
      {...rest}
    />
  );
}

const styles = StyleSheet.create({
  center: { textAlign: 'center' },
});
