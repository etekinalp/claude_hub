"""A minimal client harness that drives summarize_in_one_line_modern through
a full MRTR (multi round-trip request) round trip over stdio.

This stands in for what a real 2026-07-28-aware client does automatically.
It's deliberately raw JSON-RPC, not the `mcp` client SDK, so every step of
the exchange stays visible. The "LLM reply" below is a canned string, not a
real model call - swap `FAKE_SUMMARY` for a real LLM API call if you want
to see genuinely generated text; the point of this script is the protocol
shape, not the summarization.

Run it from this folder: uv run --with mcp python client_mrtr_demo.py
"""

import json
import subprocess
import sys

FAKE_SUMMARY = "MRTR replaces server-initiated requests with retry-carried answers."

META = {
    "io.modelcontextprotocol/protocolVersion": "2026-07-28",
    "io.modelcontextprotocol/clientInfo": {"name": "mrtr-demo-client", "version": "0.1"},
    "io.modelcontextprotocol/clientCapabilities": {"sampling": {}},
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
    text = "Model Context Protocol lets an LLM call out to external tools through a standard interface."
    proc = subprocess.Popen(
        ["python3", "server.py"],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        bufsize=1,
    )

    print("--- leg 1: initial call, no answer yet ---")
    leg1 = send(
        proc,
        {
            "jsonrpc": "2.0",
            "id": 1,
            "method": "tools/call",
            "params": {
                "name": "summarize_in_one_line_modern",
                "arguments": {"text": text},
                "_meta": META,
            },
        },
    )
    print(json.dumps(leg1, indent=2))
    assert leg1["result"]["resultType"] == "input_required", "expected an InputRequiredResult"
    request_state = leg1["result"]["requestState"]
    sampling_request = leg1["result"]["inputRequests"]["summary"]
    print("\nServer is asking the client to run this sampling/createMessage request:")
    print(json.dumps(sampling_request, indent=2))

    print(f"\n--- (client 'asks its LLM', gets back: {FAKE_SUMMARY!r}) ---\n")

    print("--- leg 2: retry the same logical call, answer attached ---")
    leg2 = send(
        proc,
        {
            "jsonrpc": "2.0",
            "id": 2,  # new id - same logical call, per the spec
            "method": "tools/call",
            "params": {
                "name": "summarize_in_one_line_modern",
                "arguments": {"text": text},
                "requestState": request_state,  # echoed back exactly
                "inputResponses": {
                    "summary": {
                        "role": "assistant",
                        "content": {"type": "text", "text": FAKE_SUMMARY},
                        "model": "fake-demo-model",
                    }
                },
                "_meta": META,
            },
        },
    )
    print(json.dumps(leg2, indent=2))
    assert leg2["result"]["resultType"] == "complete"
    print(f"\nFinal result: {leg2['result']['content'][0]['text']!r}")

    proc.stdin.close()
    proc.terminate()


if __name__ == "__main__":
    main()
