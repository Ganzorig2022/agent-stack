# Coding Style

## Principles
- **KISS / DRY / YAGNI** — simplest thing that works; extract real (not speculative) repetition; don't build ahead of need. Clarity over cleverness.
- **Immutability** — don't mutate function inputs, framework/store state, or shared/cached objects. Local mutation confined to a function is fine. Language idioms win.

## Structure
- Many focused files over few large ones; high cohesion, low coupling. ~200–400 lines typical, 800 soft max.
- Early returns over deep nesting. Named constants over magic numbers. Split long functions.

## Naming
`camelCase` vars/functions; `is/has/should/can` booleans; `PascalCase` types/components; `UPPER_SNAKE_CASE` constants; `use`-prefixed hooks. Language idioms override these.

## Errors & input
- Handle errors explicitly; never silently swallow. User-friendly messages out; diagnostic context in logs; never leak secrets, tokens, or stack traces.
- Validate at boundaries (user input, external API responses); prefer schema validation; fail fast.
