#!/bin/bash

# pause a moment for the switchaudiosource command to finish
sleep 2

# play a sound
afplay /System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Swish.caf

# send a notification to confirm which audio source is set
CURRENT_INPUT=$(SwitchAudioSource -c -t input)
CURRENT_OUTPUT=$(SwitchAudioSource -c -t output)
terminal-notifier -title "Current Audio Settings" -subtitle "input: ${CURRENT_INPUT}" -message "output: ${CURRENT_OUTPUT}"
