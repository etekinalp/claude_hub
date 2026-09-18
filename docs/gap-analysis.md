# Gap Analysis — what this repo doesn't cover yet

Dated audit of how complete the 13 concepts are against the current Claude
Code feature set. Spot-checked against live docs where flagged; treat
anything not spot-checked as "probably real, verify before building."

_Last run: 2026-09-18._

## Genuinely uncovered concepts (no folder at all yet)

**Update 2026-09-18:** the four items confirmed by live doc fetch below —
auto mode, routines, dynamic workflows, ultrareview — are now built.
Auto mode lives at `examples/13-permission-modes/02-auto-mode/`; the other
three each got their own top-level folder (`14-routines`,
`15-dynamic-workflows`, `16-ultrareview`), two of them (routines,
ultrareview) documented-not-run since actually invoking them has real
account-level side effects (persistent cloud automation; metered,
non-refreshing free runs). Exact syntax for all four was pulled from a
live fetch of their doc pages, not just research-agent recall — see each
folder's README for the citations.


Confirmed to have real, current doc pages (spot-checked):
- **Auto mode** — a distinct execution model, not just a permission mode: a
  classifier handles permission prompts, hard deny rules block risky
  actions (e.g. git/transcript tampering) automatically. Now default on
  several plans. `auto-mode-config`, `permissions`.
- **Routines** — scheduled or event-triggered cloud agents (cron, GitHub
  push/PR/issue, API call). Distinct from hooks (reactive, local) and from
  a scheduled task. `routines`.
- **Dynamic workflows** — orchestrating dozens-to-hundreds of subagents
  from a script Claude writes, distinct from spawning one subagent by
  hand (example 04). `workflows`.
- **Ultrareview** — a fleet of cloud review agents that hunt for bugs and
  report findings, distinct from the local `/code-review` command.
  `ultrareview`.

Corroborated by two independent research passes, not yet spot-checked
individually — verify against current docs before building:
- **Goal mode** (`/goal`) — keep Claude working across turns until a
  completion condition holds.
- **Artifacts** — publishing session output as a live, shareable page.
- **Effort levels & fast mode** — cost/performance tuning distinct from
  model choice.
- **Computer use** — GUI automation on native apps.
- **Session branching/forking** (`/branch`, `/fork`) and
  **checkpointing/rewind** (`/rewind`) — conversation variants and
  rollback, distinct from worktrees (which are git-based, not
  conversation-based).
- **Agent view / cross-session messaging** — `claude agents` overview plus
  sessions messaging each other.
- **Plugin evaluation** (`claude plugin eval`) — test a plugin against a
  case suite with graders; example 08 only covers `--plugin-dir` loading,
  not testing.
- **Monitor tool** — streaming background events/logs into a session.
- **LSP servers** (`.lsp.json`) — language-server-backed code intelligence.
- **Background monitors** — watching logs/files, notifying Claude of
  events (related to but distinct from the Monitor tool above).
- **The Claude Agent SDK vs. the Claude Code CLI** — how the SDK this
  environment itself runs on relates to the CLI documented everywhere
  else in this repo.
- **Server-managed / enterprise settings** — centralized org policy,
  distinct from the project/user settings in example 02.

### Correction from the first research pass
One item — **"Ultraplan"** (cloud plan drafting) — was reported as an
early-preview feature. The actual current docs page is titled
**"Ultraplan is no longer available."** It shipped and was since
discontinued. Not a candidate for a new example; noted here only so it
doesn't get re-proposed.

## Known gaps within the existing 13

- **06-hooks**: only covers `SessionStart`/`PostToolUse`/`PreToolUse`.
  Missing `PermissionRequest`, `SessionEnd`, `WorktreeCreate`/`Remove`,
  `Elicitation`, and conditional (`if`) hooks.
- **04-subagents**: only covers `tools` + `model`. Missing `background:
  true`, `isolation: worktree`, `maxTurns`, `disallowedTools`, and nested
  subagent delegation.
- **07-mcp-servers**: 02–05 already flagged as planned (see that folder's
  index). Additionally missing: MCP "channels" (webhook-style push into a
  running session), Tool Search (for servers exposing very many tools),
  and parameter-matching permission rules (`Tool(param:value)`).
- **02-settings-and-permissions**: missing environment-variable-based
  config (e.g. a default-model or effort-cap env var), `fallbackModel`
  chains, and server-managed settings (see above, arguably its own
  concept rather than a sub-aspect).
- **05-skills**: doesn't cover Anthropic's own bundled/first-party skills
  catalog, only custom ones.
- **03-slash-commands**: `builtin-commands-reference.md` is a snapshot —
  worth re-running the research and diffing periodically, since this
  surface changes weekly per the docs' own changelog cadence.

## Deliberately not worth a dedicated example

Cosmetic or platform-specific, not a distinct mechanism: statusline
customization, terminal themes/Vim mode, IDE extensions (VS Code,
JetBrains), desktop/mobile platform variants, Claude in Chrome (separate
product surface), fullscreen/accessibility rendering options. These are
configuration or platform choices, not concepts with their own "why does
this work this way" to isolate and document.

## Confidence notes

Specific version/date citations ("Week NN") and pricing figures from the
research passes behind this file were not independently verified beyond
the spot-checks noted above — treat those specifics as illustrative, not
exact, and re-check the relevant docs page before writing anything
build-worthy into a new example.
