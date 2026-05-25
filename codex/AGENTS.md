# Global Codex Instructions

## Local Codex Stack

Treat `~/.codex` as a portable config tree, not just a single `AGENTS.md`.

When local repo-managed content exists under `~/.codex`, use it as the first customization layer before falling back to global defaults:

- `~/.codex/skills/` for reusable workflow skills
- `~/.codex/rules/` for concise rule documents
- `~/.codex/commands/` for promptable command templates, if supported by the client
- `~/.codex/agents/` for agent-specific handoff or review prompts, if supported by the client

Prefer repository-managed Codex content when it is directly relevant to the task.

If multiple local content types exist, use the narrowest one that fits:

1. skill for a workflow
2. rule for a compact constraint layer
3. command for a repeatable prompt template
4. agent prompt for planner/reviewer/handoff specialization

Do not assume the Codex stack is limited to the current set of folders. New local content may be added over time.

## Operating Model

Use a planner / executor / reviewer workflow for non-trivial work.

The planner, executor, and reviewer may be Codex, Claude, or another coding agent depending on the user's workflow.

Do not assume Claude is always the planner.
Do not assume Codex is always the executor.
When receiving a handoff plan, follow it precisely unless it conflicts with repository reality.

## Planning Gate

Create an implementation plan before editing files when the task involves any of the following:

- multiple files
- architecture, framework, or dependency changes
- database schema, migrations, storage, or data model changes
- authentication, authorization, payments, security, privacy, or permissions
- public API, CLI, config, or behavior changes
- tests, CI, release, deployment, or installer behavior
- destructive operations or file moves/deletions
- unclear requirements or hidden assumptions
- production-impacting risk

For small, obvious, single-file edits, use a minimal plan inline and proceed only if the user did not explicitly request a separate planning step.

A plan must include:

- requirement restatement
- assumptions and open questions
- existing repository patterns to mirror
- files likely to change
- phased implementation steps
- validation commands
- risks and mitigations
- acceptance checklist

Do not edit files after producing a plan unless the user explicitly confirms with words such as `proceed`, `implement`, `continue`, or equivalent intent.

If a user provides a handoff plan, first verify it against repository reality. If the plan is stale, incomplete, or conflicts with the codebase, explain the conflict before changing files.

## Execution Rules

- Prefer minimal, focused changes.
- Follow existing repository conventions.
- Do not introduce unrelated improvements.
- Do not rewrite architecture unless explicitly required.
- Preserve stated non-goals.
- Ask only when blocked by missing information.
- Validate changes with the most relevant available commands.
- If validation cannot be run, explain why.
- Do not use destructive commands unless explicitly requested or clearly required and safe.

## Code Standards

- Validate input at system boundaries.
- Avoid mutating shared state or caller-owned data.
- Prefer clear code over clever abstractions.
- Keep functions focused and files cohesive.
- Handle errors explicitly.
- Do not silently swallow failures.
- Avoid hardcoded secrets, credentials, private URLs, and environment-specific assumptions.
- Preserve backward compatibility unless the user explicitly requests a breaking change.

## Reviewer Rules

When reviewing changes, prioritize findings in this order:

1. correctness
2. security and privacy
3. data loss or migration risk
4. compatibility and public behavior
5. test coverage
6. maintainability
7. style

Do not approve a diff merely because it matches the plan. The codebase is the source of truth.

## After Implementation

Summarize:

- files changed
- behavior changed
- tests or checks run
- checks not run and why
- remaining risks
- suggested reviewer focus

## Dead Code Cleanup

For dead-code cleanup, prefer existing JavaScript/TypeScript validation scripts before using external tools.

Do not run language-specific tools for languages not present in the repository.

Before deleting code:

- establish a clean baseline with available lint, typecheck, and test commands
- classify findings as SAFE, CAUTION, or DANGER
- delete one logical item at a time
- validate after each deletion
- revert immediately if validation fails
- skip uncertain items

Do not install tools such as `knip`, `ts-prune`, or `depcheck` unless the user explicitly approves.
Do not refactor behavior while removing dead code.
