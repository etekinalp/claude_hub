# 03 — Descriptions & Tool Access

## What this demonstrates
Four skills, two contrasts:

- `summarize-vague` vs. `summarize-specific` — identical behavior, wildly
  different `description` fields, to isolate how much auto-invocation
  reliability depends on that one field.
- `git-status-checker` (`allowed-tools`) vs. `read-only-reviewer`
  (`disallowed-tools`) — two frontmatter fields that sound like opposites
  of the same thing and are actually **not**: one pre-approves specific
  tools for the turn, the other actually removes tools from the pool.

## Why it matters
"Write a good description" is easy to say and hard to do without seeing
a bad one fail. Putting `summarize-vague` and `summarize-specific` side by
side, both doing the exact same thing internally, makes the difference
visible instead of theoretical. The `allowed-tools`/`disallowed-tools`
pair matters for a sharper reason: **they are not opposites**, and mixing
them up is an easy, consequential mistake. `allowed-tools` only
pre-approves listed tools so Claude doesn't stop to ask permission for
them *during the turn that invokes the skill* — every other tool is still
fully available, permissions just apply normally to them. `disallowed-tools`
is the one that actually shrinks what's callable, by removing tools from
the pool while the skill is active. If you want a skill that genuinely
can't write files, `allowed-tools: Read, Grep, Glob` does **not** get you
that — it only smooths over asking for those three; `disallowed-tools:
Write, Edit, Bash` does.

## Prerequisites
This example's `.mcp.json`-equivalent is just `.claude/skills/` — no
extra setup. `git-status-checker` expects to run inside a git repo (it
will, since this whole folder lives inside `claude_hub`).

## Steps to reproduce

### Part 1 — description quality and trigger reliability
1. `cd examples/05-skills/03-descriptions-and-allowed-tools`
2. Run `claude`.
3. Say: "can you give me a TL;DR of this paragraph: [paste a few
   sentences of anything]." Expect `summarize-specific` to fire —
   its description explicitly lists "TL;DR" as a trigger phrase.
4. In a fresh session, say the same thing again but expect to watch
   `summarize-vague` NOT fire, or fire unreliably — "Helps with summaries"
   gives Claude almost nothing to match your actual phrasing against. Try
   a couple of different odd phrasings ("shrink this down for me", "what's
   the short version") and notice `summarize-specific` keeps catching them
   while `summarize-vague` is hit or miss.

### Part 2 — allowed-tools: pre-approval, not restriction
1. Still in this folder, ask: "check the git status of this folder using
   the skill." Expect `git-status-checker` to fire and run `git status`
   **without** stopping to ask your permission for that specific `Bash(git
   status *)` call — that's the pre-approval `allowed-tools` grants for
   this turn.
2. In the same turn, ask it to also do something unrelated and not listed
   in `allowed-tools` (e.g. "and read fixture-file.txt too"). Expect
   normal permission behavior for that second action — `allowed-tools`
   only touched the one Bash pattern it named, nothing else was
   restricted or opened up.

### Part 3 — disallowed-tools: actual restriction
1. Ask: "do a read-only review of this folder's files." Expect
   `read-only-reviewer` to fire, read `fixture-file.txt` (and anything
   else here) with Read/Grep/Glob, and report back.
2. Still in that same reply/turn, ask it to edit `fixture-file.txt` or run
   a shell command. Expect it to be unable to — `Write`, `Edit`, and
   `Bash` are removed from its available tools for this turn by
   `disallowed-tools`, not just de-prioritized.
3. Send a new message (new turn) asking it to edit the file directly,
   without invoking the skill again. Expect this to work normally — both
   `allowed-tools` and `disallowed-tools` clear at the next user message.

## Expected result
Part 1: `summarize-specific` reliably fires across varied phrasing;
`summarize-vague` is noticeably less reliable, if it fires at all — same
underlying instruction, different match rate, purely from `description`
wording. Part 2: `git status` runs with no approval prompt, but the
unrelated follow-up action still goes through normal permission handling
— proving `allowed-tools` didn't touch anything outside its own list.
Part 3: file edits and shell commands are unavailable for the rest of
that turn once `read-only-reviewer` is active, and return to normal on
the next message.

## Gotchas / notes
- **The course this repo's `05-skills` batch is based on describes
  `allowed-tools` as restricting "which tools Claude can use while the
  skill is active."** Cross-checked against the official docs
  (`code.claude.com/docs/en/skills`) while building this, and that's not
  quite right: `allowed-tools` pre-approves a specific list for the
  invoking turn only, it does not remove any other tool from the pool —
  all tools remain callable, ordinary permission rules still govern the
  ones not listed. `disallowed-tools` is the field that actually
  restricts, by removing tools from what's callable. Part 2 vs. Part 3
  above is this repo's own empirical check of that distinction, not just
  a read of the docs.
- `allowed-tools`/`disallowed-tools` accept a space-separated string, a
  comma-separated string, or a YAML list — all three forms are
  equivalent. Bash entries support prefix matching:
  `Bash(git status *)` matches any `git status ...` invocation, not just
  the bare command.
- Both fields' effect clears the moment you send your next message — they
  scope to the single turn that invoked the skill, not the rest of the
  session.
- `description` has a combined 1,536-character cap with the optional
  `when_to_use` field (not used in this example) — plenty of room for
  the kind of specific, phrasing-rich description `summarize-specific`
  uses; there's rarely a good reason to leave it as terse as
  `summarize-vague`'s.

## Further reading
- https://code.claude.com/docs/en/skills.md
- https://academy.claude.com/courses/introduction-to-agent-skills
