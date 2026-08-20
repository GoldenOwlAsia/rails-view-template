---
paths:
  - "app/mailers/**/*.rb"
  - "app/views/**/*mailer*/**/*.slim"
  - "app/views/layouts/mailer.slim"
---

# Mailers

`ApplicationMailer` sets `layout 'mailer'` and `default from:
ENV.fetch('MAILER_FROM_EMAIL', nil)`. Don't override `from` on a subclass
unless the sender genuinely needs to differ.

- Delivery method differs per environment: `letter_opener_web` in
  development (opens in-browser, nothing leaves the machine), `smtp` in
  staging and production. `default_url_options` reads `host` from
  `ENV['APP_HOST']` in all three — build links with the standard `_url`
  helpers rather than hardcoding a host.
- The mailer layout (`app/views/layouts/mailer.slim`) is bare HTML with no
  Tailwind build step behind it — email clients don't run Vite. Keep markup
  and styling inline or table-based; do not reach for `vite_stylesheet_tag`
  or a daisyUI class expecting the app's compiled CSS.
- Devise's mail templates are already copied into
  `app/views/devise/mailer/*.slim` (confirmation, reset password, unlock,
  email changed, password change) — edit those directly for copy or branding
  changes rather than reopening the gem's defaults.
- Call `.deliver_later`, not `.deliver_now`, so sending goes through Sidekiq.
  If the deliver call happens inside a model callback or a transaction, see
  the "Keep non-database work out of the block" section of
  `.claude/rules/rails-transactions.md` — mail enqueued before commit can
  reference a row that isn't visible yet.
- No dedicated mailer spec support file exists; the test environment inherits
  Rails' `:test` delivery adapter, so `ActionMailer::Base.deliveries` (or
  `spec/mailers` previews) is where a spec asserts what would have been sent.
