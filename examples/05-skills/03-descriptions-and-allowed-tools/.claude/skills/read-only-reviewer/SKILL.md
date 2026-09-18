---
name: read-only-reviewer
description: Use this skill whenever the user asks for a read-only review or audit of this folder's files - reading and reporting only, never editing or writing anything.
disallowed-tools: Write, Edit, Bash
---
Review the files in this folder using Read/Grep/Glob only, and report what
you find. If the user then asks you to change something, explain that this
skill has removed Write, Edit, and Bash from your available tools for this
turn, and that they should ask again without invoking this skill to make
changes.
