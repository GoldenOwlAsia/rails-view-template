---
paths:
  - "spec/**/*.rb"
---

# Specs

RSpec with `infer_spec_type_from_file_location!`, so a file's directory sets its
type — do not pass `type:` explicitly (`RSpecRails/InferredSpecType` flags it).

Support files in `spec/supports/` are auto-required. FactoryBot, shoulda-matchers,
pundit-matchers, WebMock, VCR and SimpleCov are already wired up.

- Reproduce a bug with a failing spec before fixing it whenever practical.
- Assert behaviour, not implementation.
- Build only the records the example needs. `create` hits the database; prefer
  `build` when persistence is irrelevant.
- Use `described_class` rather than repeating the class name.
- More than one expectation in an example needs `:aggregate_failures` metadata —
  that is how this project satisfies `RSpec/MultipleExpectations`, and it gives
  better failure output than splitting assertions across examples.
- Never weaken or delete a spec to make the suite green. If a spec is wrong,
  say so and explain why before changing it.
- Never write a spec that would still pass if the feature under test were
  deleted. No no-op assertions, and no asserting against a stub where the real
  behaviour is what matters.

## System specs

`spec/supports/capybara.rb` drives system specs with `:rack_test` — in-process,
no browser, transactional fixtures intact. Devise's `IntegrationHelpers` are
included for `:system` and `:request`, so `sign_in user` works.

Two things bite here:

- Vite builds assets on demand in the test environment, so `node_modules` must be
  installed or every page render fails on `vite_image_tag` / entrypoints.
- `rack_test` requests arrive as `www.example.com`. Anything that appends to
  `config.hosts` outside `development.rb` turns on host authorization for the
  test environment and every request 403s with "Blocked hosts".

`rack_test` runs no JavaScript. A spec that needs Turbo Stream or Stimulus
behaviour needs a real driver, which this project has not set up yet — say so
rather than writing a spec that silently asserts nothing.

## Policies

Authorization deserves explicit specs. A hidden UI element is not access
control; assert the policy itself.
