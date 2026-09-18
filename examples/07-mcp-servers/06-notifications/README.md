# 06 — Log & Progress Notifications

## What this demonstrates
A tool (`process_items`) that reports what it's doing as it runs — a log
line at the start and end via `ctx.info(...)`, and a running progress
update per item via `ctx.report_progress(...)` — instead of going silent
until it returns a final result.

## Why it matters
Without this, any tool that takes more than an instant looks the same as
one that's hung: nothing happens until it either finishes or times out.
Both notification types are one-way (server → client, no response
expected) — the "notification" message type from example 03, put to
actual use. They're also cheap: a couple of extra lines per long-running
tool, for a meaningfully less confusing wait.

## Prerequisites
`uv` installed (`.mcp.json` here uses `uv run --with mcp`, same as 03).

## Steps to reproduce
1. `cd examples/07-mcp-servers/06-notifications`
2. Run `claude`, approve the `notifications-server` MCP server.
3. Ask Claude to process a batch of, say, 5 items with the tool.
4. Watch for live feedback while the tool is running, rather than a single
   result appearing all at once at the end.
5. For the raw protocol underneath (optional, mirrors example 03's
   approach): run `uv run --with mcp python server.py` directly and paste
   in an `initialize` request, `notifications/initialized`, then a
   `tools/call` for `process_items` with a `progressToken` set in
   `params._meta` (a request only gets progress notifications if it asks
   for them this way):
   `{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"process_items","arguments":{"count":3},"_meta":{"progressToken":"batch-1"}}}`
   Watch `notifications/message` and `notifications/progress` messages
   interleave with each other before the final response arrives.

## Expected result
Step 5, run exactly as written, produces: an `info`-level
`notifications/message` ("Starting batch of 3 items"), three
`notifications/progress` messages with `progress` counting 1, 2, 3 against
`total: 3`, a second `notifications/message` ("Batch complete"), and only
then the `tools/call` response itself. Through Claude Code (step 3-4), the
same sequence shows up as visible, incremental feedback instead of a
silent wait.

## Gotchas / notes
- **Only the logging half of this is deprecated.** MCP spec `2026-07-28`
  deprecates the Logging feature ([SEP-2577](https://github.com/modelcontextprotocol/modelcontextprotocol/pull/2577))
  — the `mcp` SDK installed here actually emits a `MCPDeprecationWarning`
  on stderr the instant `ctx.info(...)` runs, worth watching for when you
  try step 5. Progress notifications are **not** deprecated — they're
  unaffected by this change and remain the current, recommended way to
  report on a long-running operation. The spec's suggested replacement for
  server-side logging is writing to `stderr` on stdio, or using
  OpenTelemetry — not shown here, since it'd need real infrastructure to
  demonstrate meaningfully.
- `progress` **must** strictly increase across notifications for the same
  token, even if `total` is unknown — the spec is explicit about this,
  and `ctx.report_progress` doesn't stop you from violating it, so it's on
  you to get the sequence right.
- A receiver is always free to just not act on notifications it doesn't
  care about — nothing about this pattern is mandatory to display.

## Further reading
- https://modelcontextprotocol.io/specification/2025-06-18/basic/utilities/progress
- https://modelcontextprotocol.io/specification/2025-06-18/server/utilities/logging
- https://modelcontextprotocol.io/specification/2026-07-28/deprecated
