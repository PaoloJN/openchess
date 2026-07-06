import { createContext, useContext, useEffect, useMemo, useRef, useState } from 'react';

import { createBoard } from './createBoard';
import type { BoardStatus, BoardTransport } from './types';

type BoardContextValue = {
  board: BoardTransport;
  status: BoardStatus;
};

const BoardContext = createContext<BoardContextValue | null>(null);

/**
 * Provides the active board transport (MockBoard for now) and its live status
 * to the whole app. Swap the `new MockBoard()` line for a real transport later.
 */
export function BoardProvider({ children }: { children: React.ReactNode }) {
  const boardRef = useRef<BoardTransport>(null as unknown as BoardTransport);
  if (!boardRef.current) boardRef.current = createBoard();
  const board = boardRef.current;

  const [status, setStatus] = useState<BoardStatus>(board.getStatus());

  useEffect(() => board.subscribeStatus(setStatus), [board]);

  const value = useMemo(() => ({ board, status }), [board, status]);
  return <BoardContext.Provider value={value}>{children}</BoardContext.Provider>;
}

export function useBoard(): BoardContextValue {
  const ctx = useContext(BoardContext);
  if (!ctx) throw new Error('useBoard must be used within a BoardProvider');
  return ctx;
}
