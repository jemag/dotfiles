#!/bin/sh

getDefaultSink() {
    defaultSink=$(pactl info | awk -F : '/Default Sink:/{print $2}')
    description=$(pactl list sinks | sed -n "/${defaultSink}/,/Description/s/^\s*Description: \(.*\)/\1/p")
    echo "${description}"
}

VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | awk -F / '{print $2}' | awk '{$1=$1;print}')
SINK=$(getDefaultSink)

case $1 in
    "--up")
        pactl set-sink-volume @DEFAULT_SINK@ +3%
        ;;
    "--down")
        pactl set-sink-volume @DEFAULT_SINK@ -3%
        ;;
    "--mute")
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        ;;
    *)
        echo "|${SINK}:${VOLUME}|"
esac
