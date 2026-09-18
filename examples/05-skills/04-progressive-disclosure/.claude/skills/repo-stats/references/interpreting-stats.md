# Interpreting claude_hub's repo stats

This is reference material for `repo-stats` — only worth reading when the
user asks what the numbers mean, wants trends, or wants a written-up
analysis rather than the bare counts.

## What each number tells you
- **concepts**: one per top-level `examples/NN-name/` folder. This grows
  slowly and deliberately — a new top-level number is only added for a
  genuinely uncovered Claude Code concept (see the root `CLAUDE.md`).
- **sub-examples**: every `0N-topic/` folder inside a concept. This is
  where most growth actually happens day to day — going deeper on an
  existing concept adds here, not a new top-level number.
- **READMEs**: sub-example READMEs plus each concept's own index README
  plus the root README. A concept with N sub-examples contributes N+1
  READMEs (the index, plus one per sub-example).
- **total README lines**: a rough proxy for how much documentation this
  repo carries. Rising quickly relative to sub-example count can mean
  READMEs are getting bloated rather than examples getting more thorough
  — worth spot-checking against the 7-section template's expected length
  if this ratio jumps.

## A rough health check
Divide `total README lines` by `sub-examples`. This repo's own template
(`templates/example-template/README.md`) and the 7 required sections
tend to land most finished READMEs somewhere in the 60-150 line range;
if the average is climbing well past that, it's worth skimming a few of
the newest ones for repetition or padding before adding more.
