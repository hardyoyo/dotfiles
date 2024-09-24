# this file is sourced by login shells only

# source everything else
[[ -e ~/.bashrc ]] && source ~/.bashrc

# I don't use Google Cloud SDK, I have no idea how this got here, commenting out
# # The next line updates PATH for the Google Cloud SDK.
# if [ -f '/Users/hpotting/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/Users/hpotting/Downloads/google-cloud-sdk/path.bash.inc'; fi
#
# # The next line enables shell command completion for gcloud.
# if [ -f '/Users/hpotting/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/hpotting/Downloads/google-cloud-sdk/completion.bash.inc'; fi
# . "$HOME/.cargo/env"
#
# this is in .bashrc already, commenting out
# export COLUMNS="120"


# WARNING don't let homebrew install a config in .bash_profile, it will make path stuff really confusing in .bashrc

source /Users/hpottinger/.config/broot/launcher/bash/br
