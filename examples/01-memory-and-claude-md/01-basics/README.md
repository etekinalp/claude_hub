# Memory & CLAUDE.md

## What this demonstrates
How Claude Code automatically loads `CLAUDE.md` files as context — the project-root file every session picks up, plus how a **nested** `CLAUDE.md` in a subdirectory gets pulled in only once Claude actually touches a file inside that subdirectory.

## Why it matters
This is the mechanism behind "Claude already knows my conventions" — and misreading it is a common source of confusion (expecting a nested `CLAUDE.md` to apply repo-wide, or expecting the root file to auto-load a subfolder's context it hasn't touched yet). Getting this model right also explains why the root `CLAUDE.md` in this whole repo is meta-only: it applies to every session launched here, so it has to stay generic.

## Prerequisites
The Claude Code CLI installed and on your PATH.

## Steps to reproduce
1. `cd examples/01-memory-and-claude-md/01-basics`
2. Run `claude` — a fresh interactive session, launched *from this folder*.
3. Ask: "What do you know from CLAUDE.md right now?" — it should surface `MARKER_ROOT` from this folder's `CLAUDE.md`, and nothing from `subdir-a/` or `subdir-b/` yet.
4. Ask Claude to read `subdir-a/notes.txt`.
5. Ask again: "What do you know from CLAUDE.md now?" — it should now also surface `MARKER_SUBDIR_A`, picked up because it touched a file inside `subdir-a/`.
6. Ask Claude to read `subdir-b/notes.txt`, then ask a third time — nothing new should appear, since `subdir-b/` has no `CLAUDE.md`.

## Expected result
The set of markers Claude can recite grows as it touches subdirectories that have their own `CLAUDE.md`, and doesn't shrink back within the session — it shouldn't "forget" `subdir-a/`'s marker once you move on to `subdir-b/`.

## Try it yourself: user-level memory
This example deliberately doesn't touch anything outside this repo. To see the third layer — `~/.claude/CLAUDE.md` — add a one-line marker fact to that file yourself, start `claude` in any project, and ask what it knows about you. It should merge with whatever project-level `CLAUDE.md` is in scope. (Some Claude Code versions also support a gitignored `CLAUDE.local.md` for personal project-only notes — check your installed version's docs, since this has changed across releases.)

## Gotchas / notes
- Nested `CLAUDE.md` loading is triggered by Claude working inside that subdirectory (reading/editing a file there), not by proximity or by session start alone.
- This is a different mechanism from project config (`.claude/agents`, `.claude/commands`, `.claude/hooks`, `.claude/skills`, `.mcp.json`), which is *not* nested-aware — see `examples/02-settings-and-permissions/` and friends once they exist.

## Further reading
- https://code.claude.com/docs/en/claude-directory.md
