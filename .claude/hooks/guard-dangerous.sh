#!/usr/bin/env bash
# PreToolUse hook (matcher: Bash).
# Deterministic backstop: blocks command patterns that must never run from an agent
# context, regardless of how the model was prompted. Exit code 2 = block.
set -euo pipefail

payload=$(cat)
cmd=$(printf '%s' "$payload" | python3 -c '
import json,sys
d = json.load(sys.stdin)
print(d.get("tool_input", {}).get("command", ""))
' 2>/dev/null || true)

blocked_patterns=(
  "terraform apply"
  "terraform destroy"
  "aws neptune delete-db-cluster"
  "aws neptune delete-db-instance"
  "aws dynamodb delete-table"
  "aws emr terminate-clusters"
  "aws s3 rb "
  "aws s3 rm --recursive"
  "aws ecr delete-repository"
  "--force-delete"
  "DROP TABLE"
  "DROP DATABASE"
  "rm -rf /"
)

shopt -s nocasematch
for pat in "${blocked_patterns[@]}"; do
  if [[ "$cmd" == *"$pat"* ]]; then
    echo "Blocked by guard-dangerous hook: command matches forbidden pattern '$pat'." \
         "If this is really needed, a human must run it manually." >&2
    exit 2
  fi
done
exit 0
