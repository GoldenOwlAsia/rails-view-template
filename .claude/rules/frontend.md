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
- Previews live in `spec/components/previews`, registered in
  `config/application.rb` through `config.view_component.previews.paths` and
  `.previews.default_layout` — Rails 8.1's names for what used to be
  `preview_paths` / `default_preview_layout`. `development.rb` copies both into
  Lookbook, which keeps its own settings and inherits neither.
- The preview layout is `layouts/component_preview`, and it attaches only the
  `icons` Stimulus controller. It deliberately skips the application layout's
  header, so the `theme` controller is unavailable there — its checkbox target
  lives in that header, and connecting it without one raises "Missing target
  element". A component that needs the theme toggle cannot be exercised from a
  preview as it stands.

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
- Dark mode is the `dark:` variant. `white:` is not a Tailwind variant — the
  class is dropped silently at build time, so the markup reads as styled and
  renders as nothing. `FlashComponent` carried that typo for a while; check any
  variant prefix you have not seen elsewhere in the repo.

## Stimulus (`app/frontend`)

- **Controllers register themselves.** Each namespace directory
  (`controllers/shared`, `admin`, `charts`, `application`) has an `index.js`
  that globs its own directory:

  ```js
  setupStimulus(import.meta.glob('./**/*_controller.js', { eager: true }));
  ```

  Name a file `<name>_controller.js`, drop it in the right namespace, and it is
  picked up — there is no `application.register(...)` call to add, and editing
  `index.js` is not part of adding a controller. Only touch an `index.js` when
  introducing a brand-new namespace directory, and then wire that namespace into
  the entrypoints that need it (`entrypoints/application.js` loads `shared` +
  `application`; `entrypoints/admin.js` loads `shared` + `charts` + `admin`).
- `shared` is for controllers used by both admin and public layouts; put
  admin-only ones in `admin`, chart ones in `charts`, public-only ones in
  `application`.
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
