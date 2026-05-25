# Global Claude Code Instructions

@~/.claude/rules/common/agents.md
@~/.claude/rules/common/coding-review.md
@~/.claude/rules/common/coding-style.md
@~/.claude/rules/common/development-workflow.md
@~/.claude/rules/common/git-workflow.md
@~/.claude/rules/common/security.md
@~/.claude/rules/common/performance.md
@~/.claude/rules/common/patterns.md
@~/.claude/rules/common/testing.md

## Operating Model

Use a planner/executor/reviewer workflow for complex work.

- Planner: creates implementation strategy, constraints, phases, risks, and validation.
- Executor: implements the plan.
- Reviewer: audits the resulting diff.

The planner, executor, and reviewer may be Claude, Codex, or another coding agent depending on the user's workflow.

Do not assume Codex is always the executor.
Do not assume Claude is always the planner.
When producing a handoff, make it agent-neutral unless the user names a target agent.

## Agent Usage

- Use the planner agent for complex features, refactors, migrations, architecture changes, and handoff plans.
- Use the architect agent for architecture decisions, system boundaries, module design, and tradeoff analysis.
- Use the code-reviewer agent after meaningful code changes, before commits, and after AI-generated implementation work.
- Use the security-reviewer agent for security-sensitive changes involving auth, authorization, user input, APIs, secrets, payments, webhooks, file uploads, external URLs, or sensitive data.
- Use the build-error-resolver agent for build, typecheck, dependency, bundler, or CI compilation failures.
- Use the refactor-cleaner agent for behavior-preserving cleanup and simplification.
- Use the tdd-guide agent when the user wants test-first implementation guidance.
- Use the doc-updater agent when implementation changes require README, API, docs, examples, or changelog updates.
- Use the e2e-runner agent only when explicitly asked to create, run, maintain, or debug Playwright E2E tests.

Prefer explicit agent invocation when correctness matters.

## Handoff Plans

When creating a handoff plan for another agent:

- inspect relevant repository structure first
- identify files to inspect and likely files to modify
- state assumptions and non-goals
- break work into ordered phases
- include tests and validation commands
- include risks and rollback notes
- include exact constraints the executor must follow
- end with a concise execution prompt

## Default Behavior

- Do not implement when the user asks only for a plan.
- Do not review code changes without inspecting the actual diff when a repository is available.
- Do not run destructive commands.
- Prefer minimal, reversible changes.
- Preserve existing project conventions unless the user asks to change them.
  EOF
