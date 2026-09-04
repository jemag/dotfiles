#!/usr/bin/env bash
# Regenerate the Claude Code subagent files from the shared prose bodies.
#
# Shared bodies live in agents/<name>.md (no frontmatter). opencode's copies in
# opencode/.config/opencode/agents/ pull them in with `{file:...}`; Claude Code
# subagent files have no include mechanism, so claude/agents/<name>.md is
# frontmatter + a generated copy of the body. Run this after editing any body.
#
# Usage: ./sync-claude-agents.sh [--check]
set -euo pipefail
cd "$(dirname "$0")"

check=false
[[ ${1-} == "--check" ]] && check=true

status=0
for f in claude/agents/*.md; do
  name="$(basename "$f" .md)"
  body="agents/$name.md"
  [[ -f $body ]] || { echo "no shared body for $name"; status=1; continue; }

  # Keep everything up to and including the generated-copy notice, replace the rest.
  head -n 9 "$f" >"$f.tmp"
  printf '\n' >>"$f.tmp"
  cat "$body" >>"$f.tmp"

  if $check; then
    if cmp -s "$f" "$f.tmp"; then
      echo "in sync: $name"
    else
      echo "OUT OF SYNC: $name (run $0)"
      status=1
    fi
    rm -f "$f.tmp"
  else
    mv "$f.tmp" "$f"
    echo "synced: $name"
  fi
done
exit $status
