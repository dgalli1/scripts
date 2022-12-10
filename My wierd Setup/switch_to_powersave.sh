#!/bin/bash
sudo cpupower frequency-set -g powersave
cd "/sys/devices/pci0000:00/0000:00:01.1/0000:01:00.0/0000:02:00.0/0000:03:00.0/hwmon"
find . -name "power1_cap" -print0 | while read -d $'\0' file
do
    echo 100000000 > "$file"
done