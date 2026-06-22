# Research & Reuse

Before implementing unfamiliar or high-risk functionality (new apps, auth, payments, uploads, webhooks, integrations, infra, cross-file changes), prefer proven local patterns and battle-tested references over inventing architecture.

Order: (1) search the local repo, (2) official docs for APIs/version behavior, (3) package registries when dependency choice matters, (4) code/GitHub search when examples reduce risk, (5) broader web only when the above fall short.

Evaluate dependencies on security posture, maintenance, compatibility, simplicity, testability, and licensing. Prefer the smallest viable proven structure; don't clone a large skeleton unless the task needs it. Skip this ritual for typos, formatting, and small utilities.
