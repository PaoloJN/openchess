/**
 * Design tokens for the OpenChess companion app.
 * Values are lifted directly from the Claude Design source
 * (OpenChess App.dc.html). Keep this the single source of truth for color,
 * type, spacing, radius, and shadow — UI primitives and screens consume it.
 */

export const colors = {
  // Surfaces
  canvas: '#EDEAE3', // app/page background (dot-grid in design)
  screen: '#F3F1EC', // default screen background
  card: '#FFFFFF',
  cardBorder: 'rgba(0,0,0,0.06)',
  divider: 'rgba(0,0,0,0.06)',
  chip: '#E4DFD4',
  track: '#E7E3DA', // slider / progress track

  // Ink / dark surfaces
  ink: '#22201C', // dark cards, game-over background
  inkSoft: '#2A2723', // piece dark / avatar bg
  inkDots: '#3B3833', // password dots

  // Text
  text: '#23211D',
  textStrong: '#23211D',
  text2: '#4A463F',
  muted: '#6B6862',
  muted2: '#8A857B',
  muted3: '#9A9488',
  muted4: '#A9A396',
  muted5: '#B0AA9E',

  // Brand green
  green: '#3F8F63',
  greenBright: '#5EC489',
  greenDeep: '#2E6B4A',
  greenTint: '#E9F1EC',

  // Alerts
  red: '#C4553D',
  redTint: '#FBEDE9',

  // Accent options (hint colors in Settings)
  blue: '#4C7DD6',
  amber: '#D69E3F',

  // Board squares (warm scheme complementing the cream UI)
  boardLight: '#EFE7D6',
  boardDark: '#C6A883',

  // Pieces
  pieceWhite: '#F7F4ED',
  pieceBlack: '#2A2723',

  white: '#FFFFFF',
} as const;

/** On dark (ink) surfaces, text uses translucent cream. */
export const onInk = {
  text: '#F3F1EC',
  muted: 'rgba(243,241,236,0.55)',
  muted2: 'rgba(243,241,236,0.5)',
  faint: 'rgba(243,241,236,0.35)',
  hairline: 'rgba(255,255,255,0.08)',
  fill: 'rgba(255,255,255,0.06)',
} as const;

export const fonts = {
  // Registered in theme/fonts.ts via @expo-google-fonts
  display: 'HankenGrotesk_400Regular',
  medium: 'HankenGrotesk_500Medium',
  semibold: 'HankenGrotesk_600SemiBold',
  bold: 'HankenGrotesk_700Bold',
  extrabold: 'HankenGrotesk_800ExtraBold',
  mono: 'IBMPlexMono_400Regular',
  monoMedium: 'IBMPlexMono_500Medium',
  monoSemibold: 'IBMPlexMono_600SemiBold',
} as const;

export const radius = {
  sm: 10,
  md: 14,
  lg: 17,
  xl: 20,
  xxl: 24,
  pill: 999,
} as const;

export const space = {
  xs: 4,
  sm: 8,
  md: 12,
  lg: 16,
  xl: 20,
  xxl: 28,
} as const;

/** react-native shadow presets (iOS shadow* + Android elevation). */
export const shadow = {
  card: {
    shadowColor: '#000',
    shadowOpacity: 0.03,
    shadowRadius: 18,
    shadowOffset: { width: 0, height: 6 },
    elevation: 2,
  },
  elevated: {
    shadowColor: '#000',
    shadowOpacity: 0.05,
    shadowRadius: 30,
    shadowOffset: { width: 0, height: 10 },
    elevation: 4,
  },
  dark: {
    shadowColor: '#000',
    shadowOpacity: 0.14,
    shadowRadius: 30,
    shadowOffset: { width: 0, height: 12 },
    elevation: 8,
  },
  green: {
    shadowColor: '#3F8F63',
    shadowOpacity: 0.3,
    shadowRadius: 20,
    shadowOffset: { width: 0, height: 8 },
    elevation: 6,
  },
  board: {
    shadowColor: '#000',
    shadowOpacity: 0.1,
    shadowRadius: 26,
    shadowOffset: { width: 0, height: 10 },
    elevation: 6,
  },
} as const;

export type ColorToken = keyof typeof colors;
