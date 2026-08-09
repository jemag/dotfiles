#!/usr/bin/env bash
#
# mem-workspace.sh — herdr port of create-or-attach-mem-session.sh.
#
# If a workspace labeled "mem" exists, focus it. Otherwise launch the
# "mem" tmuxinator project via tmuxinator-launch.sh (which is idempotent).
#
# Depends on: herdr, tmuxinator-launch.sh on PATH or HERDR_SCRIPTS_DIR.

set -euo pipefail

herdr() { command herdr "$@"; }

MEM_LABEL="mem"

if herdr workspace list \
    | jq -e --arg l "$MEM_LABEL" \
      '.result.workspaces[] | select(.label == $l)' >/dev/null 2>&1; then
  herdr workspace focus "$(herdr workspace list \
    | jq -r --arg l "$MEM_LABEL" \
      '.result.workspaces[] | select(.label == $l) | .workspace_id' | head -1)" \
    >/dev/null
else
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  "$SCRIPT_DIR/tmuxinator-launch.sh" "$MEM_LABEL"
fi