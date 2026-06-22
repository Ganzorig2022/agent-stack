# Code Review

Review meaningful changes (business logic, APIs, auth, input, queries, uploads, payments, webhooks, deps, cross-file refactors, AI-generated code) with **code-reviewer**, plus **security-reviewer** for sensitive paths. Skip for typos, comments, or formatting only.

Review the real diff (`git status` + staged/unstaged); don't mix unrelated changes. Never claim tests/lint/build passed unless actually run.

Severity → action: **CRITICAL** (vuln, data loss, auth bypass, RCE, payment corruption) blocks merge; **HIGH** (likely bug, missing auth/validation in a sensitive path) fix before merge; **MEDIUM** (maintainability, coverage, edge cases) fix when practical; **LOW** optional.

Each finding: `file:line`, the failure mode, a concrete fix, and confidence. Security findings need a concrete exploit path — don't inflate severity without one.
