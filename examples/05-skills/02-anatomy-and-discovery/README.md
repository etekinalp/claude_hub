# 02 — Anatomy & Discovery

## What this demonstrates
Where `SKILL.md` files can live, and how Claude Code decides which ones are
available for a given session or request. Two skills here make the
"nested loads later, root loads at start" rule concrete: `root-scope-note`
sits in this folder's own `.claude/skills/` (loads at session start), and
`nested-scope-note` sits in `subproject/.claude/skills/` (loads only once
Claude actually works on a file inside `subproject/`).

## Why it matters
Example 01 already showed the two invocation modes (auto vs. manual) —
this one is about *where a skill has to sit* for Claude Code to find it at
all, and *when* it actually enters context. Getting this wrong is the
single most common reason a skill "doesn't work": it's not a bad
`description`, it's sitting in a folder Claude Code was never going to
look at for this session, or a nested one that hasn't been touched yet.
Skills only load their `name` and `description` up front — the full body
only enters context once a skill actually fires — which is also why
`description` quality (example 03) matters so much: it's the *only* thing
Claude has to go on before deciding to load the rest.

## Prerequisites
None.

## Steps to reproduce
1. `cd examples/05-skills/02-anatomy-and-discovery`
2. Run `claude`.
3. Run `/context` and look at the skills section. Expect `root-scope-note`
   listed; expect `nested-scope-note` **not** listed yet — you haven't
   touched anything under `subproject/` in this session.
4. Ask Claude: "what scope notes are available?" — expect
   `root-scope-note` to auto-invoke from its `description` alone (you
   never named it), replying with its canned line.
5. Ask Claude to read `subproject/notes.txt`.
6. Run `/context` again. Expect `nested-scope-note` to now appear in the
   skills section too — reading a file inside `subproject/` is what
   loaded `subproject/.claude/skills/` for this session.
7. Ask: "check the nested scope note" — expect `nested-scope-note` to
   auto-invoke now that it's loaded.

## Expected result
`/context` before step 5 lists one skill (`root-scope-note`); `/context`
after step 5 lists two. Both skills auto-invoke correctly from plain
language once loaded, without ever being named by their skill name in the
request — confirming that matching runs off `description` text, not a
literal keyword or the skill's own name.

## Gotchas / notes
- **Full storage-location list** (not all of them shown here — this
  folder only exercises project-root and nested, the two you'll hit day
  to day):

  | Location | Path | Priority |
  |---|---|---|
  | Enterprise | `.claude/skills/<name>/SKILL.md` inside the managed-settings directory | Highest |
  | Personal | `~/.claude/skills/<name>/SKILL.md` | High |
  | Project | `.claude/skills/<name>/SKILL.md` at repo root | Medium |
  | Nested | `<subdir>/.claude/skills/<name>/SKILL.md` | Medium, contextual — loads on first file touch below `<subdir>` |
  | `--add-dir` folder | `.claude/skills/<name>/SKILL.md` in a directory passed with `--add-dir` | Medium-low, session-only |
  | Plugin | `<plugin>/skills/<name>/SKILL.md` | Low, namespaced as `/plugin-name:skill-name` |
  | claude.ai synced | Skills enabled on your claude.ai account, synced to `~/.claude/skills/synced/` | Lowest on a name conflict, namespaced `/anthropic-skills:<name>` |

  When two skills share a name, the higher-priority one wins; a root and a
  nested skill with different names both load side by side, which is what
  steps 3–6 just showed. Example 06 (sharing) and 07 (debugging) go deeper
  on the enterprise/plugin/synced rows and on name conflicts specifically.
- `SKILL.md` **must** sit inside a named folder — `.claude/skills/ping.md`
  directly is not a skill, it's ignored. The folder name and the
  frontmatter `name` don't have to match, but keeping them in sync avoids
  confusing yourself later.
- Claude Code loads only each skill's `name` and `description` at
  discovery time — the file's actual instructions (the Markdown body
  below the frontmatter) are what get pulled into context once the skill
  is chosen. That's *why* it can afford to have many skills sitting around
  unused: the unselected ones cost a name and a one-line description each,
  not their full body.
- This example never names either skill's exact name in the trigger
  phrases used in steps 4 and 7 on purpose — that's the auto-invocation
  matching in action, driven by `description`, covered in more depth in
  example 03.

## Further reading
- https://code.claude.com/docs/en/skills.md
- https://code.claude.com/docs/en/debug-your-config.md
- https://code.claude.com/docs/en/claude-directory.md
