#!/bin/bash

# dependency: https://github.com/deweller/switchaudio-osx

#Default Sink: alsa_output.pci-0000_00_1f.3.analog-stereo
#Default Source: alsa_input.pci-0000_00_1f.3.analog-stereo

# commands for Linux
# /usr/bin/pactl set-default-sink alsa_output.pci-0000_00_1f.3.analog-stereo
# /usr/bin/pactl set-default-source alsa_input.pci-0000_00_1f.3.analog-stereo

# commands for OSX
/usr/local/bin/switchaudiosource -s "MacBook Pro Microphone" -t input
/usr/local/bin/switchaudiosource -s "USB audio CODEC" -t output

# send a notification to confirm the audio source is set correctly
CURRENT_AUDIO_INFO=$(SwitchAudioSource -c)
terminal-notifier -message "Audio i/o set to: ${CURRENT_AUDIO_INFO}"

exit 0
