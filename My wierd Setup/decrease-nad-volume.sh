#!/bin/bash
mosquitto_pub -h 192.168.178.81 -m '-' -t homeassistant/nad/volume
notify-send --expire-time=1500 --urgency=normal -i audio-volume-high "NAD Volume" "Lower" -h string:nad-volume:stuff

