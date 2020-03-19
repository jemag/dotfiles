#!/bin/bash

xdopath=$(which xdo)
if [ $? -ne 0 ]; then
	echo "Cannot find \`xdo\` command." 1>&2
	exit 1
fi

ids=$(xdo id -N "Polybar")

SAVEIFS=$IFS   # Save current IFS
IFS=$'\n'      # Change IFS to new line
ids=($ids) # split to array $names
IFS=$SAVEIFS   # Restore IFS


for (( i=0; i<1; i++ ))
  do
    if xprop -id ${ids[$i]}| grep -q "Normal"; then
      xdo hide -N "Polybar"
    else
      xdo show -N "Polybar"
    fi
    # echo "$i: ${names[$i]}"
  done
