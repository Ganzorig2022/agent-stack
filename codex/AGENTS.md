cat > codex/AGENTS.md <<'EOF'
# Global Codex Instructions

## Operating Model

Use a planner/executor/reviewer workflow for complex work.

- Planner: creates implementation strategy, constraints, phases, risks, and validation.
- Executor: implements the plan.
- Reviewer: audits the resulting diff.

The planner, executor, and reviewer may be Codex, Claude, or another coding agent depending on the user's workflow.

Do not assume Claude is always the planner.
Do not assume Codex is always the executor.
When receiving a handoff plan, follow it precisely unless it conflicts with repository reality.

## Execution Rules

- Prefer minimal, focused changes.
- Follow existing repository conventions.
- Do not introduce unrelated improvements.
- Do not rewrite architecture unless explicitly required.
- Preserve stated non-goals.
- Ask only when blocked by missing information.
- Validate changes with the most relevant available commands.
- If validation cannot be run, explain why.

## Code Standards

- Validate input at system boundaries.
- Avoid mutating shared state or caller-owned data.
- Prefer clear code over clever abstractions.
- Keep functions focused and files cohesive.
- Handle errors explicitly.
- Do not silently swallow failures.
- Avoid hardcoded secrets, credentials, private URLs, and environment-specific assumptions.

## After Implementation

Summarize:

- files changed
- behavior changed
- tests or checks run
- checks not run and why
- remaining risks
- suggested reviewer focus
EOF