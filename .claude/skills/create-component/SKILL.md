---
name: create-component
description: Add a ViewComponent to this Rails app — class, sidecar Slim template, Lookbook preview and spec. Use when markup gains variants, or is worth rendering and testing on its own, rather than staying a partial or a helper.
---

Component: $ARGUMENTS

If this is one piece of a feature you are also building, use
`implement-feature`, which sequences the layers around it.

## 1. Check it should be a component at all

A component earns its place once the markup has variants or is worth testing on
its own. A one-off page stays an ordinary view; presentation logic that returns
no markup belongs in a helper or a presenter. Read the closest existing one
before designing a new one — `flash_component.rb` (variants selected through
frozen constant lookup), `breadcrumb_component.rb`, `stat_tile_component.rb`.

## 2. Four files, three directories

| File | Notes |
| --- | --- |
| `app/components/x_component.rb` | subclass `ApplicationComponent`; `initialize` must call `super()` |
| `app/components/x_component.html.slim` | sidecar, beside the class |
| `spec/components/previews/x_component_preview.rb` | one method per variant; a variant needing its own markup gets `spec/components/previews/x_component_preview/<method>.html.slim` |
| `spec/components/x_component_spec.rb` | `render_inline`, never pass `type:` |

The preview is the file that gets skipped. It is how anyone looks at the
component at `/lookbook` without booting the page that uses it, and
`config.view_component.previews.paths` already points at that directory.

## 3. Constraints that bite on a first component

`.claude/rules/frontend.md` auto-loads when you open any of these files and
holds the full set. Three that are invisible until they bite:

- The preview layout attaches only the `icons` Stimulus controller — not
  `theme`, whose target lives in a header the layout does not render. A
  component depending on the theme toggle cannot be previewed as it stands.
- `dark:` is the dark-mode variant. `white:` is not a Tailwind variant at all;
  the class is dropped silently, so the markup reads as styled and renders as
  nothing.
- Tailwind scans `app/components/**`, so a class that appears only outside that
  glob is purged from the build.

## 4. Verify

RuboCop (which covers `.slim` through `rubocop-slim`) and `zeitwerk:check` run
in the Stop hook. Yours to run and paste:

- `bin/rspec spec/components/x_component_spec.rb`
- `bundle exec slim-lint app/components`
- the preview at `/lookbook` — confirm it renders, or say plainly that you could
  not check it
