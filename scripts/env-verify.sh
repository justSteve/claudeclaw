#!/usr/bin/env bash
# ============================================================================
# env-verify.sh — Verify all env layers are wired correctly
# ============================================================================
#
# WHAT THIS DOES:
#   Checks each layer of the env convention and reports what's set,
#   what's missing, and what's misconfigured. Shows masked values only.
#
# THE THREE LAYERS:
#
#   Layer 1: ~/.bashrc globals     → shared API keys
#   Layer 2: .envrc (direnv)       → repo-scoped key mappings
#   Layer 3: .env file             → app-specific config
#
#   Resolution order: process.env (layers 1+2) wins over .env (layer 3)
#
# USAGE:
#   bash scripts/env-verify.sh
#
# NOTE: Run from within the project directory (or any subdirectory).
#       If direnv is active, layer 2 vars will already be in your env.
# ============================================================================

set -euo pipefail

PROJECT_ROOT="$(git rev-parse --show-toplevel)"

# ── Helpers ─────────────────────────────────────────────────────────────────

mask() {
  local val="$1"
  if [[ -z "$val" ]]; then
    echo "(not set)"
  elif [[ ${#val} -le 8 ]]; then
    echo "${val:0:2}***"
  else
    echo "${val:0:6}...${val: -4}"
  fi
}

check_var() {
  local key="$1"
  local required="${2:-optional}"
  local val="${!key:-}"
  local status

  if [[ -n "$val" ]]; then
    status="  SET"
  elif [[ "$required" == "required" ]]; then
    status="  MISSING"
  else
    status="  -"
  fi

  printf "  %-6s %-30s %s\n" "$status" "$key" "$(mask "$val")"
}

# ── Header ──────────────────────────────────────────────────────────────────

echo ""
echo "========================================"
echo " claudeclaw environment verification"
echo "========================================"

# ── Layer 1: Global keys (~/.bashrc) ────────────────────────────────────────

echo ""
echo "Layer 1: Global keys (from ~/.bashrc)"
echo "──────────────────────────────────────"
check_var TELEGRAM_BOT_TOKEN      required
check_var GOOGLE_API_KEY           optional
check_var GROQ_API_KEY             optional
check_var ELEVENLABS_API_KEY       optional
check_var ANTHROPIC_API_KEY_4CLAW  optional

# ── Layer 2: direnv mappings (.envrc) ───────────────────────────────────────

echo ""
echo "Layer 2: direnv repo-scoped mappings"
echo "──────────────────────────────────────"

if [[ -f "$PROJECT_ROOT/.envrc" ]]; then
  echo "  OK  .envrc exists"
else
  echo "  MISSING  .envrc — run: bash scripts/env-setup-direnv.sh"
fi

if command -v direnv &>/dev/null; then
  echo "  OK  direnv installed"
else
  echo "  MISSING  direnv — run: apt install direnv"
fi

if grep -q 'direnv hook' "$HOME/.bashrc" 2>/dev/null; then
  echo "  OK  direnv hook in ~/.bashrc"
else
  echo "  MISSING  direnv hook — run: bash scripts/env-setup-direnv.sh"
fi

# The key mapping: does ANTHROPIC_API_KEY resolve?
echo ""
echo "  Key mapping check:"
check_var ANTHROPIC_API_KEY optional
if [[ -n "${ANTHROPIC_API_KEY:-}" && -n "${ANTHROPIC_API_KEY_4CLAW:-}" ]]; then
  if [[ "$ANTHROPIC_API_KEY" == "$ANTHROPIC_API_KEY_4CLAW" ]]; then
    echo "         ↳ correctly mapped from ANTHROPIC_API_KEY_4CLAW"
  else
    echo "         ↳ WARNING: value differs from ANTHROPIC_API_KEY_4CLAW"
  fi
fi

# ── Layer 3: .env file (app config) ────────────────────────────────────────

echo ""
echo "Layer 3: .env file (app-specific config)"
echo "──────────────────────────────────────"

if [[ -f "$PROJECT_ROOT/.env" ]]; then
  echo "  OK  .env exists"

  # Parse .env manually (same logic as src/env.ts)
  while IFS= read -r line; do
    trimmed="$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    [[ -z "$trimmed" || "$trimmed" == \#* ]] && continue
    key="${trimmed%%=*}"
    val="${trimmed#*=}"
    # Strip surrounding quotes
    val="$(echo "$val" | sed "s/^['\"]//;s/['\"]$//")"

    case "$key" in
      ALLOWED_CHAT_ID|ELEVENLABS_VOICE_ID|DASHBOARD_TOKEN|DB_ENCRYPTION_KEY|DASHBOARD_PORT|DASHBOARD_URL|WHATSAPP_ENABLED|SLACK_USER_TOKEN|AGENT_TIMEOUT_MS)
        if [[ -n "$val" ]]; then
          printf "  %-6s %-30s %s\n" "SET" "$key" "$(mask "$val")"
        else
          printf "  %-6s %-30s %s\n" "EMPTY" "$key" "(no value)"
        fi
        ;;
    esac
  done < "$PROJECT_ROOT/.env"
else
  echo "  MISSING  .env — run: bash scripts/env-setup-dotenv.sh"
fi

# ── .gitignore safety check ────────────────────────────────────────────────

echo ""
echo "Safety checks"
echo "──────────────────────────────────────"

for f in .env .envrc; do
  if grep -q "^${f}$\|^${f//./\\.}$" "$PROJECT_ROOT/.gitignore" 2>/dev/null; then
    echo "  OK  $f is gitignored"
  else
    echo "  WARNING  $f is NOT in .gitignore — secrets could be committed!"
  fi
done

echo ""
