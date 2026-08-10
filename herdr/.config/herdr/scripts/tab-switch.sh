#!/usr/bin/env bash
#
# tab-switch.sh — herdr port of fzf-tmux-window.
#
# Fuzzy-pick a tab from every workspace and focus it. A herdr tab is the
# equivalent of a tmux window, so `herdr tab list` with no --workspace filter
# is the equivalent of `tmux list-windows -a`.
#
# As in the original, the target id is carried in a hidden first column and
# fzf only displays the tab label (--with-nth=2).
#
# Usage: tab-switch.sh ["initial query"]
#
# Depends on: fzf, herdr, jq on PATH.

set -euo pipefail

herdr() { command herdr "$@"; }

TABS=$(herdr tab list)

LINE=$(jq -rn --argjson tabs "$TABS" '
  $tabs.result.tabs[]
  | [.tab_id, (.label // ("tab " + (.number | tostring)))]
  | @tsv
' | fzf --delimiter='\t' --with-nth=2 --prompt="Tab: " -1 -q "${1:-}" --reverse --height 50%) || exit 0

if [[ -z "$LINE" ]]; then
  exit 0
fi

TAB_ID=${LINE%%$'\t'*}

# tab_id is workspace-qualified ("w4:t3"), so the workspace falls out of the id.
herdr workspace focus "${TAB_ID%%:*}" >/dev/null
herdr tab focus "$TAB_ID" >/dev/null
