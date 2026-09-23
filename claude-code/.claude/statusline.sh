#!/usr/bin/env bash
# Status line: model | context used | session cost. Claude Code pipes session JSON on stdin.
input=$(cat)
model=$(jq -r '.model.display_name // "?"' <<<"$input")
pct=$(jq -r '.context_window.used_percentage // empty' <<<"$input")
used=$(jq -r '.context_window.total_input_tokens // empty' <<<"$input")
size=$(jq -r '.context_window.context_window_size // empty' <<<"$input")
cost=$(jq -r '.cost.total_cost_usd // empty' <<<"$input")

ctx="ctx ?"
if [ -n "$pct" ]; then
  ctx=$(printf 'ctx %.0f%%' "$pct")
  [ -n "$used" ] && [ -n "$size" ] && ctx+=$(printf ' (%dk/%dk)' $((used / 1000)) $((size / 1000)))
fi
out="$model | $ctx"
[ -n "$cost" ] && out+=$(printf ' | $%.2f' "$cost")
printf '%s' "$out"
