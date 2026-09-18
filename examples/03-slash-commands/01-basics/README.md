# 01 — Basics

## What this demonstrates
A basic project slash command (`/hello`) and a namespaced one (`/review:pr`),
created via a subdirectory under `.claude/commands/` — plus how `$ARGUMENTS`
gets substituted into the command body.

## Why it matters
Slash commands are the simplest way to turn a prompt you keep retyping into a
reusable, shareable one-liner. Namespacing matters once you have more than a
handful of commands, or want to avoid collisions with a teammate's or a
plugin's command of the same short name.

## Prerequisites
None.

## Steps to reproduce
1. `cd examples/03-slash-commands/01-basics`
2. Run `claude`
3. Type `/hello Emre` — expect a friendly greeting that names `hello.md` as
   its source and echoes back "Emre".
4. Type `/hello` with no argument — expect a fallback (e.g. "there"),
   showing `$ARGUMENTS` was empty.
5. Type `/review:pr` — expect the namespaced review-checklist command to
   run, confirming the `review/` subfolder became the `review:` prefix.

## Expected result
Both commands appear in the `/` menu only inside this folder (project-scoped,
not global), and the subdirectory maps directly onto `namespace:command`.

## Gotchas / notes
- Claude Code is folding this mechanism into Skills (a `SKILL.md` can be
  `user-invocable` for `/name` use) — see `examples/05-skills/` for the
  newer unified form and the manual-vs-auto-invoked distinction.
- Argument-substitution syntax (`$ARGUMENTS` vs positional `$1`/`$name`) has
  shifted across releases — if `$ARGUMENTS` isn't replaced, check what your
  installed version calls it.
- A same-named command in `~/.claude/commands/` (user-level) would coexist;
  project-level wins here — same precedence idea as example 02.

## Further reading
- https://code.claude.com/docs/en/skills.md (current docs fold command
  frontmatter into this page — check for a dedicated slash-commands page too)
