#!/usr/bin/env bash
# Cleans up runtime artifacts created by actually walking through this
# repo's example READMEs, so the repo stays pristine before you commit or
# push. Safe to run repeatedly. Reports what it finds, resets fixture
# files to their original content instead of deleting them where the
# fixture must keep existing, and never auto-deletes anything it isn't
# sure about (git worktrees, unexpected saved workflow files) - those are
# reported for you to handle by hand.
#
# Usage:
#   ./scripts/clean-examples.sh            # actually clean
#   ./scripts/clean-examples.sh --dry-run  # report only, changes nothing

set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

DRY_RUN=false
if [ "${1:-}" = "--dry-run" ]; then
  DRY_RUN=true
fi

removed_count=0
reset_count=0

remove() {
  local path="$1"
  if [ -e "$path" ]; then
    if $DRY_RUN; then
      echo "[dry-run] would remove: $path"
    else
      # Don't let one failed removal (permissions, read-only mount, etc.)
      # abort the rest of the cleanup - report it and keep going.
      if rm -rf "$path" 2>/dev/null; then
        echo "removed: $path"
        removed_count=$((removed_count + 1))
      else
        echo "could not remove: $path (permission denied? remove it by hand)" >&2
      fi
    fi
  fi
}

reset_file() {
  local path="$1"
  local content="$2"
  if [ -f "$path" ]; then
    current="$(cat "$path")"
    if [ "$current" != "$content" ]; then
      if $DRY_RUN; then
        echo "[dry-run] would reset: $path"
      else
        printf '%s\n' "$content" > "$path"
        echo "reset: $path"
        reset_count=$((reset_count + 1))
      fi
    fi
  fi
}

echo "== Runtime artifacts (safe to delete) =="
remove "examples/02-settings-and-permissions/01-basics/.claude/settings.local.json"
remove "examples/06-hooks/01-basics/hook-log.txt"
remove "examples/03-slash-commands/02-builtin-commands/CLAUDE.md"
remove "examples/03-slash-commands/02-builtin-commands/scratch-export.md"

# any new files a user asked the MCP server to write into the sandbox,
# beyond the one tracked fixture file (hello.txt)
sandbox_dir="examples/07-mcp-servers/01-basic-filesystem-server/sandbox"
if [ -d "$sandbox_dir" ]; then
  while IFS= read -r -d '' f; do
    name="$(basename "$f")"
    if [ "$name" != "hello.txt" ]; then
      remove "$f"
    fi
  done < <(find "$sandbox_dir" -maxdepth 1 -type f -print0)
fi

# stray settings.local.json anywhere else under examples/ - none are
# tracked fixtures anywhere in this repo
while IFS= read -r -d '' f; do
  remove "$f"
done < <(find examples -type f -name "settings.local.json" -print0 2>/dev/null)

# macOS Finder artifacts, anywhere in the repo
while IFS= read -r -d '' f; do
  remove "$f"
done < <(find . -type f -name ".DS_Store" -not -path "./.git/*" -print0 2>/dev/null)

echo
echo "== Fixture files reset to their original content (not deleted) =="
reset_file "examples/13-permission-modes/01-basics/scratch.txt" "Edit me to test permission modes. Original content."
reset_file "examples/13-permission-modes/02-auto-mode/scratch.txt" "Edit me to test auto mode. Original content."
reset_file "examples/03-slash-commands/02-builtin-commands/scratch.txt" "$(cat <<'FIXTURE'
# scratch.txt

Toy shell function kept here on purpose so /diff, /code-review,
/security-review, and /verify (all used in this folder's walkthrough) have
something real to look at once you've made an edit. Reset this file with
scripts/clean-examples.sh when you're done.

run_lookup() {
  local user_input="$1"
  eval "echo Looking up: $user_input"
}

API_KEY="sk-example-not-a-real-key-1234567890"
FIXTURE
)"

echo
echo "== Preserved on purpose (never touched by this script) =="
echo "examples/11-worktrees/01-basics/scratch/local-notes.txt - gitignored fixture, demonstrates .worktreeinclude, must stay on disk"

echo
echo "== Needs your judgment (reported only, never auto-deleted) =="
wf_dir="examples/15-dynamic-workflows/01-basics/.claude/workflows"
found_extra_workflow=false
if [ -d "$wf_dir" ]; then
  while IFS= read -r -d '' f; do
    name="$(basename "$f")"
    if [ "$name" != "find-todos.js" ]; then
      echo "extra saved workflow, decide if you want to keep it: $f"
      found_extra_workflow=true
    fi
  done < <(find "$wf_dir" -maxdepth 1 -type f -print0)
fi
if ! $found_extra_workflow; then
  echo "(no extra saved workflows found)"
fi

if git worktree list >/dev/null 2>&1; then
  wt_count=$(git worktree list | wc -l | tr -d ' ')
  if [ "$wt_count" -gt 1 ]; then
    echo "git worktrees exist beyond the main checkout - review and remove by hand if they were just for testing example 11:"
    git worktree list | tail -n +2
    echo "  (git worktree remove <path>, then git worktree prune)"
  else
    echo "(no extra git worktrees found)"
  fi
fi

echo
if $DRY_RUN; then
  echo "Dry run only - nothing was changed. Run without --dry-run to apply."
else
  echo "Done: $removed_count artifact(s) removed, $reset_count fixture(s) reset."
  echo "Run 'git status' now to confirm the tree is clean before committing."
fi
