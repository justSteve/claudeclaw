#!/usr/bin/env bash
# ============================================================================
# env-setup-globals.sh — Register global API keys in ~/.bashrc
# ============================================================================
#
# WHAT THIS DOES:
#   Adds export lines to ~/.bashrc for API keys shared across projects.
#   These are available in every shell session and every project.
#
# CONVENTION:
#   - Global keys go in ~/.bashrc (shared across all projects)
#   - Repo-scoped keys go in .envrc via direnv (auto-set on cd)
#   - App-specific config goes in .env (read by the app at runtime)
#
# USAGE:
#   1. Fill in the values below
#   2. Run: bash scripts/env-setup-globals.sh
#   3. Run: source ~/.bashrc  (or open a new terminal)
#
# IDEMPOTENT: Re-running won't duplicate entries.
# ============================================================================

set -euo pipefail

BASHRC="$HOME/.bashrc"

# ── Keys to register globally ───────────────────────────────────────────────
# Fill these in before running. Leave blank to skip.

TELEGRAM_BOT_TOKEN=""       # From @BotFather on Telegram
GOOGLE_API_KEY=""            # From https://aistudio.google.com
GROQ_API_KEY=""              # From https://console.groq.com
ANTHROPIC_API_KEY_4CLAW=""   # Anthropic key dedicated to claudeclaw
ELEVENLABS_API_KEY=""        # From https://elevenlabs.io (the longer sk_ key)

# ── Helper: add export line if not already present ──────────────────────────

add_global() {
  local key="$1"
  local val="$2"

  if [[ -z "$val" ]]; then
    echo "  SKIP  $key (no value provided)"
    return
  fi

  if grep -q "^export ${key}=" "$BASHRC" 2>/dev/null; then
    echo "  EXISTS  $key (already in $BASHRC — edit manually to change)"
  else
    echo "export ${key}=\"${val}\"" >> "$BASHRC"
    echo "  ADDED   $key"
  fi
}

# ── Run ─────────────────────────────────────────────────────────────────────

echo ""
echo "Registering global API keys in $BASHRC ..."
echo ""

add_global "TELEGRAM_BOT_TOKEN"     "$TELEGRAM_BOT_TOKEN"
add_global "GOOGLE_API_KEY"         "$GOOGLE_API_KEY"
add_global "GROQ_API_KEY"           "$GROQ_API_KEY"
add_global "ANTHROPIC_API_KEY_4CLAW" "$ANTHROPIC_API_KEY_4CLAW"
add_global "ELEVENLABS_API_KEY"     "$ELEVENLABS_API_KEY"

echo ""
echo "Done. Run 'source ~/.bashrc' to activate in current shell."
echo ""
