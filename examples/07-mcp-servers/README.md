# MCP Servers

Index for this concept. Each numbered subfolder is a self-contained example
you `cd` into before running `claude` — see the root README for why.

## Examples

| # | Sub-example | Status |
|---|---|---|
| 01 | [Basic filesystem server](01-basic-filesystem-server/) | done |
| 02 | [Multiple servers](02-multiple-servers/) | planned |
| 03 | [Transports & message types](03-transports-and-messages/) — stdio vs StreamableHTTP, JSON-RPC requests/responses/notifications, session state, plus the 2026-07-28 handshake-free/session-free request shape | done |
| 04 | [Resources, prompts, and tools](04-resources-prompts-vs-tools/) | planned |
| 05 | [Sampling](05-sampling/) — a tool asking the client's LLM to do work, no server API key needed; classic server-push pattern and its 2026-07-28 MRTR replacement, side by side | done |
| 06 | [Log & progress notifications](06-notifications/) — a tool reporting what it's doing as it runs | done |
| 07 | [Roots](07-roots/) — a tool asking the client which directories it's scoped to; classic server-push pattern and its 2026-07-28 MRTR replacement, side by side | done |

## A note on 03, 05, 06, 07

These came from a specific source: the Anthropic Academy course
"Model Context Protocol: Advanced Topics." Rather than mirror the course's
own module structure in a separate folder, its content was folded into
this concept's normal topic-based numbering (same convention as every
other example here), since a course can be restructured or retired while
a protocol concept stays reusable. Two of the four topics it covered
(Sampling, Roots) are — as of building this — deprecated in the current
MCP spec (`2026-07-28`, seven weeks old at the time), replaced by a new
"Multi Round-Trip Requests" (MRTR) pattern; each affected example says so
explicitly and links to what's replacing it, rather than presenting
soon-to-be-legacy material as the current recommended way.

Examples 03, 05, and 07 now also carry the modern (2026-07-28) approach
directly alongside the classic one they started with — a second tool in
the same `server.py` (05, 07), or a "Part D" of the same walkthrough
against the same unmodified server (03) — each one empirically verified
against the installed `mcp` SDK (`2.2.0`), not just described from the
spec. Every modern-pattern round trip shown (`InputRequiredResult`,
`requestState`, `server/discover`) was actually run and its real output
captured, the same standard the rest of this repo holds to. See
`docs/gap-analysis.md` for the full research trail, including where the
SDK's own modern-era support still has gaps (notably: its StreamableHTTP
transport doesn't yet drop the session requirement the way its stdio/
method-dispatch layer does).

## Adding more depth here

More MCP material goes in a new `0N-topic/` subfolder here, not a new
top-level `examples/` number — see the root `CLAUDE.md` conventions.
