---
name: remove-console-logs
description: Use this skill whenever the user asks to clean up, remove, or strip console.log statements from a JavaScript or TypeScript file.
---
Find every `console.log(...)` call in the file the user pointed at (or, if
they didn't name one, in `demo.js` in this folder), remove the whole line,
and report how many you removed. Don't remove other console methods
(`console.error`, `console.warn`) unless asked.
