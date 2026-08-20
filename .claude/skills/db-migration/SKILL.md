---
name: db-migration
description: Plan and write a database schema change for this Rails app under strong_migrations, covering locking, indexes, constraints, backfills and rollback. Use for any schema, index, constraint or column change.
---

Schema change requested: $ARGUMENTS

## Phase 1 — Establish the shape

1. Read the current `db/schema.rb` for the tables involved.
2. Read the models: existing validations, associations, `implicit_order_column`.
3. Decide what the database must enforce versus what the model asserts. A
   uniqueness validation without a unique index is a race.

## Phase 2 — Check each hazard

Lock, index, constraint, backfill, rollback, deploy order, and the squash-mode-
vs-deployed-mode workflow — the full checklist lives in
`.claude/rules/models-and-migrations.md` (auto-loaded once you touch a
migration file) and is maintained there, not repeated here. For anything
beyond a trivial column add, dispatch the `database-reviewer` agent
(read-only) to audit the planned change against that checklist before you
write it — it stays current independently of this skill and catches
model/schema mismatches this phase would otherwise miss.

## Phase 3 — Write it

For an isolated schema change, dispatch the write-capable `model-agent`
(it owns both models and migrations) instead of writing it inline — it
already knows the squash-mode-vs-deployed-mode workflow from
`.claude/rules/models-and-migrations.md` and the verification list for
Phase 4. Write it directly yourself when the change is part of a larger
feature you're already building — say explicitly which mode applies before
touching a migration file.

## Phase 4 — Verify

Run the "Verify" commands in `.claude/rules/models-and-migrations.md` and
paste the real output — never claim one passed without running it.

Report the change, the hazards you ruled out, and the commands you ran.
