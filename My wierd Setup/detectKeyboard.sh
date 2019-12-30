kbdEvents=($(ls /dev/input/by-id | grep "usb-Logitech_USB_Receiver-if02-event-kbd"))     
for forCounter in "${kbdEvents[@]}"
do
    eventFile=$(readlink --canonicalize "/dev/input/by-path/${forCounter}")     
    echo $eventFile
done