#!/usr/bin/env bash
# Reference only - running this spends one of your limited free ultrareview
# runs (or bills usage credits). See this folder's README before running
# for real. These lines show the non-interactive subcommand shape:

claude ultrareview                    # review current branch vs default branch
claude ultrareview 1234 --post        # review PR 1234, post findings to it
claude ultrareview --json             # machine-readable output
