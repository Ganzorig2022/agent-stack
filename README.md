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
