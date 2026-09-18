#!/usr/bin/env bash
input="$(cat)"
echo "$(date '+%Y-%m-%d %H:%M:%S') PostToolUse Bash: $input" >> "$CLAUDE_PROJECT_DIR/hook-log.txt"
