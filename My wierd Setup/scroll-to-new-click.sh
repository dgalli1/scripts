#!/bin/bash

#!/bin/bash

# Run evtest in the background and redirect its output to a file
pkill evtest
mouseHandler=$(grep -A 4 'N: Name="Logitech M705"' /proc/bus/input/devices | grep Handlers | cut -d' ' -f2 | cut -d"=" -f2)
evtest /dev/input/$mouseHandler EV_KEY > /tmp/evtest_output &
#evtest /dev/input/by-id/usb-Logitech_USB_Receiver-if02-event-mouse EV_KEY > /tmp/evtest_output &

# Get the PID of the evtest process
evtest_pid=$!

# Set a flag to indicate whether an event has already been processed
target_time=0
while read -r line; do
  current_time=$(date +%s)
  #echo $target_time $current_time
  if [[ $current_time -gt $target_time  && $line == *"(REL_WHEEL)"* && $line == *"value -1"* ]]; then
    ydotool click 0xC0
 #   target_time=$(date -d "+0.5 seconds" +%s)
  fi
  #sleep 0.1
done < <(tail -f /tmp/evtest_output)

# Kill the evtest process when the script is stopped
kill $evtest_pid
pkill evtest
