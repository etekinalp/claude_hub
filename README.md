# claude_hub

Personal hub and playground to learn and understand concepts in Claude Code — one isolated, documented example per concept, built up over time.

## How this repo works

Claude Code reads its project configuration (`.claude/agents/`, `.claude/commands/`, `.claude/hooks/`, `.claude/skills/`, `.mcp.json`) from wherever you launch `claude` from — it does **not** cascade in or out of subdirectories the way `CLAUDE.md` does. So each example under `examples/` is a self-contained mini-project: `cd` into it before running `claude`, and only that example's config is active. The repo root stays deliberately thin (this file + a meta `CLAUDE.md`) so opening Claude Code at the top level doesn't pull in every example's config at once.

```
cd examples/03-slash-commands
claude
```

## Adding a new example

```
./scripts/new-example.sh 14-my-new-concept "One-line description"
```

or copy `templates/example-template/` by hand. See the root `CLAUDE.md` for conventions.

## Checking for new Claude Code features

Claude Code ships fast, so this repo can fall behind. `check-for-updates.sh`
fetches the live weekly "what's new" digest and the full docs index, and
diffs each against a saved snapshot from your last check:

```
./scripts/check-for-updates.sh            # fetch + report what changed
./scripts/check-for-updates.sh --accept   # after reviewing, save it as the new baseline
```

It only detects and reports — it never edits or builds anything itself.
Deciding what (if anything) is worth a new example is still a Claude Code
session's job: point it at the diff (or at
https://code.claude.com/docs/en/whats-new) and have it cross-check against
[`docs/gap-analysis.md`](docs/gap-analysis.md) and `examples/`, the same
research-then-verify-against-live-docs approach every example here was
built with — never build straight off the digest's summary text alone.
Needs real network access, so run it in your own terminal rather than
through a sandboxed/remote shell.

## Before committing or pushing

Actually walking through an example's `## Steps to reproduce` leaves runtime
byproducts behind (personal settings overrides, hook logs, edited scratch
fixtures, etc.) — this is expected, not a mistake. Run the cleanup script
first so those don't get committed:

```
./scripts/clean-examples.sh --dry-run   # see what it would do
./scripts/clean-examples.sh             # actually clean
```

It only removes/resets known runtime artifacts (never deletes anything it
isn't sure about — those are reported for you to review by hand), and it
never touches files that are gitignored on purpose, like
`examples/11-worktrees/01-basics/scratch/local-notes.txt`.

## Examples

| # | Concept | Status |
|---|---|---|
| 01 | [Memory & CLAUDE.md](examples/01-memory-and-claude-md/) | done |
| 02 | [Settings & permissions](examples/02-settings-and-permissions/) | done |
| 03 | [Slash commands](examples/03-slash-commands/) | done |
| 04 | [Subagents](examples/04-subagents/) | done |
| 05 | [Skills](examples/05-skills/) | done |
| 06 | [Hooks](examples/06-hooks/) | done |
| 07 | [MCP servers](examples/07-mcp-servers/) | done |
| 08 | [Plugins](examples/08-plugins/) | done |
| 09 | [Output styles](examples/09-output-styles/) | done |
| 10 | [Headless mode](examples/10-headless-mode/) | done |
| 11 | [Worktrees](examples/11-worktrees/) | done |
| 12 | [GitHub Actions integration](examples/12-github-actions/) | done |
| 13 | [Permission modes](examples/13-permission-modes/) | done |
| 14 | [Routines](examples/14-routines/) | done |
| 15 | [Dynamic workflows](examples/15-dynamic-workflows/) | done |
| 16 | [Ultrareview](examples/16-ultrareview/) | done |

See [`docs/glossary.md`](docs/glossary.md) for short definitions and [`docs/changelog.md`](docs/changelog.md) for a dated log of what's been explored.

## Backlog — not yet covered

A fuller audit lives in [`docs/gap-analysis.md`](docs/gap-analysis.md).
Auto mode, routines, dynamic workflows, and ultrareview (previously listed
here) are now built — see rows 14-16 above and `13-permission-modes/02-
auto-mode/`. Still open, roughly in priority order:

- Goal mode, artifacts, effort levels/fast mode, computer use
- Session branching/forking and checkpoint/rewind
- Agent view and cross-session messaging
- Plugin evaluation (`claude plugin eval`, beyond `--plugin-dir` loading)
- LSP servers, background monitors, the Monitor tool
- The Claude Agent SDK vs. the Claude Code CLI relationship
- Server-managed / enterprise settings

Plus known sub-aspect gaps inside the existing concepts (more hook events,
more subagent fields, MCP channels, etc.) — see the gap-analysis doc for
the full breakdown, including one correction: "Ultraplan" was previously
listed here as a candidate and turned out to already be discontinued.
