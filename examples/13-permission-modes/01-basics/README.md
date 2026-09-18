# Permission Modes

## What this demonstrates
How Claude Code's permission mode changes what happens when it wants to
edit `scratch.txt` in this folder — tried across `default` (asks first),
`acceptEdits` (auto-approves file edits), and `plan` (shows a plan before
doing anything).

## Why it matters
Permission mode is a session-wide dial between "ask me about everything"
and "just do it" — useful to match the stakes of what you're doing: `plan`
mode for exploring a risky change, `acceptEdits` for repetitive, low-risk
edits you don't want to keep approving one by one.

## Prerequisites
None.

## Steps to reproduce
1. `cd examples/13-permission-modes/01-basics`
2. Run `claude` (default mode) and ask it to add a line to `scratch.txt`.
   Expect a permission prompt before the edit happens.
3. Exit, then run `claude --permission-mode acceptEdits` and ask the same
   thing. Expect the edit to happen without a prompt.
4. Exit, then run `claude --permission-mode plan` and ask it to make a
   larger change to `scratch.txt`. Expect it to present a plan first,
   before making any edit.
5. Revert `scratch.txt` to its original content between tries if you want a
   clean comparison each time.

## Expected result
Identical requests produce different amounts of friction depending on
mode: a prompt every time (default), no prompt (acceptEdits), or a
plan-first workflow (plan) — same underlying edit, three different
approval postures.

## Gotchas / notes
- The full set of modes turned up by this repo's research includes
  `default`, `acceptEdits`, `auto`, `plan`, `dontAsk`, and
  `bypassPermissions` — `bypassPermissions` is deliberately not exercised
  in this example, since it skips all checks and isn't something to demo
  casually in a shared playground.
- Mode can also be set per-subagent (see example 04's `permissionMode`
  field) rather than only for the whole session via `--permission-mode`.
- Exact flag name and available modes may vary by version — run
  `claude --help` to check.

## Further reading
- https://code.claude.com/docs/en/permission-modes.md
