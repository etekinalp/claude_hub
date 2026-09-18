# Settings & Permissions

## What this demonstrates
The settings precedence chain in practice: a project-level `.claude/settings.json`
(shared, committed) versus a `.claude/settings.local.json` (personal, gitignored)
that overrides it — both for an env var and for a permission rule.

## Why it matters
This is the mechanism behind "why did my personal override not take effect" and
"why does this repo behave differently for my teammate than for me." Settings.json
is also where hooks, permission allow/deny rules, and default models all live, so
understanding precedence here pays off in every later example.

## Prerequisites
None.

## Steps to reproduce
1. `cd examples/02-settings-and-permissions/01-basics`
2. Run `claude` and ask it to run `echo $CLAUDE_HUB_MARKER` in Bash.
   Expected: `from-shared-project-settings` (from `.claude/settings.json`).
3. Ask Claude to run `curl https://example.com`. Expected: it's blocked/denied
   before running — `.claude/settings.json` explicitly denies the `curl` pattern.
4. Exit. Copy the override example into place:
   `cp .claude/settings.local.json.example .claude/settings.local.json`
5. Run `claude` again (fresh session, so settings are re-read) and repeat steps 2–3.
   Expected: `echo $CLAUDE_HUB_MARKER` now prints `from-local-override`, and the
   `curl` command is now allowed — the local file won on both keys.

## Expected result
`settings.local.json` beats `settings.json` on every key it sets, confirming the
project-local layer sits above shared-project in the precedence chain. Keys it
doesn't set (there are none in this example, but in general) still fall through
to the shared file.

## Try it yourself: user and managed levels
Not reproduced here to avoid touching files outside this repo. `~/.claude/settings.json`
sits below both project layers (test by setting `CLAUDE_HUB_MARKER` there and
seeing it get overridden the moment either project-level file sets it). A managed/
enterprise settings file, where your org has one, sits above everything and can't
be overridden by any of the above — nothing to reproduce locally for that one.

## Gotchas / notes
- `settings.local.json` is real, on disk, and in this repo's `.gitignore` — it's
  meant to exist per-machine, never to be committed. `settings.local.json.example`
  is the committed stand-in that documents what it should contain, same pattern
  as `.env` / `.env.example`.
- Settings are read at session start — changes to either file need a fresh
  `claude` session to take effect, not just a new prompt in the same session.

## Further reading
- https://code.claude.com/docs/en/settings.md
