---
paths:
  - "db/migrate/**/*.rb"
  - "db/schema.rb"
---

# Migrations

`strong_migrations` and `good_migrations` are both active. Assume every table
can be large in a real deployment built from this template.

- Never reference an application model from a migration — `good_migrations`
  blocks it, and the model will not match the schema at that point in history.
- Adding an index to an existing table needs `disable_ddl_transaction!` plus
  `algorithm: :concurrently`. Inside `create_table` no such dance is needed.
- Split schema changes from large data backfills into separate migrations.
- Avoid table rewrites and long exclusive locks (changing a column type, adding
  a `NOT NULL` column with a default on a large table).
- Add foreign keys and database constraints where the model already promises the
  invariant. A model-level `validates ... uniqueness` without a matching unique
  index is a race, not a guarantee — `database_consistency` will report it.
- Primary keys are UUIDs. Models set `self.implicit_order_column = :created_at`
  because ordering by a UUID is arbitrary; keep that on new models.

## This template squashes history

Migration history here is intentionally collapsed into the original files rather
than appended to, because the template ships no production data. When changing
the schema, edit the original `create_table` migration, then regenerate:

```sh
rm db/schema.rb && RAILS_ENV=test bin/rails db:drop db:create db:migrate
```

This is the opposite of the rule for a deployed application — do not carry this
habit into one.

## Verify

Run these and paste the actual output — never claim one passed without running it:

- `RAILS_ENV=test bin/rails db:migrate:status` — no `NO FILE` entries
- `git diff db/schema.rb` — only the intended change, no unrelated version churn
- `bundle exec database_consistency` — exits 0
- `bin/rspec` — the suite still passes
- `bundle exec rubocop db/migrate` — migrations are linted too
