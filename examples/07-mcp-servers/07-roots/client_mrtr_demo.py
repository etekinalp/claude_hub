"""A minimal client harness that drives list_my_roots_modern through a full
MRTR (multi round-trip request) round trip over stdio.

This stands in for what a real 2026-07-28-aware client does automatically.
It's deliberately raw JSON-RPC, not the `mcp` client SDK, so every step of
the exchange stays visible. The roots list below is canned (this folder
itself), standing in for whatever a real client - Claude Code's launch
directory and /add-dir list, for instance - would actually supply.

Run it from this folder: uv run --with mcp python client_mrtr_demo.py
"""

import json
import os
import subprocess
import sys

META = {
    "io.modelcontextprotocol/protocolVersion": "2026-07-28",
    "io.modelcontextprotocol/clientInfo": {"name": "mrtr-demo-client", "version": "0.1"},
    "io.modelcontextprotocol/clientCapabilities": {"roots": {}},
}


def send(proc: subprocess.Popen, request: dict) -> dict:
    proc.stdin.write(json.dumps(request) + "\n")
    proc.stdin.flush()
    line = proc.stdout.readline()
    if not line:
        print("(no response - server exited early)", file=sys.stderr)
        print(proc.stderr.read(), file=sys.stderr)
        sys.exit(1)
    return json.loads(line)


def main() -> None:
    here = os.path.abspath(os.path.dirname(__file__))
    proc = subprocess.Popen(
        ["python3", "server.py"],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        bufsize=1,
    )

    print("--- leg 1: initial call, no roots supplied yet ---")
    leg1 = send(
        proc,
        {
            "jsonrpc": "2.0",
            "id": 1,
            "method": "tools/call",
            "params": {"name": "list_my_roots_modern", "arguments": {}, "_meta": META},
        },
    )
    print(json.dumps(leg1, indent=2))
    assert leg1["result"]["resultType"] == "input_required", "expected an InputRequiredResult"
    request_state = leg1["result"]["requestState"]
    print("\nServer is asking the client to answer this roots/list request:")
    print(json.dumps(leg1["result"]["inputRequests"]["roots"], indent=2))

    print(f"\n--- (client answers with its own roots: this folder, {here!r}) ---\n")

    print("--- leg 2: retry the same logical call, roots attached ---")
    leg2 = send(
        proc,
        {
            "jsonrpc": "2.0",
            "id": 2,  # new id - same logical call, per the spec
            "method": "tools/call",
            "params": {
                "name": "list_my_roots_modern",
                "arguments": {},
                "requestState": request_state,  # echoed back exactly
                "inputResponses": {
                    "roots": {"roots": [{"uri": f"file://{here}", "name": "07-roots"}]}
                },
                "_meta": META,
            },
        },
    )
    print(json.dumps(leg2, indent=2))
    assert leg2["result"]["resultType"] == "complete"
    print(f"\nFinal result:\n{leg2['result']['content'][0]['text']}")

    proc.stdin.close()
    proc.terminate()


if __name__ == "__main__":
    main()
