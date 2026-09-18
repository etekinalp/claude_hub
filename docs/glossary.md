# Glossary

Short definitions, expanded as the library grows. Each links to the example that demonstrates it hands-on.

- **CLAUDE.md** — a Markdown memory file Claude Code loads automatically as context. Project-level (`./CLAUDE.md`) and nested (`<subdir>/CLAUDE.md`, loaded once Claude works inside that subdirectory) both apply; there's also a user-level one at `~/.claude/CLAUDE.md`. → [`examples/01-memory-and-claude-md/`](../examples/01-memory-and-claude-md/)
- **Settings hierarchy** — five levels of `settings.json`, highest priority first: managed (org/MDM) → CLI flags → project-local (`.claude/settings.local.json`, gitignored) → shared project (`.claude/settings.json`, committed) → user (`~/.claude/settings.json`). → `examples/02-settings-and-permissions/`
- **Slash command** — a Markdown file under `.claude/commands/` (or `.claude/skills/`) that becomes a `/name` command. → `examples/03-slash-commands/`
- **Subagent** — a Markdown file under `.claude/agents/` with YAML frontmatter (`name`, `description`, optional `tools`, `model`, etc.) defining a delegate Claude can spawn for a subtask. → `examples/04-subagents/`
- **Skill** — a `SKILL.md` bundle (instructions plus optional supporting files) Claude auto-invokes based on its `description`, or that a user invokes with `/skill-name`. → `examples/05-skills/`
- **Hook** — a shell command wired to a lifecycle event (`PreToolUse`, `PostToolUse`, `SessionStart`, etc.) via the `hooks` key in a settings file. → `examples/06-hooks/`
- **MCP server** — an external tool/data source connected via `.mcp.json`, at `local`, `project`, or `user` scope. → `examples/07-mcp-servers/`
- **Plugin** — a distributable bundle (`.claude-plugin/plugin.json` manifest) packaging any combination of skills, agents, hooks, MCP servers, and commands. → `examples/08-plugins/`
- **MCP server scope** — `local` (personal, this project only), `project` (`.mcp.json`, committed, team-shared), or `user` (all your projects) — set via `claude mcp add --scope <scope>`. → [`examples/07-mcp-servers/`](../examples/07-mcp-servers/)
- **Output style** — changes Claude's tone/verbosity without changing capability; `keep-coding-instructions: true` keeps underlying behavior intact. → [`examples/09-output-styles/`](../examples/09-output-styles/)
- **Headless mode** — `claude -p` runs Claude Code non-interactively for scripting/CI, with structured `--output-format json` output. → [`examples/10-headless-mode/`](../examples/10-headless-mode/)
- **Worktree** — an isolated git checkout Claude Code can run a session (or a subagent, via `isolation: worktree`) inside, so parallel sessions don't collide; `.worktreeinclude` carries specific gitignored files into new worktrees. → [`examples/11-worktrees/`](../examples/11-worktrees/)
- **Permission mode** — session-wide approval posture: `default`, `acceptEdits`, `plan`, `dontAsk`, `bypassPermissions`, etc. → [`examples/13-permission-modes/`](../examples/13-permission-modes/)
