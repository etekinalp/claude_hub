# Skills

## What this demonstrates
Two skills showing the two invocation modes: `changelog-writer` auto-triggers
when Claude judges your request matches its `description` (model-invoked),
while `ping` is manual-only (`disable-model-invocation: true`) and fires
only on an explicit `/ping`.

## Why it matters
This is the mechanism example 03's Gotchas pointed at — skills are the
modern superset of both plain slash commands and auto-invoked capabilities.
Whether a skill can be auto-triggered, manually triggered, or both is a
deliberate choice per-skill, and getting the `description` field right is
what makes auto-invocation actually reliable.

## Prerequisites
None.

## Steps to reproduce
1. `cd examples/05-skills/01-basics`
2. Run `claude`
3. Ask plainly, without naming the skill: "Can you draft a changelog entry
   for adding a new .gitignore rule?" — expect `changelog-writer` to
   auto-invoke and follow this repo's `docs/changelog.md` format.
4. Type `/ping` directly — expect the canned `pong` reply.
5. In a fresh session, say the word "ping" in a plain sentence (not as a
   slash command) — expect it to NOT auto-trigger, confirming
   `disable-model-invocation` held even though the word matched.

## Expected result
`changelog-writer` fires from natural language alone; `ping` never does,
only from the literal `/ping` — same skill mechanism, two different
invocation contracts set via frontmatter.

## Gotchas / notes
- Auto-invocation quality is entirely a function of how specific and
  action-oriented the `description` is — a vague one won't trigger
  reliably, or will trigger on the wrong requests.
- This coexists with the classic `.claude/commands/` approach from example
  03; both currently work, skills are just the newer, more capable form.
- Skills can also bundle scripts/resources in their folder alongside
  `SKILL.md` — not shown here to keep this example minimal.

## Further reading
- https://code.claude.com/docs/en/skills.md
