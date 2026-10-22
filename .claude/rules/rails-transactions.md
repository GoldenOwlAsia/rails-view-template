---
paths:
  - "app/operations/**/*.rb"
  - "app/models/**/*.rb"
  - "app/jobs/**/*.rb"
  - "app/controllers/**/*.rb"
---

# Transactions

Every claim below was measured against this application on Rails 8.1, and
matches the `ActiveRecord::Transactions` documentation.

## Use one when several writes must commit as a unit

```ruby
ActiveRecord::Base.transaction do
  order = Order.create!(...)
  user.update!(balance: user.balance - product.price)
  order
end
```

That is the case a transaction is for: all of it lands, or none of it does.

## Do not wrap a single ordinary save

Rails already does it. `save` and `destroy` "come wrapped in a transaction that
ensures that whatever you do in validations or callbacks will happen under its
protected cover" — a single `User#save!` in this app emits `BEGIN` … `COMMIT` on
its own.

So an outer transaction around one `create!` or `update!` adds nothing. Note the
reason: it is redundant, *not* — as the seminar deck puts it — because "Rails
won't roll back if you don't wrap it." Rails does roll back; that is why the
extra wrapper is pointless.

## Keep non-database work out of the block

No HTTP calls, no mail delivery, no slow computation, no file uploads. They hold
locks open and they cannot be rolled back.

The `deliver_later` in the seminar's Service Object example is the trap, and it
is worse than "slow". Measured here:

```
BEGIN -> ENQUEUE(ProbeJob) -> COMMIT
```

The job is enqueued **before** the transaction commits. With a real backend like
Sidekiq a worker can pick it up in that window, query for a row that is not
visible yet, and fail — or, if the transaction later rolls back, act on a record
that never existed.

Rails 8.1 ships the fix as a class attribute, and it defaults to `false`:

```ruby
class OrderConfirmationJob < ApplicationJob
  self.enqueue_after_transaction_commit = true
end
```

With that set, the same probe gives:

```
BEGIN -> COMMIT -> ENQUEUE
```

Set it per job class, or globally with
`config.active_job.enqueue_after_transaction_commit = true`. Either way, the
shape to aim for is:

```
write -> commit -> after_commit / enqueue -> external side effect
```

`after_commit` exists for exactly this: work inside the transaction cannot see
committed state from outside the connection, so anything that has to observe the
committed row belongs after it.

## Nested transactions are not nested by default

This is sharper than the deck's "Rails uses savepoints". By default it does not.

```ruby
ActiveRecord::Base.transaction do
  User.create!(...)                       # outer
  ActiveRecord::Base.transaction do
    User.create!(...)                     # joins the SAME transaction
    raise ActiveRecord::Rollback          # silently discarded
  end
end
```

Measured: `BEGIN -> COMMIT`, and **both** users persist. The inner block is not a
separate transaction, and `ActiveRecord::Rollback` raised there does nothing —
Rails swallows that exception and there is no savepoint to roll back to.

Ask for a real sub-transaction explicitly:

```ruby
ActiveRecord::Base.transaction(requires_new: true) do
  ...
end
```

Measured: `BEGIN -> SAVEPOINT active_record_1 -> ROLLBACK TO SAVEPOINT
active_record_1 -> COMMIT`, and only the outer record persists.

If you nest at all, know which of these two you meant. Prefer not nesting.

## Operations

`ApplicationOperation` does not open a transaction for you. Open one in `#call`
when the workflow needs it, keep it to the writes, and return
`success(...)` / `failure(...)` outside or after it.

Do not rescue `StandardError` around a transaction merely to convert it into
`failure(e.message)` — that turns a bug into a quiet failure. Rescue the specific
error you expect (`ActiveRecord::RecordInvalid`, a documented API error) and let
the rest surface.
