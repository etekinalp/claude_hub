# 07 — Roots

## What this demonstrates
Two tools that both ask the connected client which directories it
currently considers "in scope" for this server — rather than requiring
the user to type out full paths, or the server guessing:

- `list_my_roots` — the classic (2025-06-18) pattern: the server sends a
  `roots/list` request back to the client mid-call and awaits the reply.
- `list_my_roots_modern` — the 2026-07-28 replacement: the tool returns an
  `InputRequiredResult` describing that same request as data, and the
  client retries the call with the roots attached instead of the server
  pushing anything.

## Why it matters
Without roots, an MCP server has no principled way to know what part of
your filesystem it should even be looking at. Claude Code actually
implements the client side of the classic version (confirmed in its own
docs, unlike sampling in example 05): it answers `roots/list` with your
session's launch directory plus every extra directory you've granted with
`/add-dir` or `--add-dir`, and re-announces the list whenever that set
changes. That makes the classic tool fully live end-to-end through Claude
Code, no workaround needed. The modern tool exists here for the same
reason as example 05's: to show the replacement mechanism working for
real, even though Claude Code doesn't speak the 2026-07-28 wire format
yet — so it's exercised with this folder's own harness script instead.

## Prerequisites
`uv` installed (`.mcp.json` here uses `uv run --with mcp`, same as 03/06).

## Steps to reproduce

### Part 1 — the classic pattern, live through Claude Code
1. `cd examples/07-mcp-servers/07-roots`
2. Run `claude`, approve the `roots-server` MCP server.
3. Ask Claude to list the roots using the `list_my_roots` tool. Expect
   exactly one root back: this folder itself (your session's launch
   directory).
4. Without exiting, run `/add-dir ../06-notifications` (or any other
   folder) to grant a second directory.
5. Ask Claude to list the roots again. Expect **two** roots now — this
   confirms the client actually re-announced the updated set rather than
   the server caching a stale answer from step 3.

### Part 2 — the modern (2026-07-28) pattern, via the included harness
1. Still in this folder: `uv run --with mcp python client_mrtr_demo.py`
   (this launches `server.py` itself as a subprocess — no separate step
   needed).
2. Read the printed output top to bottom: leg 1 is the initial
   `tools/call`, which comes back as an `InputRequiredResult` describing a
   bare `roots/list` request as plain JSON data instead of pushing it; the
   script then stands in for "the client answering with its own roots"
   using this folder's own path; leg 2 retries the *same* tool call, with
   a new `id` but the exact `requestState` echoed back and the roots
   attached under `inputResponses.roots`, and gets the final formatted
   list back with `resultType: "complete"`.

## Expected result
Part 1: the tool's output grows from one root to two between steps 3 and
5, without restarting the session or reconnecting the server — proving
roots are live, client-pushed information, not a one-time handshake
value. Part 2: running `client_mrtr_demo.py` prints leg 1's
`InputRequiredResult` (with a real, opaque, per-invocation `requestState`
token), then leg 2's final `- 07-roots: file://...` line with
`resultType: "complete"` — a full round trip against the unmodified
`server.py`, no server push involved at any point.

## Gotchas / notes
- **Roots — classic or modern — is a deprecated capability as of MCP spec
  `2026-07-28`**
  ([SEP-2577](https://github.com/modelcontextprotocol/modelcontextprotocol/pull/2577)),
  alongside Sampling (example 05) and Logging (example 06). The
  *mechanism* changed (server push vs. MRTR) but the capability itself —
  asking a connected client what directories are in scope — is what's
  deprecated either way. It still works today (Claude Code's support for
  the classic version is current, real, and exactly what Part 1 just
  exercised) and stays in the spec for at least twelve months, but the
  suggested migration for new servers is to stop relying on a
  client-exposed root list and instead take a directory or file explicitly
  as a tool parameter, a resource URI, or server configuration.
- Roots are informational guidance, not an access-control mechanism — the
  spec is explicit that nothing stops a server from reading outside the
  roots it was given. Don't treat a root list as a security boundary on
  its own, either version.
- The classic `list_my_roots` calls `list_roots()` on `ctx.session`, not
  `ctx` itself — same place `create_message` lives in example 05. The
  modern `list_my_roots_modern` doesn't touch `ctx.session` at all; it
  reads `ctx.input_responses` instead, which is `None` on the first call
  and populated on the client's retry.
- `requestState` is opaque and bound to the server process that issued it
  — that's why `client_mrtr_demo.py` keeps one `server.py` subprocess
  alive across both legs instead of starting a fresh one per request; a
  token from one process won't validate against another.
- Claude Code doesn't speak the 2026-07-28 wire format yet, so wiring
  `list_my_roots_modern` into this folder's `.mcp.json` and calling it
  through `claude` won't drive the MRTR flow shown above — that's exactly
  why Part 2 uses the included harness script instead of Claude Code.

## Further reading
- https://modelcontextprotocol.io/specification/2025-06-18/client/roots
- https://modelcontextprotocol.io/specification/2026-07-28/basic/patterns/mrtr
- https://code.claude.com/docs/en/mcp.md
- https://modelcontextprotocol.io/specification/2026-07-28/deprecated
