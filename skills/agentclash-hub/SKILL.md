---
name: agentclash-hub
description: Use when starting any AgentClash eval, CLI, or challenge-pack task. Load this skill first for the full workflow map, skill dependency order, product UI links, hosted defaults, and pointers to every other AgentClash skill in this bundle.
metadata:
  agentclash.role: hub
  agentclash.version: "1"
  agentclash.requires_cli: "false"
---

# AgentClash Hub

## Purpose
Give coding agents maximum context to run AgentClash evals through the CLI and guide humans to the right web UI pages — without reading the AgentClash source repository.

## Use When
- A user asks to evaluate agents, run evals, compare models, or use AgentClash for the first time.
- You need to pick the right downstream skill before acting.
- You need hosted defaults, UI links, or the end-to-end eval workflow in one place.

## Do Not Use When
- A narrower skill already matches (e.g. only CLI auth repair → `agentclash-cli-setup`).
- The task is only to edit AgentClash product source code in `agentclash/agentclash`.

## Hosted Defaults
Use production unless the user explicitly runs a local stack:

```bash
export AGENTCLASH_API_URL="https://api.agentclash.dev"
agentclash auth login --device
agentclash link
agentclash quickstart
```

Install the CLI: `npm i -g agentclash` or see https://agentclash.dev/docs/getting-started/quickstart

## End-to-End Eval Workflow (CLI)

```text
1. agentclash-cli-setup          → auth, workspace, doctor
2. agentclash-runtime-resources-setup → provider, model alias, runtime profile, secrets
3. agentclash-agent-build-author → build spec + ready build version
4. agentclash-agent-deployment-setup → deployment ID for runs
5. challenge-pack skills         → plan, YAML, validate, publish pack
6. agentclash-eval-runner        → eval start / run create / follow
7. agentclash-scorecard-reader   → rankings, scorecards, replay, artifacts
8. agentclash-regression-flywheel → promote failures, suite-only reruns
9. agentclash-ci-release-gate    → CI manifest + gate (optional)
```

Human-friendly shortcut after setup:

```bash
agentclash quickstart
agentclash eval start --follow
agentclash baseline set
agentclash eval scorecard
agentclash compare latest --gate
agentclash replay triage
```

## Skill Dependency Order
Read skills in this order when multiple apply:

1. `agentclash-hub` (this file)
2. `agentclash-cli-setup`
3. `agentclash-runtime-resources-setup`
4. `agentclash-agent-build-author`
5. `agentclash-agent-deployment-setup`
6. `agentclash-challenge-pack-planner`
7. `agentclash-challenge-pack-yaml-author`
8. `agentclash-challenge-pack-input-sets`
9. `agentclash-challenge-pack-tools-sandbox`
10. `agentclash-challenge-pack-artifacts`
11. `agentclash-challenge-pack-scoring-validators`
12. `agentclash-challenge-pack-llm-judges`
13. `agentclash-challenge-pack-validation-publish`
14. `agentclash-eval-runner`
15. `agentclash-scorecard-reader`
16. `agentclash-regression-flywheel`
17. `agentclash-ci-release-gate`

Each skill folder name matches its `name` in frontmatter. When a skill lists **Related Skills**, load those before mutating remote state.

## All Skills In This Bundle

| Skill folder | When to load |
| --- | --- |
| `agentclash-hub` | First — workflow map and UI links |
| `agentclash-cli-setup` | Install, auth, workspace, doctor |
| `agentclash-runtime-resources-setup` | Provider accounts, models, runtime profiles, secrets |
| `agentclash-agent-build-author` | Agent build specs and build versions |
| `agentclash-agent-deployment-setup` | Create/select deployments |
| `agentclash-challenge-pack-planner` | Plan a pack before YAML |
| `agentclash-challenge-pack-yaml-author` | Write pack YAML |
| `agentclash-challenge-pack-input-sets` | Cases and input sets |
| `agentclash-challenge-pack-tools-sandbox` | Tools and sandbox policy |
| `agentclash-challenge-pack-artifacts` | Assets and artifact refs |
| `agentclash-challenge-pack-scoring-validators` | Validators |
| `agentclash-challenge-pack-llm-judges` | LLM judges |
| `agentclash-challenge-pack-validation-publish` | Validate and publish |
| `agentclash-eval-runner` | Start and follow evals |
| `agentclash-scorecard-reader` | Interpret results |
| `agentclash-regression-flywheel` | Promote failures to regression suites |
| `agentclash-ci-release-gate` | CI/CD gates |

## Product UI — Where To Send The User

Base URL: **https://agentclash.dev**

| User goal | UI path |
| --- | --- |
| Sign in / account | https://agentclash.dev |
| Docs home | https://agentclash.dev/docs |
| Quickstart | https://agentclash.dev/docs/getting-started/quickstart |
| First eval walkthrough | https://agentclash.dev/docs/getting-started/first-eval |
| Agent skills (web catalog) | https://agentclash.dev/docs/agent-skills |
| CLI reference | https://agentclash.dev/docs/reference/cli |
| Challenge packs guide | https://agentclash.dev/docs/guides/write-a-challenge-pack |
| Multi-turn packs | https://agentclash.dev/docs/challenge-packs/multi-turn |
| Interpret results | https://agentclash.dev/docs/guides/interpret-results |
| CI/CD gates | https://agentclash.dev/docs/guides/ci-cd-agent-gates |
| Workspace runs (after login) | App dashboard → Runs list (use run ID from CLI in run detail URL when available) |
| Live run events | Run detail page while status is running |
| Scorecards & comparisons | Run detail → scorecard / ranking views after completion |

When you create a run via CLI, tell the user:

```text
Open https://agentclash.dev and navigate to your workspace runs, or search for run ID <RUN_ID> after signing in.
```

## AgentClash Concepts (30-Second Model)

- **Challenge pack** — versioned eval workload (cases, scoring, tools policy).
- **Input set** — which cases run in a given eval.
- **Agent build / deployment** — the agent under test (model + runtime + tools).
- **Run** — one execution of pack × input set × deployments.
- **Eval session** — repeated runs (`eval start --repetitions N`).
- **Scorecard** — structured results, comparisons, release gate input.
- **Regression suite** — promoted failures for suite-only reruns.

## Safety Notes
- Confirm before production-scale evals, publishes, or CI runs that spend budget.
- Never paste tokens, secrets, or customer data into chat.
- Prefer `agentclash doctor` and read-only list commands before writes.

## Report Back Format
```text
Hub loaded: yes
Next skill: <skill-folder-name>
CLI status: <auth/workspace/doctor summary>
UI for user: <https://agentclash.dev/...>
Next commands: <1-3 commands>
```

## Related Skills
Load all skills listed in **Skill Dependency Order** as needed; start with `agentclash-cli-setup` if CLI is not configured.

## Related Docs
- https://agentclash.dev/docs/agent-skills
- https://agentclash.dev/docs-md/agent-skills
- https://agentclash.dev/llms.txt
- https://github.com/agentclash/agent-skills
