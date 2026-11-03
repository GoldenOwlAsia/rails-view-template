---
name: create-job-or-mailer
description: Add a Sidekiq background job (app/jobs) or an ActionMailer mailer (app/mailers) with its template and spec, safe to retry and enqueued after commit. Use whenever the user wants something to run in the background, on a schedule, or by email — "send a welcome email", "notify admins when X", "nightly cleanup", "process this async" — even if they never say "job" or "mailer". Not for Devise's own emails (edit app/views/devise/mailer directly), and not the whole feature around it — implement-feature sequences that.
---

Job or mailer: $ARGUMENTS

If this is one piece of a larger feature, use `implement-feature`. Devise's
confirmation / reset / unlock templates already live in
`app/views/devise/mailer/*.slim` — edit those for copy changes instead of
adding a mailer.

`app/jobs` and `app/mailers` hold only their base classes today, so you are
probably writing the first one. Make it the pattern worth copying.

## 1. Decide what it is, and who triggers it

- **Mailer** — composes one email. Called as `UserMailer.welcome(user).deliver_later`.
- **Job** — runs work off the request: an API call, a batch, a slow task. A
  mailer's `deliver_later` is already a job; do not write a job whose only body
  is `deliver_now`.
- **Recurring** — goes in `config/schedule.yml` (`sidekiq-scheduler`), never a
  `loop`/`sleep` inside the job.

Whoever triggers it is an **operation**, not a model or callback — the
architecture spec fails the suite for `deliver_later` or `perform_later` in
`app/models`. If the trigger is a workflow, use `create-operation`.

## 2. Job rules (each one is a retry or race you meet in production)

- **Arguments are ids, not records.** The row can be stale or gone by dequeue;
  re-fetch in `#perform`.
- **Safe to run twice.** Sidekiq retries a failed job, so a repeat run must be a
  no-op or converge to the same state, not accumulate (no double charge, no
  second email).
- **Do not `rescue StandardError`.** `sentry-sidekiq` reports unhandled errors;
  a blanket rescue hides them from Sentry and from retry. Use
  `discard_on ActiveRecord::RecordNotFound` for a record that is legitimately
  gone, and rescue only what you have a plan for.
- **Enqueue after commit.** Inside a transaction the job can start before the
  row is visible. Either enqueue after the transaction block, or set
  `self.enqueue_after_transaction_commit = true` on the job class (Rails 8.1,
  default `false`). See `.claude/rules/rails-transactions.md`.
- **No concurrent runs for the same resource:** use `sidekiq-unique-jobs`
  (already in the middleware chain), not a hand-rolled lock.

## 3. Mailer rules

- Subclass `ApplicationMailer`; do not override `from` unless the sender truly
  differs (`MAILER_FROM_EMAIL` is set there).
- Always `deliver_later`, not `deliver_now`.
- Templates are Slim under `app/views/<mailer>/`. The mailer layout is bare HTML
  with no Vite or Tailwind behind it — email clients run no build. Inline
  styles or tables only; a daisyUI class renders as nothing.
- Build links with `_url` helpers (host comes from `APP_HOST`), never a
  hardcoded host.
- Development uses `letter_opener_web`, so nothing leaves the machine.

## 4. Spec

No Active Job or Sidekiq test mode is configured in `spec/supports`, so do not
assume `have_enqueued_job` works: write one spec and confirm it intercepts the
enqueue rather than running inline or hitting Redis. If it does not, say so
rather than writing an assertion that checks nothing.

For mailers, `spec/supports/mailer.rb` clears `ActionMailer::Base.deliveries`
before every example, so assert on `ActionMailer::Base.deliveries` or call the
mailer method and check `subject`, `to` and `body`. Put specs in `spec/jobs/`
and `spec/mailers/` (`spec/jobs` does not exist yet; `spec/mailers` is empty). Cover idempotency for a job: run `#perform` twice and assert the result
is the same. Follow `.claude/rules/specs.md`.

## 5. Verify

Yours to run and paste:

- `bin/rspec spec/jobs spec/mailers spec/architecture_spec.rb`
- `bundle exec rubocop app/jobs app/mailers spec/jobs spec/mailers`
- `bundle exec slim-lint app/views` if you added a mailer template
- `bin/rails zeitwerk:check`

Preview a mailer in development through letter_opener_web, or say plainly that
you could not check it. Report the files added, how retries and enqueue timing
are handled, and the commands you ran.
