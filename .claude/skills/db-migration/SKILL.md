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

Lock, index, constraint, backfill, rollback, deploy order — the full checklist
lives in `.claude/rules/migrations.md` (auto-loaded once you touch a migration
file) and is maintained there, not repeated here. For anything beyond a trivial
column add, dispatch the `database-reviewer` agent (read-only) to audit the
planned change against that checklist before you write it — it stays current
independently of this skill and catches model/schema mismatches this phase
would otherwise miss.

## Phase 3 — Write it

For an isolated schema change, dispatch the write-capable `migration-agent`
instead of writing it inline — it carries the same squash-mode-vs-deployed-mode
logic below and the same verification list as Phase 4. Write it directly
yourself when the change is part of a larger feature you're already building.

This template squashes migration history into the original `create_table`
migrations rather than appending new ones, because it ships no production data.
Edit the original migration, then regenerate the schema from scratch:

```sh
rm db/schema.rb && RAILS_ENV=test bin/rails db:drop db:create db:migrate
```

For a deployed application the opposite holds — add a new migration and never
touch a deployed one. Say which mode you are in.

## Phase 4 — Verify

Run the "Verify" commands in `.claude/rules/migrations.md` and paste the real
output — never claim one passed without running it.

Report the change, the hazards you ruled out, and the commands you ran.
