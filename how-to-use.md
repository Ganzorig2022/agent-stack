# How to Use This Agent Stack — CLI Guide

> CLI-first. No apps. Both Claude Code and Codex via terminal.

---

## Quick Reference

```bash
# Claude Code
claude                        # interactive session in current repo
claude "prompt here"          # one-shot with prompt
claude -c                     # resume most recent session
claude -r                     # pick from previous sessions
claude -p "prompt"            # non-interactive, prints output
claude --agent planner        # launch specific agent directly

# Codex
codex                         # interactive session
codex "prompt here"           # one-shot
codex exec "prompt"           # non-interactive
codex review                  # code review on current diff
codex resume --last           # resume last session
codex doctor                  # check local setup health
```

---

## Mental Model

```
Skills      = passive knowledge layer (always loaded, activated by context or explicit invocation)
Agents      = specialized sub-agents Claude can spawn (planner, architect, tdd-guide, etc.)
Commands    = slash commands you invoke explicitly (/plan, /refactor-clean)
Rules       = always-on behavioral constraints (coding style, git workflow, etc.)
```

Skills don't self-trigger in Codex. In Claude, they self-trigger when the SKILL.md's
"When to Activate" conditions match — or you invoke them explicitly.

**Explicit invocation pattern:**

```
# Claude
"use the docker-patterns skill and write a production Dockerfile for this Node.js app"
"apply dart-flutter-patterns and review this widget"

# Codex
"using the docker-patterns skill, ..."
```

---

## Installed Skills — When to Use Each

### Daily Stack (Node.js / Next.js / Express / Fastify)

| Skill                 | Trigger                                                | How to invoke                                      |
| --------------------- | ------------------------------------------------------ | -------------------------------------------------- |
| `backend-patterns`    | Writing Express/Fastify routes, middleware, API design | auto-triggers on Node.js backend work              |
| `nextjs-turbopack`    | Next.js 15-16 bundling, Turbopack config, slow builds  | auto-triggers on Next.js config/performance        |
| `docker-patterns`     | Writing Dockerfiles, Compose files, deploy pipeline    | auto-triggers when touching Docker files           |
| `github-ops`          | PR triage, CI status, release cuts, stale issues       | `"use github-ops to triage open PRs"`              |
| `mcp-server-patterns` | Building a custom MCP server (like Figma MCP)          | `"use mcp-server-patterns and build a tool for X"` |
| `codebase-onboarding` | First session in an unfamiliar repo                    | `"use codebase-onboarding on this repo"`           |

### Agent / Token Efficiency

| Skill                          | Trigger                                              | How to invoke                                       |
| ------------------------------ | ---------------------------------------------------- | --------------------------------------------------- |
| `context-budget`               | Session feels slow or expensive, before long task    | `"run context-budget audit before we start"`        |
| `cost-aware-llm-pipeline`      | Designing agent pipelines, choosing models per task  | auto-triggers when writing LLM routing code         |
| `cost-tracking`                | Check spend by project or session                    | `"show cost breakdown for this week"`               |
| `autonomous-loops`             | Designing a multi-step agent pipeline                | `"use autonomous-loops to architect this workflow"` |
| `continuous-agent-loop`        | Running a loop that needs quality gates and recovery | `"apply continuous-agent-loop patterns here"`       |
| `parallel-execution-optimizer` | Task can be split into independent parts             | `"use parallel-execution-optimizer on this task"`   |
| `agent-architecture-audit`     | Agent pipeline misbehaves, loops, loses context      | `"audit my agent architecture"`                     |
| `verification-loop`            | After any meaningful implementation, before commit   | auto-triggers after implementation                  |

### Mobile (Flutter — before June 2)

| Skill                      | Trigger                                               | How to invoke                               |
| -------------------------- | ----------------------------------------------------- | ------------------------------------------- |
| `dart-flutter-patterns`    | Any Flutter/Dart code — state, routing, network, arch | auto-triggers on `.dart` files              |
| `flutter-dart-code-review` | Review pass on Flutter PR or before merge             | `"run flutter-dart-code-review on this PR"` |

### Research & Design

| Skill                       | Trigger                                                      | How to invoke                                             |
| --------------------------- | ------------------------------------------------------------ | --------------------------------------------------------- |
| `deep-research`             | Research before building, tech eval, competitive analysis    | `"deep research: best state management for Flutter 2026"` |
| `frontend-design-direction` | UI task from Figma handoff, building a new page              | auto-triggers on frontend UI work                         |
| `motion-patterns`           | Animations in Next.js/React (modal, toast, page transitions) | `"use motion-patterns for this transition"`               |
| `security-bounty-hunter`    | Security audit your own repo before deploy                   | `"security-bounty-hunter on this repo"`                   |

---

## Chain-Reaction Workflows

Chains are: trigger → skill → artifact → next trigger → skill → artifact.
Start the first skill explicitly; subsequent ones can auto-trigger from their conditions.

### Chain 1: New Feature (your daily pattern)

```
cd my-project
claude

> /plan add optimistic UI for ticket updates

# Claude uses planner agent → produces approved plan

> Implement the approved plan. Follow existing patterns, minimal change.

# After implementation:
> Run verification-loop on the changes.

# Before commit:
> Code review on current diff, findings by severity.

# If auth/API involved:
> security-review on the auth changes.
```

### Chain 2: Joining a New Project

```
cd unknown-repo
claude

> Use codebase-onboarding. Generate architecture map and a starter CLAUDE.md.

# Now you have: entry points, conventions, module map
# Then continue with any feature work — context is established
```

### Chain 3: Flutter Mobile (from June 2)

```
cd mobile-app
claude

> Use codebase-onboarding on this Flutter repo.

# First feature:
> Use dart-flutter-patterns and implement [feature] with Riverpod state management.

# Before PR:
> Run flutter-dart-code-review on the changed files.
```

### Chain 4: Agent/Token Efficiency Audit

```
claude

> Run context-budget audit — what's eating our context window?

# Produces: ranked list of bloat (rules, skills, agents, MCPs)

> Based on that, apply cost-aware-llm-pipeline patterns to route cheaper
> models for sub-tasks. Show me the routing table.

# Then for the implementation:
> Use parallel-execution-optimizer — split the independent tasks and
> run them concurrently.
```

### Chain 5: Performance — "Make This Faster"

```
claude

> Use parallel-execution-optimizer on this data pipeline task.

# If you want to measure and compare:
> Benchmark current vs proposed. Show latency and cost delta.
```

### Chain 6: MCP Server (build your own tool)

```
claude

> deep research: what MCP tools exist for [X domain]?

# If nothing fits:
> Use mcp-server-patterns and build an MCP server for [X].
> TypeScript, stdio transport, Zod validation on all tools.
```

### Chain 7: Security Before Deploy

```
claude -p "security-bounty-hunter on this repo. Focus on API routes and auth." > security-report.md
cat security-report.md
```

---

## Claude vs Codex — When to Use Which

| Use Claude when                           | Use Codex when                         |
| ----------------------------------------- | -------------------------------------- |
| Planning, orchestration, chaining skills  | Pure focused implementation            |
| Cross-file reasoning and architecture     | Single-file or small-scope edits       |
| Security/arch review passes               | Fast iteration, tight feedback loop    |
| Long context: reading many files at once  | Autonomous execution without guidance  |
| Spawning sub-agents (planner, reviewer)   | Code-only tasks, no research needed    |
| Memory/context management across sessions | You want raw speed                     |
| Session involves skills + rules + agents  | Task is well-defined with no ambiguity |

**Best-of-two-worlds loop:**

```
# Claude plans
claude "create an implementation plan for [feature]. inspect repo first, list risks."

# Codex executes
codex "implement the plan in plan.md. keep changes minimal, follow existing patterns."

# Claude reviews
claude "run code review on current diff. findings by severity. block on CRITICAL/HIGH."
```

---

## Claude CLI Patterns You'll Use Daily

```bash
# Start fresh in current repo
claude

# One-shot review (non-interactive, good for CI or scripting)
claude -p "review the current diff for security issues" > review.md

# Resume last session (continuity across terminal restarts)
claude -c

# Pick a specific previous session
claude -r

# Launch a specific agent directly
claude --agent architect
claude --agent planner
claude --agent tdd-guide

# Run a slash command immediately on start
claude "/plan add rate limiting to all API routes"
```

## Codex CLI Patterns You'll Use Daily

```bash
# One-shot implementation
codex "add input validation to all Express routes in src/routes/"

# Non-interactive exec (scriptable)
codex exec "inspect the repo and list all API endpoints with their auth requirements"

# Review current diff
codex review

# Resume last session
codex resume --last

# Check setup
codex doctor
```

---

## Adding New Skills to This Repo

```bash
# 1. Create the skill file
mkdir -p claude/skills/my-skill
# write claude/skills/my-skill/SKILL.md

# 2. If agent-neutral, also add for Codex
mkdir -p codex/skills/my-skill
cp claude/skills/my-skill/SKILL.md codex/skills/my-skill/SKILL.md

# 3. Validate
bash scripts/check.sh

# 4. Install
bash scripts/install.sh --target all --backup
```

**Agent-neutral** = no `Agent(`, `subagent_type`, `TaskCreate`, or Claude-specific tool calls in the SKILL.md.
If it only contains patterns, checklists, and workflows → safe for both agents.

---

## Skill Decision Tree

```
Starting a task?
│
├── Unfamiliar repo → codebase-onboarding first
│
├── Non-trivial feature / refactor → /plan first, then implement
│
├── Flutter/Dart work → dart-flutter-patterns active throughout
│
├── Node.js/Express/Fastify API → backend-patterns active
│
├── Next.js frontend → nextjs-turbopack + frontend-design-direction
│
├── Animation/motion work → motion-patterns
│
├── Docker/deploy → docker-patterns
│
├── Building MCP tool → mcp-server-patterns
│
├── Agent pipeline slow/broken → context-budget + agent-architecture-audit
│
├── Pre-deploy security → security-bounty-hunter
│
└── After implementation → verification-loop → code-reviewer agent
```

---

## Chaining in One CLI Command (non-interactive)

```bash
# Research → plan → report (all in one non-interactive run)
claude -p "
1. Use deep-research: what are the best Flutter state management libraries in 2026?
2. Based on findings, recommend one for a new mobile app (medium complexity, team of 3).
3. Output a decision record in ADR format.
" > docs/adr/flutter-state-management.md

# Security scan on current repo, save report
claude -p "use security-bounty-hunter on this repo. Output severity-ranked findings." > security-$(date +%Y%m%d).md

# Onboard to a new repo and create CLAUDE.md
claude -p "use codebase-onboarding. Generate a CLAUDE.md for this repo." > CLAUDE.md
```

---

## Context Window Tips (token efficiency)

```
# Before a long session, trim context
> Run context-budget audit. What can we remove or compress?

# Route sub-tasks to cheaper models
> For the repetitive file edits, use haiku-class operations.
> Reserve sonnet/opus for planning and review.

# Keep sessions focused
# One session = one feature or one concern
# Use claude -c to resume rather than re-explaining context
# Use /handoff to pass context between sessions without re-reading all files
```

---

## Bootstrapping on a New Machine

```bash
git clone https://github.com/Ganzorig2022/agent-stack.git ~/agent-stack
cd ~/agent-stack
bash scripts/check.sh
bash scripts/install.sh --target all --backup

# Verify
ls ~/.claude/skills | wc -l    # should be 20+
ls ~/.claude/agents | wc -l    # should be 9
ls ~/.claude/commands           # plan, refactor-clean
```
