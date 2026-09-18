"""Roots: a tool that asks the client which directories/files it's allowed
to work in, instead of the user having to type out full paths.

Two versions live here side by side:

- `list_my_roots` - the classic (2025-06-18) pattern: the server pushes a
  `roots/list` request to the client mid-call and awaits the reply.
- `list_my_roots_modern` - the 2026-07-28 replacement: the tool returns an
  `InputRequiredResult` describing the same `roots/list` request as data,
  and picks up where it left off when the client retries the call with
  the roots attached. No server-initiated request involved.
"""

from mcp.server.mcpserver import Context, MCPServer
from mcp.types import InputRequiredResult, ListRootsRequest

mcp = MCPServer("roots-server")


@mcp.tool()
async def list_my_roots(ctx: Context) -> str:
    """List the filesystem roots the connected client currently exposes to this server."""
    result = await ctx.session.list_roots()
    if not result.roots:
        return "The client didn't expose any roots."
    lines = [f"- {r.name or '(unnamed)'}: {r.uri}" for r in result.roots]
    return "\n".join(lines)


@mcp.tool()
async def list_my_roots_modern(ctx: Context) -> str | InputRequiredResult:
    """Same as list_my_roots, using the 2026-07-28 MRTR pattern instead of a server push."""
    if ctx.input_responses is None:
        # First round: no answer yet. Describe the roots/list request as data
        # and hand the call back to the client instead of pushing it ourselves.
        return InputRequiredResult(
            input_requests={"roots": ListRootsRequest()},
            request_state="awaiting-roots",
        )
    # Second round: the client retried this same tool call with the roots
    # result attached under inputResponses["roots"] and the echoed requestState.
    result = ctx.input_responses["roots"]
    if not result.roots:
        return "The client didn't expose any roots."
    lines = [f"- {r.name or '(unnamed)'}: {r.uri}" for r in result.roots]
    return "\n".join(lines)


if __name__ == "__main__":
    mcp.run()
