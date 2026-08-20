---
paths:
  - "app/views/**/*.slim"
  - "app/components/**/*.rb"
  - "app/components/**/*.slim"
  - "app/frontend/**/*.js"
  - "app/helpers/**/*.rb"
---

# Views and frontend

## ViewComponents (`app/components`)

- Subclass `ApplicationComponent`. The template is a sidecar file next to the
  class: `flash_component.rb` + `flash_component.html.slim`.
- `initialize` must call `super()` — ViewComponent's own constructor does real
  work, and RuboCop's `Lint/MissingSuper` will flag its absence.
- Keep the public surface to the constructor; make the rest private, including
  the methods the template calls.
- No database access from a component. Pass records in.
- Specs live in `spec/components` and use `render_inline` — the `:component` type
  is registered in `spec/supports/view_component.rb`, so do not pass `type:`.
- Tailwind scans `app/components/**` (see `tailwind.config.js`); a class used only
  in a component and not covered by that glob gets purged from the build.

Reach for a component when markup has variants or is worth testing on its own. A
one-off page stays an ordinary view.

## Slim templates

- Every view is Slim. Two linters cover them: `rubocop-slim` (a RuboCop plugin,
  runs via `bundle exec rubocop`) and `slim-lint` (`bundle exec slim-lint
  app/views`), whose RuboCop linter is deliberately disabled in `.slim-lint.yml`
  because it judges Ruby extracted out of the template.
- Keep logic out of templates. A `case` mapping a value to CSS classes or an icon
  belongs in a helper (see `FlashHelper`), not in the view — not as a chain of
  `-` control statements, and not in a `ruby:` block either.
- No database access from a view.
- Assets go through Vite: `vite_image_tag`, `vite_javascript_tag`,
  `vite_stylesheet_tag`. A missing entrypoint raises rather than degrading.
- Tailwind with daisyUI. Reuse existing component classes before adding new
  utility soup.

## Stimulus (`app/frontend`)

- Stimulus is the client-side tool here. Do not reach for React or Vue for a
  piece of interactive UI.
- Prefer Turbo (frames, streams, plain form submissions) over JavaScript. Add a
  controller only when the interaction genuinely needs one.
- One responsibility per controller; name targets and values rather than
  querying the DOM ad hoc.
- Anything registered in `connect()` — listeners, timers, observers — must be
  torn down in `disconnect()`. Turbo replaces DOM nodes on navigation, so a
  leaked listener accumulates across visits.
- Avoid global mutable state; Turbo does not reload the page between visits.

## Helpers

Helpers are the home for presentation logic pulled out of templates. Keep them
pure and give them specs — `spec/helpers` uses the `helper` object.
