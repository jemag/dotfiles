#!/usr/bin/env sh

if pgrep "waybar" > /dev/null; then
  killall -SIGUSR1 .waybar-wrapped
else
  killall -USR1 .waybar-wrapped
fi
