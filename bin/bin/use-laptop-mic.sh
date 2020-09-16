#!/bin/bash

# commands for Linux
# /usr/bin/pactl set-default-sink alsa_output.usb-Logitech_Inc._Logitech_USB_Headset_H340-00.analog-stereo
# /usr/bin/pactl set-default-source alsa_input.usb-Logitech_Inc._Logitech_USB_Headset_H340-00.analog-stereo 

# commands for OSX
/usr/local/bin/switchaudiosource -s "MacBook Pro Microphone" -t input

exit 0
