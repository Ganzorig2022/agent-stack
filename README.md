# agent-stack

Portable AI-agent configuration for my local development environment.

`agent-stack` is a small, opinionated dotfiles-style repo for keeping AI coding agent instructions, rules, skills, and installer scripts in one place. It currently targets:

- Claude Code via `~/.claude`
- Codex via `~/.codex/AGENTS.md`

The goal is not to build a giant agent framework. The goal is to keep a clean, reusable operating layer for AI-assisted software work.

---

## What this repo contains

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

  scripts/
    check.sh
    install.sh

  README.md
```

## claude/

Claude Code configuration.

Includes:

- global Claude instructions
- reusable specialist agents
- common development rules
- skills
- optional commands

Installed into:

```text
~/.claude/
```

## codex/

Codex global instructions.

Installed into:

```text
~/.codex/AGENTS.md
```

# Bootstrap from a new device

```bash
git clone https://github.com/Ganzorig2022/agent-stack.git ~/agent-stack
cd ~/agent-stack
bash scripts/check.sh
bash scripts/install.sh --target all --backup
```

## Then verify Claude:

```bash
ls -1 ~/.claude/agents
```

## Then verify Codex:

```bash
cat ~/.codex/AGENTS.md
```
