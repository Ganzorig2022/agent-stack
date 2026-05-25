mkdir -p claude/rules/common

cat > claude/rules/common/code-review.md <<'EOF'
# Code Review Standards

## Purpose

Code review exists to catch correctness issues, regressions, security risks, missing tests, maintainability problems, and unnecessary complexity before changes are considered complete.

This rule defines when to review, what to check, and how to classify findings.

## When to Review

Use code review after meaningful code changes, especially when changes involve:

- production code
- business logic
- API behavior
- authentication or authorization
- user input
- database queries
- file uploads/downloads
- payments or financial logic
- webhooks
- external API calls
- dependency changes
- architecture or module boundaries
- cross-file refactors
- AI-generated implementation work

Review is usually unnecessary for:

- typo-only changes
- comments-only changes
- formatting-only changes
- docs-only changes with no behavior impact
- trivial one-line local changes with no meaningful risk

Before commits or merges, review the actual diff.

## Pre-Review Requirements

Before declaring code ready for review:

- inspect `git status`
- inspect staged and unstaged diffs when available
- resolve obvious merge conflicts
- run relevant tests/checks or explain why they were not run
- ensure unrelated changes are not mixed into the diff

Do not claim CI, tests, lint, typecheck, or build passed unless actually verified.

## Review Checklist

Check the changed code for:

- [ ] Code is readable and well-named.
- [ ] Functions are focused and understandable.
- [ ] Files remain cohesive.
- [ ] Control flow avoids unnecessary deep nesting.
- [ ] Errors are handled explicitly.
- [ ] Boundary input is validated.
- [ ] No hardcoded secrets, credentials, tokens, or private keys.
- [ ] No debug logging, `console.log`, or temporary instrumentation left in production paths.
- [ ] Tests exist or are updated for meaningful behavior changes.
- [ ] Existing behavior is preserved unless intentionally changed.
- [ ] Project conventions are followed.
- [ ] No unrelated rewrites or speculative abstractions were introduced.

Numeric thresholds such as function length, file length, and coverage are project-specific. Use project rules if present; otherwise treat thresholds as guidance, not automatic blockers.

## Security Review Triggers

Stop and use the security-reviewer agent when changes involve:

- authentication
- authorization
- user input handling
- API endpoints
- database queries
- file system operations
- file uploads/downloads
- external API calls
- external URLs or SSRF surfaces
- cryptographic operations
- session, JWT, or cookie handling
- payment or financial code
- webhooks
- secrets or sensitive data
- dependency updates

Security findings must be evidence-based. Do not inflate severity without a concrete exploit path or failure mode.

## Agent Usage

Use the available agents according to scope:

| Agent | Use For |
|---|---|
| `code-reviewer` | General code quality, correctness, regressions, tests, maintainability |
| `security-reviewer` | Security vulnerabilities, OWASP risks, secrets, auth, injection, SSRF, unsafe crypto |
| `build-error-resolver` | Build, typecheck, bundler, dependency, or CI compilation failures |
| `refactor-cleaner` | Behavior-preserving cleanup, simplification, and structure improvements |
| `tdd-guide` | Test-first strategy and coverage for new or changed behavior |
| `doc-updater` | Documentation updates after behavior, API, config, or usage changes |

Do not reference unavailable language-specific reviewer agents unless they are installed.

## Review Workflow

1. Inspect the actual diff:
   - `git status`
   - `git diff`
   - `git diff --staged`

2. Understand the scope:
   - changed files
   - changed behavior
   - affected call sites
   - affected tests
   - user-visible or security-sensitive impact

3. Read surrounding context:
   - imports
   - callers
   - validation
   - error handling
   - tests
   - configuration

4. Check security-sensitive areas first.

5. Check correctness and regression risk.

6. Check tests and validation coverage.

7. Check maintainability and project conventions.

8. Report only actionable findings.

## Review Severity Levels

| Level | Meaning | Action |
|---|---|---|
| CRITICAL | Confirmed security vulnerability, data loss, auth bypass, RCE, payment/financial corruption, or severe production breakage | BLOCK: must fix before merge |
| HIGH | Likely bug, serious regression risk, missing auth/validation in sensitive path, or major maintainability issue | SHOULD FIX before merge unless explicitly accepted |
| MEDIUM | Maintainability, test coverage, edge-case, or robustness issue with realistic but limited risk | Consider fixing before merge |
| LOW | Minor style, naming, clarity, or small cleanup suggestion | Optional |
| INFO | Observation or non-blocking note | No action required |

Do not inflate severity. Severity inflation makes review output less useful.

## Evidence Requirements

For each finding, include:

- file and line/function when available
- concrete problem
- realistic failure mode or risk
- recommendation
- confidence level

For HIGH and CRITICAL findings, include:

- exact trigger or exploit path
- impact
- why existing guards are insufficient

Drop vague findings that cannot cite a concrete location or failure mode.

## Common Issues to Catch

### Security

- hardcoded credentials
- SQL/NoSQL injection
- shell command injection
- XSS via unsafe HTML rendering
- path traversal
- missing auth or authorization checks
- unverified webhooks
- insecure CORS with credentials
- sensitive data in logs
- unsafe external URL fetches
- weak password hashing or crypto misuse

### Correctness

- broken edge cases
- incorrect null/undefined handling
- race conditions
- missing idempotency for retries/webhooks
- incorrect error handling
- behavior changes not reflected in tests
- API contract regressions
- state mutation where immutable update is required

### Code Quality

- large or unfocused functions
- large or incohesive files
- deep nesting that obscures logic
- duplicated logic that is likely to drift
- speculative abstractions
- unclear names
- dead code
- commented-out code
- temporary debug statements

### Performance

- N+1 queries on unbounded datasets
- missing pagination or limits
- unbounded memory growth
- blocking synchronous I/O in async/server paths
- repeated expensive computation without caching where it matters
- excessive client bundle growth

Performance findings should explain why the cost matters in this code path.

## Approval Criteria

Use these verdicts:

- **APPROVE**: No confirmed CRITICAL or HIGH issues.
- **WARNING**: HIGH issues exist, but no confirmed CRITICAL issues. Merge only if the risk is explicitly accepted.
- **BLOCK**: Any confirmed CRITICAL issue exists.

Do not block on speculative issues, low-value nits, or project preferences not stated in the repo.

## Integration with Other Rules

This rule works with:

- `testing.md` for test expectations
- `security.md` for security checklist
- `git-workflow.md` for commit and PR discipline
- `development-workflow.md` for the broader implementation pipeline

When rules conflict, prefer the more specific project-level rule over global common rules.
EOF