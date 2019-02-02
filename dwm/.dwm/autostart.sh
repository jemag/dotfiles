#! /bin/bash

dte(){
  dte="$(date +"%Y-%m-%d %l:%M%p")"
  echo -e " $dte"
}

mem(){
  mem=`free | awk '/Mem/ {printf "%d MiB/%d MiB\n", $3 / 1024.0, $2 / 1024.0 }'`
  echo -e " $mem"
}

cpu(){
  read cpu a b c previdle rest < /proc/stat
  prevtotal=$((a+b+c+previdle))
  sleep 0.5
  read cpu a b c idle rest < /proc/stat
  total=$((a+b+c+idle))
  cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
  echo -e " $cpu% cpu"
}

while true; do
     xsetroot -name "$(cpu) | $(mem) | $(dte)"
     sleep 5s    # Update time every ten seconds
done &
