---
paths:
  - "app/policies/**/*.rb"
  - "config/environments/*.rb"
  - "config/application.rb"
  - "config/initializers/**/*.rb"
  - "config/routes/**/*.rb"
---

# Authorization and environment configuration

## Authorization

- Pundit is the authorization layer. Authorize explicitly; a hidden button is
  not a control.
- Admin policies live under `app/policies/admin` and are reached through
  `Admin::BaseController`'s namespaced `authorize` / `policy_scope`.
- Scope collections with `policy_scope` whenever visibility depends on the actor.
- Roles come from rolify (`super_admin?`, `admin?`, `employee?` on `User`).
  `config/routes/system.rb` gates Sidekiq Web behind `super_admin`; any new
  operational endpoint mounted there needs the same treatment.

## Environment configuration

These have each caused a real outage or broken suite in this repository — check
them when touching config.

- **`config.hosts`**: Rails pre-populates it only in development. Appending to it
  from `config/application.rb` therefore switches host authorization *on* in
  test, staging and production with that one entry as the entire allow-list,
  which 403s every real request. Host entries belong in the per-environment file.
- **`web-console`**: the gem aborts boot in any non-development environment
  unless `config.web_console.development_only = false`. It is scoped to
  `groups: %i[development staging]` in the Gemfile so production and test never
  load it, and only `staging.rb` sets the flag. Do not move it back to the
  top level — it executes arbitrary Ruby. `staging.rb` also scopes it by CIDR:
  `config.web_console.permissions = ENV.fetch('WEB_CONSOLE_CIDR', '10.0.0.0/8')`.
  Widening that to `0.0.0.0/0` hands a REPL running inside the app process to
  anyone who can reach an error page, on data that is usually production-shaped.
- **Sentry**: sample rates read from `SENTRY_TRACES_SAMPLE_RATE` /
  `SENTRY_PROFILES_SAMPLE_RATE`, defaulting to 0.1. Do not hardcode 1.0 or add a
  `traces_sampler` that returns `true` unconditionally.
- **Rack::Attack**: `config/initializers/rack_attack.rb` throttles overall
  request rate and login attempts by IP and by email. The gem's railtie inserts
  the middleware itself. Three things in that file are load-bearing. Counters go
  to Redis via `Rack::Attack.cache.store`, not the default `Rails.cache`, which
  is `:memory_store` here and would make every limit per-Puma-worker and reset
  it on deploy. `/up` is safelisted so the load balancer's health poll does not
  spend the `req/ip` budget and then read its own 429 as a dead instance. And a
  throttle that reads `req.params` must check path and verb first — touching
  `params` parses the request body of every request that reaches it.

## Secrets

Never read, write, or print `.env`, `config/master.key`, `config/credentials/*.key`,
or any `*.pem` / `*.key`. A `PreToolUse` hook blocks writes to these; do not
attempt to work around it. `.env.sample` is the file to update when a new
variable is introduced.
