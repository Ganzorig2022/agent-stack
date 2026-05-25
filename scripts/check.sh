#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() {
  echo "FAIL: $1"
  exit 1
}

ok() {
  echo "OK: $1"
}

check_skill_layout() {
  local root="$1"
  local label="$2"

  if [ -d "$root" ]; then
    while IFS= read -r -d '' skill_dir; do
      [ -f "$skill_dir/SKILL.md" ] || fail "skill directory missing SKILL.md: ${skill_dir#$ROOT/}"
    done < <(find "$root" -mindepth 1 -maxdepth 1 -type d -print0)

    local flat_skill_count
    flat_skill_count="$(find "$root" -maxdepth 1 -type f -name "*.md" | wc -l | tr -d ' ')"
    [ "$flat_skill_count" = "0" ] || fail "flat .md files found in ${root#$ROOT/}; use skill-name/SKILL.md"
  fi

  ok "$label skills layout"
}

[ -d "$ROOT/claude" ] || fail "missing claude/"
[ -f "$ROOT/claude/CLAUDE.md" ] || fail "missing claude/CLAUDE.md"
[ -d "$ROOT/claude/agents" ] || fail "missing claude/agents/"
[ -d "$ROOT/codex" ] || fail "missing codex/"
[ -f "$ROOT/codex/AGENTS.md" ] || fail "missing codex/AGENTS.md"

ok "base directories"

expected_agents=(
  architect.md
  build-error-resolver.md
  code-reviewer.md
  doc-updater.md
  e2e-runner.md
  planner.md
  refactor-cleaner.md
  security-reviewer.md
  tdd-guide.md
)

for agent in "${expected_agents[@]}"; do
  file="$ROOT/claude/agents/$agent"
  [ -f "$file" ] || fail "missing claude/agents/$agent"

  first_line="$(head -n 1 "$file")"
  [ "$first_line" = "---" ] || fail "$agent does not start with YAML frontmatter"

  grep -q "^name:" "$file" || fail "$agent missing name:"
  grep -q "^description:" "$file" || fail "$agent missing description:"
  grep -q "^tools:" "$file" || fail "$agent missing tools:"
done

ok "Claude agents"

if [ -d "$ROOT/claude/skills" ]; then
  check_skill_layout "$ROOT/claude/skills" "Claude"
else
  ok "Claude skills layout"
fi

check_skill_layout "$ROOT/codex/skills" "Codex"

echo "Check complete."
