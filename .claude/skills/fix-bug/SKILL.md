---
name: fix-bug
description: Investigate and fix a bug in this Rails app by tracing the real data flow and proving the root cause before changing any code. Use when something is broken, failing, or behaving unexpectedly.
---

Fix the bug described in: $ARGUMENTS

## Phase 1 — Investigate. Do not edit code yet.

If the cause is not obvious and the search will span many files, dispatch the
`bug-investigator` agent (read-only) to do this phase instead of working it
inline — `.claude/agents/bug-investigator.md` holds the maintained checklist
of layers that hide causes in this codebase; don't re-derive it here. For a
bug already localized to one or two files, do the following directly instead:

1. Reproduce it, or pin down the exact failing behaviour and how you know.
2. Find every entry point involved: route → controller → operation/query →
   model → job → view → Stimulus controller.
3. Trace the data end to end. Read the code; do not infer what it "probably"
   does.
4. `git log -p` the suspect files when the behaviour looks like a regression.
5. Find the specs that cover the behaviour — or establish that none do.

Then state the root cause with file:line references. If you cannot, say what
you ruled out and what evidence you still need. Do not guess.

## Phase 2 — Fix

1. Write a spec that fails for this reason, and run it to see it fail.
2. Make the smallest change at the actual cause.
3. No unrelated refactoring in the same diff.

## Phase 3 — Verify

Run the commands from `CLAUDE.md`'s Workflow section that apply to what
changed, and paste the real output. Specs need a working database and
`node_modules` (Vite builds test assets on demand). Use `RAILS_ENV=test`.

## Report

- root cause, with references
- the fix and why it is at the right layer
- files changed
- commands run and their results
- anything still unverified or risky
