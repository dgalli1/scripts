#!/usr/bin/env bash

# Get a list of all input devices
input_devices=$(find /dev/input -type c)

# Create an array to store the keyboard devices and their names
declare -A keyboard_devices

# Iterate over the input devices and find the keyboard devices
for device in $input_devices; do
  # Check if the device is a keyboard by checking if it has an "event" file
  if [[ -e "$device/event" ]]; then
    # Get the device name by reading the "name" file in the device directory
    name=$(cat "$device/name")
    keyboard_devices["$device"]="$name"
  fi
done

# Wait for keyboard events
while true; do
  # Iterate over the keyboard devices and read their events
  for device in "${!keyboard_devices[@]}"; do
    # Read the events from the device
    events=$(cat "$device/event")

    # Parse the events and print the name of the keyboard that generated the event
    if [[ -n "$events" ]]; then
      name="${keyboard_devices[$device]}"
      echo "Keyboard '$name' generated events: $events"
    fi
  done
done
