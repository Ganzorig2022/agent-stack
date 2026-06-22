# Performance & Context Discipline

## Model & effort
Run the main session on the latest capable model (currently Opus 4.8); let agents pick their own model via frontmatter (see agents.md). Tune `effortLevel` to match task depth instead of capping thinking tokens.

## Context window
Context is the scarce resource. Keep always-on instructions lean; push procedures to skills and exploration to subagents so they load only when relevant. For large multi-file work, start fresh rather than pushing into a saturated window.

## Cost
Route mechanical work (cleanup, docs, build fixes) to cheaper models; reserve deep reasoning for architecture, security, and planning.
