---
paths:
  - "app/jobs/**/*.rb"
---

# Background jobs

`ApplicationJob` is currently an empty `ActiveJob::Base` subclass — Sidekiq is
the adapter in production and staging (`config/environments/{production,staging}.rb`),
configured with `sidekiq-unique-jobs` and `sidekiq-scheduler`
(`config/initializers/sidekiq.rb`, `config/schedule.yml`).

- Take ids, not records, as arguments. A record can be stale or gone by the
  time Sidekiq dequeues the job; re-fetch inside `#perform`.
- Jobs must be safe to run twice — Sidekiq's default retry policy re-runs a
  failed job automatically. Design `#perform` so a repeat execution is a
  no-op or converges to the same state, not an accumulation.
- Do not `rescue StandardError` broadly inside a job. `sentry-sidekiq` reports
  unhandled job errors automatically; swallowing them there hides the failure
  from Sentry as well as from Sidekiq's retry/dead-set handling. Rescue only
  the specific exception you have a plan for (e.g. `discard_on
  ActiveRecord::RecordNotFound` when the referenced record is legitimately
  gone).
- A job enqueued from inside a transaction can be picked up by a worker
  before that transaction commits and query for a row that isn't visible yet.
  Enqueue after commit — see the "Keep non-database work out of the block"
  section of `.claude/rules/rails-transactions.md`.
- Use `sidekiq-unique-jobs` (already in the middleware chain) when a job must
  not run concurrently for the same resource, rather than hand-rolling a lock.
- A recurring job goes in `config/schedule.yml` under `sidekiq-scheduler`, not
  a cron entry or a `loop`/`sleep` inside the job itself.

## Testing

No spec support file configures `ActiveJob::TestHelper` or Sidekiq's test
mode yet — before assuming `have_enqueued_job` or `Sidekiq::Testing.fake!`
works, write one spec and confirm it actually intercepts the enqueue rather
than running the job inline or hitting Redis. Say so if it doesn't, the same
way `.claude/rules/specs.md` does for the missing JS driver.
