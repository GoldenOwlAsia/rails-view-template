# Rails view template

Rails 8.1 / Ruby 3.4.7 / PostgreSQL. Slim + Vite + Turbo + Stimulus + Tailwind
(daisyUI). Devise + Pundit + rolify. Sidekiq. RSpec.

Detailed conventions live in `.claude/rules/` and load when you open matching
files. This file holds only what applies everywhere.

## Architecture

These layers exist. Extend them rather than introducing a parallel pattern.
`.claude/rules/rails-architecture.md` has the decision table for choosing
between them.

**What other Rails codebases call a Service Object is an Operation here. There is
no `app/services` and you must not create one.**

- `app/operations` — write/business workflows. Subclass `ApplicationOperation`,
  return `success(...)` / `failure(...)` from `Responseable`.
- `app/queries` — complex reads. Subclass `ApplicationQuery`, use its
  `filter`/`sort` helpers.
- `app/components` — ViewComponents. Subclass `ApplicationComponent`, template as
  a `.html.slim` sidecar beside the class.
- `app/presenters` — view-facing transformation.
- `app/permit_params` — strong parameters as plain classes exposing
  `permitted_attributes`.
- `app/policies` — Pundit authorization. Admin policies are namespaced under
  `app/policies/admin`.
- `app/validators` — custom ActiveModel validators.
- `app/controllers/concerns` — `Crudable`, `Attachable`, `Currentable`.
- `app/jobs` — Sidekiq background work.

Controllers orchestrate. They authorize, delegate mutations to operations and
reads to queries, then render.

Each layer's conventions live in the `.claude/rules/` file that auto-loads when
you open a matching file. Write the code yourself, following those — there are
no write-capable agents here, deliberately: an agent that edits files is an
agent making changes nobody reviewed, and a per-layer agent mostly restates a
rule file that has already loaded.

The two agents under `.claude/agents/` are both read-only, and exist for
context isolation rather than knowledge: `reviewer-agent` (architecture fit,
database, security — fresh eyes on finished work) and `bug-investigator`
(root-cause tracing across many files). Neither edits anything.

## Environment

Ruby is managed by rbenv (`.ruby-version`), Node by nvm (`.nvmrc`). Both must
match or Vite fails. Run `nvm use` in the project directory.

Database config reads `DB_HOST`, `DB_PORT`, `DB_USERNAME`, `DB_PASSWORD`,
`DB_NAME` from `.env`. The test database name is fixed and never taken from
`DB_NAME`.

## Workflow

Before editing:

1. Find an existing analogous implementation and follow it.
2. Trace the full data flow before concluding anything.
3. Fix the root cause, not the symptom.
4. Check which specs cover the behaviour.

After editing, run what the change touched and say which commands you ran:

- `bin/rspec <paths>` — targeted specs first
- `bundle exec rubocop <files>` — changed Ruby (and `.slim`, via rubocop-slim)
- `bundle exec slim-lint app/views` — changed templates
- `yarn lint` — changed `app/frontend`
- `bin/rails zeitwerk:check` — files/constants added, moved, or renamed
- `bundle exec database_consistency` — schema or model validation changes

Never claim something passes without having run it and seen the output.

## Safety

- Never write to `.env`, `config/master.key`, `config/credentials/*.key`, or any
  `*.pem` / `*.key`. `.env.sample` is fine. This holds for shell commands too —
  a redirect or `cp` is the same write.
- Never run destructive database commands (`db:drop`, `db:reset`,
  `db:migrate:reset`, `db:schema:load` on a populated database). The development
  database in this workspace is not disposable.
- Never target production: no `RAILS_ENV=production` task runs, no production
  `DATABASE_URL`.
- Do not add a gem or npm package without a concrete requirement in the task.
- Do not change public behaviour while refactoring.

## Git

- `git commit` and `git push` are blocked by a hook and are the user's to run.
  Describe what changed and let them commit. Do not look for a way around it.
- Reading history and staging are fine: `git status`, `git diff`, `git log`,
  `git show`, `git add`.
- Keep unrelated changes out of the diff.
- Never edit a migration that is already deployed — except in this template,
  where migration history is intentionally squashed into the original files.

## Compaction

When compacting, preserve: the root cause found, files modified, architectural
decisions taken, unresolved issues, and which verification commands were
actually run with their results.

Note that path-scoped rules under `.claude/rules/` are not re-injected after a
compaction; they reload when you next read a matching file.
