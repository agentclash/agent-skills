# feat/sync-p1-from-upstream — Test Contract

## Functional Behavior

Sync four P1 skills from agentclash main into the install bundle (23 skills total).

## Unit Tests

```bash
bash scripts/verify-bundle.sh
```

## Integration Tests

```bash
for h in claude codex cursor openclaw hermes opencode; do
  bash scripts/install.sh --host "$h" --dry-run
done
```

## Smoke Tests

manifest.json lists 23 skills; hub includes P1 optional branches.

## E2E Tests

N/A.

## Manual Tests

```bash
curl -fsSL .../install.sh | bash -s -- --host cursor --dry-run
```
