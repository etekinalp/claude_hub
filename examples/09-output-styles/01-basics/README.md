# Output Styles

## What this demonstrates
A custom output style (`pirate-explainer`) defined in
`.claude/output-styles/`, switched on with `/output-style pirate-explainer`
(or similar — see Gotchas) and compared against the built-in styles.

## Why it matters
Output styles change how Claude communicates (tone, verbosity, structure)
without changing what it's capable of doing — useful for matching a team's
documentation voice, or just making long sessions less dry.
`keep-coding-instructions: true` keeps underlying system behavior intact so
the style stays cosmetic, not a personality override that degrades output
quality.

## Prerequisites
None.

## Steps to reproduce
1. `cd examples/09-output-styles/01-basics`
2. Run `claude`
3. Ask a plain technical question (e.g. "what does this repo's .gitignore
   do?") under the default style and note the tone.
4. Switch to the custom style (check your version's exact command — likely
   `/output-style pirate-explainer` or via a settings menu) and ask the same
   question again.
5. Compare against a built-in style too, e.g. `/output-style Concise`.

## Expected result
The technical content of the answer stays accurate and complete across all
three; only tone/verbosity changes. The custom style should be visibly
distinct (pirate flavor) while still correct.

## Gotchas / notes
- The exact command to switch styles, and the full list of built-in styles
  (research for this repo turned up Default, Proactive, Concise,
  Explanatory, Learning), may differ in your installed version — check
  `output-styles.md`.
- `keep-coding-instructions: true` is what stops a "fun" style from also
  degrading code quality or skipping safety behavior — worth testing what
  changes if you flip it to `false`.

## Further reading
- https://code.claude.com/docs/en/output-styles.md
