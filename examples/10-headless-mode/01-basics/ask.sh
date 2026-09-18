#!/usr/bin/env bash
# Runs Claude Code non-interactively against a fixed prompt and prints
# structured JSON output - useful for scripting/CI.
claude -p "Summarize what examples/10-headless-mode/README.md demonstrates, in one sentence." \
  --output-format json
