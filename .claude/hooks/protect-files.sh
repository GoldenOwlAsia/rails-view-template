#!/usr/bin/env bash
# PreToolUse hook for Edit|Write.
#
# Blocks writes to secrets. Reads the hook payload on stdin and denies when the
# target path is a credential file. `.env.sample` is explicitly allowed: it is
# the file to update when a new variable is introduced.
set -uo pipefail

payload=$(cat)
path=$(printf '%s' "$payload" | jq -r '.tool_input.file_path // empty')

[ -z "$path" ] && exit 0

base=$(basename "$path")

# Allowed: sample/example files carry no real values.
case "$base" in
  .env.sample|.env.example|*.key.sample) exit 0 ;;
esac

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

case "$base" in
  .env|.env.*)
    deny "Refusing to write $base: it holds real credentials. Update .env.sample instead and tell the user which variable to set." ;;
  master.key|*.pem)
    deny "Refusing to write $base: this is a private key." ;;
  *.key)
    deny "Refusing to write $base: this looks like a key file." ;;
esac

case "$path" in
  */config/credentials/*)
    deny "Refusing to write inside config/credentials: use bin/rails credentials:edit." ;;
esac

exit 0
