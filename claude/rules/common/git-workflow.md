# Git Workflow

Commit format: `<type>: <description>` then an optional body. Types: feat, fix, refactor, docs, test, chore, perf, ci.

Commit or push only when explicitly asked; branch first if on the default branch.

PRs: analyze the full commit range (`git diff <base>...HEAD`), not just the latest commit. Write a real summary and a test plan. Push new branches with `-u`.

For the full process (plan → TDD → review) before git operations, see development-workflow.md.
