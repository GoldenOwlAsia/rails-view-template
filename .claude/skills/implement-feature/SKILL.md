---
name: implement-feature
description: Build a feature in this Rails app by first finding an analogous existing implementation, then placing each piece in the layer that already exists for it. Use when adding new functionality.
---

Implement: $ARGUMENTS

## Phase 1 — Explore before designing

For a large or unclear feature, dispatch the `rails-architect` agent
(read-only) to do this phase — it produces a layer-by-layer plan and is the
place to argue for a new abstraction, rather than re-deciding that here. For a
small, clearly analogous feature, do the following directly.

1. Find the closest existing feature and read it end to end. `app/controllers/admin/users_controller.rb`
   plus its policy, permit_params, query and views is the fullest worked example.
2. List which existing layers the work needs — operation, query, presenter,
   permit_params, policy, job, view, Stimulus controller.
3. If you believe a new architectural pattern is required, stop and say why
   before writing it. The default answer is that one of the existing layers fits.

## Phase 2 — Agree the plan

State: the layers you will touch, the files you will add, the authorization
rule, and what the specs will assert. Keep it short. Get agreement before
writing code for anything non-trivial.

## Phase 3 — Build

Write the spec first where it is practical.

Order that works well here: migration → model → policy → operation/query →
permit_params → controller → view → Stimulus.

Follow `.claude/rules/` for each layer — they load as you open the files. For a
feature that touches several layers, each step above has a matching
write-capable agent that already knows that layer's rule file and hard
constraints — dispatch them in the order above instead of writing every layer
inline yourself when the feature is large enough to benefit from the
isolation. For a small, single-file change, just write it directly.

- `model-agent` — models, validators, and their migrations
- `policy-agent` — Pundit policies
- `operation-agent` — operations and queries
- `controller-agent` — controllers and permit_params
- `view-agent` — views, ViewComponents, and Stimulus controllers
- `job-agent` — background jobs and mailers
- `rspec-agent` — standalone spec work not already covered by the above

## Phase 4 — Verify

Run the commands from `CLAUDE.md`'s Workflow section that apply to what
changed, and paste real output for each — never claim one passed without
running it.

If `model-agent` touched anything beyond a trivial column add, dispatch
`database-reviewer` now — don't rely on that agent's own self-report as the
only check, even when it says its own verification passed. Same for
`security-reviewer` when the feature touches auth, admin, uploads, or
permissions: dispatch it rather than trusting `policy-agent`'s or
`controller-agent`'s self-report alone.

## Phase 5 — Review your own diff

Read `git diff` as a reviewer: missing authorization, an N+1, a validation with
no database constraint behind it, a spec that would pass even if the feature
were removed, leftover debugging, unrelated churn.

Report files changed, commands run with results, and anything left undone.
