#!/usr/bin/env bash
# Install all AgentClash portable skills for a coding agent host.
# Usage: install.sh --host <claude|codex|cursor|openclaw|hermes|opencode> [--global|--project] [--dry-run]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILLS_SRC="$REPO_ROOT/skills"

HOST=""
SCOPE="global"
DRY_RUN=0

usage() {
  cat <<'EOF'
AgentClash skills installer — installs the full skill bundle for one agent host.

Usage:
  install.sh --host <host> [--global|--project] [--dry-run]

Hosts:
  claude    Claude Code     → ~/.claude/skills/ or ./.claude/skills/
  codex     OpenAI Codex    → ~/.agents/skills/ or ./.agents/skills/
  cursor    Cursor          → ~/.cursor/skills/ or ./.cursor/skills/
  openclaw  OpenClaw        → ~/.openclaw/skills/ or ./.openclaw/skills/
  hermes    Hermes          → ~/.hermes/skills/ or ./.hermes/skills/
  opencode  OpenCode        → ~/.config/opencode/skills/ or ./.opencode/skills/

Options:
  --global     Install under the user home directory (default)
  --project    Install under the current project directory
  --dry-run    Print actions without copying files
  -h, --help   Show this help

Examples:
  curl -fsSL https://raw.githubusercontent.com/agentclash/agent-skills/main/scripts/install.sh | bash -s -- --host claude
  bash scripts/install.sh --host cursor --project
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --host)
      HOST="${2:-}"
      shift 2
      ;;
    --global)
      SCOPE="global"
      shift
      ;;
    --project)
      SCOPE="project"
      shift
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -z "$HOST" ]]; then
  echo "Error: --host is required" >&2
  usage >&2
  exit 2
fi

resolve_target_dir() {
  case "$HOST" in
    claude)
      rel=".claude/skills"
      ;;
    codex)
      rel=".agents/skills"
      ;;
    cursor)
      rel=".cursor/skills"
      ;;
    openclaw)
      rel=".openclaw/skills"
      ;;
    hermes)
      rel=".hermes/skills"
      ;;
    opencode)
      if [[ "$SCOPE" == "global" ]]; then
        rel=".config/opencode/skills"
      else
        rel=".opencode/skills"
      fi
      ;;
    *)
      echo "Unsupported host: $HOST" >&2
      echo "Supported: claude, codex, cursor, openclaw, hermes, opencode" >&2
      exit 2
      ;;
  esac

  if [[ "$SCOPE" == "global" ]]; then
    echo "$HOME/$rel"
  else
    echo "$(pwd)/$rel"
  fi
}

if [[ ! -d "$SKILLS_SRC" ]]; then
  echo "Error: skills source not found at $SKILLS_SRC" >&2
  exit 1
fi

TARGET="$(resolve_target_dir)"
COUNT=0

echo "AgentClash skills install"
echo "  Host:   $HOST"
echo "  Scope:  $SCOPE"
echo "  Target: $TARGET"
echo ""

for skill_dir in "$SKILLS_SRC"/*/; do
  [[ -f "${skill_dir}SKILL.md" ]] || continue
  skill_name="$(basename "$skill_dir")"
  dest="$TARGET/$skill_name"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] would install $skill_name → $dest/SKILL.md"
  else
    mkdir -p "$dest"
    cp "$skill_dir/SKILL.md" "$dest/SKILL.md"
    echo "installed $skill_name"
  fi
  COUNT=$((COUNT + 1))
done

if [[ "$COUNT" -eq 0 ]]; then
  echo "Error: no skills found in $SKILLS_SRC" >&2
  exit 1
fi

echo ""
echo "Done: $COUNT skills → $TARGET"
echo "Start with skill: agentclash-hub"
echo "Docs: https://agentclash.dev/docs/agent-skills"
