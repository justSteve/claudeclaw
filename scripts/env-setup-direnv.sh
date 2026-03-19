#!/usr/bin/env bash
# ============================================================================
# env-setup-direnv.sh — Configure direnv for repo-scoped env var mapping
# ============================================================================
#
# WHAT THIS DOES:
#   1. Ensures direnv is installed
#   2. Adds the direnv hook to ~/.bashrc (if missing)
#   3. Creates .envrc in the project root
#   4. Adds .envrc to .gitignore (if missing)
#   5. Runs 'direnv allow' to trust the .envrc
#
# WHY DIRENV:
#   Some API keys need to be named differently per-project. For example,
#   ANTHROPIC_API_KEY_4CLAW is the global name for the Anthropic key
#   dedicated to claudeclaw, but the app expects ANTHROPIC_API_KEY.
#
#   direnv auto-maps these when you cd into the project directory,
#   and unsets them when you leave. No manual sourcing needed.
#
# CONVENTION:
#   Global keys (in ~/.bashrc):    ANTHROPIC_API_KEY_4CLAW="sk-ant-..."
#   Repo-scoped mapping (.envrc):  export ANTHROPIC_API_KEY="$ANTHROPIC_API_KEY_4CLAW"
#   App reads:                     process.env.ANTHROPIC_API_KEY  ← just works
#
# USAGE:
#   bash scripts/env-setup-direnv.sh
# ============================================================================

set -euo pipefail

PROJECT_ROOT="$(git rev-parse --show-toplevel)"
BASHRC="$HOME/.bashrc"
ENVRC="$PROJECT_ROOT/.envrc"
GITIGNORE="$PROJECT_ROOT/.gitignore"

echo ""
echo "Setting up direnv for $(basename "$PROJECT_ROOT") ..."
echo ""

# ── 1. Check direnv is installed ────────────────────────────────────────────

if ! command -v direnv &>/dev/null; then
  echo "ERROR: direnv not installed. Run: apt install direnv"
  exit 1
fi
echo "  OK  direnv found at $(command -v direnv)"

# ── 2. Add hook to ~/.bashrc ────────────────────────────────────────────────

if grep -q 'direnv hook bash' "$BASHRC" 2>/dev/null; then
  echo "  OK  direnv hook already in $BASHRC"
else
  echo 'eval "$(direnv hook bash)"' >> "$BASHRC"
  echo "  ADDED  direnv hook to $BASHRC"
fi

# ── 3. Create .envrc ────────────────────────────────────────────────────────
# Add mappings here for any global key that needs a different name in this repo.

cat > "$ENVRC" << 'ENVRC_CONTENT'
# ── claudeclaw direnv config ─────────────────────────────────────────────────
# Auto-loaded when you cd into this directory, unloaded when you leave.
#
# Maps globally-named keys to the names this app expects.
# Global (in ~/.bashrc)          → Repo-scoped (what the app reads)
# ─────────────────────────────────────────────────────────────────────────────

export ANTHROPIC_API_KEY="$ANTHROPIC_API_KEY_4CLAW"

# Add more mappings below as needed, e.g.:
# export SOME_APP_KEY="$MY_GLOBAL_KEY_NAME"
ENVRC_CONTENT

echo "  WROTE  $ENVRC"

# ── 4. Ensure .envrc is gitignored ──────────────────────────────────────────

if grep -q '\.envrc' "$GITIGNORE" 2>/dev/null; then
  echo "  OK  .envrc already in .gitignore"
else
  echo '.envrc' >> "$GITIGNORE"
  echo "  ADDED  .envrc to .gitignore"
fi

# ── 5. Allow direnv for this directory ──────────────────────────────────────

direnv allow "$PROJECT_ROOT"
echo "  OK  direnv allowed for $PROJECT_ROOT"

echo ""
echo "Done. Run 'source ~/.bashrc' if this is your first direnv setup."
echo ""
