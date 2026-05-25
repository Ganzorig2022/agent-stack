# Development Workflow

This rule defines the default feature-development pipeline before final git operations.

Use this workflow for non-trivial features, refactors, migrations, architecture changes, security-sensitive work, and unfamiliar codebases.

Do not apply the full workflow mechanically to tiny edits, typo fixes, formatting-only changes, or obvious one-file fixes.

## Core Workflow

1. Research and reuse when needed.

2. Plan before implementation.

3. Prefer test-aware or TDD development.

4. Review after meaningful code changes.

5. Run validation checks.

6. Summarize clearly.

7. Commit only when explicitly asked.

## 0. Research and Reuse

Research is mandatory when work involves:

- unfamiliar APIs or libraries

- new dependencies

- security-sensitive behavior

- architecture decisions

- external integrations

- unclear requirements

- implementing something likely to have established patterns

Research is optional for:

- small local fixes

- simple refactors

- project-specific glue code

- obvious changes using existing local patterns

Research priority:

1. **Local repository first**

   - Search the current codebase for existing patterns.

   - Prefer consistency with local conventions over external examples.

   - Inspect similar modules, tests, routes, components, and utilities.

2. **Primary documentation second**

   - Use official/vendor docs for API behavior, version-specific details, and supported patterns.

   - Prefer primary sources over blog posts.

3. **Package registries when dependency choice matters**

   - Check npm, PyPI, crates.io, Go packages, or other relevant registries before writing reusable infrastructure.

   - Prefer established libraries when the problem is generic and security-sensitive.

   - Avoid adding dependencies for trivial utilities.

4. **GitHub/code search when useful and available**

   - Use GitHub search only when examples or implementation patterns would reduce risk.

   - Do not use external code blindly.

   - Respect licenses and avoid copying incompatible code.

5. **Broader web research last**

   - Use broader web research only when local code, primary docs, and package registries are insufficient.

Do not block progress if external research tools are unavailable. State the limitation and proceed from local context where reasonable.

## 1. Plan First

Use the planner agent for:

- complex features

- architecture changes

- cross-file refactors

- migrations

- security-sensitive changes

- unfamiliar codebases

- work that will be handed to another agent/session

A useful plan includes:

- requirements

- assumptions

- non-goals

- affected files/modules

- files to inspect first

- likely files to modify

- implementation phases

- dependencies

- risks and mitigations

- validation commands

- testing strategy

- handoff prompt when another agent/session will execute

Planning should be proportional. Do not create heavyweight PRDs for simple fixes.

## 2. Test-Aware Development / TDD

Prefer TDD when the behavior is clear and testable.

Use the tdd-guide agent when:

- implementing new business logic

- fixing a bug with a reproducible failure

- adding validation rules

- changing API behavior

- refactoring behavior that must be preserved

TDD loop:

1. RED: write or identify failing test.

2. GREEN: implement the smallest change that passes.

3. IMPROVE: refactor without changing behavior.

4. VERIFY: run relevant tests/checks.

Do not force TDD when:

- exploring an unknown codebase

- doing mechanical docs work

- making tiny config changes

- test setup does not exist and adding it would be larger than the change

Coverage targets are project-specific. Do not invent an 80% requirement unless the project already has that policy.

## 3. Implementation Discipline

During implementation:

- make minimal, focused changes

- follow existing project conventions

- preserve stated non-goals

- avoid unrelated cleanup

- avoid broad rewrites unless explicitly justified

- keep changes reversible

- validate assumptions against existing code

If a plan conflicts with repository reality, update the plan instead of forcing the implementation.

## 4. Code Review

Use the code-reviewer agent after meaningful code changes.

Review focus:

- correctness

- regressions

- security risks

- missing tests

- maintainability

- unnecessary complexity

- project convention violations

Address:

- CRITICAL issues before merge

- HIGH issues before merge unless explicitly accepted

- MEDIUM issues when practical

- LOW/nit issues only when they provide clear value

Do not manufacture findings to appear rigorous.

## 5. Security Review

Use the security-reviewer agent when changes involve:

- authentication

- authorization

- user input

- API endpoints

- database queries

- file uploads/downloads

- payments

- webhooks

- external URLs

- secrets

- sensitive data

- dependency updates

Security findings must be evidence-based and include concrete impact.

## 6. Validation Checks

Before marking work complete:

- run the most relevant available checks

- prefer existing package scripts

- use the project’s package manager

- report commands run and results

- report commands not run and why

Examples of relevant checks:

- tests

- typecheck

- lint

- build

- dependency audit for security-sensitive work

- E2E tests only for critical browser journeys or when explicitly requested

Never claim a check passed unless it was actually run.

## 7. Documentation

Use the doc-updater agent when implementation changes affect:

- README setup or usage

- API behavior

- CLI behavior

- configuration

- environment variables

- migration steps

- examples

- changelog/release notes

Do not update docs for invisible internal changes unless documentation would prevent future mistakes.

## 8. Commit and Push

Do not commit or push unless the user explicitly asks.

When asked to commit:

- inspect `git status`

- inspect staged and unstaged changes

- keep commits focused

- use conventional commits when appropriate

- include meaningful commit messages

- do not include secrets or unrelated changes

For commit message and PR process, follow `git-workflow.md`.

## 9. Pre-Review Checks

Before saying work is ready for review:

- relevant tests/checks have passed or failures are explained

- merge conflicts are resolved or called out

- branch status is understood when relevant

- critical/high review findings are addressed or explicitly accepted

- docs are updated if behavior or usage changed

## Done Criteria

Work is done only when:

- requested scope is satisfied

- unrelated changes are avoided

- meaningful edge cases are handled

- relevant validation was run or limitations are stated

- review findings are addressed based on severity

- final summary includes changed files, validation, and remaining risks