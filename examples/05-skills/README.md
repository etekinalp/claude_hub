# Skills

Index for this concept. Each numbered subfolder is a self-contained example
you `cd` into before running `claude` — see the root README for why.

## Examples

| # | Sub-example | Status |
|---|---|---|
| 01 | [Basics](01-basics/) — auto-invoked vs manual-only skill, contrasted | done |
| 02 | [Anatomy & discovery](02-anatomy-and-discovery/) — where skills live (project, nested, and beyond), and how Claude Code matches a request to one | done |
| 03 | [Descriptions & tool access](03-descriptions-and-allowed-tools/) — writing descriptions that actually trigger, and the real difference between `allowed-tools` and `disallowed-tools` | done |
| 04 | [Progressive disclosure](04-progressive-disclosure/) — a larger skill organized with `scripts/`, `references/`, and `assets/` to stay token-cheap | done |
| 05 | [Choosing the right tool](05-choosing-the-right-tool/) — the same rule as CLAUDE.md, a skill, and a hook, so the guidance-vs-enforcement tradeoff is visible, not just tabled | done |
| 06 | [Sharing & distribution](06-sharing-and-distribution/) — project repos, plugins (cross-linked to example 08), a skill-preloading subagent, and enterprise managed settings (documented) | done |
| 07 | [Debugging & validation](07-debugging-and-validation/) — three real structural bugs (broken/fixed pairs) plus the actual diagnostic commands | done |

## A note on 02–07

Built from the Anthropic Academy course "Introduction to Agent Skills,"
organized by topic rather than mirrored to the course's own lesson order
(same convention as this repo's `07-mcp-servers` batch). Two things
surfaced while cross-checking the course against the official docs
(`code.claude.com/docs/en/skills`, `sub-agents`, `debug-your-config`),
each flagged explicitly in the affected example rather than silently
corrected:

- **`allowed-tools` doesn't restrict** the way the course frames it — it
  only pre-approves a list for the invoking turn; `disallowed-tools` is
  the field that actually removes tools from the pool. See example 03.
- **The course's "skills validator... installed via uv"** doesn't match
  anything in the current official docs. The real diagnostic surface is
  `/skills`, `/context`, `claude doctor`, `claude --debug`, `/status`,
  and `claude --safe-mode` — see example 07.

See `docs/gap-analysis.md` for the full research trail.

## Adding more depth here

More skills material goes in a new `0N-topic/` subfolder here, not
a new top-level `examples/` number — see the root `CLAUDE.md` conventions.
