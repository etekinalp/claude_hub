#!/usr/bin/env bash
# Checks the live Claude Code docs for changes since the last time you ran
# this script, so you know when it's worth reviewing docs/gap-analysis.md
# and this repo's examples/ for something new to add.
#
# This ONLY detects and reports changes -- it never edits, builds, or
# removes anything under examples/. Deciding what (if anything) to build
# from a diff, and verifying it against the live docs the way every
# existing example in this repo was built, is a job for a Claude Code
# session, not this script.
#
# Sources checked:
#   - the weekly "what's new" feature digest (human-readable, the useful
#     one for "did anything worth an example ship")
#   - the full docs index (llms.txt) -- catches brand-new doc pages that
#     might not get a mention in the weekly digest's prose
#
# Usage:
#   ./scripts/check-for-updates.sh            # fetch + diff against the saved baseline
#   ./scripts/check-for-updates.sh --accept   # after reviewing, save the fetched
#                                              # content as the new baseline
#
# Requires network access -- run this in your own terminal, not through
# any sandboxed/remote shell, since those may sit behind a restrictive
# egress proxy that blocks the fetch.

set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

SNAPSHOT_DIR="docs/update-check"
mkdir -p "$SNAPSHOT_DIR"

WHATS_NEW_URL="https://code.claude.com/docs/en/whats-new.md"
DOCS_INDEX_URL="https://code.claude.com/docs/llms.txt"

WHATS_NEW_SNAPSHOT="$SNAPSHOT_DIR/whats-new.snapshot.md"
DOCS_INDEX_SNAPSHOT="$SNAPSHOT_DIR/docs-index.snapshot.txt"

ACCEPT=false
if [ "${1:-}" = "--accept" ]; then
  ACCEPT=true
fi

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Fetching live Claude Code docs..."
if ! curl -fsSL "$WHATS_NEW_URL" -o "$TMP_DIR/whats-new.md"; then
  echo "Failed to fetch $WHATS_NEW_URL -- check your network connection." >&2
  echo "(If you're running this through a sandboxed/remote shell, try your own terminal instead.)" >&2
  exit 1
fi
if ! curl -fsSL "$DOCS_INDEX_URL" -o "$TMP_DIR/docs-index.txt"; then
  echo "Failed to fetch $DOCS_INDEX_URL -- check your network connection." >&2
  exit 1
fi

report_diff() {
  local label="$1"
  local snapshot="$2"
  local fresh="$3"

  echo
  if [ ! -f "$snapshot" ]; then
    echo "== $label: no baseline yet =="
    echo "First run -- saving current content as the baseline. Run this"
    echo "script again later (e.g. in a few weeks) to see what changed."
    cp "$fresh" "$snapshot"
    return
  fi

  if diff -q "$snapshot" "$fresh" >/dev/null 2>&1; then
    echo "== $label: no change since last check =="
    return
  fi

  echo "== $label: changed since last check =="
  diff -u "$snapshot" "$fresh" | tail -n +3
  if $ACCEPT; then
    cp "$fresh" "$snapshot"
    echo
    echo "(baseline updated)"
  else
    echo
    echo "(baseline NOT updated -- review the diff above, then re-run with"
    echo " --accept once you've decided what, if anything, to act on)"
  fi
}

report_diff "Weekly digest (whats-new)" "$WHATS_NEW_SNAPSHOT" "$TMP_DIR/whats-new.md"
report_diff "Full docs index (llms.txt)" "$DOCS_INDEX_SNAPSHOT" "$TMP_DIR/docs-index.txt"

echo
echo "Done. If either section above showed a real change, the next step is"
echo "a Claude Code session: point it at https://code.claude.com/docs/en/whats-new"
echo "(or paste the diff above) and ask it to cross-check against"
echo "docs/gap-analysis.md and this repo's examples/ -- same research-then-"
echo "verify approach used to build every example here so far. Don't let it"
echo "build straight from the weekly digest's summary alone; it should"
echo "confirm details against the live docs first, the way this repo always has."
