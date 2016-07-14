# Known to work with bash 2.05a with programmable completion and extended
# pattern matching enabled (use 'shopt -s extglob progcomp' to enable
# these if they are not already enabled).

shopt -s extglob

_ws()
{
    local cur
    COMPREPLY=()
    #Variable to hold the current word
    cur="${COMP_WORDS[COMP_CWORD]}"

    #Build a list of our keywords for auto-completion using
    #the dirs in the workspace folder
	local names=$(for x in `ls -1 $HOME/workspace`; do echo ${x} ; done )

    #array variable COMPREPLY
    COMPREPLY=($(compgen -W "${names}" -- ${cur}))
	return 0
}

#Assign the auto-completion function _ws for our command ws.
complete -F _ws ws
