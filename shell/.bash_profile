# this file is sourced by login shells only

# source everything else
[[ -e ~/.bashrc ]] && source ~/.bashrc

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/hpotting/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/Users/hpotting/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/hpotting/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/hpotting/Downloads/google-cloud-sdk/completion.bash.inc'; fi
