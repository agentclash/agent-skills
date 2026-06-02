# init-skills-bundle — Test Contract

## Functional Behavior

A new public repo `agentclash/agent-skills` bundles all portable AgentClash skills from `agentclash/agentclash` (`web/content/agent-skills/`) without removing them from the main docs source.

- One install command per supported coding agent installs **all** skills at once.
- Supported agents: Claude Code, Codex, Cursor, OpenClaw, Hermes, OpenCode.
- Global install (user home) and project install (current directory) both work.
- Skills are flattened under `skills/<skill-name>/SKILL.md` in the repo.
- A hub skill (`agentclash-hub`) provides eval workflow context, skill dependency graph, cross-skill references, CLI happy path, and product UI links.
- Individual skills retain or gain `Related Skills` sections pointing to sibling skill folder names.
- Source skills in `agentclash/agentclash` remain unchanged (copy-only sync).

## Unit Tests

- N/A for shell installer — validated via install dry-run and file count assertions in `scripts/verify-bundle.sh`.

## Integration / Functional Tests

- `scripts/verify-bundle.sh` passes: manifest skill count matches `skills/*/SKILL.md` count (excluding catalog-only if omitted).
- `bash scripts/install.sh --host claude --dry-run` lists all skills and target path.
- `bash scripts/install.sh --host codex --dry-run` targets `.agents/skills/`.
- `bash scripts/install.sh --host cursor --dry-run` targets `.cursor/skills/`.
- `bash scripts/install.sh --host openclaw --dry-run` targets `.openclaw/skills/`.
- `bash scripts/install.sh --host hermes --dry-run` targets `.hermes/skills/`.
- `bash scripts/install.sh --host opencode --dry-run` targets `.config/opencode/skills/` (global) or `.opencode/skills/` (project).
- Local project install to a temp dir creates expected directory tree with 17 skill folders.

## Smoke Tests

- README documents one-liner curl install for each host.
- `manifest.json` lists dependency order matching catalog skill.
- Hub skill links to https://agentclash.dev docs and run UI paths.

## E2E Tests

- N/A — no runtime service; manual clone + install smoke on one host is sufficient.

## Manual / cURL Tests

```bash
# From a clean temp directory
git clone https://github.com/agentclash/agent-skills.git /tmp/ac-skills-test
cd /tmp/ac-skills-test
bash scripts/verify-bundle.sh
bash scripts/install.sh --host claude --project --dry-run
bash scripts/install.sh --host claude --project
test -f .claude/skills/agentclash-hub/SKILL.md
test -f .claude/skills/agentclash-eval-runner/SKILL.md
ls .claude/skills | wc -l   # expect 17
```
