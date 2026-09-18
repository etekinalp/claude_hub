"""Minimal reference server for the transports-and-messages walkthrough.

One tool, deliberately trivial, so the JSON-RPC traffic around it is easy to
read. Run directly (python server.py) for the stdio transport, or see
server_http.py for the same tool over StreamableHTTP.
"""

import random

from mcp.server.mcpserver import MCPServer

mcp = MCPServer("reference-server")


@mcp.tool()
def roll_dice(sides: int = 6) -> int:
    """Roll a die with the given number of sides and return the result."""
    return random.randint(1, sides)


if __name__ == "__main__":
    mcp.run()
