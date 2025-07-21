#!/bin/bash
sleep 3
while true; do
  # Press the Down arrow key
  ydotool key 108:1
  ydotool key 108:0
  sleep 0.1

  # Press the Enter key
  ydotool key 28:1
  ydotool key 28:0
  sleep 0.1

  # Sleep for 1 second
  sleep 1

  # Press the Right arrow key 8 times
  for i in {1..8}; do
    ydotool key 106:1
    ydotool key 106:0
    sleep 0.1
  done

  # Write the text "Holiday"
  ydotool type "Holidaz"
  sleep 0.1

  # Press the Right arrow key
  ydotool key 106:1
  ydotool key 106:0
  sleep 0.1

  # Write the text "Holiday"
  ydotool type "Holidaz"
  sleep 0.1

  # Press the Escape key
  ydotool key 1:1
  ydotool key 1:0
  sleep 0.1

  # Press the Enter key
  ydotool key 28:1
  ydotool key 28:0
  sleep 0.1

  # Sleep for 1 second
  sleep 1
done
