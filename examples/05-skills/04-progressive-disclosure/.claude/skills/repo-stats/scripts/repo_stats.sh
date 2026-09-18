#!/usr/bin/env bash
# Prints a few real counts about the claude_hub repo. Run from anywhere
# inside the repo - it walks up to find the repo root itself.
set -euo pipefail

root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$root"

concept_count=$(find examples -maxdepth 1 -mindepth 1 -type d | wc -l | tr -d ' ')
subexample_count=$(find examples -mindepth 2 -maxdepth 2 -type d -name '[0-9][0-9]-*' | wc -l | tr -d ' ')
readme_count=$(find examples -name README.md | wc -l | tr -d ' ')
readme_lines=$(find examples -name README.md -exec cat {} + | wc -l | tr -d ' ')

echo "concepts: $concept_count"
echo "sub-examples: $subexample_count"
echo "READMEs: $readme_count"
echo "total README lines: $readme_lines"
