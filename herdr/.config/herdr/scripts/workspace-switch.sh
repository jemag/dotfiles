#!/bin/sh
herdr workspace list \
  | jq -r '.result.workspaces[] | "\(.label)\t\(.workspace_id)\t(\(.tab_count) tabs, \(.pane_count) panes)"' \
  | fzf --reverse --delimiter='\t' --with-nth=1,3 \
  | cut -f2 \
  | xargs -r herdr workspace focus
