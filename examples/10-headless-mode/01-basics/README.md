# Headless Mode

## What this demonstrates
Running Claude Code non-interactively with `claude -p` (print mode),
including structured `--output-format json` output — the pattern used for
scripting Claude Code from CI, cron, or another program rather than a
terminal session.

## Why it matters
Everything in this repo so far has been interactive. Headless mode is how
Claude Code becomes a building block in a larger automated pipeline: a
pre-commit check, a scheduled report, a CI step that asks Claude to review
a diff and exits non-zero on certain findings.

## Prerequisites
None.

## Steps to reproduce
1. `cd examples/10-headless-mode/01-basics`
2. Run `./ask.sh` (make executable first if needed: `chmod +x ask.sh`)
3. Observe the JSON structure printed to stdout instead of an interactive
   session.
4. Try `claude -p "list the files in this folder" --allowedTools "Bash(ls:*)"`
   directly, to see tool access scoped down for a single headless call.
5. Try `--output-format stream-json` for the streaming variant, if your
   version supports it, and compare against the single JSON blob from step 2.

## Expected result
Step 2 returns a single JSON object/response with no back-and-forth prompt,
suitable for piping into `jq` or another program. Step 4 shows tool access
can be restricted per-invocation, not just per-project.

## Gotchas / notes
- Headless mode still respects `.claude/settings.json` in the launch
  directory (permissions, hooks, etc.) unless overridden with flags — it's
  not a separate, unconfigured mode.
- `--allowedTools` syntax and the exact set of `--output-format` values
  (`text`, `json`, `stream-json`, structured `--json-schema`) may vary by
  version — run `claude -p --help` to check what your install supports.
- This is the mechanism a GitHub Actions integration
  (`examples/12-github-actions/`) is built on top of.

## Further reading
- https://code.claude.com/docs/en/headless.md
