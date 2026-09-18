# 01 — Basic Filesystem Server

## What this demonstrates
A project-scoped MCP server declared in `.mcp.json`: a local filesystem
server (via `npx @modelcontextprotocol/server-filesystem`) scoped only to
this folder's own `sandbox/` folder, giving Claude a second, independent
set of file-read/write tools distinct from its built-in Read/Write/Edit.

## Why it matters
MCP servers are how Claude Code reaches things it doesn't have native tools
for: a database, an internal API, a specialized filesystem view, etc.
`.mcp.json` at project scope is the shareable, committed way to declare one
for a whole team, as opposed to `local` scope (personal, machine-specific)
or `user` scope (all your projects).

## Prerequisites
Node.js / npx available on your PATH (the server is fetched on first run via
`npx -y ...`, no manual install needed, but it does need network access the
first time).

## Steps to reproduce
1. `cd examples/07-mcp-servers/01-basic-filesystem-server`
2. Run `claude` — on first launch with a project-scoped `.mcp.json`, Claude
   Code should prompt you to approve/trust this project's MCP servers.
   Approve it.
3. Ask Claude to list what MCP tools it has available — you should see
   filesystem tools from `example-filesystem`, separate from its built-in
   Read/Write/Edit.
4. Ask it to use the MCP server (not its built-in tools) to read
   `sandbox/hello.txt`.
5. Ask it to write a new file into `sandbox/` via the MCP server, then
   check the file actually appeared there.

## Expected result
Claude has a second set of file tools, and both approaches (native tools vs
MCP server tools) can read the same `sandbox/hello.txt` — proving the MCP
server is a genuinely separate, working tool provider, not just a relabeled
version of what Claude already had.

## Gotchas / notes
- First launch requires network access (`npx` fetches the package) and a
  one-time project-trust approval — if it silently does nothing, check
  whether that approval prompt is what's blocking it.
- `.mcp.json` argument paths: this uses a relative `./sandbox` path, which
  resolves against the directory you launched `claude` from. If your
  version of Claude Code needs an absolute path instead, or supports
  `${CLAUDE_PROJECT_DIR}`-style expansion, adjust accordingly — check
  `mcp-quickstart.md`.
- This is `project` scope (`.mcp.json`, committed, team-shared). `claude mcp
  add --scope local` / `--scope user` are the other two — not reproduced
  here since they write outside this repo (`~/.claude.json`).

## Further reading
- https://code.claude.com/docs/en/mcp-quickstart.md
