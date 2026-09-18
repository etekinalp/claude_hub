#!/usr/bin/env bash
# Reads the tool-call JSON from stdin, blocks anything containing "rm -rf".
input="$(cat)"
if echo "$input" | grep -q "rm -rf"; then
  echo "Blocked by examples/06-hooks/.claude/hooks/block-dangerous-bash.sh: rm -rf is not allowed in this example." >&2
  exit 2
fi
exit 0
