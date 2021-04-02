#!/bin/bash

# dependency: https://github.com/deweller/switchaudio-osx

# commands for Linux
# /usr/bin/pactl set-default-sink alsa_output.usb-Logitech_Inc._Logitech_USB_Headset_H340-00.analog-stereo
# /usr/bin/pactl set-default-source alsa_input.usb-Logitech_Inc._Logitech_USB_Headset_H340-00.analog-stereo 

# commands for OSX
/usr/local/bin/switchaudiosource -s "PowerLocus" -t output
/usr/local/bin/switchaudiosource -s "PowerLocus" -t input

exit 0
