# 01 — Basics

## What this demonstrates
The shape of a Claude Code routine — a saved prompt, repositories, and
trigger(s) that run as autonomous cloud sessions — via the exact `/schedule`
CLI syntax and the API-trigger request shape, kept as reference rather than
actually created against your account.

## Why it matters
Routines are how Claude Code work keeps happening when your laptop is
closed: scheduled (cron-like), API-triggered (webhook-style), or
GitHub-event-triggered, running on Anthropic-managed cloud infrastructure as
full autonomous sessions with no permission prompts during the run.
Distinct from hooks (example 06 — reactive, local, fires inside a session
you're running) and from GitHub Actions (example 12 — runs in your own CI,
not on Anthropic's infrastructure).

## Prerequisites
A claude.ai subscription (Pro, Max, Team, or Enterprise) — `/schedule`
requires this login, not an API key alone.

## Not run live here, on purpose
Unlike most examples in this repo, this one is deliberately not something
to execute as-is. Creating a routine isn't a local config file — `/schedule`
writes it to your actual claude.ai account, where it will actually run on
its trigger, actually consume your account's daily routine-run allowance,
and actually push commits/PRs under your real connected GitHub identity.
That's a real, persistent side effect outside this repo, not a sandboxed
demo — same reasoning as example 12's inactive GitHub Actions template — so
it's documented here rather than created.

## Steps to reproduce
1. In any Claude Code session (not necessarily in this repo), run:
   `/schedule daily PR review at 9am`
   Claude Code walks you through the same info the web form collects
   (repositories, prompt, trigger) conversationally, then saves it to your
   account. Alias: `/routines`.
2. To see or manage what you created: `/schedule list`, `/schedule update`,
   `/schedule run` (run it immediately), or visit
   https://claude.ai/code/routines directly.
3. To remove a routine you created while testing this, use the web UI's
   **Delete** option on that routine — this repo has no way to do that for
   you, since the routine lives on your account, not in any file here.

## Expected result
Once created, the routine shows up immediately at
https://claude.ai/code/routines and in `/schedule list` — creation happens
synchronously in step 1, no separate "deploy" step. On its next scheduled
fire (or right away via `/schedule run` / the web UI's **Run now**), it
starts as a full autonomous cloud session with no permission prompts during
the run, and that run appears as its own session under the routine's detail
page, where you can read the transcript, review changes, and open a pull
request. A green status in the run list means only that the session started
and exited without an infrastructure error — not that the task in your
prompt succeeded — so open the run itself to confirm what actually happened.

## The API trigger shape
For webhook-style triggering (e.g. from a monitoring tool or deploy
pipeline), a routine can expose an HTTP endpoint. `sample-fire-request.sh`
in this folder shows the exact request shape from the docs — with a
placeholder routine ID and token, not a real one, and is not meant to be
run.

## Gotchas / notes
- Routines are in research preview — behavior, limits, and the API surface
  may change.
- The `text` field sent to the `/fire` endpoint arrives wrapped as labeled
  untrusted data (`<routine-fire-payload>`), not as a direct instruction —
  a routine's saved prompt has to explicitly opt in to acting on it.
- A routine's actions (commits, PRs, Slack messages, etc.) appear as *you*
  — it uses your connected identity, not a service account.
- `/loop` (in-session scheduling) and Desktop scheduled tasks are the
  local equivalents when you don't want a cloud-hosted routine.

## Further reading
- https://code.claude.com/docs/en/routines
