# Global Claude Code Instructions

@~/.claude/rules/common/agents.md
@~/.claude/rules/common/code-review.md
@~/.claude/rules/common/coding-style.md
@~/.claude/rules/common/development-workflow.md
@~/.claude/rules/common/git-workflow.md
@~/.claude/rules/common/security.md
@~/.claude/rules/common/performance.md
@~/.claude/rules/common/patterns.md
@~/.claude/rules/common/testing.md

## Operating Model

Use Planner → Executor → Reviewer for non-trivial work. Any role may be Claude, Codex, or another agent — never assume who plays which. Make handoffs agent-neutral unless a target agent is named.

## Handoff Plans

Inspect the repo first. Then: state assumptions and non-goals, order the work into phases, give validation commands, note risks and rollback, list the exact constraints the executor must follow, and end with a concise execution prompt.

## Default Behavior

- A plan-only request → don't implement.
- Review only against the actual diff when a repo is available.
- Make minimal, reversible changes; preserve project conventions; never run destructive commands.
