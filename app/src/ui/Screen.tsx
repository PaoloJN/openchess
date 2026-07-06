import { ScrollView, StyleSheet, View, ViewStyle } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { colors } from '@/theme/tokens';

type ScreenProps = {
  children: React.ReactNode;
  scroll?: boolean;
  background?: string;
  padded?: boolean;
  contentStyle?: ViewStyle;
};

/**
 * Safe-area page wrapper. Uses the panel background by default; pass
 * `background={colors.ink}` for the dark screens (Game over).
 */
export function Screen({
  children,
  scroll = false,
  background = colors.screen,
  padded = true,
  contentStyle,
}: ScreenProps) {
  const insets = useSafeAreaInsets();
  const pad: ViewStyle = padded
    ? { paddingHorizontal: 20, paddingTop: insets.top + 20, paddingBottom: insets.bottom + 24 }
    : { paddingTop: insets.top, paddingBottom: insets.bottom };

  if (scroll) {
    return (
      <ScrollView
        style={[styles.flex, { backgroundColor: background }]}
        contentContainerStyle={[pad, contentStyle]}
        showsVerticalScrollIndicator={false}>
        {children}
      </ScrollView>
    );
  }
  return <View style={[styles.flex, { backgroundColor: background }, pad, contentStyle]}>{children}</View>;
}

const styles = StyleSheet.create({
  flex: { flex: 1 },
});
