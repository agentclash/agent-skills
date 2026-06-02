#!/usr/bin/env bash
# Copy portable skills from agentclash main repo into this bundle (maintainers).
# Does not modify the source repo.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DST="$REPO_ROOT/skills"

SRC="${AGENTCLASH_SOURCE:-}"
if [[ -z "$SRC" ]]; then
  for candidate in \
    "$REPO_ROOT/../agentclash/web/content/agent-skills" \
    "$HOME/agentclash/web/content/agent-skills"; do
    if [[ -d "$candidate" ]]; then
      SRC="$candidate"
      break
    fi
  done
fi

if [[ -z "$SRC" || ! -d "$SRC" ]]; then
  echo "Set AGENTCLASH_SOURCE to web/content/agent-skills from agentclash/agentclash" >&2
  exit 1
fi

echo "Syncing from $SRC"

copy_skill() {
  local src_dir="$1"
  local name
  name="$(basename "$src_dir")"
  mkdir -p "$DST/$name"
  cp "$src_dir/SKILL.md" "$DST/$name/SKILL.md"
  echo "  synced $name"
}

for dir in "$SRC"/agentclash-*/; do
  [[ -d "$dir" ]] || continue
  copy_skill "$dir"
done
for dir in "$SRC/agent-build-skills"/agentclash-*/; do
  [[ -d "$dir" ]] || continue
  copy_skill "$dir"
done
for dir in "$SRC/challenge-pack-skills"/agentclash-*/; do
  [[ -d "$dir" ]] || continue
  copy_skill "$dir"
done

# Preserve hub skill (bundle-only, not in upstream web/content)
if [[ ! -f "$DST/agentclash-hub/SKILL.md" ]]; then
  echo "  warning: agentclash-hub missing — restore from git" >&2
fi

bash "$SCRIPT_DIR/verify-bundle.sh"
