# 04 — Progressive Disclosure

## What this demonstrates
One larger skill, `repo-stats`, organized the way the docs recommend once
a skill outgrows a single self-contained `SKILL.md`: a short top-level
file that stays under the recommended 500-line ceiling, an executable
`scripts/repo_stats.sh` that Claude *runs* rather than reads, a
`references/interpreting-stats.md` pulled in only when the user actually
wants analysis rather than raw numbers, and an `assets/report-template.md`
used only when a formatted report is requested.

## Why it matters
Every one of this skill's four files could have been pasted directly
into `SKILL.md` — the script's logic, the interpretation notes, the report
format. Doing that would make *every* invocation of this skill cost the
tokens of all four, whether the request needed them or not. Progressive
disclosure is the discipline of keeping the always-loaded file (the
`SKILL.md` body itself, once triggered) down to just the routing logic —
what to run, and when to go read something else — and pushing everything
else out to files that only enter context on the turns that actually need
them. The script goes further still: its *source* never has to enter
context at all, only its output does, which is the entire point of telling
Claude to run scripts instead of reading them.

## Prerequisites
`git` (the script uses `git rev-parse` to find the repo root; falls back
to the current directory if that fails, so it still works if you copy just
this skill elsewhere).

## Steps to reproduce
1. `cd examples/05-skills/04-progressive-disclosure`
2. Run `claude`.
3. Ask: "what are the repo stats for claude_hub?" Expect `repo-stats` to
   fire, run `scripts/repo_stats.sh` (no approval prompt — pre-approved by
   this skill's `allowed-tools`), and report back four numbers in plain
   prose. `references/interpreting-stats.md` should **not** be pulled in
   for this — it's a plain numbers request.
4. Ask a follow-up in the same session: "what do these numbers actually
   tell me?" Expect Claude to now read `references/interpreting-stats.md`
   and answer using its guidance (the README-lines-per-sub-example health
   check, specifically) — this is the on-demand load happening live.
5. Ask: "give me that as a formatted report." Expect it to use
   `assets/report-template.md`'s table structure, filled in with the
   script's real output and today's date.

## Expected result
Step 3's answer is short and numbers-only. Step 4's answer visibly changes
character — it starts reasoning using content that wasn't in context a
moment ago, specifically the health-check ratio from the reference file.
Step 5 produces a table matching the asset template's shape, not a
freehand report — confirming the template actually got used rather than
Claude improvising a similar-looking one from memory.

## Gotchas / notes
- The 500-line `SKILL.md` ceiling is a guideline for staying token-cheap
  on every invocation, not a hard limit Claude Code enforces — nothing
  breaks at line 501, it just starts costing more on every single trigger
  whether that content was needed or not.
- `${CLAUDE_SKILL_DIR}` in this skill's `allowed-tools` value resolves to
  this skill's own folder (`.claude/skills/repo-stats/`), not the plugin
  or project root — confirmed by the script test above only being
  reachable via that exact substitution, run from two different working
  directories, with the same correct result both times.
- The instruction "do not read the script itself, just run it" in
  `SKILL.md` matters: if Claude reads the script's source instead of
  executing it, its ~20 lines of bash enter context on every single
  invocation for no reason — exactly what progressive disclosure is
  trying to avoid. Watch for this if you copy this pattern: the file
  being executable isn't enough on its own, the skill has to explicitly
  say "run", not "read" or "look at".
- `scripts/`, `references/`, and `assets/` are conventional folder names
  from the docs, not required ones — Claude Code doesn't treat them
  specially by name, `SKILL.md`'s own prose is what tells Claude when to
  open each one. Naming them this way is purely for a human skimming the
  skill's folder later.

## Further reading
- https://code.claude.com/docs/en/skills.md
- https://academy.claude.com/courses/introduction-to-agent-skills
