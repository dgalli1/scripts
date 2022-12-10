
#sudo cat /dev/input/by-id/usb-SONiX_USB_DEVICE-event-kbd  
#sudo cat /dev/input/by-id/usb-Logitech_USB_Receiver-if02-event-kbd

# Execute screenlayout/tv.sh  when new input is detected from /dev/input/by-id/usb-SONiX_USB_DEVICE-event-kbd 
# Execute screenlayout/monitor.sh  when new input is detected from /dev/input/by-id/usb-Logitech_USB_Receiver-if02-event-kbd

# Detect keyboard input
sudo evtest "/dev/input/by-id/usb-Logitech_USB_Receiver-if02-event-kbd" | while read line; do
    # echo current time
    echo $(date)
    echo "tv.sh"
done
