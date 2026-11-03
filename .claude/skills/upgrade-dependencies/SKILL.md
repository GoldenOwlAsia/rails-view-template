---
name: upgrade-dependencies
description: Bump gems or npm packages in this template and prove the result still builds, lints and passes — covering the runtime pins that must move together and the CI gates that will judge the change. Use when updating dependencies, refreshing the lockfiles, or acting on a bundler-audit advisory. Not for a Rails major-version upgrade.
---

Upgrade: $ARGUMENTS

This is the routine that keeps a template worth cloning, so it runs more often
than any feature work. It is not a Rails major-version upgrade — that is a
different job with dual-booting and `app:update`, and this skill does not cover
it.

## 1. Establish what is actually out of date

```sh
bundle outdated --strict --parseable
bin/bundle-audit check --update
yarn outdated
```

Split the result into three buckets before touching a lockfile, and say which
bucket each change is in:

- **security** — a `bundle-audit` advisory. Goes first, on its own, and lands
  even if something else in the batch has to wait.
- **patch/minor** — routine. Batch these.
- **major** — one at a time, each with its changelog read. Never batched with
  anything else.

## 2. Bump

Prefer the narrow command; `bundle update` with no argument rewrites the whole
lockfile and turns a two-line diff into an unreviewable one.

```sh
bundle update <gem> --conservative
yarn upgrade <package>@^x.y.z
```

CI runs `yarn install --frozen-lockfile`, so `yarn.lock` must be committed and
must match `package.json` exactly — a lockfile left stale fails the lint job
before a single test runs.

## 3. Runtime pins move together or not at all

Changing Ruby or Node means changing every file that declares it. Miss one and
the production image builds on a different interpreter than every test ran on:

| Runtime | Files that must agree |
| --- | --- |
| Ruby | `.ruby-version`, `Gemfile`, `Dockerfile` (`ARG RUBY_VERSION`) — CI reads `.ruby-version` directly, so it follows |
| Node | `.node-version`, `.nvmrc`, `package.json` `engines.node` (hardcoded), `Dockerfile` (`ARG NODE_VERSION`) — CI reads `.node-version` |
| Yarn | `Dockerfile` (`ARG YARN_VERSION`) |
| Bundler | `Gemfile.lock` `BUNDLED WITH` |

`repo-consistency-audit` checks these agree and is the maintained copy of that
list — run it after a runtime bump rather than re-deriving the check here.

## 4. Read what a major actually changed

Read the changelog, not the version number. The failures that cost real time in
this repo have all been silent renames and behaviour flips, not crashes:

- `view_component` renamed `preview_paths` / `default_preview_layout` to
  `previews.paths` / `previews.default_layout`; the old names kept working
  while doing less, and Lookbook reads whichever it is handed.
- `strong_migrations` and `good_migrations` gate every migration — a bump can
  start flagging migrations that were fine yesterday.
- `ransack` 4.x has no default attribute allowlist; a bump that changes
  allowlist handling is a security change, not a chore.
- Devise, Pundit and rolify sit under `User` and admin authorization. A major
  in any of them means re-running the policy specs deliberately, not just
  watching the suite go green.

For a major in anything touching auth, uploads or the schema, dispatch
`reviewer-agent` (read-only) over the diff before you call it done.

## 5. Verify with exactly what CI runs

The Stop hook covers RuboCop and `zeitwerk:check` on changed files only, which
is not enough here — a dependency bump can break a file nobody edited. Run the
full gate and paste real output:

```sh
bin/bundle-audit check --update -v
bundle exec brakeman --no-pager
bin/rubocop
bundle exec slim-lint app/views app/components
yarn lint
bundle exec i18n-tasks health
bin/rspec
```

Then the two the gate cannot see: `bin/rails zeitwerk:check`, and a real boot —
`bin/rails runner 'Rails.application.eager_load!'` catches an initializer that
a green suite would not.

Never weaken a spec, a lint rule or a `.rubocop.yml` exclusion to absorb an
upgrade. If a bump genuinely requires a code change, that change is part of the
work; if it requires deleting a check, stop and report it instead.

## 6. Report

Which gems and packages moved and to what, which bucket each was in, what the
changelogs said for any major, every command you ran with its result, and
anything you deliberately held back and why.
