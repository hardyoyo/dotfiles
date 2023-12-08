# this file is sourced by login shells only

# source everything else
[[ -e ~/.bashrc ]] && source ~/.bashrc

# let's use powerbash
source /home/hardy/.local/powerbash/powerbash.sh


if [ -e /home/hardy/.nix-profile/etc/profile.d/nix.sh ]; then . /home/hardy/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

source /home/hardy/.config/broot/launcher/bash/br
