# Subagents

## What this demonstrates
A project-level subagent (`.claude/agents/note-summarizer.md`) with a
restricted toolset (`Read`, `Grep` only — no edits) and a different model
(`haiku`) than whatever model your main session is running.

## Why it matters
Subagents let you delegate a subtask to a specialist with its own prompt,
its own tool permissions, and its own model — useful both for safety (an
agent that can only read can't accidentally break anything) and for cost
(cheap, fast model for a mechanical task, saving the expensive model for
things that need it).

## Prerequisites
None.

## Steps to reproduce
1. `cd examples/04-subagents/01-basics`
2. Run `claude`
3. Ask plainly: "What's in notes/meeting-notes.txt?" — see whether Claude
   picks the `note-summarizer` subagent on its own, based on the
   description match.
4. In a fresh session, ask explicitly: "Use the note-summarizer subagent to
   summarize notes/meeting-notes.txt." — forces the delegation directly.
5. Try asking the subagent (via either route) to also *edit* the notes file.
   Expect it to be unable to — `tools` on this agent doesn't include `Edit`
   or `Write`.

## Expected result
The summary comes back as exactly 3 bullet points (per the agent's
instructions), sourced only by reading the file — and any attempt to have
it edit the file is blocked by its restricted `tools` list, not just
discouraged by the prompt.

## Gotchas / notes
- `tools` is an actual permission boundary, not a suggestion the agent can
  talk itself out of — that's the point of testing step 5.
- `model` on a subagent can differ from your main session's model; useful
  for cost/speed tradeoffs on mechanical subtasks, but check output quality
  before relying on a cheaper model for anything that needs judgment.
- Same project/user scoping as commands and settings: this agent only
  exists for sessions launched from this folder; `~/.claude/agents/` would
  make one available everywhere.
- Subagent frontmatter also supports `isolation: worktree` (runs the
  subagent in its own git worktree — see `examples/11-worktrees/` for what
  worktrees are), plus `background`, `maxTurns`, and `disallowedTools` —
  none demoed in this minimal example, but worth knowing they exist.

## Further reading
- https://code.claude.com/docs/en/sub-agents.md
