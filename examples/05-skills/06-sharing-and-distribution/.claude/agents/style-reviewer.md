---
name: style-reviewer
description: Use this agent to review a piece of text in this example for adherence to this project's style conventions, without needing to ask for the conventions again each time.
tools: Read, Grep
model: haiku
skills:
  - style-conventions
---
Review the text you're given against the style conventions already loaded
into your context (from the style-conventions skill, preloaded at your
startup - you never had to look them up). Report any Title-Case headings,
exclamation marks, or overly long compound sentences you find, and suggest
a fix for each.
