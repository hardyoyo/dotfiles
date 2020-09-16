#!/bin/bash

# something keeps chewing up my .config/dconf/user file, which makes
# my multiple monitor setup FUBAR, so... whatever, just copy a known
# good version of the file and keep going

echo "... copying our backup .config/dconf/user file..."
cp /home/pottingerhj/backups/20150204-dot-config-dconf-user /home/pottingerhj/.config/dconf/user
echo "... DONE! ... sorry it has to be this way."
echo "Hey! Don't forget to REBOOT!"
exit 0
