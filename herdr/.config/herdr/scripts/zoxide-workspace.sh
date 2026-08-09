#!/usr/bin/env bash
#
# zoxide-workspace.sh — herdr port of fzf-tmux-session.
#
# Fuzzy-pick a directory from `zoxide query -l` and create-or-focus a
# workspace for it. The workspace is labeled with the directory's basename
# and rooted at the directory.
#
# Usage: zoxide-workspace.sh ["initial query"]
#
# Depends on: zoxide, fzf, herdr, jq on PATH.

set -euo pipefail

herdr() { command herdr "$@"; }

SELECTED_DIR=$(zoxide query -l | fzf --prompt="Project: " -m -1 -q "${1:-}" --reverse --height 50%)
if [[ -z "$SELECTED_DIR" ]]; then
  exit 0
fi

LABEL=$(basename "$SELECTED_DIR")

EXISTING=$(herdr workspace list | jq -r --arg l "$LABEL" \
  '.result.workspaces[] | select(.label == $l) | .workspace_id' | head -1)

if [[ -n "$EXISTING" ]]; then
  herdr workspace focus "$EXISTING" >/dev/null
else
  NEW=$(herdr workspace create --cwd "$SELECTED_DIR" --label "$LABEL" --no-focus)
  herdr workspace focus "$(jq -r '.result.workspace.workspace_id' <<<"$NEW")" >/dev/null
fi