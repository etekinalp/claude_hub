"""Same tool as server.py, run over StreamableHTTP instead of stdio.

    uv run --with mcp python server_http.py

Then talk to it directly with curl - see this folder's README for the full
request/response walkthrough (initialize, session ID, tool call, DELETE).
"""

import random

from mcp.server.mcpserver import MCPServer

mcp = MCPServer("reference-server")


@mcp.tool()
def roll_dice(sides: int = 6) -> int:
    """Roll a die with the given number of sides and return the result."""
    return random.randint(1, sides)


if __name__ == "__main__":
    mcp.run(transport="streamable-http", host="127.0.0.1", port=8765)
