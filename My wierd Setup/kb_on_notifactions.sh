#!/bin/bash

interface=org.freedesktop.Notifications
member=Notify

# method call time=1649956562.950745 sender=:1.123 -> destination=:1.24 serial=7 path=/org/freedesktop/Notifications; interface=org.freedesktop.Notifications; member=Notify
#    string "notify-send"
#    uint32 0
#    string "dialog-information"
#    string "Hello world!"
#    string "This is an example notification."
#    array [
#    ]
#    array [
#       dict entry(
#          string "urgency"
#          variant             byte 1
#       )
#    ]
# 

# listen for playingUriChanged DBus events,
# each time we enter the loop, we just got an event
# so handle the event, e.g. by printing the artist and title
# see rhythmbox-client --print-playing-format for more output options

dbus-monitor --profile "interface='$interface',member='$member'" |
while read -r line; do
  sudo rgb_keyboard --brightness 3 --speed 3 --color ff0000 --leds fixed
done
