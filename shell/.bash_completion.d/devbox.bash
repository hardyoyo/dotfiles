#!/bin/bash

# devbox completion script
_devbox() {
    local cur prev
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # Get available scripts from devbox.json
    local scripts=$(jq -r '.shell.scripts | keys[]' devbox.json)

    case $prev in
        devbox)
            # Complete with available commands
            COMPREPLY=( $(compgen -W "run shell init ${scripts}" -- $cur) )
            return 0
            ;;
        devbox\ run)
            # Complete with available scripts
            COMPREPLY=( $(compgen -W "${scripts}" -- $cur) )
            return 0
            ;;
    esac
}

# Register the completion function
complete -F _devbox devbox
