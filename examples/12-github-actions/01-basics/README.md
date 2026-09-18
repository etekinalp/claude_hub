# GitHub Actions Integration

## What this demonstrates
A template GitHub Actions workflow (`workflow-template.yml`) that would run
Claude Code against every pull request — kept inactive in this example
(not inside `.github/workflows/`) on purpose, since committing a live
workflow into a learning playground would actually start firing against
real pushes/PRs to this repo.

## Why it matters
This is Claude Code running server-side, triggered by repo events, rather
than something you invoke from your terminal — the same non-interactive
mechanism as `examples/10-headless-mode/`, just triggered by GitHub instead
of you.

## Prerequisites
A GitHub repo with this pushed to it, and an `ANTHROPIC_API_KEY` (or
equivalent) added as a repo secret, if you actually want to activate it.

## Steps to reproduce
1. Read `workflow-template.yml` — note the action reference, inputs, and
   trigger (`on: pull_request`).
2. To actually try it: copy it to `.github/workflows/claude.yml` at the
   repo root, add the required secret in your GitHub repo settings, push,
   and open a pull request to see it run.
3. Compare its structure to `examples/10-headless-mode/01-basics/ask.sh` — same
   underlying non-interactive invocation, different trigger.

## Expected result
Once activated on a real repo with the secret configured, opening a PR
should trigger a Claude-authored review comment.

## Gotchas / notes
- **Not activated in this repo, on purpose.** This file is deliberately
  outside `.github/workflows/` so it can't fire.
- The exact action name/version (`anthropics/claude-code-action@v1` here)
  and its inputs are the part most likely to have changed since this was
  written — verify against the current GitHub Marketplace listing / Claude
  Code docs before relying on this in a real repo.
- Costs real API usage per run once activated — worth scoping the trigger
  (e.g. only specific labels) before turning it on broadly.

## Further reading
- Search "Claude Code GitHub Action" in the current docs / GitHub
  Marketplace for the authoritative, up-to-date reference.
