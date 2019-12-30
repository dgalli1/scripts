#!/bin/bash

if /usr/bin/amixer -c 1 sget "Auto-Mute Mode" | grep -q "Item0: 'Disabled'";
then
    /usr/bin/amixer -c 1 sset "Auto-Mute Mode" Enabled > /dev/null
else
    /usr/bin/amixer -c 1 sset "Auto-Mute Mode" Disabled > /dev/null
fi

echo "Successfully changed Auto-Mute mode"
