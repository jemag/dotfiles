#!/bin/sh
#xrandr --addmode VGA-1 1920x975
#xrandr --addmode VGA-2 1920x975
xrandr --output VGA-1 --primary --mode 1920x975 --pos 1920x0 --rotate normal --output VGA-2 --mode 1920x975 --pos 0x0 --rotate normal
