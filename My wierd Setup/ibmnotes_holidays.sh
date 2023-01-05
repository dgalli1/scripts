#!/bin/bash
sleep 3
while true; do
  # Press the Down arrow key
  xdotool keydown Down
  xdotool keyup Down

  # Press the Enter key
  xdotool keydown Return
  xdotool keyup Return

  # Sleep for 1 second
  sleep 1

  # Press the Right arrow key 8 times
  for i in {1..8}; do
    xdotool keydown Right
    xdotool keyup Right
  done

  # Write the text "Holiday"
  xdotool type "Holiday"

  # Press the Right arrow key
  xdotool keydown Right
  xdotool keyup Right

  # Write the text "Holiday"
  xdotool type "Holiday"

  # Press the Escape key
  xdotool keydown Escape
  xdotool keyup Escape

  # Press the Enter key
  xdotool keydown Return
  xdotool keyup Return

  # Sleep for 1 second
  sleep 1
done
