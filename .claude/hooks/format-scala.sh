#!/usr/bin/env bash
# PostToolUse hook (matcher: Edit|Write).
# After any source file is written or edited, run scalafmt on it so the repo stays
# consistently formatted. Exit 0 always — formatting is advisory at edit time; the
# check alias enforces it in CI.
set -euo pipefail

payload=$(cat)
file=$(printf '%s' "$payload" | python3 -c '
import json,sys
d = json.load(sys.stdin)
print(d.get("tool_input", {}).get("path", ""))
' 2>/dev/null || true)

if [[ "$file" == *.scala ]]; then
  if command -v sbt &>/dev/null; then
    sbt "scalafmtCheck" 2>/dev/null || sbt "scalafmt" 2>/dev/null || true
  fi
fi
exit 0
