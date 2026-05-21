#!/usr/bin/env bash

_complete_aws_adfs() {
    COMPREPLY=()
    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=($(compgen -W "login" -- ${COMP_WORDS[1]}))
    fi
}

complete -F _complete_aws_adfs aws-adfs
