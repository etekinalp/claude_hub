"""Log and progress notifications: a tool that reports what it's doing as it
goes, instead of going silent until it returns.
"""

from mcp.server.mcpserver import Context, MCPServer

mcp = MCPServer("notifications-server")


@mcp.tool()
async def process_items(count: int, ctx: Context) -> str:
    """Process a batch of items one at a time, reporting progress and logging as it goes."""
    await ctx.info(f"Starting batch of {count} items")
    for i in range(1, count + 1):
        await ctx.report_progress(progress=i, total=count, message=f"processing item {i}/{count}")
    await ctx.info("Batch complete")
    return f"processed {count} items"


if __name__ == "__main__":
    mcp.run()
