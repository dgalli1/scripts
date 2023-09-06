#!/bin/bash

dbus-monitor "interface=org.freedesktop.PowerManagement.Inhibit,member=Inhibit" |
while read -r line; do
  echo $line
  if [[ $line == *"string \"/usr/local/src/3cx/3cx-linux-x64/3cx\""* ]]; then
    notify-send -i /usr/local/src/3cx/icon.png "3CX" "Incoming Call"
  fi
done

