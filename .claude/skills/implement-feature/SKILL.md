---
name: implement-feature
description: Build a feature in this Rails app by first finding an analogous existing implementation, then placing each piece in the layer that already exists for it. Covers schema and migration work under strong_migrations. Use when adding new functionality, or when changing a schema, index, constraint or column.
---

Implement: $ARGUMENTS

## Phase 1 — Explore before designing

For a large or unclear feature, dispatch the `reviewer-agent`
(read-only, Architecture section) to do this phase — it produces a
layer-by-layer plan and is the place to argue for a new abstraction, rather
than re-deciding that here. For a small, clearly analogous feature, do the
following directly.

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

Order that works well here: backend (migration → model → policy →
operation/query → permit_params → controller, in that internal order) →
frontend (view → Stimulus) → async (job/mailer), where each phase applies.

Follow `.claude/rules/` for each layer — they load as you open the files, so
the conventions arrive with the code rather than needing to be recited here.
Write each layer yourself and verify it before starting the next; don't write
six layers and verify once at the end, and never let a later layer paper over
an earlier one being wrong (a model tightening what the migration should have
enforced in the database, a controller inlining logic an operation should own).

### If the work changes the schema

This is the first step of the backend order above, and it applies whether
the migration is part of a feature or is the whole task.

1. Read `db/schema.rb` for the tables involved, then the models — existing
   validations, associations, and the indexes already on the table.
2. Decide what the database must enforce versus what the model merely
   asserts. A uniqueness validation with no unique index behind it is a
   race, not a guarantee.
3. State which mode applies — squash (edit the original migration, then
   regenerate the schema) or deployed (append a new migration, never touch
   one that has already run) — *before* touching a migration file.
4. For anything beyond a trivial column add, dispatch `reviewer-agent`
   (read-only, Database section) to audit the planned change before it is
   written. Locking, concurrent indexes, constraints, backfills, rollback
   and deploy order are all covered by the checklist in
   `.claude/rules/models-and-migrations.md`, which auto-loads once you open
   a migration and is maintained there rather than repeated here.
5. Verify with that rule file's own "Verify" commands, not just the ones in
   Phase 4 below.

## Phase 4 — Verify

Run the commands from `CLAUDE.md`'s Workflow section that apply to what
changed, and paste real output for each.

If the change went beyond a trivial single layer — a migration beyond a column
add, or anything touching auth, admin, uploads, or permissions — dispatch
`reviewer-agent` now. Your own verification passing is not the same as a
second pass over the diff with fresh eyes, which is the whole reason that
agent is read-only and separate.

## Phase 5 — Review your own diff

Read `git diff` as a reviewer: missing authorization, an N+1, a validation with
no database constraint behind it, a spec that would pass even if the feature
were removed, leftover debugging, unrelated churn.

Report files changed, commands run with results, and anything left undone.
