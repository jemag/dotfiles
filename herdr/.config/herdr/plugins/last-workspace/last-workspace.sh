#!/usr/bin/env bash
#
# last-workspace.sh — tmux `switch-client -l` and `last-window` for herdr.
#
# State in $HERDR_PLUGIN_STATE_DIR, one id per line, most recent first:
#   mru      workspace ids
#   mru-tab  tab ids (tab ids are unique across workspaces)
# Focus hooks move an id to the top, close hooks drop it. `toggle` focuses the
# newest live workspace other than the current one; `toggle-tab` does the same
# for tabs, limited to the current workspace like tmux's per-session last
# window. Nothing to toggle to -> silent no-op.
#
# Depends on: herdr, jq, flock.

set -euo pipefail

herdr() { command herdr "$@"; }

state_dir="${HERDR_PLUGIN_STATE_DIR:?}"
mru="$state_dir/mru"
mru_tab="$state_dir/mru-tab"
mkdir -p "$state_dir"
touch "$mru" "$mru_tab"

exec 9>"$mru.lock"
flock 9

# Value of key $1 in the triggering event, wherever herdr nests it.
event_field() {
  jq -r --arg k "$1" 'first(.. | objects | .[$k] // empty)' <<<"${HERDR_PLUGIN_EVENT_JSON:-}"
}

# Rewrite MRU file $1 without $2, optionally pushing $2 to the top.
mru_update() {
  local file="$1" id="$2" push="$3" tmp
  tmp="$(mktemp "$file.XXXXXX")"
  { if [[ "$push" == 1 ]]; then printf '%s\n' "$id"; fi; grep -vxF -- "$id" "$file" || true; } >"$tmp"
  mv "$tmp" "$file"
}

# Focus the newest id in MRU file $1 that is in $2 (live ids) and is not $3.
focus_newest() {
  local file="$1" live="$2" current="$3" kind="$4" id
  while read -r id; do
    [[ -z "$id" || "$id" == "$current" ]] && continue
    if grep -qxF -- "$id" <<<"$live"; then
      flock -u 9   # the focus below fires our own focused hook
      herdr "$kind" focus "$id" >/dev/null
      return 0
    fi
  done <"$file"
}

case "${1:-}" in
  focused)
    id="$(event_field workspace_id)"
    if [[ -n "$id" ]]; then mru_update "$mru" "$id" 1; fi
    ;;
  closed)
    id="$(event_field workspace_id)"
    if [[ -n "$id" ]]; then mru_update "$mru" "$id" 0; fi
    ;;
  tab-focused)
    id="$(event_field tab_id)"
    if [[ -n "$id" ]]; then mru_update "$mru_tab" "$id" 1; fi
    ;;
  tab-closed)
    id="$(event_field tab_id)"
    if [[ -n "$id" ]]; then mru_update "$mru_tab" "$id" 0; fi
    ;;
  toggle)
    list="$(herdr workspace list)"
    current="$(jq -r '.result.workspaces[] | select(.focused) | .workspace_id' <<<"$list")"
    live="$(jq -r '.result.workspaces[].workspace_id' <<<"$list")"
    focus_newest "$mru" "$live" "$current" workspace
    ;;
  toggle-tab)
    ws="$(herdr workspace list | jq -r '.result.workspaces[] | select(.focused) | .workspace_id')"
    [[ -n "$ws" ]] || exit 0
    list="$(herdr tab list --workspace "$ws")"
    current="$(jq -r '.result.tabs[] | select(.focused) | .tab_id' <<<"$list")"
    live="$(jq -r '.result.tabs[].tab_id' <<<"$list")"
    focus_newest "$mru_tab" "$live" "$current" tab
    ;;
esac
