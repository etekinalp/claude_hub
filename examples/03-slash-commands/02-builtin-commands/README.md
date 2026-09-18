# 02 — Built-in Commands Walkthrough

## What this demonstrates
Actually running the commands catalogued in
[`../builtin-commands-reference.md`](../builtin-commands-reference.md) — one
deliberate pass through what Claude Code ships out of the box, organized by
the same categories as that reference, so each command is understood by
using it, not just by reading a one-line description.

## Why it matters
`01-basics` covers *your own* commands (`.claude/commands/`); this folder
covers the much larger set Claude Code already gives you for free. Knowing
what's already built in stops you from reinventing a command that exists
(e.g. writing a custom `/summary` when `/compact` already does most of it),
and several of these — `/context`, `/usage`, `/rewind`, `/goal` — are the
kind of thing you only really learn by watching what actually happens when
you run them, not from a description.

## Prerequisites
- Claude Code CLI installed and signed in — a few commands here (`/usage`,
  `/cost`) show real data from your account.
- A git repo with something to look at for the review-family commands
  (`/diff`, `/code-review`, `/security-review`, `/verify`) — this folder's
  `scratch.txt` exists for exactly that: make a small edit to it first (see
  its own header comment), then those commands have a real, uncommitted
  change to react to.
- A small number of commands are **not run in this walkthrough** because
  running them for real would have a persistent side effect outside this
  repo (signing you out, sending a real bug report, spending a metered
  resource) — same bar this whole repo holds elsewhere (see examples 12,
  14, 16). Each one below says so explicitly and why.

## Steps to reproduce
Work through these in order, inside `cd examples/03-slash-commands/02-builtin-commands`
with `claude` running. Everything marked **Not run here** is documented
rather than executed — read that row rather than skipping it.

### Session & context management

| Command | Try it | What you should see |
|---|---|---|
| `/context` | `/context` | A breakdown of what's currently filling your context window (system prompt, files read, conversation so far). |
| `/compact` | Read a few files first (e.g. `scratch.txt` and this README), then `/compact` | The conversation gets summarized down to free up context — ask afterward what it still remembers to confirm the summary preserved the key facts. |
| `/branch test-branch` | `/branch test-branch` | A new conversation branch starting from this point — the original conversation is untouched, so you can experiment freely on the branch. |
| `/fork` | Ask a throwaway question, then `/fork` | Copies the conversation to a new background session so it can keep working while your foreground session stays free — check `/tasks` afterward to see it listed. |
| `/cd ../01-basics` then `/cd ../02-builtin-commands` | as shown | Session's working directory moves to `01-basics`, then back — notice project config (like `01-basics`'s `.claude/commands/`) becomes available/unavailable as you cross that boundary, same mechanism as example 02. |
| `/add-dir ../01-basics` | `/add-dir ../01-basics` | Grants file access to a second directory without switching into it or losing this folder's own config. |
| `/clear` | `/clear` | Starts a genuinely empty conversation — the strongest reset available, heavier than `/compact`. |
| `/resume` | `/resume` | A picker over past conversations for this project — pick the one you just abandoned with `/clear` to see it come back. |

### Model & performance

| Command | Try it | What you should see |
|---|---|---|
| `/model` | `/model` | Shows the current model and lets you pick another — note which one you started on if you want to switch back. |
| `/effort status` then `/effort high` | as shown | Current effort level, then a change — higher effort trades speed/cost for more thorough reasoning on hard problems. |
| `/fast` | `/fast` | Toggles fast mode if your plan/model combination supports it, or tells you plainly if it doesn't — either outcome is the expected result, this command's availability is plan-gated. |
| `/advisor` | `/advisor` | Enables/disables the advisor tool — check its current state before and after. |

### Code review & testing

| Command | Try it | What you should see |
|---|---|---|
| `/diff` | Edit `scratch.txt` (e.g. add a comment), then `/diff` | A summary of your uncommitted change to `scratch.txt`. |
| `/code-review` | with the same edit in place, `/code-review` | Findings on the diff — the toy `eval "echo ... $user_input"` and hardcoded `API_KEY` in `scratch.txt` exist specifically to give it something to flag. |
| `/review` | `/review` | Same output as `/code-review` — confirms it's the documented alias. |
| `/security-review` | `/security-review` | A security-focused pass over the same diff — expect it to flag the `eval` on unsanitized input and/or the hardcoded-looking key, since that's exactly what this fixture is for. |
| `/verify` | `/verify` | Verification checks against the change — compare what it checks for against what `/code-review` and `/security-review` each flagged. |

Compare this local, free, seconds-to-minutes tier against the cloud-based,
metered `/code-review ultra` in `examples/16-ultrareview/` once you've tried
these — same command family, very different cost and depth.

### Workflow & automation

| Command | Try it | What you should see |
|---|---|---|
| `/plan add a one-line comment to scratch.txt` | as shown | Plan mode: Claude proposes the change before making it, rather than just doing it. |
| `/goal scratch.txt contains the word DONE` | as shown, then ask Claude to work toward it, then `/goal clear` | Claude keeps working turn-to-turn until the condition holds (add "DONE" to the file), then confirm `/goal clear` releases it. |
| `/batch add a trailing comment "# reviewed" to scratch.txt` | as shown | A single, trivial batch task — kept intentionally small here since `/batch` is meant for large-scale parallel changes and a big one would burn real usage for no learning benefit. |
| `/background summarize scratch.txt` | as shown | The task detaches into a background session; check `/tasks` to see it running/finished without blocking this session. |
| `/tasks` | `/tasks` | Lists background work and subagent tasks — run this after the two rows above to see them show up. |
| `/loop 1 check if scratch.txt changed` | start it, watch **one** iteration fire, then cancel (Ctrl+C) | Confirms the repeating-on-a-schedule behavior — cancel promptly; an uncancelled loop keeps consuming usage on a schedule you can forget about. |
| `/deep-research what changed in Claude Code this month` | as shown | Fans out several web searches and returns a synthesized report — costs real usage (multiple searches), kept to one cheap, small question on purpose rather than an elaborate one. |

### Project setup & configuration

| Command | Try it | What you should see |
|---|---|---|
| `/memory` | `/memory` | Opens CLAUDE.md editing / auto-memory management for this session. |
| `/mcp` | `/mcp` | Reports no MCP servers configured for this folder (correct — none are, on purpose, so this stays about built-in commands only; see example 07 for MCP itself). |
| `/permissions` | `/permissions` | Shows/manages this session's permission rules — compare with example 02's file-based `permissions.deny`. |
| `/config` | `/config` | Opens settings, or set one directly, e.g. `/config theme=dark`. |
| `/init` | `/init` | Generates a `CLAUDE.md` for this folder from what Claude can see here. This is a real file it writes — remove it afterward with `scripts/clean-examples.sh` (added there for exactly this) unless you deliberately want to keep it. |

### Debugging & troubleshooting

| Command | Try it | What you should see |
|---|---|---|
| `/doctor` | `/doctor` | A setup checkup — should report this install as healthy; a real problem would show up here with a suggested fix. |
| `/debug` | `/debug` | Turns on debug logging for the rest of the session — ask it to do something simple afterward and note the extra verbosity. |
| `/rewind` | Make two small, separate edits to `scratch.txt`, then `/rewind` | A checkpoint picker — roll back to before the second edit and confirm `scratch.txt` reverts to match. |

### Design & visualization

| Command | Try it | What you should see |
|---|---|---|
| `/dataviz suggest a chart for showing this repo's 16 concepts by status` | as shown | Design guidance text for a chart, not a rendered one — this command advises, it doesn't draw. |
| `/design` | **Not run here** — a research-preview feature (shipped Week 34, 2026) that opens a full artboard/UI workflow. Worth trying deliberately in a real UI project; out of scope for a slash-commands walkthrough in a docs repo with nothing to design. | — |
| `/design-sync` | **Not run here** — needs a connected design system and its own auth. | — |
| `/design-login` | **Not run here** — same reason as `/design-sync`; nothing to authorize against from this repo. | — |

### API & development tools

| Command | Try it | What you should see |
|---|---|---|
| `/claude-api` | `/claude-api` | Loads the Claude API reference into context and offers API-related subcommands. |
| `/import` | `/import cursor` (or `codex`/`gemini`, whichever you might actually have) | Either imports config from that tool if it finds it on your machine, or reports nothing to import — both are informative, expected outcomes. |

### Utilities & viewing

| Command | Try it | What you should see |
|---|---|---|
| `/btw what does .gitignore do in this repo?` | as shown | Answers the side question without adding it to the main conversation history. |
| `/focus` | `/focus` | Toggles a focused view of the current work. |
| `/copy` | Get a short response first, then `/copy` | Copies the last response to your system clipboard — this is environment-dependent: it works in a real local terminal, and may silently do nothing over a remote/headless shell, which is itself worth knowing. |
| `/export scratch-export.md` | as shown | Writes the conversation to `scratch-export.md` in this folder as plain text — a real file; `scripts/clean-examples.sh` removes it, since it's a byproduct of running this command, not something to keep. |

### Account & status

| Command | Try it | What you should see |
|---|---|---|
| `/status` | `/status` | Session status: model, permission mode, working directory, etc. |
| `/usage` | `/usage` | Real token usage and cost for your account — safe to run, purely informational, no side effect. |
| `/cost` | `/cost` | Same output as `/usage` — confirms the documented alias. |
| `/help` | `/help` | Lists available commands — compare what it shows against `builtin-commands-reference.md` for your installed version. |
| `/login` | **Not run here** — you're presumably already signed in to try any of the above; re-running `/login` risks a real account/session switch, not something to trigger casually mid-walkthrough. | — |
| `/logout` | **Not run here, deliberately.** This ends your real, signed-in session — running it "just to see" is exactly the kind of real, persistent side effect this repo avoids demoing live (same reasoning as examples 12, 14, 16). | — |

### Miscellaneous

| Command | Try it | What you should see |
|---|---|---|
| `/color` | `/color` | Lists/sets the prompt bar color — cosmetic, reversible, safe to play with. |
| `/theme` | `/theme` | Switches the UI color theme. Distinct from example 09's output styles: this changes how the *terminal* looks, output styles change how *Claude writes*. |
| `/mobile` | `/mobile` | Shows a QR code linking this session to the mobile app — harmless to display even if you don't scan it. |
| `/desktop` | `/desktop` | Offers to continue this session in Claude Code Desktop, if it's installed — otherwise reports that plainly. |
| `/feedback` | **Not run here** — sends real product feedback to Anthropic; not something to spam with throwaway walkthrough test content. | — |
| `/bug` | **Not run here** — files a real bug report / shares the conversation; same reasoning as `/feedback`. | — |
| `/exit` | Save for last: `/exit` | Ends the session — the natural last command to actually try. |

## Expected result
By the end, every command in `builtin-commands-reference.md` has either
actually run against this folder's own files (the large majority), or has
an explicit, reasoned note here for why it wasn't — never a silent gap.
`scratch.txt` should end up edited from all the review/rewind/goal/batch
commands above; reset it (and remove any `CLAUDE.md` from `/init` or
`scratch-export.md` from `/export`) with `scripts/clean-examples.sh` before
committing.

## Gotchas / notes
- This is a living checklist more than a fixed script — new built-in
  commands ship on a roughly weekly cadence (see
  `scripts/check-for-updates.sh` at the repo root). When you find a command
  in `builtin-commands-reference.md` that isn't in this walkthrough yet, or
  vice versa, that's this file falling behind, not a mistake in either one.
- A few commands here are plan-gated (`/fast`, `/design`) or
  version-dependent — a "not available" response is itself a valid,
  informative result, not a failure of the walkthrough.
- Commands that mutate session/account-wide state (`/model`, `/color`,
  `/theme`, `/effort`) are easy to leave changed after you're done playing —
  worth checking `/status` at the end if you want everything back to
  default.
- The "documented, not run here" rows follow the exact same standard as
  examples 12 (GitHub Actions), 14 (Routines), and 16 (Ultrareview): a real,
  persistent side effect outside this repo means it gets documented, not
  demoed live.

## Further reading
- https://code.claude.com/docs/en/commands.md
- [`../builtin-commands-reference.md`](../builtin-commands-reference.md) — the catalog this walkthrough runs through
