---
paths:
  - "app/controllers/**/*.rb"
---

# Controllers

`ApplicationController` already includes `Currentable`, `Pagy::Method` and
`Pundit::Authorization`, calls `authenticate_user!` in a `before_action`, and
rescues `Pundit::NotAuthorizedError`, `ActiveRecord::RecordNotFound` and
`ActionController::RoutingError`. Do not re-add those.

- Orchestrate only: authorize, delegate the mutation to an operation and the
  read to a query, then render.
- Authorize with Pundit explicitly (`authorize`, `policy_scope`). Admin
  controllers inherit `Admin::BaseController`, which overrides both to namespace
  into `[:admin, record]` — call the plain `authorize` / `policy_scope` there and
  let the override do the namespacing.
- `Admin::BaseController` gates access with `authenticate_admin!`. Any new admin
  controller inherits it rather than rolling its own check.
- Strong parameters come from the `app/permit_params` classes
  (`UserParams.permitted_attributes`), not from inline `permit` lists.
- Do not `rescue StandardError` in a controller.
- Use `send_flash_message(message:, success:, now:)` for flashes rather than
  assigning `flash` directly.
- `only_turbo_stream_for :action` restricts an action to Turbo Frame requests;
  use it instead of hand-rolling the check.
- Preserve Turbo semantics: redirects, `data: { turbo: false }` on forms that
  need a full page load, and Turbo Stream responses where they already exist.

Note: the application layout does not render flashes — only the `devise` and
`admin` layouts do. A flash set on a page using the application layout will not
be visible.
