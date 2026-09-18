#!/usr/bin/env bash
# Reference only - placeholders, not a real routine. See this folder's
# README for why this isn't meant to be run as-is.
curl -X POST https://api.anthropic.com/v1/claude_code/routines/trig_PLACEHOLDER/fire \
  -H "Authorization: Bearer sk-ant-oat01-PLACEHOLDER" \
  -H "anthropic-beta: experimental-cc-routine-2026-04-01" \
  -H "anthropic-version: 2023-06-01" \
  -H "Content-Type: application/json" \
  -d '{"text": "Sentry alert SEN-4521 fired in prod. Stack trace attached."}'
