# Agent Orchestration

Reach for a subagent when a task is well-scoped and would otherwise flood the main thread with search results, logs, or files you won't reread. It works in its own context and returns a summary.

## When to use which

- **planner / architect** — complex features, refactors, migrations, system design, boundaries, tradeoffs.
- **code-reviewer** — after meaningful code changes (use **typescript-reviewer** / **react-reviewer** for TS/React diffs).
- **security-reviewer** — auth, authz, user input, APIs, DB queries, secrets, payments, webhooks, uploads, external URLs, dependency bumps.
- **build-error-resolver** — build, typecheck, bundler, or CI failures.
- **tdd-guide** — test-first behavior. **refactor-cleaner** — behavior-preserving cleanup. **doc-updater** — docs after API/behavior/config changes. **e2e-runner** — only when explicitly asked for Playwright.

Prefer explicit invocation when correctness matters. Launch independent agents in parallel, not in sequence.

## Model strategy

Per-agent `model` in frontmatter is authoritative — do **not** set `CLAUDE_CODE_SUBAGENT_MODEL`, it hard-overrides every agent. Current split: architect/planner on opus; reviewers, tdd, build, refactor, e2e on sonnet; doc-updater on haiku.
