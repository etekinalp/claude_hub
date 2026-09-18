# 05 — Sampling

## What this demonstrates
Two tools that both ask the connected client's LLM to summarize text,
instead of calling an LLM API directly:

- `summarize_in_one_line` — the classic (2025-06-18) pattern: the server
  sends a `sampling/createMessage` request back to the client mid-call and
  awaits the reply.
- `summarize_in_one_line_modern` — the 2026-07-28 replacement: the tool
  returns an `InputRequiredResult` describing that same request as data,
  and the client retries the call with the answer attached instead of the
  server pushing anything.

## Why it matters
Sampling is what lets a public, free-to-run MCP server offer AI-powered
tools without eating the cost of every user's LLM calls itself, or making
every user configure their own API key just to use one tool. The classic
version is also the clearest example in this repo of MCP being genuinely
bidirectional — the *server* initiates a request and the *client* answers
it. The modern version keeps the same idea (client pays, client picks the
model) but removes the bidirectionality: nothing is pushed, so a client
doesn't need a special "answer unsolicited server requests" code path at
all — it just needs to notice `resultType: "input_required"` and retry.
That's a materially lower bar for a client to clear, which is exactly why
Claude Code can't do the classic version yet but this repo's own harness
script can drive the modern one today, with no client-side MCP support
required beyond retrying a call.

## Prerequisites
- `uv` installed.
- Node.js/`npx`, to run the MCP Inspector (for the classic pattern, below).

## Read this before running the classic tool
**Claude Code does not currently implement the client side of classic
sampling.** There's an open, unresolved feature request for it
([anthropics/claude-code#1785](https://github.com/anthropics/claude-code/issues/1785))
with no ship date as of this writing. If you wire this server into Claude
Code via its `.mcp.json` and call `summarize_in_one_line`, the call will
simply hang — Claude Code has no code path that answers a
`sampling/createMessage` request, so the server sits waiting for a reply
that never comes. That's not a bug in this example; it's accurately
reflecting where Claude Code is today. This folder's `.mcp.json` still
wires the server up (so you can see that hang yourself, once, on purpose),
but the real steps to reproduce the classic tool use the **MCP
Inspector** instead — the reference test client, which does implement
sampling.

The modern tool (`summarize_in_one_line_modern`) has no such gap: it
doesn't need the client to implement anything beyond retrying a call, so
it's exercised below with a small raw-JSON-RPC harness script instead —
see Part 2.

## Steps to reproduce

### Part 1 — the classic pattern, via MCP Inspector
1. `cd examples/07-mcp-servers/05-sampling`
2. Launch the Inspector against this server:
   `npx @modelcontextprotocol/inspector uv run --with mcp python server.py`
3. The Inspector opens a browser UI. Connect (it should auto-detect the
   stdio server), open the **Tools** tab, select `summarize_in_one_line`,
   and call it with some text, e.g. "Model Context Protocol lets an LLM
   call out to external tools and data sources through a standard
   interface."
4. The Inspector's UI should surface an incoming sampling request — this
   is the `sampling/createMessage` call the tool made. Review it (this is
   exactly the human-in-the-loop approval step the spec expects every
   client to offer) and approve it.
5. Optional, to see the Claude-Code gap for yourself: exit the Inspector,
   run `claude` in this folder instead, approve the `.mcp.json` server, and
   ask it to summarize some text with the tool. Expect the call to hang
   with no response — cancel it once you've confirmed that's what happens.

### Part 2 — the modern (2026-07-28) pattern, via the included harness
1. Still in this folder: `uv run --with mcp python client_mrtr_demo.py`
   (this launches `server.py` itself as a subprocess — no separate step
   needed).
2. Read the printed output top to bottom: leg 1 is the initial
   `tools/call`, which comes back as an `InputRequiredResult` describing
   the `sampling/createMessage` request as plain JSON data instead of
   pushing it; the script then stands in for "asking an LLM" with a canned
   string (swap it for a real API call if you want genuine text); leg 2
   retries the *same* tool call, with a new `id` but the exact
   `requestState` echoed back and the answer attached under
   `inputResponses.summary`, and gets the final one-line result back with
   `resultType: "complete"`.
3. Optional: try wiring `summarize_in_one_line_modern` into Claude Code via
   this folder's `.mcp.json` too. As of this writing Claude Code doesn't
   speak the 2026-07-28 modern era either (it's on the classic protocol,
   same as the rest of this repo's examples), so expect this call to
   behave like any other unknown-shaped tool response rather than
   completing — this repo doesn't have a Claude-Code-native way to drive
   this tool yet, which is exactly why the harness script exists.

## Expected result
Part 1, through the Inspector: the tool's `sampling/createMessage` request
appears for your review, and once approved, a real one-line summary comes
back as the tool's result. Through Claude Code: the call hangs
indefinitely, because nothing on the client side ever answers the request.
Part 2: running `client_mrtr_demo.py` prints leg 1's `InputRequiredResult`
(with a real, opaque, per-invocation `requestState` token — the SDK signs
it, it's not just an echoed string you could forge), then leg 2's final
`"Hello, <summary>"`-shaped result with `resultType: "complete"` — a full
round trip against the unmodified `server.py`, no server push involved at
any point.

## Gotchas / notes
- **Sampling — classic or modern — is a deprecated capability as of MCP
  spec `2026-07-28`**
  ([SEP-2577](https://github.com/modelcontextprotocol/modelcontextprotocol/pull/2577)),
  alongside Roots (example 07) and Logging (example 06's log half). The
  *mechanism* that carries it (server-initiated push vs. MRTR) changed in
  the same revision, but sampling itself — asking a connected client's LLM
  to do work — is what's actually deprecated, either way you invoke it. It
  still works today and stays in the spec for at least twelve months, but
  new servers are steered toward integrating directly with an LLM
  provider's API instead. The irony — sampling exists specifically so
  servers *don't* need their own API key — is real; see this repo's
  `docs/gap-analysis.md` note on this whole batch of examples for more.
- The `mcp` Python SDK (`2.2.0`, installed here via `uv run --with mcp`)
  emits a `MCPDeprecationWarning` on stderr the moment classic
  `create_message` is actually called (worth watching for in the
  Inspector's server logs) — it does **not** fire for the modern tool,
  since returning an `InputRequiredResult` isn't itself deprecated, only
  the underlying sampling capability it's describing.
- `requestState` is opaque and MUST be treated that way by clients — don't
  parse it, don't reuse a stale one. The spec requires servers to
  integrity-protect it if it affects authorization or business logic
  (HMAC/AEAD), and the token you'll see printed in Part 2 is exactly that
  kind of value: it's bound to the server process that issued it, which is
  why `client_mrtr_demo.py` keeps one `server.py` subprocess alive across
  both legs instead of starting a fresh one per request.
- `model_preferences` (hints plus cost/speed/intelligence priority values)
  let a server express *what kind* of model it wants without naming one
  exactly — not used in either tool here, but worth reading about in the
  spec link below if you're designing a real sampling-based tool.

## Further reading
- https://modelcontextprotocol.io/specification/2025-06-18/client/sampling
- https://modelcontextprotocol.io/specification/2026-07-28/basic/patterns/mrtr
- https://modelcontextprotocol.io/specification/2026-07-28/deprecated
- https://github.com/anthropics/claude-code/issues/1785
