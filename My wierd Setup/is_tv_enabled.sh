#!/bin/bash

if kscreen-doctor --outputs | grep "HDMI-A-1" | grep -q "enabled"; then
    mosquitto_pub -h 192.168.178.81 -p 1883 -t homeassistant/sensor/computer_buero_monitor/state -m tv
else
    mosquitto_pub -h 192.168.178.81 -p 1883 -t homeassistant/sensor/computer_buero_monitor/state -m multi
fi
