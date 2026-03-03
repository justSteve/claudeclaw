import { describe, it, expect, vi, beforeEach } from 'vitest';
import { execSync } from 'child_process';
import { existsSync } from 'fs';

vi.mock('child_process', () => ({
  execSync: vi.fn(),
}));

vi.mock('fs', () => ({
  existsSync: vi.fn(),
}));

vi.mock('./logger.js', () => ({
  logger: { warn: vi.fn(), info: vi.fn(), error: vi.fn() },
}));

import {
  isBeadsAvailable,
  getBeadsContext,
  getReadyTasks,
  _resetCache,
} from './beads.js';

const mockExecSync = vi.mocked(execSync);
const mockExistsSync = vi.mocked(existsSync);

describe('isBeadsAvailable', () => {
  beforeEach(() => {
    vi.clearAllMocks();
    _resetCache();
  });

  it('returns false when .beads/ directory does not exist', () => {
    mockExistsSync.mockReturnValue(false);
    expect(isBeadsAvailable()).toBe(false);
    expect(mockExecSync).not.toHaveBeenCalled();
  });

  it('returns false when bd binary is not on PATH', () => {
    mockExistsSync.mockReturnValue(true);
    mockExecSync.mockImplementation(() => { throw new Error('not found'); });
    expect(isBeadsAvailable()).toBe(false);
  });

  it('returns true when .beads/ exists and bd is on PATH', () => {
    mockExistsSync.mockReturnValue(true);
    mockExecSync.mockReturnValue(Buffer.from('bd 0.1.0'));
    expect(isBeadsAvailable()).toBe(true);
  });

  it('caches the result across calls', () => {
    mockExistsSync.mockReturnValue(true);
    mockExecSync.mockReturnValue(Buffer.from('bd 0.1.0'));

    isBeadsAvailable();
    isBeadsAvailable();
    isBeadsAvailable();

    // existsSync called once, execSync called once (for --version)
    expect(mockExistsSync).toHaveBeenCalledTimes(1);
    expect(mockExecSync).toHaveBeenCalledTimes(1);
  });
});

describe('getBeadsContext', () => {
  beforeEach(() => {
    vi.clearAllMocks();
    _resetCache();
  });

  it('returns empty string when Beads is unavailable', () => {
    mockExistsSync.mockReturnValue(false);
    expect(getBeadsContext()).toBe('');
  });

  it('returns wrapped output when bd prime succeeds', () => {
    mockExistsSync.mockReturnValue(true);
    // First call: bd --version (from isBeadsAvailable)
    // Second call: bd prime
    mockExecSync
      .mockReturnValueOnce(Buffer.from('bd 0.1.0'))
      .mockReturnValueOnce('Task #1: Fix the login bug\nStatus: ready' as any);

    const result = getBeadsContext();
    expect(result).toBe(
      '[Task context (bd)]\nTask #1: Fix the login bug\nStatus: ready\n[End task context]',
    );
  });

  it('returns empty string when bd prime returns empty output', () => {
    mockExistsSync.mockReturnValue(true);
    mockExecSync
      .mockReturnValueOnce(Buffer.from('bd 0.1.0'))
      .mockReturnValueOnce('  \n  ' as any);

    expect(getBeadsContext()).toBe('');
  });

  it('returns empty string and does not throw when bd prime fails', () => {
    mockExistsSync.mockReturnValue(true);
    mockExecSync
      .mockReturnValueOnce(Buffer.from('bd 0.1.0'))
      .mockImplementationOnce(() => { throw new Error('timeout'); });

    expect(getBeadsContext()).toBe('');
  });
});

describe('getReadyTasks', () => {
  beforeEach(() => {
    vi.clearAllMocks();
    _resetCache();
  });

  it('returns null when Beads is unavailable', () => {
    mockExistsSync.mockReturnValue(false);
    expect(getReadyTasks()).toBeNull();
  });

  it('returns output when bd ready succeeds', () => {
    mockExistsSync.mockReturnValue(true);
    mockExecSync
      .mockReturnValueOnce(Buffer.from('bd 0.1.0'))
      .mockReturnValueOnce('  #1 Fix login [P2] ready\n  #2 Add tests [P1] ready  ' as any);

    expect(getReadyTasks()).toBe('#1 Fix login [P2] ready\n  #2 Add tests [P1] ready');
  });

  it('returns null when bd ready fails', () => {
    mockExistsSync.mockReturnValue(true);
    mockExecSync
      .mockReturnValueOnce(Buffer.from('bd 0.1.0'))
      .mockImplementationOnce(() => { throw new Error('fail'); });

    expect(getReadyTasks()).toBeNull();
  });
});
