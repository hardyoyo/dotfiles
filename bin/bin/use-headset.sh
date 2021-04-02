#!/bin/bash

# dependency: https://github.com/deweller/switchaudio-osx

# commands for Linux
# /usr/bin/pactl set-default-sink alsa_output.usb-Logitech_Inc._Logitech_USB_Headset_H340-00.analog-stereo
# /usr/bin/pactl set-default-source alsa_input.usb-Logitech_Inc._Logitech_USB_Headset_H340-00.analog-stereo 

# commands for OSX
/usr/local/bin/switchaudiosource -s "Logitech USB Headset" -t input
/usr/local/bin/switchaudiosource -s "Logitech USB Headset" -t output

# send a notification to confirm the audio source is set correctly
CURRENT_AUDIO_INFO=$(SwitchAudioSource -c)
terminal-notifier -message "Audio i/o set to: ${CURRENT_AUDIO_INFO}"

exit 0
