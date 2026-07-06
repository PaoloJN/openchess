import { StyleSheet, View, ViewProps } from 'react-native';

import { colors, radius, shadow } from '@/theme/tokens';

type CardProps = ViewProps & {
  padded?: boolean;
  radiusToken?: keyof typeof radius;
  elevated?: boolean;
};

/** White rounded panel with the design's subtle border + shadow. */
export function Card({ style, padded = true, radiusToken = 'xl', elevated, children, ...rest }: CardProps) {
  return (
    <View
      style={[
        styles.card,
        { borderRadius: radius[radiusToken] },
        padded && styles.padded,
        elevated ? shadow.elevated : shadow.card,
        style,
      ]}
      {...rest}>
      {children}
    </View>
  );
}

/** Dark ink panel — connected-status card, game-over surface. */
export function DarkCard({ style, padded = true, radiusToken = 'xxl', children, ...rest }: CardProps) {
  return (
    <View
      style={[
        styles.dark,
        { borderRadius: radius[radiusToken] },
        padded && styles.padded,
        shadow.dark,
        style,
      ]}
      {...rest}>
      {children}
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: colors.card,
    borderWidth: 1,
    borderColor: colors.cardBorder,
  },
  dark: { backgroundColor: colors.ink },
  padded: { padding: 18 },
});
