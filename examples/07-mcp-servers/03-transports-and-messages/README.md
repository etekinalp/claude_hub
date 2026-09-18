# 03 — Transports & Message Types

## What this demonstrates
The three JSON-RPC message types MCP is built on (requests, responses,
notifications), and the two transports the spec defines for carrying
them: **stdio** (subprocess, newline-delimited JSON over stdin/stdout) and
**StreamableHTTP** (a single HTTP endpoint, POST for client→server
messages, an optional GET SSE stream for server→client ones). Same tiny
server (`server.py` / `server_http.py`, one `roll_dice` tool) run both
ways, so you can watch the exact same exchange take two different physical
forms.

## Why it matters
Every other example in this repo treats "the MCP server" as a black box
Claude Code talks to. This one opens the box: once you've seen a raw
`initialize` request and its response with your own eyes, hooks (example
06), subagents' tool calls, and everything else that's "just JSON-RPC
under the hood" stop being mysterious. The transport choice also matters
practically — stdio is what example 01 uses (local, one client, dies with
the parent process); StreamableHTTP is what you'd reach for to put a
server on a network for more than one client to reach, which is also why
it's the one with session/state to reason about.

## Prerequisites
- `uv` installed (or `pip install mcp` yourself and adjust the commands
  below — this folder's `.mcp.json` uses `uv run --with mcp`, which
  fetches the `mcp` package into an ephemeral environment on first run,
  same zero-setup idea as example 01's `npx`).
- `curl`, for the StreamableHTTP part.

## Steps to reproduce

### A. The three message types, live, over stdio
1. `cd examples/07-mcp-servers/03-transports-and-messages`
2. Run the server directly (no Claude Code yet): `uv run --with mcp python server.py`
3. Paste this single line into the terminal and press enter — a **request**
   (has an `id`, expects a response):
   `{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"probe","version":"0.1"}}}`
   You should see a **response** come back on the next line, echoing `id: 1`
   with a `result` object (never both `result` and `error`).
4. Paste this — a **notification** (no `id`, no response expected):
   `{"jsonrpc":"2.0","method":"notifications/initialized"}`
   Nothing comes back — that's the defining trait of a notification.
5. Paste a `tools/call` request and watch a matching response come back
   with the dice roll:
   `{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"roll_dice","arguments":{"sides":20}}}`
6. Ctrl+C to stop the server.

### B. The same server, wired into Claude Code over stdio
1. Still in this folder, run `claude` — this folder's `.mcp.json` launches
   `server.py` the same way, as a subprocess of your session, via stdio.
   Approve the project's MCP server when prompted.
2. Ask Claude to roll a 20-sided die using the tool. Same protocol
   exchange as part A, just driven by Claude Code instead of you pasting
   JSON by hand.

### C. The same tool, over StreamableHTTP
1. In a separate terminal (still in this folder): `uv run --with mcp python server_http.py`
   — it listens on `http://127.0.0.1:8765/mcp`.
2. `curl -i -X POST http://127.0.0.1:8765/mcp -H "Content-Type: application/json" -H "Accept: application/json, text/event-stream" -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"probe","version":"0.1"}}}'`
   Look at the response headers for `mcp-session-id: <some-id>` — copy it.
3. Try a `tools/call` **without** that header:
   `curl -i -X POST http://127.0.0.1:8765/mcp -H "Content-Type: application/json" -H "Accept: application/json, text/event-stream" -d '{"jsonrpc":"2.0","id":2,"method":"tools/list"}'`
   Expect `400 Bad Request` — sessions are mandatory once established.
4. Now with the header (replace `<SESSION_ID>`), send the
   `notifications/initialized` notification, then a `tools/call`:
   `curl -i -X POST http://127.0.0.1:8765/mcp -H "Content-Type: application/json" -H "Accept: application/json, text/event-stream" -H "Mcp-Session-Id: <SESSION_ID>" -d '{"jsonrpc":"2.0","method":"notifications/initialized"}'`
   `curl -i -X POST http://127.0.0.1:8765/mcp -H "Content-Type: application/json" -H "Accept: application/json, text/event-stream" -H "Mcp-Session-Id: <SESSION_ID>" -d '{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"roll_dice","arguments":{"sides":6}}}'`
5. Terminate the session: `curl -i -X DELETE http://127.0.0.1:8765/mcp -H "Mcp-Session-Id: <SESSION_ID>"`
6. Re-run the same `tools/call` from step 4 with the now-dead session ID —
   expect `404`, since the server has forgotten it.
7. Ctrl+C the server.

### D. The same server, the modern (2026-07-28) way — no handshake, no session
The spec revision `2026-07-28` removes the `initialize` handshake and
`Mcp-Session-Id` entirely: every request just carries its own version and
capability info inline, in a `_meta` object, and gets a self-contained
answer back. **No server code changes are needed for this** — `server.py`
already answers modern-shaped requests correctly, because the installed
SDK (`2.2.0`) serves both eras from the same process and tells them apart
per-request (legacy: an `initialize` method call; modern: a `_meta`
object carrying the reserved `io.modelcontextprotocol/protocolVersion`
key). Same server, no restart, no flag.

1. Still in this folder: `uv run --with mcp python server.py`
2. Paste this — the new `server/discover` request, MCP's replacement for
   the `initialize` handshake (any client MAY call it up front to see what
   a server supports; note there's no session to establish first):
   `{"jsonrpc":"2.0","id":1,"method":"server/discover","params":{"_meta":{"io.modelcontextprotocol/protocolVersion":"2026-07-28","io.modelcontextprotocol/clientInfo":{"name":"probe","version":"0.1"},"io.modelcontextprotocol/clientCapabilities":{}}}}`
   You should get back `supportedVersions`, `capabilities`, and a
   `resultType: "complete"` — every modern-era result carries a
   `resultType` now (`"complete"` or `"input_required"`, see examples 05
   and 07 for the latter).
3. Now call the tool directly — still no `initialize`, no session ID,
   just the `_meta` envelope on the request itself:
   `{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"roll_dice","arguments":{"sides":20},"_meta":{"io.modelcontextprotocol/protocolVersion":"2026-07-28","io.modelcontextprotocol/clientInfo":{"name":"probe","version":"0.1"},"io.modelcontextprotocol/clientCapabilities":{}}}}`
   You get a normal result back, with `resultType: "complete"` and a
   `_meta.io.modelcontextprotocol/serverInfo` block identifying the server
   — the modern reverse of `clientInfo` in `initialize`.
4. Ctrl+C to stop the server.

## Expected result
Part A: an `initialize` request gets a matching response by `id`; the
`notifications/initialized` notification gets nothing back; a `tools/call`
request gets a response containing the roll. Part C, tested exactly as
written above: the initial `initialize` returns `200` with an
`mcp-session-id` response header; any request after that missing the
`Mcp-Session-Id` header gets `400` (`"Bad Request: Missing session ID"`);
requests carrying it succeed (`202` for the notification, `200` with the
roll for the tool call); `DELETE` returns `200`; reusing that session ID
afterward returns `404` (`"Session not found"`). Part D, tested exactly as
written above: `server/discover` returns immediately with no prior
handshake (`supportedVersions: ["2026-07-28"]`, `resultType: "complete"`);
the `tools/call` right after it succeeds on the very first message sent to
the process — no `initialize`, no `notifications/initialized`, no session
ID anywhere.

## Gotchas / notes
- **The session/state model in part C is on its way out — but the SDK
  already speaks both.** Revision `2026-07-28` (about seven weeks old as
  of this writing) removes `Mcp-Session-Id` and the `initialize` handshake
  from the protocol, in favor of the fully stateless, per-request model
  part D just exercised
  ([changelog](https://modelcontextprotocol.io/specification/2026-07-28/changelog),
  SEP-2567 and SEP-2575). The installed SDK (`2.2.0`) isn't "on the old
  version" the way it might look from part A/C alone — it's dual-era: it
  classifies each incoming request by shape (an `initialize` method call
  vs. a `_meta.io.modelcontextprotocol/protocolVersion` key) and serves
  either protocol from the same running process, which is exactly what
  parts A/C vs. D just proved against the one unmodified `server.py`.
  Claude Code and most servers in the wild still default to speaking the
  session-based `2025-06-18` shape (part A/B/C), so that stays the
  practical default — part D is what's available today if a client speaks
  it, and where things are headed.
- **The StreamableHTTP transport hasn't caught up to this yet, in this SDK
  version.** Repeating part D's exact requests against `server_http.py`
  (part C) still returns `400 Bad Request: Missing session ID`, even with
  a full modern `_meta` envelope and no `initialize` call — the
  method-dispatch layer understands modern requests fine (confirmed by
  testing it directly against the same server object over stdio), but
  this SDK's HTTP transport still gates every request on the classic
  session handshake regardless of era. Worth re-checking on a newer `mcp`
  release; as of `2.2.0` the two transports aren't at the same point on
  this.
- `server.py` and `server_http.py` are the same tool defined twice on
  purpose, once per transport's `mcp.run(...)` call — a real server
  usually only picks one transport, this folder just wants both runnable
  side by side.
- If `uv run --with mcp` hangs the first time, it's fetching the `mcp`
  package — check your network, same as `npx` in example 01.

## Further reading
- https://modelcontextprotocol.io/specification/2025-06-18/basic/transports
- https://modelcontextprotocol.io/specification/2026-07-28/changelog
- https://modelcontextprotocol.io/specification/2026-07-28/basic/lifecycle
