---
name: create-operation
description: Add an Operation (app/operations) for a business workflow — several writes, several collaborators, or a sequence someone has to be able to read — returning success(...) / failure(...) via Responseable, with a spec. Use whenever the user wants a service object, a use case, "a class that does X then Y", or logic is outgrowing a controller action or a model callback. Not for a single Model.create or update (that stays on the model), not for reads (a query object), and not when the operation is one layer of a larger feature — implement-feature sequences that.
---

Operation: $ARGUMENTS

If this is one piece of a feature you are also building, use
`implement-feature`. If the work is a read (filters, sorting, reports), it is a
query object, not an operation — use `create-query`. This repo has no `app/services`; do not create one.

## 1. Check it earns an operation

An operation is a *workflow*: several writes, several collaborators, or a
sequence worth reading top to bottom. Line count is not the test — a long
method about one record's own state belongs on the model, and a short method
coordinating three objects belongs here. An operation that only wraps
`Model.create(...)` or `model.update(...)` is noise; say so and stop.

Then look for what exists: `app/operations/` for a sibling to copy, and the
sample at the top of `application_operation.rb` for the shape. Note that no
controller calls an operation yet, so you may be setting the first call-site
pattern — keep it the obvious one (`Users::Create.call(params)`, then branch on
`success?`).

## 2. Shape

- Namespace by resource, name with a verb: `Users::Create`, never
  `Users::Creator`. File at `app/operations/users/create.rb`.
- Subclass `ApplicationOperation`. `spec/architecture_spec.rb` fails the suite
  for an operation that does not, because it would lose `Responseable`.
- Collaborators come through `initialize` with defaults (`def initialize(user =
  User.new)`); the work is the instance method `#call`. The class method `.call`
  just builds an instance and forwards to it.
- Return `success(record)` or `success(user:, token:)` when the caller needs
  several values — a non-Hash is keyed by its class name, a Hash becomes a
  `Data` object so `response.user` works. Return `failure(errors)`. Do not
  invent a second response shape.

## 3. The decisions that go wrong

- **Transaction.** Open one in `#call` only if several writes must land
  together, and keep it to the writes. `ApplicationOperation` does not open one
  for you, and one `save!` is already transactional.
- **Rescue narrowly.** The sample in `application_operation.rb` ends with
  `rescue StandardError => e; failure(e.message)`. Do not copy that line: it
  turns a programming error into a quiet failure, and the architecture spec
  bans a blanket rescue. Rescue the error you expect —
  `ActiveRecord::RecordInvalid`, a documented API error — and let the rest
  raise.
- **Mail and jobs.** Sending mail or enqueuing a job is a workflow, so it lives
  here and never in a model or callback (the architecture spec checks the
  models). Do it *after* the transaction block, not inside it: a job enqueued
  before commit can run before its row is visible. Full measurements in
  `.claude/rules/rails-transactions.md`.
- **Authorization** stays in the controller (`authorize`), not the operation.

## 4. Spec

`spec/operations/users/create_spec.rb` (RSpec infers the type from the path; do
not pass `type:`). `spec/operations` does not exist yet — create it. Cover:
success returns the data the caller reads, a failure returns `failure?` with
errors, and — for a multi-write operation — that nothing persisted when the
second write fails. A spec that still passes if the operation were deleted
proves nothing. Follow `.claude/rules/specs.md`.

## 5. Verify

Yours to run and paste:

- `bin/rspec spec/operations spec/architecture_spec.rb`
- `bundle exec rubocop app/operations spec/operations`
- `bin/rails zeitwerk:check` (a new constant was added)

Report the files added, the transaction and rescue decisions you made and why,
and the commands you ran.
