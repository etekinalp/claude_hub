---
name: repo-stats
description: Use this skill whenever the user asks for stats about this claude_hub repo - how many examples, concepts, or READMEs it has, or wants a repo stats report.
allowed-tools: Bash(${CLAUDE_SKILL_DIR}/scripts/repo_stats.sh)
---
Run `${CLAUDE_SKILL_DIR}/scripts/repo_stats.sh` to get the current counts.
Do not read the script itself - just run it and use its output.

Report the four numbers it prints back to the user in plain prose.

If the user asks what the numbers *mean*, wants a trend read, or wants a
written-up analysis rather than just the counts, read
`references/interpreting-stats.md` (only then - it's not needed for a
plain "what are the stats" request) and use it to inform your answer.

If the user asks for a formatted report instead of a plain reply, use
`assets/report-template.md` as the structure, filling in today's date and
the script's output.
