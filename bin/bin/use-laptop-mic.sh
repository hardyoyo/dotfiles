#!/bin/bash

# dependency: https://github.com/deweller/switchaudio-osx

# commands for Linux
# /usr/bin/pactl set-default-sink alsa_output.usb-Logitech_Inc._Logitech_USB_Headset_H340-00.analog-stereo
# /usr/bin/pactl set-default-source alsa_input.usb-Logitech_Inc._Logitech_USB_Headset_H340-00.analog-stereo 

# commands for OSX
/usr/local/bin/switchaudiosource -s "MacBook Pro Microphone" -t input

# send a notification to confirm the audio source is set correctly
notify-which-audio-selected.sh

exit 0
