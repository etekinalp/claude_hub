# 07 — Debugging & Validation

## What this demonstrates
Three real, structural skill bugs, each as a `broken/` version and a
`fixed/` version side by side: a `SKILL.md` sitting directly in
`.claude/skills/` instead of its own folder, invalid YAML frontmatter,
and a bundled script missing its executable bit. Plus a walkthrough of
the actual diagnostic commands Claude Code gives you for these and the
two other failure classes (triggering problems, priority conflicts) that
don't reduce to a file you can just point at.

## Why it matters
"My skill isn't working" is almost always one of a handful of specific,
diagnosable causes, not a mystery — but only if you know which command
surfaces which kind of failure. This example exists to make that mapping
concrete: some things are inspectable structurally, some only show up in
a live session, and one of the four categories the course this batch is
based on describes (a CLI "skills validator") turned out not to exist as
described once checked against the official docs — worth knowing before
you go looking for a tool that isn't there. See Gotchas.

## Prerequisites
`python3` with `pyyaml` (`pip install pyyaml`) if you want to re-run the
structural checks below yourself; not needed just to read this README.

## Steps to reproduce

### Part 1 — three structural bugs, verified
This folder doesn't ask you to spot these live in a session — they're
verified directly against what actually parses/executes, the same way
Claude Code's own loader would hit them:

1. **Flat file, not a folder**: `broken/.claude/skills/flat-file.md`
   exists directly under `skills/`, not as
   `skills/flat-file/SKILL.md`. Per the docs, this makes it invisible —
   it won't appear in `/skills` at all. `fixed/.claude/skills/flat-file-fixed/SKILL.md`
   is the same content, correctly placed.
2. **Invalid YAML frontmatter**:
   `broken/.claude/skills/bad-yaml/SKILL.md` has an unterminated quoted
   string in its `description` field. Parsing it with a real YAML parser
   throws:
   ```
   while scanning a quoted scalar
     in "<unicode string>", line 2, column 14:
       description: "unterminated string frontmatter
                    ^
   found unexpected end of stream
   ```
   `fixed/.claude/skills/good-yaml/SKILL.md` parses cleanly.
3. **Script missing its executable bit**:
   `broken/.claude/skills/no-exec-script/scripts/greet.sh` is valid bash
   but was never `chmod +x`'d. Running it directly fails immediately:
   ```
   $ ./broken/.claude/skills/no-exec-script/scripts/greet.sh
   bash: ...: Permission denied
   ```
   (exit code `126`) — this is exactly the failure Claude would hit
   trying to run it mid-skill.
   `fixed/.claude/skills/exec-script/scripts/greet.sh` is `chmod +x`'d
   and runs cleanly, printing `hello from greet.sh`.

   Re-run these three checks yourself: from this folder,
   `python3 -c "import yaml; yaml.safe_load(open('broken/.claude/skills/bad-yaml/SKILL.md').read().split('---')[1])"`
   reproduces the parse error; `test -x broken/.claude/skills/no-exec-script/scripts/greet.sh && echo yes || echo no`
   reproduces the permission check.

### Part 2 — triggering problems: already staged in example 03
Don't rebuild it here — `examples/05-skills/03-descriptions-and-allowed-tools/`'s
`summarize-vague` vs. `summarize-specific` pair *is* this failure class,
live. The diagnostic process the docs recommend: when a skill won't fire,
try 2-3 different phrasings of the same request ("help me profile this",
"why is this slow", "make this faster" is the docs' own example set for a
performance-tuning skill), see which land, and fold the language from the
phrasings that *didn't* land into the skill's `description`.

### Part 3 — priority conflicts: already tabled in example 02
`examples/05-skills/02-anatomy-and-discovery/`'s storage-location table
has the full precedence order. The short version for a same-named
conflict: enterprise beats personal beats project beats a plugin's
namespaced copy. If a project skill of yours silently stops firing and
you didn't touch it, check whether your organization (or you, locally)
added a same-named skill somewhere higher in that order — renaming your
copy is almost always the faster fix over escalating to an administrator
for the enterprise case.

### Part 4 — the real diagnostic commands
Run these inside `claude`, in any session, to see what they report for
your actual setup (not specific to this folder):

| Command | What it shows |
|---|---|
| `/skills` | Every available skill from project, user, and plugin sources (not bundled ones) |
| `/context` | Everything in the context window right now, including a skills section that **does** include bundled skills |
| `/doctor` (in-session) | Setup checkup with proposed fixes: invalid settings files, duplicate subagent names, and more |
| `claude doctor` (terminal, no session) | Same read-only diagnostics, without starting a session |
| `/debug [issue]` | Turns on debug logging for the session and asks Claude to diagnose using the log |
| `claude --debug` (terminal) | Starts a session with debug logging on from the first line |
| `/status` | Which settings sources are active, including managed settings |
| `claude --safe-mode` | Starts a session with CLAUDE.md, skills, plugins, hooks, MCP servers, and custom commands/agents all disabled — if a problem vanishes here, it's one of those; re-enable them one at a time to isolate which |

## Expected result
The three structural checks in Part 1 reproduce exactly the output quoted
above (a YAML parse traceback for `bad-yaml`, a `Permission denied` /
exit `126` for `no-exec-script`) — this repo actually ran them while
building this example, not just describing the expected behavior.
`/skills` inside a live session started in `broken/` should list none of
the three broken skills usably (the flat file won't appear at all; the
other two may appear but fail when invoked); the same commands run from
`fixed/` should list and successfully invoke all three fixed versions.

## Gotchas / notes
- **The course this whole `05-skills` batch is based on describes "a
  skills validator... a command-line utility (installed via uv)."**
  Checked directly against the current official docs
  (`code.claude.com/docs/en/skills`, `debug-your-config`) while building
  this, and no such tool is documented as part of Claude Code. What *is*
  real and documented: `/skills`, `/context`, `claude doctor`/`/doctor`,
  `claude --debug`/`/debug`, `/status`, and `claude --safe-mode` (all
  tabled above) — plus, separately, the `anthropics/skills` GitHub repo's
  own `package_skill.py` for validating a skill against the portable
  Agent Skills spec *before uploading it to claude.ai*, which is a real
  but different thing from a general Claude-Code-side validator. This
  example's structural checks (Part 1) do by hand, with a plain YAML
  parser and `test -x`, roughly what such a validator would check — that
  gap is exactly why this repo built them explicitly rather than naming
  a tool that couldn't be confirmed. Flagging this the same way this
  repo's MCP batch flagged its own course/spec mismatch — see
  `docs/gap-analysis.md`.
- `/skills` and `/context`'s skills section are **not** the same list:
  `/context` additionally includes Claude Code's own bundled skills,
  which `/skills` leaves out. If you're hunting for why something is or
  isn't loaded, check both.
- The docs are explicit that a malformed **user, project, or local**
  settings/hooks file is rejected as a whole with a warning, while a
  malformed **managed** settings entry degrades more gracefully (invalid
  entries are dropped individually where possible) — the failure mode is
  not symmetric between the two, worth knowing if you're debugging a
  managed-settings skill rollout specifically (example 06 has the real
  file paths).
- None of this folder's `broken/` skills are wired into this example's
  own `.claude/` at the top level — they live under `broken/.claude/`
  and `fixed/.claude/`, one level down, specifically so opening this
  folder in Claude Code doesn't load six half-broken skills into every
  session here. `cd` into `broken/` or `fixed/` specifically to exercise
  either set.

## Further reading
- https://code.claude.com/docs/en/skills.md
- https://code.claude.com/docs/en/debug-your-config.md
- https://academy.claude.com/courses/introduction-to-agent-skills
