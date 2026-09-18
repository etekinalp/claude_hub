# Worktrees

## What this demonstrates
Running an isolated Claude Code session in its own git worktree
(`claude -w` / `--worktree`), plus `.worktreeinclude` — a way to carry
specific gitignored files (like local scratch notes) into a freshly created
worktree, which git itself would never do on its own.

## Why it matters
Worktrees let you run multiple Claude Code sessions on the same repo in
parallel without them stepping on each other's uncommitted changes — handy
for "let one session explore a risky refactor while another keeps working
on the main branch." Subagents can also be given `isolation: worktree` (see
example 04) to run in their own worktree automatically.

## Prerequisites
Git installed (already true for this repo).

## Steps to reproduce
1. From the repo root (not inside this example folder), run something like
   `claude -w` or `claude --worktree` (check your version's exact flag) to
   start a session in a new worktree.
2. Confirm you're in a separate worktree: `git worktree list` from a normal
   terminal should show a new entry beyond the main checkout.
3. Make a change in that worktree session and confirm the main checkout
   (in your original terminal) is unaffected until you merge.
4. Separately, look at `examples/11-worktrees/01-basics/.worktreeinclude` and
   `scratch/local-notes.txt` — the latter is gitignored (check `git status`
   won't flag it), yet `.worktreeinclude` marks it to be copied into any new
   worktree created from this repo.

## Expected result
Steps 1-3 confirm worktree isolation: changes in the worktree session don't
touch your main checkout until merged. Step 4 confirms `.worktreeinclude`
is what makes an otherwise-invisible gitignored file follow you into a new
worktree.

## Gotchas / notes
- This example is more "walkthrough" than static artifacts to inspect —
  worktrees are inherently created at runtime, not something to check into
  git ahead of time.
- The exact worktree-launch flag and `.worktreeinclude` file location
  (repo root vs per-example) may differ from what's shown here — verify
  against `worktrees.md` for your version. This example's
  `.worktreeinclude` lives alongside it for demonstration; a real one
  typically sits at the repo root.
- Related hook events exist for this lifecycle too: `WorktreeCreate` /
  `WorktreeRemove` (see example 06 for the general hooks pattern).

## Further reading
- https://code.claude.com/docs/en/worktrees.md
