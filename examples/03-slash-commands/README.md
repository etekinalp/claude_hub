# Slash Commands

Index for this concept. Each numbered subfolder is a self-contained example
you `cd` into before running `claude` — see the root README for why.

## Examples

| # | Sub-example | Status |
|---|---|---|
| 01 | [Basics](01-basics/) — a plain command and a namespaced one | done |
| 02 | [Built-in commands walkthrough](02-builtin-commands/) — actually running every cataloged built-in command | done |

## Reference

- [`builtin-commands-reference.md`](builtin-commands-reference.md) — catalog
  of commands that ship with Claude Code itself, with a per-command
  "Tried it?" column for your own notes. [`02-builtin-commands/`](02-builtin-commands/)
  is the runnable companion to this catalog — actual steps to reproduce each
  one, organized by the same categories.

## Adding more depth here

More slash-command material (advanced argument handling, dynamic
`!`command`` substitution, interactions with skills, etc.) goes in a new
`0N-topic/` subfolder here, not a new top-level `examples/` number — see the
root `CLAUDE.md` conventions.
