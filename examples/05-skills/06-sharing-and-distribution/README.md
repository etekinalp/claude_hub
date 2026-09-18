# 06 — Sharing & Distribution

## What this demonstrates
Four ways a skill reaches other people or other parts of a setup, in order
from "already happening" to "needs infrastructure this repo can't stand
up":

1. **Project repository** — every skill in this repo already demonstrates
   this. Nothing new to build; see "Gotchas" below.
2. **Plugins** — already covered concretely by
   `examples/08-plugins/01-basics/my-first-plugin/skills/greet/`, a real
   plugin bundling a real skill. Not rebuilt here on purpose.
3. **Custom subagents** — new in this folder: `style-reviewer`, a subagent
   that *preloads* the `style-conventions` skill via a `skills:`
   frontmatter field, so it never has to go look the conventions up.
4. **Enterprise managed settings** — documented, not run. Rolling out a
   skill org-wide requires writing to a system directory outside any git
   repo (`/etc/claude-code/` on Linux, for instance) on every developer's
   machine — not something this repo touches, consistent with this
   repo's own rule against reaching outside itself. The real file shape
   is given below instead, sourced from the official docs, not the
   course (see Gotchas).

## Why it matters
"Sharing a skill" means different things depending on who needs it and
how much control you want over whether they can turn it off. A project
skill reaches anyone who clones the repo, automatically, with no
installation step — but they can still ignore, edit, or delete it, since
it's just a file. A plugin reaches anyone who installs it from a
marketplace, across unrelated repos — the audience gets wider, the
delivery gets a version number and an install step. A subagent's `skills:`
field isn't really about *reaching more people* — it's about giving one
specific, isolated agent guaranteed knowledge at the moment it starts,
without spending a turn on it deciding to go fetch that knowledge itself.
Enterprise managed settings is the only one of the four that's not really
"sharing" at all — it's mandating: the skill (or the plugin marketplace it
comes from) applies whether an individual developer wants it there or not.

## Prerequisites
None for parts 1–3. Part 4 (enterprise) can't be exercised in this repo —
read-only by design, see above.

## Steps to reproduce

### Part 1 & 2 — already demonstrated elsewhere
Nothing to run here. Part 1 is this whole repo's `.claude/skills/`
folders. For part 2, go run `examples/08-plugins/01-basics/README.md`'s
steps — that's the plugin-distribution demonstration, skills included.

### Part 3 — a subagent preloading a skill
1. `cd examples/05-skills/06-sharing-and-distribution`
2. Run `claude`.
3. Ask: "use the style-reviewer agent to check draft.txt against our style
   conventions." Expect the `style-reviewer` subagent to run and flag:
   the Title-Case headings, the exclamation marks, and the very long
   compound sentence in the second paragraph — using conventions it never
   had to ask for or look up, because `skills: [style-conventions]` in
   its own frontmatter loaded that skill's full content into its context
   at startup, before it did anything else.

## Expected result
The subagent's review names the specific violations (Title Case, `!`,
run-on sentence) using the exact vocabulary from `style-conventions`'
`SKILL.md` — confirming it's reasoning from that preloaded content, not
guessing at generic "style" advice.

## Gotchas / notes
- **Project-repo sharing is this repo's default, not a separate demo.**
  Every `.claude/skills/` folder across all 27 sub-examples here is
  already "shared via project repository" — cloning `claude_hub` hands
  someone all of them at once. Worth naming explicitly since it's easy to
  read past something that's just... always been true here.
- **The `skills:` subagent field only *preloads* — it doesn't gate
  access.** Per the official docs (checked while building this, since the
  course's phrasing implied otherwise): even without listing a skill in
  `skills:`, a subagent can still discover and invoke project, user, and
  plugin skills through the Skill tool at runtime. What `skills:` buys you
  specifically is that the listed skill's full content is already in
  context at the agent's very first turn, at the cost of that many tokens
  up front whether the agent ends up needing it or not.
- **Correction to this batch's source course:** it states "Built-in
  agents (like Explorer, Plan, and Verify) can't access skills at all."
  The official docs say something narrower: built-in agents can't
  *preload* skills via `skills:` (that field is custom-subagent-only),
  but they can still invoke skills at runtime through the Skill tool like
  any other agent. "Can't preload" and "can't access at all" are
  different claims — flagging this the same way this repo flagged the
  MCP course's deprecation gap in `examples/07-mcp-servers/`.
- You genuinely cannot preload a skill that sets
  `disable-model-invocation: true` (including the bundled `/verify`
  skill) — preloading draws from the same pool Claude can invoke on its
  own, and a manual-only skill isn't in that pool.
- **Enterprise managed settings — the real shape**, for reference (not
  run here): a skill dropped at `.claude/skills/<name>/SKILL.md` inside
  the OS-specific managed-settings directory beats every other copy of a
  same-named skill, no matter what a project or personal skill says:

  | OS | Managed settings directory |
  |---|---|
  | macOS | `/Library/Application Support/ClaudeCode/` |
  | Linux / WSL | `/etc/claude-code/` |
  | Windows | `C:\Program Files\ClaudeCode\` |

  For mandating skills come only from *approved sources* rather than
  planting one specific skill, the relevant key is
  `strictPluginOnlyCustomization` in `managed-settings.json` — set to
  `true` it blocks skills (and agents, hooks, and MCP servers) from user
  and project sources entirely, or pass an array to lock only some of
  those four:
  ```json
  {
    "strictPluginOnlyCustomization": ["skills", "agents"]
  }
  ```
  and `strictKnownMarketplaces` restricts which plugin marketplaces
  (and therefore which plugin-delivered skills) are installable at all —
  the course's example of this key is accurate:
  ```json
  "strictKnownMarketplaces": [
    { "source": "github", "repo": "acme-corp/approved-plugins" },
    { "source": "npm", "package": "@acme-corp/compliance-plugins" }
  ]
  ```

## Further reading
- https://code.claude.com/docs/en/sub-agents.md
- https://code.claude.com/docs/en/managed-settings.md
- https://code.claude.com/docs/en/skills.md
- `examples/08-plugins/01-basics/` — the plugin-distribution demo this folder cross-references
