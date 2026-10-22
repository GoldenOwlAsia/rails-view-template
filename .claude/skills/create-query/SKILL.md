---
name: create-query
description: Add a Query object (app/queries) for a complex or dynamic read — filters, sorting, search, reports, a dashboard list — built on ApplicationQuery's filter/sort helpers and returning a relation, with a spec. Use whenever the user wants a filterable or sortable index, a search box, a report, or the same ActiveRecord chain is being repeated across controllers or views. Not for writes (an operation), not for display formatting (a presenter), and not when the query is one layer of a larger feature — implement-feature sequences that.
---

Query: $ARGUMENTS

If this is one piece of a feature you are also building, use
`implement-feature`. A read that changes data is an operation
(`create-operation`); a read only shaped for display is a presenter. The full
convention is in `.claude/rules/operations-and-queries.md`, which auto-loads
when you open a query file.

## 1. Check it earns a query

A query object is for a read that is complex or dynamic: several optional
filters, user-chosen sorting, joins, a report. One fixed `where` belongs as a
scope on the model. Two controllers repeating the same chain is the sign to
extract. Read `app/queries/users/gather.rb` and its spec first — it is the
whole pattern.

## 2. Shape

- Namespace by resource, named for the read: `Products::Gather`. File at
  `app/queries/products/gather.rb`. Subclass `ApplicationQuery`
  (`spec/architecture_spec.rb` fails the suite otherwise).
- `def call(scope = Model.all, **params)` — a default scope, so a caller can
  pass `Product.on_sale` and compose.
- One private method per filter, taking `(scope, value)` and returning a
  relation. Register it with `filter(scope, :by_term, params[:term])`, which
  already skips blank values; then `sort(scope, params[:sort])`.
- Return an `ActiveRecord::Relation` so the caller can paginate (Pagy) and
  compose. Never mutate records from a query.

## 3. The traps

- **Do not copy the seminar's `return self if value.blank?`.** It works on the
  slide only because the module is mixed into the relation. In a method on the
  query object `self` is the query, which has no `where`; that is exactly how
  `Users::Gather` once raised `ArgumentError` on every non-blank email. The
  blank check is already in `filter`, so a filter body is just `scope.where(...)`.
- **`sort` is not whitelisted.** It passes `?sort=whatever` straight into
  `order(column => direction)`; Rails refuses an unknown column with
  `ActiveRecord::UnknownAttributeReference`, so there is no SQL injection, but
  the request still 500s. Check the column against a permitted list before
  calling `sort`, and ignore or reject the rest.
- **Never interpolate user input into SQL.** Use placeholders:
  `scope.where('name ILIKE ?', "%#{term}%")`. Escape `%` and `_` with
  `sanitize_sql_like` if the term should match literally.
- **Ordering.** Primary keys are random UUIDv4 and no model sets
  `implicit_order_column`, so an unordered query paginates unreliably. If order
  matters, order explicitly, with a unique tiebreaker such as `:id`.
- **Eager loading.** Choose `includes` / `preload` / `joins` for how the caller
  uses the result; do not add `includes` reflexively. Bullet runs in
  development and flags real N+1s.
- **Queries do not run in templates or components** — the architecture spec
  checks for `.where(` / `.find_by` / `.pluck(` there. Load in the controller or
  a presenter and pass the result in.

## 4. Spec

`spec/queries/products/gather_spec.rb` (type inferred from the path; do not pass
`type:`). `spec/queries/users/gather_spec.rb` is the template: returns a
relation, returns everything with no filter, each filter narrows, a blank
filter is ignored, sorting asc and desc, and it composes onto a passed scope. Add
a case for an unpermitted sort column. A filter spec that passes with the filter
deleted proves nothing — make sure a non-matching record is excluded. Follow
`.claude/rules/specs.md`.

## 5. Wire it up

A query with no caller and no spec is where contract bugs hide, and
`Users::Gather` currently has no controller caller. Call it from the controller
(`Products::Gather.call(policy_scope(Product), **params)`) so authorization
scoping is applied *before* filtering, then paginate.

## 6. Verify

Yours to run and paste:

- `bin/rspec spec/queries spec/architecture_spec.rb`
- `bundle exec rubocop app/queries spec/queries`
- `bin/rails zeitwerk:check`

Report the files added, which filters and sort columns are allowed, how
ordering and eager loading were decided, and the commands you ran.
