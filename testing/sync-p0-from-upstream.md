# sync-p0-from-upstream — Test Contract

## Functional Behavior

Sync portable skills copied from `agentclash/agentclash` @ main (post PR #923):

- `agentclash-quickstart` and `agentclash-compare-and-triage` added to bundle.
- `agentclash-hub`, `agentclash-eval-runner`, and cross-linked skills match upstream content.
- `manifest.json` lists 19 skills with updated `dependency_order`.
- `scripts/verify-bundle.sh` passes.
- All six hosts install via `scripts/install.sh --dry-run`.

## Unit Tests

N/A — shell verification only.

## Integration / Functional Tests

```bash
bash scripts/verify-bundle.sh
for h in claude codex cursor openclaw hermes opencode; do
  bash scripts/install.sh --host "$h" --dry-run
done
```

## Smoke Tests

- Every manifest skill has `skills/<name>/SKILL.md` with YAML frontmatter.
- Hub references quickstart and compare-and-triage.

## E2E Tests

N/A.

## Manual Tests

```bash
bash scripts/install.sh --host cursor --project --dry-run
grep -l agentclash-quickstart skills/*/SKILL.md
grep -l agentclash-compare-and-triage skills/*/SKILL.md
```
