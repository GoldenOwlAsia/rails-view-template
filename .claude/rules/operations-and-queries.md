---
paths:
  - "app/operations/**/*.rb"
  - "app/queries/**/*.rb"
  - "app/presenters/**/*.rb"
---

# Operations, queries, presenters

## Operations (`app/operations`)

- Subclass `ApplicationOperation`. It provides `self.call(...)` which forwards to
  a new instance's `#call`, so define `#call` as an instance method.
- Return `success(data)` or `failure(errors)` — both come from `Responseable`.
- `success` normalizes a non-Hash argument to `{ classname: value }` and wraps
  Hashes in a `Data` object, so `response.user` works. Pass a Hash when the
  caller needs several values: `success(user:, token:)`.
- Callers use `success?` / `failure?` / `data` / `errors`, or chain
  `.on_success { }.on_failure { }`. Do not invent a second response shape.
- Wrap multi-write workflows in `ActiveRecord::Base.transaction`.
- Rescue narrowly. `rescue StandardError => e; failure(e.message)` at the top of
  an operation hides programming errors — only do it where the failure is
  genuinely expected and the message is useful to the caller.
- Do not move plain model persistence into an operation just to have one.

## Queries (`app/queries`)

- Subclass `ApplicationQuery`. Define `#call(scope = Model.all, **params)`.
- Use the inherited `filter(scope, :method_name, value)` helper — it skips the
  filter when the value is blank — and `sort(scope, params[:sort])`, which
  understands `+column` / `-column` prefixes.
- Return an `ActiveRecord::Relation` so callers can compose and paginate.
- Never mutate records from a query.
- Do not copy the `return self if value.blank?` idiom from the seminar's Query
  Object slide. It works there only because `relation.extending(Filterable)`
  mixes the module into the relation, so `self` is the relation. In a method on
  the query object, `self` is the query object and there is no `where`. Here the
  blank check is already handled by `filter`, so the method body is simply
  `scope.where(...)`.
- Whitelist any sort column that comes from user input. `sort` passes the value
  into `order(column => direction)`; Rails 8.1 refuses an unknown column with
  `ActiveRecord::UnknownAttributeReference`, so this is not an injection hole —
  but it is an unhandled exception, and `?sort=whatever` will 500 the request.
  Check the value against a permitted list and ignore or reject anything else.
- Never interpolate user input into SQL.
- Choose `includes` / `preload` / `joins` based on how the caller consumes the
  result; do not add `includes` reflexively. Bullet is enabled in development
  and will flag real N+1s.

## Presenters (`app/presenters`)

- Presenters shape data for a view. No writes, no authorization decisions.
- Keep database access out of the presenter when the caller can pass the records
  in.
