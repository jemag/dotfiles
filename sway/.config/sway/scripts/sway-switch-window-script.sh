#!/usr/bin/env sh

prev_focus=$(swaymsg -r -t get_seats | jq '.[0].focus')

swaymsg -m -t subscribe '["window"]' | \
  jq --unbuffered 'select(.change == "focus").container.id' | \
  while read new_focus; do
    swaymsg "[con_id=${prev_focus}] mark --add _prev" &>/dev/null
    prev_focus=$new_focus
  done
