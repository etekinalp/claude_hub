# claude_hub — meta instructions

This repository is a personal, long-lived learning library for Claude Code itself: every feature, tool, and concept gets its own isolated, documented example under `examples/`.

## When working in this repo

- This root level is meta-only. Do not add example-specific `.claude/agents`, `.claude/commands`, `.claude/hooks`, `.claude/skills`, or `.mcp.json` here — they would apply to every session launched at the repo root, defeating the isolation the whole repo is built around. Example-specific config belongs inside that example's own folder.
- To add a new example: run `scripts/new-example.sh <NN-concept-name> "<one-line description>"`, or copy `templates/example-template/` by hand. Keep the numbering roughly in learning order (see the table in the root README).
- Every example folder must contain a `README.md` covering: what it demonstrates, why it matters, exact reproduction steps, the expected result, and any gotchas hit while building it.
- Update `docs/changelog.md` with a dated entry whenever an example is added or a new Claude Code feature is folded in.
- Update the status column in the root `README.md` table when an example moves from planned to done.
- Prefer real, runnable artifacts (actual hook scripts, actual agent/skill files) over prose-only explanations — the point of this repo is to have something to re-run and inspect later, not just notes.

## Conventions

- One concept per top-level `examples/` folder; going deeper on an already-covered concept (more examples, advanced setups) is a new numbered subfolder INSIDE that concept's folder (e.g. `examples/07-mcp-servers/03-remote-http-with-auth/`), never a new top-level `examples/` number. A concept folder with sub-examples gets its own index `README.md` linking to each one, same shape as the root README's table.
- A new top-level number is only for a concept not covered at all yet — see the Backlog section in the root README for the current list of candidates.
- Reference/catalog material with no config of your own to isolate (e.g. a list of built-in slash commands nobody configured) is a single doc alongside the concept's examples, not a folder per item.
- Keep each example's `.claude/` minimal: only the pieces that concept actually needs. It's fine for an example to have no `.claude/` at all.
- Never touch files outside this repo (e.g. `~/.claude/`) when building an example — where a concept requires user-level or machine-level state, document the manual steps in that example's README instead.
