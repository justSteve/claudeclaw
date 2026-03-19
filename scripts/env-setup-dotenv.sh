#!/usr/bin/env bash
# ============================================================================
# env-setup-dotenv.sh — Create the project .env file from template
# ============================================================================
#
# WHAT THIS DOES:
#   Creates .env with claudeclaw-specific settings that don't belong in
#   ~/.bashrc or .envrc. These are values the app reads at runtime via
#   its own .env parser (src/env.ts).
#
# WHAT GOES HERE vs ELSEWHERE:
#
#   ~/.bashrc (globals)     Keys shared across projects
#                           TELEGRAM_BOT_TOKEN, GOOGLE_API_KEY, GROQ_API_KEY
#
#   .envrc (direnv)         Key name mappings (global name → app name)
#                           ANTHROPIC_API_KEY_4CLAW → ANTHROPIC_API_KEY
#
#   .env (this file)        App-specific config not needed anywhere else
#                           ALLOWED_CHAT_ID, DASHBOARD_TOKEN, DB_ENCRYPTION_KEY,
#                           ELEVENLABS_VOICE_ID, feature flags
#
# HOW THE APP RESOLVES A KEY:
#   1. process.env (globals from ~/.bashrc + direnv mappings)  ← checked first
#   2. .env file (parsed by src/env.ts)                        ← fallback
#   So globals and direnv always win over .env values.
#
# USAGE:
#   bash scripts/env-setup-dotenv.sh
#   Then edit .env to fill in values.
# ============================================================================

set -euo pipefail

PROJECT_ROOT="$(git rev-parse --show-toplevel)"
DOTENV="$PROJECT_ROOT/.env"

if [[ -f "$DOTENV" ]]; then
  echo ""
  echo ".env already exists at $DOTENV"
  echo "To regenerate, delete it first: rm $DOTENV"
  echo ""
  exit 0
fi

# ── Generate dashboard token and encryption key ─────────────────────────────

DASH_TOKEN=$(node -e "console.log(require('crypto').randomBytes(24).toString('hex'))" 2>/dev/null || echo "")
DB_KEY=$(node -e "console.log(require('crypto').randomBytes(32).toString('hex'))" 2>/dev/null || echo "")

cat > "$DOTENV" << EOF
# ============================================================================
# claudeclaw .env — app-specific config (not shared across projects)
# ============================================================================
#
# Keys set globally (in ~/.bashrc) — do NOT duplicate here:
#   TELEGRAM_BOT_TOKEN, GOOGLE_API_KEY, GROQ_API_KEY, ELEVENLABS_API_KEY
#
# Keys mapped via direnv (.envrc) — do NOT duplicate here:
#   ANTHROPIC_API_KEY (mapped from ANTHROPIC_API_KEY_4CLAW)
#
# The app checks process.env first, then falls back to this file.
# ============================================================================

# ── Required — fill after first bot run with /chatid ─────────────────────────
ALLOWED_CHAT_ID=

# ── Voice ────────────────────────────────────────────────────────────────────
# Voice ID from https://elevenlabs.io → Voices → your voice → Voice ID
# (hex string, NOT an sk_ key)
ELEVENLABS_VOICE_ID=

# ── Dashboard ────────────────────────────────────────────────────────────────
DASHBOARD_TOKEN=${DASH_TOKEN}
# DASHBOARD_PORT=3141
# DASHBOARD_URL=

# ── Database Encryption ──────────────────────────────────────────────────────
DB_ENCRYPTION_KEY=${DB_KEY}

# ── Optional — uncomment as needed ───────────────────────────────────────────
# WHATSAPP_ENABLED=true
# SLACK_USER_TOKEN=
# AGENT_TIMEOUT_MS=300000
EOF

echo ""
echo "Created $DOTENV"
echo "  - Dashboard token: auto-generated"
echo "  - DB encryption key: auto-generated"
echo "  - Fill in ALLOWED_CHAT_ID after running the bot and sending /chatid"
echo ""
