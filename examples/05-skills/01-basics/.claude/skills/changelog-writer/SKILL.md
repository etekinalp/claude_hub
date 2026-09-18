---
name: changelog-writer
description: Use this skill whenever the user asks to add, draft, or write a changelog entry for this repo (claude_hub). Formats a new dated entry matching docs/changelog.md's existing style.
---
When asked to add a changelog entry, follow the exact format already used in
docs/changelog.md: a `## YYYY-MM-DD` heading (today's date), followed by one
bullet per item, each naming the affected file(s) in backticks and a short
description of what changed. Read the existing docs/changelog.md first to
match tone, and place the new heading with the most recent entries, not
buried below older ones.
