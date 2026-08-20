#!/usr/bin/env bash
# PreToolUse hook for Bash.
#
# Permission rules match on a command *prefix*, so `bin/rails db:drop` is caught
# by a deny rule but `RAILS_ENV=x bin/rails db:drop` is not — the prefix is the
# variable assignment. This hook matches anywhere in the command string, which
# closes that gap for the handful of commands that are actually destructive here.
set -uo pipefail

payload=$(cat)
cmd=$(printf '%s' "$payload" | jq -r '.tool_input.command // empty')

[ -z "$cmd" ] && exit 0

deny() {
  jq -nc --arg reason "$1" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: $reason
    }
  }'
  exit 0
}

# Anything aimed at production.
if printf '%s' "$cmd" | grep -qE 'RAILS_ENV=["'"'"']?production'; then
  deny "Refusing to run a command with RAILS_ENV=production."
fi
if printf '%s' "$cmd" | grep -qE 'DATABASE_URL=[^ ]*production'; then
  deny "Refusing to run a command against a production DATABASE_URL."
fi

# Destructive database tasks. The development database in this workspace is not
# disposable; the test database is rebuilt explicitly by the migration workflow.
if printf '%s' "$cmd" | grep -qE '(rails|rake)[^|;&]*db:(drop|reset|purge)'; then
  if ! printf '%s' "$cmd" | grep -qE 'RAILS_ENV=["'"'"']?test'; then
    deny "Refusing to run a destructive db task outside RAILS_ENV=test. If the test database really needs rebuilding, prefix the command with RAILS_ENV=test; otherwise ask the user first."
  fi
fi

# Committing and pushing are the user's to do, always.
#
# The pattern anchors on a command boundary (start of line, or after ; & | &&)
# and skips leading git flags, so `git -C dir commit`, `git -c k=v push` and
# `git add . && git commit` are all caught, while `git log --grep=commit` is not.
git_subcommand='(^|[;&|][;&|]?)[[:space:]]*git[[:space:]]+((-[Cc][[:space:]]+[^[:space:]]+|--?[^[:space:]]+)[[:space:]]+)*'

if printf '%s' "$cmd" | grep -qE "${git_subcommand}commit\b"; then
  deny "Refusing to run git commit. Committing is the user's decision — describe the change and let them commit it."
fi
if printf '%s' "$cmd" | grep -qE "${git_subcommand}push\b"; then
  deny "Refusing to run git push. Publishing is the user's decision."
fi
if printf '%s' "$cmd" | grep -qE 'git[^|;&]*reset[^|;&]*--hard'; then
  deny "Refusing to run git reset --hard: it discards uncommitted work. Stash instead, or ask the user."
fi
if printf '%s' "$cmd" | grep -qE 'git[^|;&]*clean[^|;&]*-[a-z]*f'; then
  deny "Refusing to run git clean -f: it deletes untracked files. Ask the user first."
fi

exit 0
