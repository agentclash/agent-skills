#!/usr/bin/env bash
# Verify skill bundle matches manifest.json
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MANIFEST="$REPO_ROOT/manifest.json"
SKILLS_DIR="$REPO_ROOT/skills"

if [[ ! -f "$MANIFEST" ]]; then
  echo "FAIL: missing manifest.json" >&2
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: python3 required" >&2
  exit 1
fi

python3 - <<'PY' "$MANIFEST" "$SKILLS_DIR"
import json, sys
from pathlib import Path

manifest_path, skills_dir = Path(sys.argv[1]), Path(sys.argv[2])
manifest = json.loads(manifest_path.read_text())
expected = manifest["skills"]
on_disk = sorted(p.name for p in skills_dir.iterdir() if p.is_dir() and (p / "SKILL.md").exists())

missing = [s for s in expected if s not in on_disk]
extra = [s for s in on_disk if s not in expected]

if missing:
    print("FAIL: missing skills:", ", ".join(missing))
    sys.exit(1)
if extra:
    print("FAIL: unexpected skills:", ", ".join(extra))
    sys.exit(1)
if len(on_disk) != len(expected):
    print(f"FAIL: count mismatch disk={len(on_disk)} manifest={len(expected)}")
    sys.exit(1)

print(f"OK: {len(expected)} skills match manifest.json")
PY

for skill in $(python3 -c "import json; print(' '.join(json.load(open('$MANIFEST'))['skills']))"); do
  f="$SKILLS_DIR/$skill/SKILL.md"
  if [[ ! -f "$f" ]]; then
    echo "FAIL: $f" >&2
    exit 1
  fi
  if ! head -1 "$f" | grep -q '^---'; then
    echo "FAIL: $f missing frontmatter" >&2
    exit 1
  fi
done

echo "OK: all SKILL.md files have frontmatter"
