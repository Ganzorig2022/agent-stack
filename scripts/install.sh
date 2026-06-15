#!/usr/bin/env bash
set -euo pipefail

TARGET="all"
MODE="skip"
DRY_RUN="false"
PRUNE="false"
RUN_TS="$(date +%Y%m%d%H%M%S)"

usage() {
  cat <<USAGE
Usage: scripts/install.sh [options]

Options:
  --target claude|codex|all   Install target. Default: all
  --skip                      Skip existing files. Default
  --backup                    Backup existing files before overwriting
  --force                     Overwrite existing files without backup
  --prune                     Remove live agents/rules/commands not in the repo (skills left intact)
  --dry-run                   Print actions without changing files
  -h, --help                  Show help

Examples:
  bash scripts/install.sh --target claude --backup
  bash scripts/install.sh --target codex --force
  bash scripts/install.sh --target all --dry-run
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --target)
      TARGET="${2:-}"
      shift 2
      ;;
    --skip)
      MODE="skip"
      shift
      ;;
    --backup)
      MODE="backup"
      shift
      ;;
    --force)
      MODE="force"
      shift
      ;;
    --prune)
      PRUNE="true"
      shift
      ;;
    --dry-run)
      DRY_RUN="true"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
  esac
done

if [ "$TARGET" != "claude" ] && [ "$TARGET" != "codex" ] && [ "$TARGET" != "all" ]; then
  echo "Invalid --target: $TARGET"
  exit 1
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

run() {
  if [ "$DRY_RUN" = "true" ]; then
    echo "[dry-run] $*"
  else
    "$@"
  fi
}

copy_file() {
  local source="$1"
  local target="$2"

  if [ ! -f "$source" ]; then
    echo "Missing source file: $source"
    return 1
  fi

  run mkdir -p "$(dirname "$target")"

  if [ -e "$target" ]; then
    case "$MODE" in
      skip)
        echo "Skip existing: $target"
        return 0
        ;;
      backup)
        local rel="${target#"$HOME"/}"
        local backup="$HOME/.claude/.backups/$RUN_TS/$rel"
        echo "Backup: $target -> $backup"
        run mkdir -p "$(dirname "$backup")"
        run mv "$target" "$backup"
        ;;
      force)
        echo "Overwrite: $target"
        ;;
    esac
  else
    echo "Install: $target"
  fi

  run cp "$source" "$target"
}

copy_dir_contents() {
  local source_dir="$1"
  local target_dir="$2"
  local src_file relative target

  if [ ! -d "$source_dir" ]; then
    echo "Skip missing directory: $source_dir"
    return 0
  fi

  while IFS= read -r -d '' src_file; do
    relative="${src_file#"$source_dir"/}"
    target="$target_dir/$relative"
    copy_file "$src_file" "$target"
  done < <(find "$source_dir" -type f -print0)
}

# Remove files in target_dir that have no counterpart in source_dir.
# Opt-in via --prune. Used only for repo-owned dirs (agents, rules, commands).
prune_orphans() {
  local source_dir="$1"
  local target_dir="$2"
  local tgt_file relative

  [ -d "$target_dir" ] || return 0

  while IFS= read -r -d '' tgt_file; do
    relative="${tgt_file#"$target_dir"/}"
    if [ ! -f "$source_dir/$relative" ]; then
      echo "Prune orphan: $tgt_file"
      run rm "$tgt_file"
    fi
  done < <(find "$target_dir" -type f -print0)
}

install_claude() {
  local source="$REPO_ROOT/claude"
  local target="$HOME/.claude"

  if [ ! -d "$source" ]; then
    echo "Missing Claude source directory: $source"
    return 1
  fi

  echo "Installing Claude config..."

  copy_file "$source/CLAUDE.md" "$target/CLAUDE.md"
  copy_dir_contents "$source/agents" "$target/agents"
  copy_dir_contents "$source/rules" "$target/rules"
  copy_dir_contents "$source/skills" "$target/skills"
  copy_dir_contents "$source/commands" "$target/commands"

  if [ "$PRUNE" = "true" ]; then
    echo "Pruning orphans (agents/rules/commands; skills left intact)..."
    prune_orphans "$source/agents" "$target/agents"
    prune_orphans "$source/rules" "$target/rules"
    prune_orphans "$source/commands" "$target/commands"
  fi

  echo "Claude install complete."
}

install_codex() {
  local source="$REPO_ROOT/codex"
  local target="$HOME/.codex"

  if [ ! -d "$source" ]; then
    echo "Missing Codex source directory: $source"
    return 1
  fi

  echo "Installing Codex config..."

  copy_file "$source/AGENTS.md" "$target/AGENTS.md"

  local path name
  while IFS= read -r -d '' path; do
    name="$(basename "$path")"

    if [ "$name" = "AGENTS.md" ]; then
      continue
    fi

    if [ -d "$path" ]; then
      copy_dir_contents "$path" "$target/$name"
    elif [ -f "$path" ]; then
      copy_file "$path" "$target/$name"
    fi
  done < <(find "$source" -mindepth 1 -maxdepth 1 -print0)

  echo "Codex install complete."
}

case "$TARGET" in
  claude)
    install_claude
    ;;
  codex)
    install_codex
    ;;
  all)
    install_claude
    install_codex
    ;;
esac

echo
echo "Done."
echo "Mode: $MODE"
echo "Target: $TARGET"
echo "Prune: $PRUNE"
