#!/usr/bin/env bash
# Stop hook.
#
# Runs the fast checks over files that actually changed, and blocks the turn from
# ending while any of them fail. Deliberately does NOT run the RSpec suite —
# targeted specs are the model's job, the full suite is CI's.
set -uo pipefail

cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
command -v git >/dev/null 2>&1 || exit 0
git rev-parse --git-dir >/dev/null 2>&1 || exit 0

changed=$(git status --porcelain --untracked-files=all 2>/dev/null | awk '{print $NF}')
[ -z "$changed" ] && exit 0

ruby_files=$(printf '%s\n' "$changed" | grep -E '\.(rb|rake|slim)$' || true)
js_files=$(printf '%s\n' "$changed" | grep -E '^app/frontend/.*\.js$' || true)

problems=""

if [ -n "$ruby_files" ]; then
  # --force-exclusion so files the config excludes are skipped even when named.
  if ! out=$(printf '%s\n' "$ruby_files" | xargs bundle exec rubocop --force-exclusion --no-color 2>&1); then
    problems="${problems}RuboCop failed:
$(printf '%s' "$out" | tail -30)

"
  fi
fi

if [ -n "$js_files" ]; then
  if ! out=$(yarn --silent lint 2>&1); then
    problems="${problems}ESLint failed:
$(printf '%s' "$out" | tail -20)

"
  fi
fi

# Structural Ruby changes can break autoloading without any linter noticing.
if printf '%s\n' "$changed" | grep -qE '^(app|lib)/.*\.rb$'; then
  if ! out=$(RAILS_ENV=test bin/rails zeitwerk:check 2>&1); then
    problems="${problems}zeitwerk:check failed:
$(printf '%s' "$out" | tail -20)

"
  fi
fi

if [ -n "$problems" ]; then
  jq -nc --arg reason "$problems" '{decision: "block", reason: $reason}'
  exit 0
fi

exit 0
