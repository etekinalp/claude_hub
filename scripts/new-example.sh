#!/usr/bin/env bash
set -euo pipefail

# Scaffold a new isolated Claude Code example from templates/example-template.
#
# Usage:
#   ./scripts/new-example.sh 14-my-new-concept "One-line description of the concept"

if [ $# -lt 1 ]; then
  echo "Usage: $0 <NN-concept-name> [\"one-line description\"]" >&2
  exit 1
fi

NAME="$1"
DESC="${2:-TODO: describe this concept}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_ROOT/templates/example-template"
DEST="$REPO_ROOT/examples/$NAME"

if [ -e "$DEST" ]; then
  echo "examples/$NAME already exists, aborting." >&2
  exit 1
fi

cp -R "$SRC" "$DEST"

TITLE="$(echo "$NAME" | sed -E 's/^[0-9]+-//; s/-/ /g')"
DATE="$(date +%Y-%m-%d)"

# macOS/BSD sed requires an explicit (empty) backup suffix with -i
sed -i '' "s/<Concept Title>/${TITLE}/" "$DEST/README.md"
sed -i '' "s/<one or two sentences>/${DESC}/" "$DEST/README.md"
sed -i '' "s#cd examples/<NN-concept-name>#cd examples/${NAME}#" "$DEST/README.md"

echo "Created examples/$NAME"
echo "  - remember to add a row to the table in the root README.md"
echo "  - remember to add a dated entry to docs/changelog.md ($DATE)"
