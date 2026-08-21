---
name: create-migration
description: Write a schema change on its own — a column, index, constraint or table — choosing squash-vs-deployed mode before any migration file is touched. Use when the migration is the whole task. If the schema change is one layer of a feature being built, implement-feature sequences it instead.
---

Schema change: $ARGUMENTS

If this turns out to be one layer of a feature you are also building, stop and
use `implement-feature` — it orders the model, policy, operation and controller
work around this step. Continue here only when the migration is the task.

## 1. Establish the current shape

Read `db/schema.rb` for the tables involved, then the models: existing
validations, associations, and the indexes already on the table. Decide what
the database must enforce versus what a model merely asserts — a uniqueness
validation with no unique index behind it is a race, not a guarantee.

## 2. Declare the mode before touching a file

Say which one applies, out loud, before opening any migration:

- **squash** — edit the original `create_table` migration, then regenerate the
  schema. This is the template's default, and it carries a trap: every
  migration in the repo today is at or before
  `StrongMigrations.start_after` (20241004100359), so the gem checks *nothing*
  when you edit one. Locks, rewrites and backfills are yours to reason about by
  hand there.
- **deployed** — append a new migration and never touch one that has already
  run. A migration after the marker does get checked normally.

Getting this backwards is the expensive mistake, which is why it is settled
before a file is opened rather than after.

## 3. Write it

`.claude/rules/models-and-migrations.md` auto-loads the moment you open a
migration file. Its Migrations section is the maintained checklist — concurrent
indexes, `nulls_not_distinct`, foreign keys, backfills, the UUID ordering
caveat. Work from it rather than from memory; this skill deliberately does not
restate it.

Anything beyond a trivial column add: dispatch `reviewer-agent` (read-only,
Database section) to audit the plan *before* it is written.

## 4. Verify

Run the "Verify" commands in that rule file and paste the real output. RuboCop
and `zeitwerk:check` already run in the Stop hook, so the ones that matter here
are `db:migrate:status`, `git diff db/schema.rb`,
`bundle exec database_consistency`, and the specs touching those tables.

Report: which mode you used, which hazards you ruled out, and what you ran.
