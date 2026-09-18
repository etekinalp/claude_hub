# 02 — Auto Mode

## What this demonstrates
Auto mode as a distinct execution model (not just another value for
`--permission-mode`): a classifier reviews each tool call and blocks
anything irreversible, destructive, or aimed outside your working
repo/remotes — without prompting for routine actions. This folder also
shows the one piece of it that *is* project-scoped: forcing a human
checkpoint on `git push`/`gh pr create` even while auto mode is on.

## Why it matters
`01-basics` compares modes that are really just "how much does Claude ask
before acting." Auto mode is a different mechanism entirely — a second,
independent classifier gate that runs after the normal permission system,
with its own hard-deny/soft-deny/allow rule tiers. Understanding the
distinction matters because auto mode is now the default execution model
on several plans.

## Prerequisites
None to observe the default behavior. Customizing the classifier's trusted
environment requires editing `~/.claude/settings.json` (see Gotchas) — not
done automatically here, since it's outside this repo.

## Steps to reproduce
1. `cd examples/13-permission-modes/02-auto-mode`
2. Run `claude --permission-mode auto`
3. Ask Claude to edit `scratch.txt` (e.g. add a line). Expect it to happen
   without a prompt — a routine, reversible, in-repo action the classifier
   allows by default.
4. Ask Claude to run `git push` (it's fine if it fails locally, e.g. no
   remote configured — the point is what happens *before* it runs). Expect
   a permission prompt anyway: this folder's `.claude/settings.json` sets
   `permissions.ask` on `git push *` and `gh pr create *`, and an explicit
   `ask` rule always forces a prompt, even in auto mode, before the
   classifier is even consulted.
5. Ask Claude to do something that reaches outside this repo/its remotes
   (e.g. "write a file to /tmp/outside-repo-test.txt", or push to a
   different, unrelated repo). Expect the classifier to block it as
   outside the trusted environment, with a named reason in the denial.

## Expected result
Routine in-repo edits proceed with no prompts; `git push`/`gh pr create`
still checkpoint via the project-level `ask` rule regardless of mode; and
genuinely out-of-scope actions get blocked by the classifier with a named
reason, not silently allowed just because the mode is "auto."

## Gotchas / notes
- The `autoMode` settings block itself (`environment`, `allow`,
  `soft_deny`, `hard_deny`) is deliberately **not read from project
  settings** (`.claude/settings.json` or `.claude/settings.local.json`) —
  only from `~/.claude/settings.json` (personal), managed/organization
  settings, or a `--settings`/Agent SDK override. This stops a checked-in
  repo from granting itself its own bypass rules. Only `permissions.ask`
  and `permissions.deny` (the normal permission system, example 02) are
  project-scopable and still apply before the classifier runs.
- Run `claude auto-mode config` to see the effective classifier rules
  (defaults plus your personal `~/.claude/settings.json` additions), and
  `claude auto-mode defaults` to see the built-in rules alone.
- `/auto-mode-setup` can draft `autoMode.environment` entries for you from
  this project's CLAUDE.md, README, and git remotes — worth trying in a
  real project, not attempted here since it writes to
  `~/.claude/settings.json`, outside this repo.
- Explicit user intent can override a `soft_deny` rule ("force-push this
  branch" is specific enough; "clean up the repo" is not) — `hard_deny`
  rules can't be overridden by intent at all.

## Further reading
- https://code.claude.com/docs/en/auto-mode-config
- https://code.claude.com/docs/en/permission-modes
