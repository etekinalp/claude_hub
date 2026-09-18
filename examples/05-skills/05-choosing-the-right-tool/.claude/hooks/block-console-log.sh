#!/usr/bin/env bash
# PreToolUse hook for Edit|Write: reads the tool-call JSON from stdin and
# blocks any new content that introduces a console.log( call.
input="$(cat)"
new_content="$(echo "$input" | python3 -c 'import json,sys; d=json.load(sys.stdin); ti=d.get("tool_input",{}); print(ti.get("new_string","") + ti.get("content",""))' 2>/dev/null)"
if echo "$new_content" | grep -q "console\.log("; then
  echo "Blocked by examples/05-skills/05-choosing-the-right-tool/.claude/hooks/block-console-log.sh: console.log( is not allowed in this example's files, even mid-edit." >&2
  exit 2
fi
exit 0
