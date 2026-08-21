---
name: accessibility-review
description: Audit this app's Slim views, ViewComponents and Stimulus controllers against WCAG 2.2 AA and report findings with file:line and a fix. Read-only — it never edits. Use when asked for an accessibility or a11y audit, or when keyboard navigation, screen readers, ARIA, focus order or colour contrast come up.
---

Audit: $ARGUMENTS (default: every view and component)

Report findings. Do not edit anything — the same reason `reviewer-agent` is
read-only applies here.

## No automated tool is installed

Say this plainly rather than pretending otherwise. Capybara runs on `:rack_test`
(`spec/supports/capybara.rb`), which executes no JavaScript, so axe-core,
Lighthouse and Pa11y cannot run against this app as configured. Everything below
is a static read of the markup. A finding that genuinely needs a rendered page
or a real screen reader gets reported as *unverified*, not as a pass.

## Where to look

- `app/views/**/*.slim` — layouts first (`layouts/_header`, `admin/shared/_sidebar`,
  `admin/shared/_navbar`), then forms, tables, modals
- `app/components/**/*.{rb,html.slim}` — a bug in a component repeats everywhere
  it renders
- `app/frontend/controllers/**/*_controller.js` — focus, live regions, key handlers

## What actually breaks in this stack

- **Icons.** Lucide icons render as `i data-lucide="..."` with no text. Purely
  decorative ones need `aria-hidden="true"`; an icon that *is* the button's
  label needs an `aria-label` on the button. `FlashComponent` and the navbar are
  where this recurs.
- **Flash toasts.** `FlashComponent` renders a dismissible toast. Without
  `role="status"` / `aria-live="polite"` on the container, a screen reader never
  announces it — the user submits a form and hears nothing. The dismiss button
  needs a real accessible name, not just an `×` glyph.
- **Contrast, including dark mode.** Every colour pair in the `dark:` variants
  needs 4.5:1 (3:1 for large text) — WCAG 1.4.3. Check the `dark:` half as
  carefully as the light half; it is the half nobody looks at. A class written
  with a prefix Tailwind does not know is dropped silently, so contrast that
  "looks fine in the file" may not exist in the build at all.
- **Focus visibility.** daisyUI and Tailwind resets remove default outlines.
  Every interactive element needs a visible `focus-visible:` state — WCAG 2.4.7.
- **The admin sidebar.** It is a `-translate-x-full` drawer on small screens.
  Off-canvas content that is still in the accessibility tree is reachable by
  keyboard while invisible; it needs `inert` or `hidden`, and the open state
  needs Escape-to-close and focus moved into it.
- **Turbo.** A frame or stream swap replaces DOM without moving focus, so the
  keyboard user is left on a node that no longer exists and screen readers
  announce nothing. Any replaced region needs focus managed explicitly, and
  content that updates in place needs a live region.
- **Forms.** simple_form emits labels, but check the association survives
  (`label_for` on custom wrappers), that errors are tied to their input with
  `aria-describedby`, and that required is conveyed by more than a red asterisk.
- **Semantics.** A `div` styled as a heading, a clickable `div` with no
  `button`/`role` and no keyboard handler, a table without `th scope`, headings
  that skip a level — WCAG 1.3.1 and 4.1.2.

## Report format

Group by severity, worst first. For each finding:

**Issue** → **WCAG SC** (e.g. `1.4.3 Contrast (Minimum)`) → **file:line** →
**who it blocks and how** → **the fix**, as the Slim or JS the repo would
actually contain.

- **P0** — Level A failure that blocks assistive-tech users entirely
- **P1** — Level AA failure, a significant barrier
- **P2** — best practice, or Level AAA
- **Unverified** — needs a rendered page or a real screen reader; say what you
  would check and how

Close with what already works — the existing `aria-label`s on the sidebar and
homepage links, for one — so the report is a review and not just a list.
