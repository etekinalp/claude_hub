# 05 — Choosing the Right Tool

## What this demonstrates
One goal — "no `console.log` left in code here" — implemented three
different ways in this same folder, so you can feel the difference
instead of just reading about it:

- **`CLAUDE.md`** — a standing instruction, loaded into every session
  started here, telling Claude to avoid leaving `console.log` behind.
- **The `remove-console-logs` skill** — task-specific expertise that
  loads only when you explicitly ask to clean `console.log` calls out of
  a file.
- **The `block-console-log.sh` hook** — a `PreToolUse` hook on
  `Edit`/`Write` that actually blocks any edit introducing a new
  `console.log(` call, regardless of what Claude was asked to do or
  decided along the way.

## Why it matters
These three mechanisms all *could* address the same problem, and picking
the wrong one is a common way to end up frustrated with a feature that's
actually working exactly as designed. The decision isn't about which is
"best" — it's about what kind of guarantee you need:

- **CLAUDE.md** shapes Claude's *judgment*. It's always loaded, cheap, and
  great for "we do it this way here" — but it's guidance, not
  enforcement. Under enough competing pressure in a long turn, an
  always-on instruction can lose out to something else Claude judged more
  important in the moment.
- **Skills** are *on-demand expertise*. `remove-console-logs` costs
  nothing until someone actually asks for that specific task, and then it
  brings focused, detailed instructions for exactly that job. It's not
  loaded for unrelated work, and it doesn't stop anyone from writing a
  `console.log` in the first place — it only helps once asked to remove
  them.
- **Hooks** are *event-driven enforcement*. `block-console-log.sh` doesn't
  care what Claude was asked, what skill (if any) is active, or how
  reasonable the request sounded — it inspects every `Edit`/`Write` call
  before it happens and refuses the ones that fail its check. This is the
  only one of the three that's an actual guarantee rather than guidance.

A typical real setup layers these rather than picking one: CLAUDE.md for
always-on standards, skills for task-specific expertise that would be
wasteful to load every turn, hooks for the handful of things that must
never happen no matter what. This folder's cross-references below point
at this repo's dedicated concept folders for the two mechanisms not shown
fully here (subagents, MCP servers) — this example only stages a working
comparison for the two most easily confused with skills (CLAUDE.md and
hooks).

## Prerequisites
`python3` (the hook script uses it to parse the tool-call JSON — same
dependency-free approach as example 06's hooks).

## Steps to reproduce

### Part 1 — CLAUDE.md: guidance, not a guarantee
1. `cd examples/05-skills/05-choosing-the-right-tool`
2. Run `claude`.
3. Ask: "add a `multiply` function to demo.js, following this project's
   style." Expect Claude to write it *without* a stray `console.log`,
   because `CLAUDE.md`'s instruction is in context the whole time — no
   skill or hook did anything here, it's just standing guidance being
   followed.

### Part 2 — the skill: on-demand, task-specific
1. Still in this folder, temporarily add a `console.log("test")` line
   into `demo.js` yourself (or ask Claude to add one for a moment) so
   there's something to clean up. Given `block-console-log.sh` is active
   (see Part 3), you may need to disable the hook in `.claude/settings.json`
   temporarily to get one in, or add it directly with a text editor
   outside Claude Code.
2. Ask: "clean up the console.log statements in demo.js." Expect
   `remove-console-logs` to fire and remove it, reporting how many it
   found.

### Part 3 — the hook: enforced, no matter what
1. Ask Claude to add a `console.log` call to `demo.js` directly (not
   through the skill — just ask it to add one, plainly, overriding
   `CLAUDE.md`'s guidance on purpose for this test). Expect the `Edit` or
   `Write` call to be **blocked**, with the hook's stderr message
   surfaced, regardless of the fact that CLAUDE.md's instruction alone
   didn't stop it this time (you explicitly asked for the thing it warns
   against) — the hook doesn't care about the conversation's reasoning,
   only the content of the edit.

## Expected result
Part 1: the new function has no `console.log` in it, and nothing
"fired" in a way you'd notice — it's just quietly-followed guidance.
Part 2: the skill visibly loads, removes the line(s), and reports a
count. Part 3: the edit is refused outright with the hook's message,
even on a direct, explicit request — the one case where CLAUDE.md alone
would have been overridden by a direct instruction, and where only the
hook actually holds the line.

## Gotchas / notes
- This folder's `block-console-log.sh` hook will also block *this
  example's own* `demo.js` from ever legitimately containing
  `console.log` through Claude Code — that's intentional, it's what makes
  Part 3 demonstrable. Edit the file directly with a text editor if you
  need to reset it.
- Deeper, dedicated treatment of each mechanism lives elsewhere in this
  repo, not repeated here: CLAUDE.md in `examples/01-memory-and-claude-md/`,
  hooks in `examples/06-hooks/`, subagents in `examples/04-subagents/`,
  MCP servers in `examples/07-mcp-servers/`. This example is only the
  side-by-side comparison, not the full depth on any one of them.
- Subagents and MCP servers aren't staged here as running comparisons —
  they solve a different kind of problem than "should this be
  guidance, on-demand expertise, or enforcement" (isolated execution
  context, and external tool/data integration, respectively), so a
  three-way console.log demo doesn't fit them the way it fits
  CLAUDE.md/skill/hook. See `examples/04-subagents/` and
  `examples/07-mcp-servers/` for what each is actually for.
- The hook's JSON parsing checks both `tool_input.new_string` (Edit) and
  `tool_input.content` (Write) — concatenated, so the one grep covers
  both tools with the single `Edit|Write` matcher in `.claude/settings.json`.

## Further reading
- https://academy.claude.com/courses/introduction-to-agent-skills
- https://code.claude.com/docs/en/skills.md
- https://code.claude.com/docs/en/hooks.md
