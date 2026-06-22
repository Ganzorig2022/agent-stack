# Development Workflow

For non-trivial features, refactors, migrations, security work, or unfamiliar code. Skip for typos, formatting, obvious one-file fixes.

1. **Research & reuse** before inventing (see patterns.md): local repo → official docs → package registries → code/web search. Mandatory for unfamiliar APIs, new deps, security-sensitive or architectural work.
2. **Plan** non-trivial work (planner / `/plan`): requirements, assumptions, non-goals, affected files, phases, risks, validation. Proportional — no heavyweight PRD for small fixes.
3. **TDD** testable behavior (tdd-guide / `tdd` skill): red → green → refactor → verify.
4. **Implement** minimal, focused, reversible changes; follow conventions; no unrelated cleanup; update the plan if it conflicts with reality.
5. **Review** meaningful changes against the real diff (see code-review.md).
6. **Validate** — run the most relevant existing checks (test/typecheck/lint/build); report what ran and what didn't; never claim a check passed unless it did.
7. **Document** (doc-updater) when API, CLI, config, or behavior changes.

Done = scope met, edge cases handled, validation run or limitations stated, plus a summary of changed files, results, and remaining risks.
