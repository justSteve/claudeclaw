import { execSync } from 'child_process';
import { existsSync } from 'fs';
import path from 'path';

import { PROJECT_ROOT } from './config.js';
import { logger } from './logger.js';

const BEADS_DIR = path.join(PROJECT_ROOT, '.beads');
const EXEC_TIMEOUT = 5000;

let cachedAvailable: boolean | null = null;

/**
 * Check if `bd` binary is on PATH and `.beads/` exists in PROJECT_ROOT.
 * Result is cached for the process lifetime.
 */
export function isBeadsAvailable(): boolean {
  if (cachedAvailable !== null) return cachedAvailable;

  if (!existsSync(BEADS_DIR)) {
    cachedAvailable = false;
    return false;
  }

  try {
    execSync('bd --version', { timeout: EXEC_TIMEOUT, stdio: 'pipe' });
    cachedAvailable = true;
  } catch {
    cachedAvailable = false;
  }

  return cachedAvailable;
}

/**
 * Run `bd prime` and wrap output in context tags for injection before the user message.
 * Returns empty string on failure or when Beads is unavailable.
 */
export function getBeadsContext(): string {
  if (!isBeadsAvailable()) return '';

  try {
    const output = execSync('bd prime', {
      timeout: EXEC_TIMEOUT,
      cwd: PROJECT_ROOT,
      stdio: ['pipe', 'pipe', 'pipe'],
      encoding: 'utf-8',
    }).trim();

    if (!output) return '';
    return `[Task context (bd)]\n${output}\n[End task context]`;
  } catch (err) {
    logger.warn({ err }, 'bd prime failed');
    return '';
  }
}

/**
 * Run `bd ready` for display in Telegram via /tasks command.
 * Returns null if Beads is unavailable or the command fails.
 */
export function getReadyTasks(): string | null {
  if (!isBeadsAvailable()) return null;

  try {
    return execSync('bd ready', {
      timeout: EXEC_TIMEOUT,
      cwd: PROJECT_ROOT,
      stdio: ['pipe', 'pipe', 'pipe'],
      encoding: 'utf-8',
    }).trim();
  } catch (err) {
    logger.warn({ err }, 'bd ready failed');
    return null;
  }
}

/** Reset the cached availability check (for testing). */
export function _resetCache(): void {
  cachedAvailable = null;
}
