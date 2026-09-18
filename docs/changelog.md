# Changelog

Dated log of what's been explored in this repo. Newest first.

## 2026-09-18
- Repo scaffolded: root `README.md`, meta `CLAUDE.md`, `docs/`, `templates/example-template/`, `scripts/new-example.sh`.
- Built `examples/01-memory-and-claude-md/` — first fully worked example, demonstrating root vs nested `CLAUDE.md` loading.

## 2026-09-18
- Built `examples/02-settings-and-permissions/` — settings.json vs settings.local.json precedence, demonstrated via an env var and a permission allow/deny override.

## 2026-09-18
- Built `examples/03-slash-commands/` — basic and namespaced project slash commands, $ARGUMENTS substitution.

## 2026-09-18
- Built `examples/04-subagents/` — restricted-tools subagent with a different model, delegation via auto-match and explicit request.

## 2026-09-18
- Built `examples/05-skills/` — auto-invoked vs manual-only skill, contrasted via disable-model-invocation.

## 2026-09-18
- Built `examples/06-hooks/` — SessionStart/PostToolUse logging plus a PreToolUse block on dangerous Bash commands.

## 2026-09-18
- Built `examples/07-mcp-servers/` — project-scoped .mcp.json with a filesystem MCP server sandboxed to its own folder.
- Built `examples/08-plugins/` — minimal local plugin (manifest + one skill) loaded via --plugin-dir.

## 2026-09-18
- Built `examples/09-output-styles/` — custom output style with keep-coding-instructions, contrasted against built-ins.
- Built `examples/10-headless-mode/` — claude -p / --output-format json scripting pattern.

## 2026-09-18
- Built `examples/11-worktrees/` — worktree launch walkthrough plus .worktreeinclude carrying a gitignored file across worktrees.
- Built `examples/12-github-actions/` — template (inactive) PR-review workflow, mirrors example 10's headless pattern.

## 2026-09-18
- Built `examples/13-permission-modes/` — default/acceptEdits/plan compared on the same edit, bypassPermissions deliberately not exercised.
- All 13 planned examples now done; glossary entries added for 07-13.

## 2026-09-18
- Restructured `examples/03-slash-commands/` and `examples/07-mcp-servers/` into numbered sub-example folders (01-basics, 01-basic-filesystem-server) with their own index README, to make room for depth without new top-level numbers.
- Added `examples/03-slash-commands/builtin-commands-reference.md` — full catalog of built-in slash commands researched from current docs, with a per-command "tried it?" column to fill in by hand.
- Added planned placeholders under `examples/07-mcp-servers/`: 02-multiple-servers, 03-remote-http-with-auth, 04-resources-prompts-vs-tools, and 05-anthropic-course (waiting on the specific course link).
- Sharpened the depth-vs-breadth convention in root `CLAUDE.md`, and added a Backlog section to the root README listing concepts not yet covered.

## 2026-09-18
- Restructured every remaining example folder (01, 02, 04, 05, 06, 08, 09, 10, 11, 12, 13) the same way as 03 and 07: original content moved into `01-basics/` (or, for 07, `01-basic-filesystem-server/`), each concept folder now has its own index README. Every concept can now grow depth (`02-...`, `03-...`) without a future restructuring pass.
- Updated cross-references (01's CLAUDE.md files, 12's reference to 10's ask.sh) and .gitignore paths (06's hook-log.txt, 11's scratch/) to match the new locations.

## 2026-09-18
- Ran a full gap audit (two research passes, spot-checked against live docs) and wrote `docs/gap-analysis.md`. Confirmed real: auto mode, routines, dynamic workflows, ultrareview. Corrected one item: "Ultraplan" is discontinued, not in preview.
- Expanded the root README Backlog section to summarize the audit and link to the full doc.

## 2026-09-18
- Built the four "confirmed real" items from the gap audit: `examples/13-permission-modes/02-auto-mode/` (classifier-based execution model, contrasted with example 02's project-scoped permission rules), `examples/14-routines/` (documented, not created against a real account), `examples/15-dynamic-workflows/` (a real saved workflow, .claude/workflows/find-todos.js, fanning out over sample files), `examples/16-ultrareview/` (documented, not run, since it spends a metered/non-refreshing resource).
- Verified exact syntax for all four via live doc fetches rather than relying on research-agent summaries alone.
- Updated root README table (rows 14-16) and Backlog section, and annotated docs/gap-analysis.md.

## 2026-09-18
- Audited every example README against the 7-section template. Found and fixed two inconsistencies: examples/14-routines/01-basics/README.md and examples/16-ultrareview/01-basics/README.md used a differently-named "How you'd actually try it" section and had no "Expected result" section. Renamed to "Steps to reproduce" and added "Expected result" (describing what the real, unrun outcome looks like) to both, matching every other example's structure.

## 2026-09-18
- Did a full prose read-through of all 33 example READMEs (not just the structural section-header check from the previous entry) — checked for clarity, accuracy, and cross-reference consistency between files.
- Fixed a real cross-reference gap: `examples/11-worktrees/01-basics/README.md` pointed to example 04 for subagent `isolation: worktree`, but example 04's README never actually mentioned it. Added a Gotcha to `examples/04-subagents/01-basics/README.md` naming `isolation: worktree`, `background`, `maxTurns`, and `disallowedTools` as documented-but-not-demoed fields, so the cross-reference now resolves to something real.
- Fixed an inconsistency between `examples/08-plugins/01-basics/README.md` (presented `/reload-plugins` as a real, version-gated command) and `examples/03-slash-commands/builtin-commands-reference.md` (had already flagged `/reload-plugins` as checked and not confirmed as a real built-in command). 08's step 4 now points to restarting the session as the reliable way to pick up a plugin edit, and notes the `/reload-plugins` uncertainty explicitly instead of implying it probably works.
- Added `scripts/clean-examples.sh` — a deliberately explicit (not blanket `git clean`) cleanup script for runtime artifacts created by actually walking through the READMEs (settings.local.json copies, hook-log.txt, extra sandbox files, .DS_Store), resets known fixture files (13's scratch.txt) to their original content instead of deleting them, leaves 11's intentionally-gitignored `scratch/local-notes.txt` untouched, and only reports (never auto-deletes) ambiguous cases like extra saved workflows or leftover git worktrees. Run with `--dry-run` first, then for real, before committing/pushing.

## 2026-09-18
- Added `scripts/check-for-updates.sh` — fetches the live Claude Code weekly "what's new" digest and the full docs index (llms.txt), diffs each against a saved snapshot from the last check, and reports what changed. It never edits or builds anything itself: deciding what's worth a new example is left to a Claude Code session cross-checking the diff against `docs/gap-analysis.md`, following the same research-then-verify pattern used for every existing example.
- Documented the new script in the root README (new "Checking for new Claude Code features" section, between "Adding a new example" and "Before committing or pushing").
- Note for next time this runs: while researching this script, a live fetch of the weekly digest showed several `docs/gap-analysis.md` backlog items already shipped as of Week 20-32 2026 (agent view, /goal, artifacts, computer use, cross-session messaging, the Monitor tool, fast mode, rewind's "summarize up to here") — the backlog doc has not been re-audited against this yet.

## 2026-09-18
- Built `examples/03-slash-commands/02-builtin-commands/` — a full runnable walkthrough of every command in `builtin-commands-reference.md`, organized by the same categories, with concrete steps and expected results for almost every one. Added `scratch.txt`, a toy fixture (an `eval` on unsanitized input plus a hardcoded-looking key) so the review-family commands (`/diff`, `/code-review`, `/review`, `/security-review`, `/verify`) have something real to catch once edited.
- Held the same "documented, not run" line this repo uses elsewhere (examples 12, 14, 16) for the handful of built-in commands with a real, persistent side effect: `/login`, `/logout`, `/feedback`, `/bug`, and the newly-shipped `/design`/`/design-sync`/`/design-login` (need a connected design system this repo doesn't have).
- Updated `examples/03-slash-commands/README.md` and `builtin-commands-reference.md` to cross-link the new walkthrough; added its runtime artifacts (`/init`'s generated `CLAUDE.md`, `/export`'s `scratch-export.md`) to `.gitignore` and to `scripts/clean-examples.sh`.
- Fixed a real robustness bug in `scripts/clean-examples.sh` found while testing this: `remove()` ran `rm -rf` under `set -e` with no error handling, so a single failed removal (permissions, read-only mount, etc.) silently aborted the rest of the cleanup instead of reporting it and continuing. `remove()` now catches a failed removal, reports it, and keeps going.

## 2026-09-18
- Built `examples/07-mcp-servers/03-transports-and-messages/`, `05-sampling/`, `06-notifications/`, `07-roots/` from the Anthropic Academy course "Model Context Protocol: Advanced Topics" (transports, JSON message types, sampling, log/progress notifications, roots). Removed the old `03-remote-http-with-auth` and `05-anthropic-course` planned/placeholder folders they superseded — content is organized by topic like every other concept in this repo, not mirrored to one specific course's structure.
- Verified everything against ground truth, not course summaries alone: installed `mcp` 2.2.0 in a real venv and introspected the actual `MCPServer`/`Context`/`ServerSession` API (FastMCP was renamed to `MCPServer` in the 2.x line); ran the stdio and StreamableHTTP servers for real and captured actual request/response traffic (raw JSON-RPC over stdio, and the full curl session-ID dance — initialize, missing-header 400, authenticated call, DELETE, post-delete 404) rather than describing it from the spec alone.
- Major finding along the way: MCP spec `2026-07-28` (about seven weeks old) deprecates Roots, Sampling, and Logging in favor of a new "Multi Round-Trip Requests" (MRTR) pattern, and removes the session/`Mcp-Session-Id` model the "state and StreamableHTTP" course lesson is built around. Confirmed Claude Code supports Roots today but not Sampling at all (open feature request, no ship date), and that Claude Code's early MRTR support has open bugs. Decided with the user to build the classic, still-functional pattern the course teaches, with the deprecation and its replacement flagged explicitly in each affected README, rather than silently teaching soon-to-be-legacy material or jumping to a replacement neither the course nor Claude Code has caught up to yet. Full detail in `docs/gap-analysis.md`.

## 2026-09-18
- Follow-up on the batch above: added the modern (2026-07-28, MRTR) approach itself, "next to" each classic pattern it replaces, per the user's request. `05-sampling/server.py` and `07-roots/server.py` each gained a second tool (`summarize_in_one_line_modern`, `list_my_roots_modern`) built on `InputRequiredResult`/`ctx.input_responses`/`request_state` instead of a server-initiated push, plus a `client_mrtr_demo.py` harness script in each folder that drives a real two-leg round trip over stdio against the unmodified server. `03-transports-and-messages/README.md` gained a "Part D" showing `server/discover` and a handshake-free, session-free `tools/call` — against the exact same `server.py` used in parts A-C, no server code changes needed at all.
- All of it empirically verified against the installed `mcp` 2.2.0 SDK before being written into the repo, the same standard as the rest of this batch: real two-leg JSON-RPC exchanges over stdio, real signed/opaque `requestState` tokens captured from actual server output (not fabricated), `server/discover`'s exact required `_meta` fields worked out by reading `mcp_types.methods.validate_client_request`'s error output directly rather than guessing. Each new script was then re-run against its final location in the repo (not just the scratch copy) to confirm it still works there.
- Corrected an assumption in `03-transports-and-messages/README.md`'s original Gotchas: it claimed the installed SDK "still speaks the older, session-based `2025-06-18` protocol by default." It doesn't — it's dual-era, serving both protocols from the same process and classifying each request by shape (an `initialize` call vs. a `_meta.io.modelcontextprotocol/protocolVersion` key), which is exactly what the new Part D proves against the same server object used in parts A-C.
- One real SDK gap surfaced during this verification, documented rather than worked around: `2.2.0`'s StreamableHTTP transport still requires the classic session handshake even for a fully modern-`_meta` request — the method-dispatch layer understands modern requests fine over stdio, but the HTTP layer hasn't caught up. Noted as a gotcha in 03; worth re-checking on a future SDK release.

## 2026-09-18
- Built `examples/05-skills/02-anatomy-and-discovery/` through `07-debugging-and-validation/`, from the Anthropic Academy course "Introduction to Agent Skills": where skills live and how Claude Code matches them (02); writing effective descriptions and the real `allowed-tools`/`disallowed-tools` distinction (03); progressive disclosure with `scripts/`/`references/`/`assets/` (04); a worked skill-vs-CLAUDE.md-vs-hook comparison built around one concrete rule enforced three different ways (05); sharing/distribution — project repos, a cross-link to 08-plugins for the plugin case, a subagent preloading a skill via `skills:`, and enterprise managed settings documented (not run, since it needs a system directory outside any repo) (06); and debugging/validation with three real broken/fixed structural bug pairs plus the actual diagnostic command surface (07).
- Verified against ground truth, not the course alone: fetched the official docs (`code.claude.com/docs/en/skills`, `sub-agents`, `debug-your-config`, `managed-settings`) for every frontmatter field, storage location, and command referenced; validated real YAML frontmatter with a real parser for every new `SKILL.md`; actually ran the progressive-disclosure example's bundled script from two different working directories; deliberately built and triggered three real structural bugs (a flat `SKILL.md` file outside its own folder, invalid YAML frontmatter with an unterminated string, a bundled script missing its executable bit) and captured their real failure output (a YAML parser traceback, a `Permission denied` / exit `126`) rather than describing the expected behavior secondhand; wrote and tested a real `PreToolUse` hook script against three simulated Edit/Write payloads to confirm its block/allow logic before writing it into the comparison example.
- Two corrections to the source course found this way, each flagged explicitly in the affected example rather than silently fixed: `allowed-tools` doesn't restrict tool access the way the course frames it — it only pre-approves a list for the invoking turn, and `disallowed-tools` (not covered by the course at all) is the actual restriction mechanism; and the course's claimed "skills validator... installed via uv" doesn't match anything in the current official docs — no such CLI tool is documented, and the real diagnostic surface is `/skills`, `/context`, `claude doctor`, `claude --debug`, `/status`, and `claude --safe-mode`. A third, smaller correction: the course states built-in agents "can't access skills at all," but the docs say they can't *preload* skills via the `skills:` frontmatter field specifically — they can still invoke skills at runtime through the Skill tool. Full detail in `docs/gap-analysis.md`.
