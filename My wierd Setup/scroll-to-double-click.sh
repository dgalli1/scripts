#!/bin/bash

#!/bin/bash

# Run evtest in the background and redirect its output to a file
sudo evtest /dev/input/by-id/usb-Logitech_USB_Receiver-if02-event-mouse EV_KEY > /tmp/evtest_output &

# Get the PID of the evtest process
evtest_pid=$!

# Set a flag to indicate whether an event has already been processed
event_processed=false

# Listen to the evtest output and print "dsffs" when the REL_WHEEL event occurs with value -1
while read -r line; do
  if [[ $line == *"REL_WHEEL"* && $line == *"value -1"* && $event_processed == false ]]; then
    ydotool click 0xC0
    sleep 0.02
    ydotool click 0xC0
    sleep 0.1 # Add a delay of .1 second to prevent multiple events from triggering the same action
    event_processed=true
  else
    event_processed=false
  fi
done < <(tail -f /tmp/evtest_output)

# Kill the evtest process when the script is stopped
kill $evtest_pid
