"""Sampling: a tool that asks the connected client's LLM to do work for it,
instead of calling an LLM API directly.

Two versions of the same idea live here side by side:

- `summarize_in_one_line` - the classic (2025-06-18) pattern: the server
  pushes a `sampling/createMessage` request to the client mid-call and
  awaits the reply. Heads up before you run this against Claude Code: as
  of this writing, Claude Code does not implement the client side of this
  (no server API key needed is the whole point, but the client has to opt
  in) - see this folder's README for how to actually exercise this tool
  with the MCP Inspector instead.

- `summarize_in_one_line_modern` - the 2026-07-28 replacement: instead of
  a mid-call push, the tool returns an `InputRequiredResult` describing
  the same `sampling/createMessage` request as data, and picks up where
  it left off when the *same logical call* is retried with the answer
  attached. No server-initiated request, no back-channel, no client
  feature to "not implement" - any client that can retry a tools/call with
  extra fields can drive this, which is the whole point of the change.
"""

from mcp.server.mcpserver import Context, MCPServer
from mcp.types import (
    CreateMessageRequest,
    CreateMessageRequestParams,
    InputRequiredResult,
    SamplingMessage,
    TextContent,
)

mcp = MCPServer("sampling-server")


@mcp.tool()
async def summarize_in_one_line(text: str, ctx: Context) -> str:
    """Ask the connected client's LLM to summarize the given text in one short line."""
    result = await ctx.session.create_message(
        messages=[
            SamplingMessage(
                role="user",
                content=TextContent(type="text", text=f"Summarize in one short line: {text}"),
            )
        ],
        max_tokens=60,
    )
    content = result.content
    return content.text if hasattr(content, "text") else str(content)


@mcp.tool()
async def summarize_in_one_line_modern(text: str, ctx: Context) -> str | InputRequiredResult:
    """Same as summarize_in_one_line, using the 2026-07-28 MRTR pattern instead of a server push."""
    if ctx.input_responses is None:
        # First round: no answer yet. Describe the sampling request as data
        # and hand the call back to the client instead of pushing it ourselves.
        return InputRequiredResult(
            input_requests={
                "summary": CreateMessageRequest(
                    params=CreateMessageRequestParams(
                        messages=[
                            SamplingMessage(
                                role="user",
                                content=TextContent(
                                    type="text", text=f"Summarize in one short line: {text}"
                                ),
                            )
                        ],
                        max_tokens=60,
                    )
                )
            },
            request_state="awaiting-summary",
        )
    # Second round: the client retried this same tool call with the sampling
    # result attached under inputResponses["summary"] and the echoed requestState.
    result = ctx.input_responses["summary"]
    content = result.content
    return content.text if hasattr(content, "text") else str(content)


if __name__ == "__main__":
    mcp.run()
