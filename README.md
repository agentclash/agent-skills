# AgentClash Skills

Portable [Agent Skills](https://agentclash.dev/docs/agent-skills) bundle for coding agents. Teaches Claude Code, Codex, Cursor, OpenClaw, Hermes, and OpenCode how to run AgentClash evals via the CLI **without reading the AgentClash source repo**.

Canonical docs source remains in [agentclash/agentclash](https://github.com/agentclash/agentclash) under `web/content/agent-skills/`. This repo is a **copy + install bundle** with a hub skill for workflow context and UI links.

## Install (one command, all skills)

Pick your agent host:

### Claude Code

```bash
curl -fsSL https://raw.githubusercontent.com/agentclash/agent-skills/main/scripts/install.sh | bash -s -- --host claude
```

Installs to `~/.claude/skills/<skill>/SKILL.md`.

Project-local:

```bash
curl -fsSL https://raw.githubusercontent.com/agentclash/agent-skills/main/scripts/install.sh | bash -s -- --host claude --project
```

### OpenAI Codex CLI

```bash
curl -fsSL https://raw.githubusercontent.com/agentclash/agent-skills/main/scripts/install.sh | bash -s -- --host codex
```

Installs to `~/.agents/skills/<skill>/SKILL.md`.

### Cursor

```bash
curl -fsSL https://raw.githubusercontent.com/agentclash/agent-skills/main/scripts/install.sh | bash -s -- --host cursor
```

Installs to `~/.cursor/skills/<skill>/SKILL.md`.

### OpenClaw

```bash
curl -fsSL https://raw.githubusercontent.com/agentclash/agent-skills/main/scripts/install.sh | bash -s -- --host openclaw
```

Installs to `~/.openclaw/skills/<skill>/SKILL.md`.

### Hermes

```bash
curl -fsSL https://raw.githubusercontent.com/agentclash/agent-skills/main/scripts/install.sh | bash -s -- --host hermes
```

Installs to `~/.hermes/skills/<skill>/SKILL.md`.

### OpenCode

```bash
curl -fsSL https://raw.githubusercontent.com/agentclash/agent-skills/main/scripts/install.sh | bash -s -- --host opencode
```

Global: `~/.config/opencode/skills/`. Project: `.opencode/skills/` (use `--project`).

## Clone and install locally

```bash
git clone https://github.com/agentclash/agent-skills.git
cd agent-skills
bash scripts/install.sh --host claude        # or codex, cursor, openclaw, hermes, opencode
bash scripts/install.sh --host cursor --project --dry-run
```

## Start here

After install, tell your agent to load **`agentclash-hub`** first. It includes:

- Full eval workflow and skill dependency order
- Links to every skill in the bundle
- Product UI URLs on https://agentclash.dev
- Hosted CLI defaults (`https://api.agentclash.dev`)

## What's in the bundle

17 skills (16 synced from main docs + hub):

| Skill | Purpose |
| --- | --- |
| `agentclash-hub` | Entry point — workflow map, UI links, skill graph |
| `agentclash-cli-setup` | Auth, workspace, config, doctor |
| `agentclash-runtime-resources-setup` | Providers, models, runtime, secrets |
| `agentclash-agent-build-author` | Build specs |
| `agentclash-agent-deployment-setup` | Deployments |
| `agentclash-challenge-pack-*` | Plan, YAML, inputs, tools, artifacts, scoring, judges, publish |
| `agentclash-eval-runner` | Run evals |
| `agentclash-scorecard-reader` | Read results |
| `agentclash-regression-flywheel` | Regression promotion |
| `agentclash-ci-release-gate` | CI gates |

See `manifest.json` for the full list and dependency order.

## Maintainer sync

Copy latest skills from a local `agentclash` checkout (does not edit upstream):

```bash
AGENTCLASH_SOURCE=/path/to/agentclash/web/content/agent-skills bash scripts/sync-from-upstream.sh
bash scripts/verify-bundle.sh
```

## Verify

```bash
bash scripts/verify-bundle.sh
```

## License

MIT — same as [AgentClash](https://github.com/agentclash/agentclash).
