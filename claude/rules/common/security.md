# Security

## Always
- No hardcoded secrets — use env vars or a secret manager; validate required secrets at startup.
- Validate all external input. Parameterized queries (no SQL/NoSQL injection). Sanitize HTML (XSS). Enforce CSRF protection, authz on every sensitive path, and rate limits on endpoints. Verify webhooks.
- Never let error messages leak secrets, tokens, or internals.

## If a security issue is found
Stop, invoke **security-reviewer**, fix CRITICAL before continuing, rotate any exposed secret, then sweep the codebase for the same pattern.
