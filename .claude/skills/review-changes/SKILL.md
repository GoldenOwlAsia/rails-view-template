---
name: review-changes
description: Review the current diff against this project's Rails conventions, looking for real defects rather than style. Use before opening a PR or when asked to review work.
---

Review the diff. Default to `git diff` plus staged and untracked changes; if
$ARGUMENTS names a branch, commit range or path, review that instead.

Do not modify code unless explicitly asked. Report findings.

For a diff that touches migrations/schema or auth/exposure, dispatch
`reviewer-agent` (read-only) and fold its findings into this review, rather
than re-deriving items 2–4 and 8 below from scratch — it holds the fuller,
independently-maintained version of those checks. Do the full list yourself
for a smaller diff or when those areas aren't touched.

## What to look for, in priority order

1. **Correctness** — does it do what it claims, including the edge cases the
   diff itself introduces.
2. **Authorization** — full checklist in `.claude/agents/reviewer-agent.md`'s
   Security → Authorization section; at minimum, check every new action/route
   has an explicit `authorize`/`policy_scope` call.
3. **Model/database mismatch** — full checklist in
   `.claude/agents/reviewer-agent.md`'s Database → "Model/schema agreement"
   section. `bundle exec database_consistency` is the mechanical check.
4. **Migration safety** — full checklist in `.claude/agents/reviewer-agent.md`'s
   Database → "Migration safety" section.
5. **N+1 and query shape** — `includes`/`preload`/`joins` matching how the result
   is actually consumed.
6. **Background jobs** — is the job idempotent, does it take ids rather than
   serialized records, what happens on retry.
7. **Turbo and Stimulus lifecycle** — listeners or timers set up in `connect()`
   without teardown in `disconnect()`; a Turbo Stream target that does not exist;
   a form needing `data: { turbo: false }`.
8. **Environment configuration** — full checklist in
   `.claude/agents/reviewer-agent.md`'s Security → "Environment config" section.
9. **Tests** — behaviour not covered, a spec that would pass with the feature
   removed, a weakened assertion, a deleted spec.
10. **Dead or duplicated code** — including a second implementation of something
    `app/operations` or `app/queries` already does.

## Rules

- Report real defects. Skip style that RuboCop, slim-lint and ESLint already
  enforce — they run in CI.
- For each finding: file:line, what breaks, and the concrete input or sequence
  that triggers it. If you cannot describe how it fails, it is a question, not a
  finding — label it as such.
- Say plainly when the diff is clean.
