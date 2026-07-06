import Svg, { Circle, Path, Rect } from 'react-native-svg';

import { colors } from '@/theme/tokens';

type IconProps = { size?: number; color?: string };

export function Chevron({ size = 13, color = '#C3BDB1' }: IconProps) {
  return (
    <Svg width={(size * 7) / 13} height={size} viewBox="0 0 7 13" fill="none">
      <Path d="M1 1l5 5.5-5 5.5" stroke={color} strokeWidth={1.8} strokeLinecap="round" />
    </Svg>
  );
}

export function ChevronRight({ size = 16, color = '#fff' }: IconProps) {
  return (
    <Svg width={(size * 9) / 16} height={size} viewBox="0 0 9 16" fill="none">
      <Path d="M1 1l7 7-7 7" stroke={color} strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" />
    </Svg>
  );
}

export function CheckCircle({ size = 22 }: IconProps) {
  return (
    <Svg width={size} height={size} viewBox="0 0 22 22" fill="none">
      <Circle cx={11} cy={11} r={10} fill={colors.greenTint} />
      <Path
        d="M6.5 11.2l3 3 6-6.4"
        stroke={colors.green}
        strokeWidth={2.2}
        strokeLinecap="round"
        strokeLinejoin="round"
      />
    </Svg>
  );
}

export function Gear({ size = 20, color = '#4A463F' }: IconProps) {
  return (
    <Svg width={size} height={size} viewBox="0 0 20 20" fill="none">
      <Path d="M10 13a3 3 0 100-6 3 3 0 000 6z" stroke={color} strokeWidth={1.6} />
      <Path
        d="M10 1.5v2M10 16.5v2M16.5 10h2M1.5 10h2M14.6 5.4l1.4-1.4M4 16l1.4-1.4M14.6 14.6l1.4 1.4M4 4l1.4 1.4"
        stroke={color}
        strokeWidth={1.6}
        strokeLinecap="round"
      />
    </Svg>
  );
}

export function Lock({ size = 15, color = '#B8B2A6' }: IconProps) {
  return (
    <Svg width={(size * 13) / 15} height={size} viewBox="0 0 13 15" fill="none">
      <Rect x={1} y={6} width={11} height={8} rx={2} fill={color} />
      <Path d="M3.2 6V4.2a3.3 3.3 0 016.6 0V6" stroke={color} strokeWidth={1.6} />
    </Svg>
  );
}

/** Wi-Fi signal arcs; `strength` 0-3 controls how many are lit. */
export function WifiGlyph({ size = 14, strength = 3, color = '#8A857B' }: IconProps & { strength?: 0 | 1 | 2 | 3 }) {
  return (
    <Svg width={(size * 19) / 14} height={size} viewBox="0 0 19 14" fill="none">
      <Path
        d="M1 4.5C3.3 2.3 6.2 1 9.5 1S15.7 2.3 18 4.5"
        stroke={color}
        strokeWidth={1.6}
        strokeLinecap="round"
        opacity={strength >= 3 ? 1 : 0.25}
      />
      <Path
        d="M4 7.5C5.5 6 7.4 5.2 9.5 5.2s4 0.8 5.5 2.3"
        stroke={color}
        strokeWidth={1.6}
        strokeLinecap="round"
        opacity={strength >= 2 ? 1 : 0.25}
      />
      <Circle cx={9.5} cy={11} r={1.6} fill={color} opacity={strength >= 1 ? 1 : 0.25} />
    </Svg>
  );
}

/** Little vertical bar-chart glyph (analysis / review icon). */
export function BarsGlyph({ size = 17, color = colors.greenDeep }: IconProps) {
  return (
    <Svg width={size} height={size} viewBox="0 0 17 17">
      <Rect x={1} y={10} width={3.5} height={6} rx={1} fill={color} />
      <Rect x={6.7} y={6} width={3.5} height={10} rx={1} fill={color} />
      <Rect x={12.4} y={2} width={3.5} height={14} rx={1} fill={color} />
    </Svg>
  );
}
