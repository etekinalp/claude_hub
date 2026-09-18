# 01 — Basics

## What this demonstrates
A saved dynamic workflow (`.claude/workflows/find-todos.js`) that fans out
one agent per file in `sample-modules/` to find TODO/FIXME markers, then
returns a consolidated list — plus the ad-hoc form, asking Claude to "use a
workflow" for a one-off task without saving anything.

## Why it matters
Workflows move the orchestration plan out of Claude's context and into a
script: instead of Claude deciding turn-by-turn what to spawn next (like
subagents in example 04), the script itself holds the loop, and
intermediate results live in script variables, not the conversation. That's
what lets a single run fan out to dozens or hundreds of agents without
blowing up context, and what makes the orchestration itself something you
can save, diff, and rerun.

## Prerequisites
A paid plan, Anthropic API access, or Bedrock/GCP Agent Platform/Foundry —
dynamic workflows aren't available on every account tier. On a Pro plan,
turn them on first via the "Dynamic workflows" row in `/config`.

## Steps to reproduce
1. `cd examples/15-dynamic-workflows/01-basics`
2. Run `claude`
3. Run `/find-todos` — this is the saved workflow at
   `.claude/workflows/find-todos.js`, auto-loaded and available as a `/`
   command.
4. Approve the run when prompted (the exact prompt depends on your
   permission mode).
5. Run `/workflows`, select the run, and press Enter to watch its progress
   in real time — one agent per file, running in parallel.
6. Once it finishes, compare the consolidated report against the actual
   TODO/FIXME markers in `sample-modules/` (module-a and module-c each have
   one, module-b has none).
7. Separately, try the ad-hoc form on a throwaway task in the same session:
   "use a workflow to count how many words are in each file under
   sample-modules/" — note that nothing gets saved to `.claude/workflows/`
   unless you explicitly save it afterward via `/workflows` → select the
   run → `s`.

## Expected result
The saved workflow reports module-a and module-c as containing a
TODO/FIXME (quoted exactly) and module-b as clean, running entirely in the
background while your session stays responsive — confirmed by being able
to keep typing during step 5 rather than waiting on a blocking turn.

## Gotchas / notes
- Workflow scripts have no direct filesystem or shell access themselves —
  only the `agent()` calls they spawn do. The script only coordinates.
- Up to 16 concurrent agents, 1,000 agents per run, and up to 4,096 items
  per `pipeline()`/`parallel()` call — this example is far under all three
  limits on purpose, to keep it fast and cheap to run repeatedly.
- Saved workflows can also live at `~/.claude/workflows/` (personal, every
  project) instead of a project's `.claude/workflows/` (shared, this repo).
  This example uses project scope so it travels with the repo.
- A workflow run still counts against normal usage/rate limits — small
  runs like this one are cheap, but a large fan-out (dozens to hundreds of
  agents) can use meaningfully more tokens than working the same task
  turn-by-turn.

## Further reading
- https://code.claude.com/docs/en/workflows
