# Built-in Slash Commands — Reference

Catalog of commands that ship with Claude Code itself, as opposed to custom
ones defined in `.claude/commands/` or `.claude/skills/` (see `01-basics/`
for those). This is a reference doc, not a runnable example — there's no
config here to isolate, since these aren't something you configured.

**Source:** https://code.claude.com/docs/en/commands.md, researched via a
live docs fetch. Availability varies by platform, plan, and installed
version — type `/` in any session to see what's actually available to you,
and treat any mismatch with this table as this table being stale, not your
install being wrong.

The "Tried it?" column is meant to be filled in by hand as you actually run
each one — that's the useful documentation here, not the description column,
which is just what the docs claim. [`02-builtin-commands/`](02-builtin-commands/)
is a full runnable walkthrough of this same catalog, with concrete steps and
expected results for (almost) every row below — use it alongside this table
rather than starting from scratch.

## Session & Context Management

| Command | Description | Args | Tried it? |
|---|---|---|---|
| `/clear [name]` | Start a new conversation with empty context | optional | not yet tried |
| `/resume` | Return to an earlier conversation | no | not yet tried |
| `/branch [name]` | Create a branch of the current conversation | optional | not yet tried |
| `/fork [prompt]` | Copy current conversation to a new background session | optional | not yet tried |
| `/cd <path>` | Move session to a new working directory | required | not yet tried |
| `/add-dir <path>` | Add a working directory for file access | required | not yet tried |
| `/context [all]` | Visualize current context usage | optional | not yet tried |
| `/compact [instructions]` | Summarize conversation to free up context | optional | not yet tried |

## Model & Performance

| Command | Description | Args | Tried it? |
|---|---|---|---|
| `/model [model]` | Switch the AI model | optional | not yet tried |
| `/effort [level\|auto\|status]` | Set effort level (low/medium/high/xhigh/max/ultracode) | optional | not yet tried |
| `/fast [on\|off]` | Toggle fast mode | optional | not yet tried |
| `/advisor [model\|off]` | Enable/disable advisor tool | optional | not yet tried |

## Code Review & Testing

| Command | Description | Args | Tried it? |
|---|---|---|---|
| `/code-review [level] [--fix] [pr#\|branch\|path]` | Review diff or PR for bugs and cleanups | optional | not yet tried |
| `/review` | Alias for `/code-review` | optional | not yet tried |
| `/security-review` | Check diff for security vulnerabilities | no | not yet tried |
| `/diff` | Review changes in working tree | no | not yet tried |
| `/verify` | Verification checks for code changes | no | not yet tried |

## Workflow & Automation

| Command | Description | Args | Tried it? |
|---|---|---|---|
| `/batch <instruction>` | Orchestrate large-scale changes in parallel | required | not yet tried |
| `/plan [description]` | Enter plan mode for large changes | optional | not yet tried |
| `/goal [condition\|clear]` | Set a goal for Claude to work toward | optional | not yet tried |
| `/loop [interval] [prompt]` | Run prompt repeatedly on schedule | optional | not yet tried |
| `/background [prompt]` | Detach session to run as background agent | optional | not yet tried |
| `/tasks` | List background work and subagent tasks | no | not yet tried |
| `/deep-research <question>` | Fan out web searches and synthesize a report | required | not yet tried |

## Project Setup & Configuration

| Command | Description | Args | Tried it? |
|---|---|---|---|
| `/init` | Initialize project with a CLAUDE.md guide | no | not yet tried |
| `/memory` | Edit CLAUDE.md files and manage auto memory | no | not yet tried |
| `/mcp [reconnect\|enable\|disable]` | Manage MCP server connections | optional | not yet tried |
| `/permissions` | Manage tool permission rules | no | not yet tried |
| `/config [key=value ...]` | Open Settings or set config directly | optional | not yet tried |

## Debugging & Troubleshooting

| Command | Description | Args | Tried it? |
|---|---|---|---|
| `/doctor` | Run setup checkup and fix issues | no | not yet tried |
| `/debug [description]` | Enable debug logging and troubleshoot | optional | not yet tried |
| `/rewind` | Roll code and conversation back to a checkpoint | no | not yet tried |

## Design & Visualization

| Command | Description | Args | Tried it? |
|---|---|---|---|
| `/design [brief]` | Draft UI mockups and design canvases | optional | not yet tried |
| `/design-sync [hint]` | Sync a React design system to Claude Design | optional | not yet tried |
| `/design-login` | Authorize design-system access | no | not yet tried |
| `/dataviz [request]` | Design guidance for charts and dashboards | optional | not yet tried |

## API & Development Tools

| Command | Description | Args | Tried it? |
|---|---|---|---|
| `/claude-api [subcommand]` | Load Claude API reference and run API tasks | optional | not yet tried |
| `/import [codex\|gemini\|cursor]` | Import config from other tools | optional | not yet tried |

## Utilities & Viewing

| Command | Description | Args | Tried it? |
|---|---|---|---|
| `/copy [N]` | Copy last assistant response to clipboard | optional | not yet tried |
| `/export [filename]` | Export conversation as plain text | optional | not yet tried |
| `/btw [question]` | Ask a side question without adding it to history | required | not yet tried |
| `/focus` | Toggle focus view | no | not yet tried |

## Account & Status

| Command | Description | Args | Tried it? |
|---|---|---|---|
| `/login` | Sign in to your Anthropic account | no | not yet tried |
| `/logout` | Sign out of your Anthropic account | no | not yet tried |
| `/usage` | Show token usage and costs | no | not yet tried |
| `/cost` | Alias for `/usage` | no | not yet tried |
| `/status` | Show session status | no | not yet tried |
| `/help` | Show help and available commands | no | not yet tried |

## Miscellaneous

| Command | Description | Args | Tried it? |
|---|---|---|---|
| `/exit` or `/quit` | Exit the CLI | no | not yet tried |
| `/color [color\|default]` | Set prompt bar color | optional | not yet tried |
| `/theme [theme]` | Change UI theme | optional | not yet tried |
| `/feedback [report]` | Send product feedback | optional | not yet tried |
| `/bug [report]` | Report a bug or share the conversation | optional | not yet tried |
| `/desktop` or `/app` | Continue session in Claude Code Desktop | no | not yet tried |
| `/mobile`, `/ios`, `/android` | Show a QR code for the mobile app | no | not yet tried |

## Checked but not confirmed as built-in commands

These appeared in earlier drafts of this list but were **not found** in the
current official docs as slash commands — noted here so they don't get
re-added by mistake:
- `/vim`, `/output-style`, `/statusline`, `/reload-plugins` — not documented
- `/skill-doctor` — documented as a plugin-eval / CLI concept, not confirmed
  as a slash command
- `/agents` — exists as the CLI command `claude agents`, not a slash command
