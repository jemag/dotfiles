#!/usr/bin/env bash
#
# last-workspace.sh — tmux `switch-client -l` for herdr.
#
# State: $HERDR_PLUGIN_STATE_DIR/mru, one workspace id per line, most recent
# first. The workspace.focused hook moves an id to the top, workspace.closed
# drops it, and the toggle action focuses the newest id after the current one
# that still exists. Nothing to toggle to -> silent no-op.
#
# Depends on: herdr, jq, flock.

set -euo pipefail

herdr() { command herdr "$@"; }

state_dir="${HERDR_PLUGIN_STATE_DIR:?}"
mru="$state_dir/mru"
mkdir -p "$state_dir"
touch "$mru"

exec 9>"$mru.lock"
flock 9

# Workspace id carried by the triggering event, wherever herdr nests it.
event_workspace_id() {
  jq -r 'first(.. | .workspace_id? // empty)' <<<"${HERDR_PLUGIN_EVENT_JSON:-}"
}

# Rewrite the MRU without $1, optionally pushing $1 to the top.
mru_update() {
  local id="$1" push="$2" tmp
  tmp="$(mktemp "$mru.XXXXXX")"
  { if [[ "$push" == 1 ]]; then printf '%s\n' "$id"; fi; grep -vxF -- "$id" "$mru" || true; } >"$tmp"
  mv "$tmp" "$mru"
}

case "${1:-}" in
  focused)
    id="$(event_workspace_id)"
    if [[ -n "$id" ]]; then mru_update "$id" 1; fi
    ;;
  closed)
    id="$(event_workspace_id)"
    if [[ -n "$id" ]]; then mru_update "$id" 0; fi
    ;;
  toggle)
    list="$(herdr workspace list)"
    current="$(jq -r '.result.workspaces[] | select(.focused) | .workspace_id' <<<"$list")"
    live="$(jq -r '.result.workspaces[].workspace_id' <<<"$list")"
    while read -r id; do
      [[ -z "$id" || "$id" == "$current" ]] && continue
      if grep -qxF -- "$id" <<<"$live"; then
        flock -u 9   # the focus below fires our own focused hook
        herdr workspace focus "$id" >/dev/null
        exit 0
      fi
    done <"$mru"
    ;;
esac
