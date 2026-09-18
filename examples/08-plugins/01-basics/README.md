# Plugins

## What this demonstrates
A minimal local plugin (`my-first-plugin/`) with a `.claude-plugin/plugin.json`
manifest and one bundled skill, loaded without installing or publishing it,
via `--plugin-dir`.

## Why it matters
Plugins are the distribution unit — once you've built a skill, agent, hook,
or MCP server you like, a plugin is how you package several of them together
and share or reuse them across projects, instead of copy-pasting `.claude/`
folders. `--plugin-dir` lets you iterate on a plugin locally before ever
publishing it to a marketplace.

## Prerequisites
None.

## Steps to reproduce
1. `cd examples/08-plugins/01-basics`
2. Run `claude --plugin-dir ./my-first-plugin`
3. Ask Claude to "greet me using the plugin" — expect the `greet` skill from
   `my-first-plugin` to respond and explicitly name itself as coming from
   the plugin.
4. If you edit `my-first-plugin/skills/greet/SKILL.md` mid-session, exit
   and restart `claude --plugin-dir ./my-first-plugin` to pick up the
   change — plugin config, like project config generally, is read at
   session start. (`/reload-plugins` turns up in some searches, but
   example 03's built-in-commands audit couldn't confirm it as a real
   command in the current docs, so don't rely on it — see
   `builtin-commands-reference.md`'s "Checked but not confirmed" section.)

## Expected result
The plugin's skill behaves like any project skill, but is clearly scoped to
`--plugin-dir` rather than this example's own `.claude/` (which doesn't
exist here on purpose — everything in this example comes from the plugin).

## Gotchas / notes
- No `.claude/` folder exists in this example directory at all — that's
  deliberate, to prove the skill is coming entirely from the plugin, not
  from project-level config.
- `claude plugin eval` (if available in your version) can run a plugin
  against a test-case suite with graders — worth exploring once you have a
  plugin worth testing rigorously; not reproduced here.
- Publishing to a marketplace (a `marketplace.json` listing multiple
  plugins) is a separate step beyond this example's scope.

## Further reading
- https://code.claude.com/docs/en/plugins.md
