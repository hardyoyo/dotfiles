#!/bin/bash

# dependency: https://github.com/deweller/switchaudio-osx

#Default Sink: alsa_output.pci-0000_00_1f.3.analog-stereo
#Default Source: alsa_input.pci-0000_00_1f.3.analog-stereo

# commands for Linux
# /usr/bin/pactl set-default-sink alsa_output.pci-0000_00_1f.3.analog-stereo
# /usr/bin/pactl set-default-source alsa_input.pci-0000_00_1f.3.analog-stereo

# commands for OSX
/opt/homebrew/bin/switchaudiosource -s "MacBook Pro Microphone" -t input
/opt/homebrew/bin/switchaudiosource -s "MacBook Pro Speakers" -t output

# send a notification to confirm the audio source is set correctly
notify-which-audio-selected.sh

exit 0
