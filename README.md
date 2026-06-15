# agent-stack

Portable AI-agent configuration for local development.

`agent-stack` is a small dotfiles-style repository for keeping AI coding agent instructions, reusable workflows, and installer scripts in one place. It currently supports:

- Claude Code via `~/.claude/`
- Codex via `~/.codex/`

The goal is not to build a giant framework. The goal is to keep a practical, reusable operating layer for real software work.

## What This Repo Is For

Use this repo when you want:

- consistent planning and execution behavior across agent sessions
- reusable specialist prompts and workflows
- portable local setup on a new machine
- a clean place to version your agent operating model

This repo is not:

- a general-purpose CLI tool
- a replacement for project-specific `AGENTS.md` or `CLAUDE.md`
- a guarantee that Claude and Codex behave identically

## Repository Layout

```txt
agent-stack/
  claude/
    CLAUDE.md
    agents/
    rules/
    skills/
    commands/

  codex/
    AGENTS.md
    skills/
    rules/      # optional
    commands/   # optional
    agents/     # optional

  scripts/
    check.sh
    install.sh
```

## Installed Layout

| Target | Installed path | What gets installed                                                                                       |
| ------ | -------------- | --------------------------------------------------------------------------------------------------------- |
| Claude | `~/.claude/`   | `CLAUDE.md`, agents, rules, skills, commands                                                              |
| Codex  | `~/.codex/`    | `AGENTS.md` plus any top-level folders under `codex/` such as `skills/`, `rules/`, `commands/`, `agents/` |

The Codex side is intentionally extensible. If you later add `codex/rules/`, `codex/commands/`, or `codex/agents/`, the installer will copy them without needing another script change.

## Current Contents

### Claude

| Type              | Current items                                                                                                                                      |
| ----------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| Global entrypoint | `CLAUDE.md`                                                                                                                                        |
| Agents            | `architect`, `build-error-resolver`, `code-reviewer`, `doc-updater`, `e2e-runner`, `planner`, `react-reviewer`, `refactor-cleaner`, `security-reviewer`, `tdd-guide`, `typescript-reviewer` |
| Commands          | `plan`, `refactor-clean`                                                                                                                           |
| Skills            | 23 skills — daily stack (`backend-patterns`, `frontend-patterns`, `nextjs-turbopack`, `docker-patterns`, `payment-service-patterns`, …), agent/token efficiency, research/design, and Flutter. Full list in [how-to-use.md](how-to-use.md#installed-skills--when-to-use-each). |
| Rules             | common workflow, review, security, testing, git, style, patterns, performance guidance                                                             |

### Codex

| Type                 | Current items                                                             |
| -------------------- | ------------------------------------------------------------------------- |
| Global entrypoint    | `AGENTS.md`                                                               |
| Skills               | `coding-standards`, `dead-code-cleanup`, `frontend-patterns`, `vault-csi` |
| Future-ready folders | `rules/`, `commands/`, `agents/` can be added later                       |

## Bootstrap On A New Device

```bash
git clone https://github.com/Ganzorig2022/agent-stack.git ~/agent-stack
cd ~/agent-stack
bash scripts/check.sh
bash scripts/install.sh --target all --backup
```

## Validation Before Install

Run this first:

```bash
bash scripts/check.sh
```

This verifies:

- expected base directories exist
- Claude agent files are present and structurally valid
- Claude and Codex skill directories follow `skill-name/SKILL.md`

## Install Options

```bash
bash scripts/install.sh --target claude --backup
bash scripts/install.sh --target codex --backup
bash scripts/install.sh --target all --backup
```

### Installer Flags

| Flag              | Meaning                                    |
| ----------------- | ------------------------------------------ |
| `--target claude` | Install only Claude config                 |
| `--target codex`  | Install only Codex config                  |
| `--target all`    | Install both                               |
| `--skip`          | Keep existing files and skip conflicts     |
| `--backup`        | Move existing files aside before overwrite |
| `--force`         | Overwrite existing files directly          |
| `--prune`         | Remove live agents/rules/commands not in the repo (skills left intact) |
| `--dry-run`       | Print actions without changing files       |

Recommended default: `--backup`. For a clean re-sync that also removes items you
renamed or deleted in the repo (e.g. old flat rules left behind by a layout change),
add `--prune`:

```bash
bash scripts/install.sh --target claude --backup --prune
```

Backups are written to a single `~/.claude/.backups/<timestamp>/` tree (mirrored paths),
not scattered as `*.backup.<timestamp>` files next to the originals. `--prune` never
touches `skills/`, since that directory also holds skills installed from other sources.

## Verify The Install

### Claude

```bash
ls -1 ~/.claude/agents
ls -1 ~/.claude/commands
find ~/.claude/skills -maxdepth 2 -type f | sort
```

### Codex

```bash
cat ~/.codex/AGENTS.md
find ~/.codex -maxdepth 3 -type f | sort
```

## CLI-First Usage

This repo is designed to be practical from the terminal, not only from IDE integrations.

### Claude Code CLI

| Goal                                                    | Command                                           |
| ------------------------------------------------------- | ------------------------------------------------- |
| Start an interactive session in the current repo        | `claude`                                          |
| Start with a direct prompt                              | `claude "review the auth flow and suggest risks"` |
| Resume the most recent conversation in the current repo | `claude -c`                                       |
| Resume a previous session or open the picker            | `claude -r`                                       |
| Run a one-shot non-interactive task                     | `claude -p "summarize the current diff"`          |
| Start with a specific agent                             | `claude --agent planner`                          |

### Codex CLI

| Goal                                             | Command                                                 |
| ------------------------------------------------ | ------------------------------------------------------- |
| Start an interactive session in the current repo | `codex`                                                 |
| Start with a direct prompt                       | `codex "inspect this repo and propose a refactor plan"` |
| Run a one-shot non-interactive task              | `codex exec "summarize the current architecture"`       |
| Run a non-interactive code review                | `codex review`                                          |
| Resume the most recent interactive session       | `codex resume --last`                                   |
| Check local installation health                  | `codex doctor`                                          |

## CLI Command Model

Claude and Codex are not symmetric in how this repo plugs into their CLIs.

| Agent  | Best CLI integration point today                                | Notes                                                                           |
| ------ | --------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| Claude | repo-local slash commands plus agents and skills                | This repo already ships concrete Claude slash commands under `claude/commands/` |
| Codex  | global `AGENTS.md`, local skills, and top-level CLI subcommands | This repo does not currently depend on Codex-specific repo-local slash commands |

## How To Use This Stack With Claude

Claude is the richer side of this repo today. It has:

- a global instruction entrypoint
- reusable specialist agents
- reusable commands
- a shared rule layer
- a small set of skills

### Claude Slash Commands In CLI

The Claude side of this repo already exposes repo-local slash commands through `~/.claude/commands/`.

| Slash command     | When to use                       | What it does                                                                                                          |
| ----------------- | --------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| `/plan`           | before non-trivial implementation | forces requirement restatement, repo inspection, risk analysis, file list, phased plan, and validation before editing |
| `/refactor-clean` | cleanup work in JS/TS codebases   | drives safe dead-code and cleanup work with baseline validation and scope control                                     |

### Suggested Claude CLI Workflow

| Phase            | Preferred CLI move                                    | Example                                                  |
| ---------------- | ----------------------------------------------------- | -------------------------------------------------------- |
| Start planning   | run Claude interactively, then use `/plan`            | `claude` then `/plan add audit logging to admin actions` |
| Deep design work | launch with an explicit agent                         | `claude --agent architect`                               |
| Implementation   | continue in the same session after plan approval      | `implement the approved plan`                            |
| Review           | either ask in-session or use a review-oriented prompt | `run a code review on the current diff`                  |
| Cleanup          | use `/refactor-clean` for scoped cleanup              | `/refactor-clean src/modules/orders`                     |

### Suggested Claude Workflow

| Situation                       | Suggested usage                                  | Why                                                                       |
| ------------------------------- | ------------------------------------------------ | ------------------------------------------------------------------------- |
| Starting a non-trivial feature  | Use the `planner` agent or `/plan` command first | Forces requirements, risks, affected files, and validation to be explicit |
| Architecture or boundary change | Use the `architect` agent                        | Better for tradeoffs, module boundaries, and system shape                 |
| New behavior or bug fix         | Use the `tdd-guide` agent                        | Pushes test-aware execution instead of ad hoc coding                      |
| Security-sensitive change       | Use the `security-reviewer` agent                | Good for auth, secrets, input handling, APIs, uploads, webhooks           |
| Build/typecheck/CI breakage     | Use the `build-error-resolver` agent             | Faster path for dependency and compilation failures                       |
| Cleanup without behavior change | Use `/refactor-clean` or `refactor-cleaner`      | Keeps cleanup scoped and safer                                            |
| After meaningful implementation | Use the `code-reviewer` agent                    | Adds a deliberate review pass before commit                               |
| Docs changed by implementation  | Use the `doc-updater` agent                      | Keeps docs updates from being forgotten                                   |

### Example Claude Flow

| Step      | Example prompt                                                                    |
| --------- | --------------------------------------------------------------------------------- |
| Start CLI | `claude`                                                                          |
| Plan      | `/plan add optimistic UI for ticket status updates`                               |
| Implement | `Implement the approved plan. Keep changes minimal and follow existing patterns.` |
| Review    | `Run a code review on the current diff and list findings by severity.`            |
| Cleanup   | `/refactor-clean src/modules/tickets`                                             |

## How To Use This Stack With Codex

Codex currently has:

- a global `AGENTS.md`
- portable local skills
- an extensible config layout for future rules, commands, and agent prompts

The Codex side is intentionally simpler right now, but it is no longer just a single `AGENTS.md`.

### Codex CLI Workflow Model

Codex is currently best documented as:

- interactive prompt-driven work inside `codex`
- non-interactive shell subcommands such as `codex exec`, `codex review`, `codex resume`, and `codex doctor`
- repo-local skill guidance loaded through `~/.codex/AGENTS.md`

That means this stack should treat Codex CLI as command-driven first and slash-command-driven second.

### Codex Slash Command Guidance

For Codex, this repo deliberately does **not** assume custom repo-local slash commands the way Claude does.

| Case                                                         | Recommendation                                                                                       |
| ------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------- |
| You need a stable scripted entrypoint                        | prefer top-level CLI commands like `codex exec`, `codex review`, `codex resume`, `codex doctor`      |
| You are inside an interactive Codex session                  | use normal prompts and local skills from `AGENTS.md`                                                 |
| Your local Codex build exposes interactive slash commands    | treat them as optional convenience features, not as required repo workflow                           |
| You want true reusable Codex slash-command equivalents later | add prompt templates under `codex/commands/`, but document them only after validating client support |

### Suggested Codex CLI Workflow

| Phase                          | Preferred CLI move                    | Example                                                                  |
| ------------------------------ | ------------------------------------- | ------------------------------------------------------------------------ |
| Start a planning session       | open `codex` with a plan-first prompt | `codex "create an implementation plan first for adding SSO to this app"` |
| One-shot architecture analysis | use `codex exec`                      | `codex exec "inspect the repo and summarize the module boundaries"`      |
| Review an existing diff        | use `codex review`                    | `codex review`                                                           |
| Resume ongoing work            | use `codex resume --last`             | `codex resume --last`                                                    |
| Diagnose local setup issues    | use `codex doctor`                    | `codex doctor`                                                           |

### Suggested Codex Workflow

| Situation                             | Suggested usage                                                                          | Why                                                                             |
| ------------------------------------- | ---------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| Cross-file or risky work              | Follow the planner/executor/reviewer model in `AGENTS.md`                                | Keeps execution disciplined instead of jumping straight into edits              |
| General implementation                | Lean on `coding-standards`                                                               | Gives a portable baseline for naming, validation, structure, and error handling |
| Frontend React or Next.js work        | Use `frontend-patterns`                                                                  | Keeps component, state, and accessibility decisions consistent                  |
| Vault CSI or Kubernetes secret wiring | Use `vault-csi`                                                                          | Avoids repeating the same migration mistakes                                    |
| JS/TS cleanup                         | Use `dead-code-cleanup`                                                                  | Establishes baseline validation and safe deletion rules                         |
| Future specialized workflows          | Add `codex/skills/`, `codex/rules/`, `codex/commands/`, or `codex/agents/` and reinstall | Lets the Codex side grow without changing installer behavior                    |

### Example Codex Flow

| Step                     | Example prompt                                                                                                                       |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------ |
| Start CLI session        | `codex`                                                                                                                              |
| Plan-first feature       | `Create an implementation plan first. Inspect repo patterns, list files to change, risks, and validation commands. Do not edit yet.` |
| Implement after approval | `Proceed with the approved plan. Keep the change minimal and validate with the most relevant checks.`                                |
| Frontend task            | `Use the local frontend-patterns skill and implement this settings page in the style of the existing app.`                           |
| Cleanup task             | `Use the dead-code-cleanup skill and remove safe unused TypeScript code in this package.`                                            |

## Recommended Working Style

For both Claude and Codex:

| Stage                 | Recommendation                     |
| --------------------- | ---------------------------------- |
| Before editing        | inspect local patterns first       |
| Before risky changes  | produce a plan                     |
| During implementation | keep changes narrow and reversible |
| After implementation  | run the most relevant checks       |
| Before commit         | do a review pass                   |

## Extending The Stack

### Add A New Claude Item

| Content type | Put files here                        |
| ------------ | ------------------------------------- |
| Agent        | `claude/agents/`                      |
| Rule         | `claude/rules/`                       |
| Skill        | `claude/skills/<skill-name>/SKILL.md` |
| Command      | `claude/commands/`                    |

### Add A New Codex Item

| Content type | Put files here                       |
| ------------ | ------------------------------------ |
| Skill        | `codex/skills/<skill-name>/SKILL.md` |
| Rule         | `codex/rules/`                       |
| Command      | `codex/commands/`                    |
| Agent prompt | `codex/agents/`                      |

After adding new content:

```bash
bash scripts/check.sh
bash scripts/install.sh --target all --backup
```

## Practical Notes

- Keep portable agent logic here, not project-specific product rules.
- Keep project-specific instructions in the project repo.
- Prefer small, composable skills over giant monolithic documents.
- Treat install scripts as production-sensitive dotfiles tooling. Avoid casual breaking changes.

## Current Direction

Right now this repo is still Claude-heavier than Codex-heavier.

That is fine as long as:

- Claude remains the richer orchestration layer
- Codex continues to gain portable skills and structure
- shared patterns are moved into portable forms instead of being trapped in Claude-only wrappers
