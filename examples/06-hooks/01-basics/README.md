# Hooks

## What this demonstrates
Three hook scripts wired to three lifecycle events via `.claude/settings.json`:
`SessionStart` (logs when a session begins), `PostToolUse` (logs every Bash
command that ran), and `PreToolUse` (blocks any Bash command containing
`rm -rf` before it runs, regardless of what the model intended).

## Why it matters
Hooks are Claude Code's deterministic layer — they run whether or not the
model "decides" to comply, which is what separates them from a CLAUDE.md
instruction like "please don't run rm -rf" (a suggestion the model could
still get wrong). Compare with example 02's `permissions.deny`: that's a
declarative pattern match; hooks are an arbitrary script, so they can log,
transform, or block based on any logic you write.

## Prerequisites
None (uses plain bash scripts, no extra dependencies).

## Steps to reproduce
1. `cd examples/06-hooks/01-basics`
2. `rm -f hook-log.txt` (start from a clean log — safe, this file is just
   this example's own generated output, see Gotchas)
3. Run `claude` — a `SessionStart` line should already be appended to
   `hook-log.txt` before you type anything.
4. Ask Claude to run `ls` in Bash. Expect it to succeed, and a new
   `PostToolUse` line to appear in `hook-log.txt` recording it.
5. Ask Claude to run `rm -rf /tmp/some-test-file`. Expect it to be blocked
   with a custom message before execution — and no matching `PostToolUse`
   line for it, since `PreToolUse` stopped it first.

## Expected result
`hook-log.txt` accumulates `SessionStart` and `PostToolUse` entries for
everything that actually ran; the `rm -rf` attempt never executes and never
gets logged as having run, only as blocked.

## Gotchas / notes
- `hook-log.txt` is generated at runtime by these hooks, not a source file —
  it's gitignored.
- The hook config shape (`matcher` + `hooks: [{type: "command", command:
  ...}]`) and env vars like `$CLAUDE_PROJECT_DIR` have been stable across
  recent versions, but verify against your installed version's
  `hooks-guide.md` if a hook doesn't fire as expected.
- Blocking here uses exit code `2` (stderr becomes the message Claude sees).
  Some versions also support a JSON response on stdout for richer control —
  worth checking if you need more than allow/block.

## Further reading
- https://code.claude.com/docs/en/hooks-guide.md
