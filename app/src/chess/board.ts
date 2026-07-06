import { Chess } from 'chess.js';

import { colors } from '@/theme/tokens';
import type { LedCell } from '@/board/types';

export type PieceType = 'p' | 'n' | 'b' | 'r' | 'q' | 'k';
export type PieceColor = 'w' | 'b';

/** Filled Unicode glyphs; distinguished by fill color, not glyph set. */
export const PIECE_GLYPH: Record<PieceType, string> = {
  p: '♟',
  n: '♞',
  b: '♝',
  r: '♜',
  q: '♛',
  k: '♚',
};

export type Cell = {
  square: string; // "e4"
  light: boolean;
  glyph?: string;
  pieceColor?: string; // resolved text color for the glyph
  sel?: boolean; // selection ring
  led?: boolean; // green LED hint dot
  err?: boolean; // red error pulse
  last?: boolean; // last-move highlight
};

const FILES = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];

export type BoardOverlays = {
  selected?: string[];
  led?: string[];
  error?: string[];
  last?: string[];
};

/**
 * Turn a FEN into 64 render cells, top-left first.
 * orientation 'w' => rank 8 at top; 'b' => flipped.
 */
export function boardCells(
  fen: string,
  orientation: PieceColor = 'w',
  overlays: BoardOverlays = {},
): Cell[] {
  const chess = new Chess(fen);
  const grid = chess.board(); // grid[0] = rank 8, grid[0][0] = a8

  const sel = new Set(overlays.selected ?? []);
  const led = new Set(overlays.led ?? []);
  const err = new Set(overlays.error ?? []);
  const last = new Set(overlays.last ?? []);

  const cells: Cell[] = [];
  const rankOrder = orientation === 'w' ? [7, 6, 5, 4, 3, 2, 1, 0] : [0, 1, 2, 3, 4, 5, 6, 7];
  const fileOrder = orientation === 'w' ? [0, 1, 2, 3, 4, 5, 6, 7] : [7, 6, 5, 4, 3, 2, 1, 0];

  for (const rank of rankOrder) {
    for (const file of fileOrder) {
      const piece = grid[7 - rank][file]; // grid row 0 is rank 8
      const square = `${FILES[file]}${rank + 1}`;
      cells.push({
        square,
        light: (file + rank) % 2 === 1,
        glyph: piece ? PIECE_GLYPH[piece.type as PieceType] : undefined,
        pieceColor: piece
          ? piece.color === 'w'
            ? colors.pieceWhite
            : colors.pieceBlack
          : undefined,
        sel: sel.has(square),
        led: led.has(square),
        err: err.has(square),
        last: last.has(square),
      });
    }
  }
  return cells;
}

/** Legal destination squares for the piece on `from`, for hint LEDs. */
export function legalTargets(fen: string, from: string): string[] {
  const chess = new Chess(fen);
  return chess
    .moves({ square: from as never, verbose: true })
    .map((m) => (m as unknown as { to: string }).to);
}

const GREEN: [number, number, number] = [63, 143, 99];

/** Convert target squares into green LedCell payloads for BoardTransport.setLEDs. */
export function ledsForSquares(squares: string[], rgb: [number, number, number] = GREEN): LedCell[] {
  return squares.map((sq) => {
    const file = FILES.indexOf(sq[0]);
    const rank = parseInt(sq[1], 10) - 1;
    return { file, rank, r: rgb[0], g: rgb[1], b: rgb[2] };
  });
}

export const START_FEN = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
