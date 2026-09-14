#!/usr/bin/env bash
# Stop hook: fires when Claude is about to finish responding.
# If Scala sources changed but no 'sbt check' ran recently (we look for a marker file
# the check alias writes), remind the model to run the suite.
# Exit 2 sends stderr back to Claude and keeps it working; we only nudge once.
set -euo pipefail

payload=$(cat)
already=$(printf '%s' "$payload" | python3 -c '
import json,sys
print(json.load(sys.stdin).get("stop_hook_active", False))
' 2>/dev/null || echo False)
[ "$already" = "True" ] && exit 0

if git diff --quiet -- '*.scala' 2>/dev/null; then
  exit 0   # no Scala changes -> nothing to verify
fi

marker=".claude/.last-test-run"
if [ -f "$marker" ]; then
  changed=$(git diff --name-only -- '*.scala' | head -1)
  if [ -n "$changed" ] && [ "$marker" -nt "$changed" ]; then
    exit 0   # tests ran after the last change
  fi
fi

echo "Scala sources changed but the test suite has not run since. Run 'sbt check' and fix any failures before finishing." >&2
exit 2
