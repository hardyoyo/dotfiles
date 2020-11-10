# this file is sourced by non-login interactive shells and ~/.bash_profile

# set the umask to something reasonable
umask 002

# let's use a visible bell
set bell-style visible

# let's use rbenv, shall we?
# skip on Windows
case "$OSTYPE" in
  # darwin*)  ;; 
  msys*)    ;;
  *)		eval "$(rbenv init -)";;
esac


# and lets' use jenv, too
eval "$(jenv init -)"
export JAVA_HOME="$(jenv javahome)"

# let's use the bleeding-edge version of Ansible

#source $HOME/workspace/ansible/hacking/env-setup

# and lets give the gnome keyring daemon what it wants
# this doesn't appear to work at all, but I'll leave it here for giggles
# does not work on mac
#SSH_AUTH_SOCK=`ssh -xl | grep -o '/run/user/1000/keyring-.*/ssh'`
#[ -z "$SSH_AUTH_SOCK" ] || export SSH_AUTH_SOCK

# trying again

if [ -n "$DESKTOP_SESSION" ];then
    eval $(gnome-keyring-daemon --start)
    export SSH_AUTH_SOCK
fi

# set gopath
export GOPATH=~/gocode/

# set up DSpace docker-compose stuff
export DSPACE_SRC=$HOME/workspace/dspace
export DSPACE_VER=dspace-6_x-jdk8-test
export DPROJ=v6

# use vim for programs opening an editor
export VISUAL='vim'
export EDITOR="$VISUAL"

# set ask_sudo_password for serverspec testing
ASK_SUDO_PASSWORD=1

# skip on mac and Windows
# on linux, always spin up vim with servername set to vim
case "$OSTYPE" in
  darwin*)  ;; 
  msys*)    ;;
  *)		alias vim='vim --servername vim'
			alias vi='vim --servername vim'
			;;
esac

# be more verbose when we mv, cp or rm things
alias mv='mv -v'
alias cp='cp -v'
alias rm='rm -v'

# always open VScode in a new window, so we don't clobber existing work
alias code='code -n'

# let's use pyenv to manage our Python setup
export PYENV_ROOT="$HOME/.pyenv"

# set up java, maven, and ant
# NOTE: no trailing slash on JAVA_HOME, *EVER*
# skip on mac
#export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
#export MAVEN3_HOME=/usr/share/maven
#export ANT_HOME=/usr/share/ant



# path setup
source ~/.shell/path-edit.sh
path_front $PYENV_ROOT/bin
path_front ~/.rbenv/plugins/ruby-build/bin
path_front ~/bin /usr/local/sbin /usr/local/bin $GOPATH/bin /usr/local/idea/bin
path_front /usr/local/android-studio/bin
path_back /sbin /bin /usr/sbin /usr/bin $JAVA_HOME/bin /usr/local/kakadu /usr/local/idea/bin /usr/local/visualvm/bin /usr/local/yjp/bin /usr/local/node/bin $M2_HOME/bin $ANT_HOME/bin /usr/local/pycharm/bin

# icu4c needs to be up front so I can use uconv to keep Excel from munging UTF-8 characters
path_front /usr/local/opt/icu4c/bin

# openssl munging so MySQL works
path_back /usr/local/opt/openssl@1.1/bin
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/opt/openssl/lib/

# workspace setup
source ~/.shell/workspace.sh

# run setup
source ~/.shell/run.sh

# only run this for interactive shells, skip otherwise
if [[ -v PS1 ]]; then
    # show a fortune
    source ~/.shell/fortune.sh
    echo "--"
    # run ddate, because it's awesome
    ddate
    echo
fi

# cd options
#shopt -s autocd cdspell dirspell
# autocd and dirspell don't work on mac

# glob options
# skip on mac and Windows
case "$OSTYPE" in
  darwin*)  ;; 
  msys*)    ;;
  *)		shopt -s cdspell
            shopt -s dotglob extglob globstar nocaseglob
            shopt -s checkjobs huponexit
            ;;
esac

# shell options
shopt -s checkhash checkwinsize

# history
shopt -s cmdhist histappend histverify

HISTCONTROL=ignoreboth
# Unset for unlimited history
HISTSIZE=
HISTFILESIZE=
# Use separate history file to avoid truncation
HISTFILE=~/.bash_history_file

# only on mac
if type brew &>/dev/null; then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "$COMPLETION" ]] && source "$COMPLETION"
    done
  fi
fi

# source my own bash_completeions, plz
source ~/.bash_completion

# prompt setup
PROMPT_DIRTRIM=2

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWCOLORHINTS=1
GIT_PS1_SHOWUPSTREAM=auto

set_prompt () {
    local last_command=$?
    PS1='\u@\h:'
    # save after every command
    history -a

    # color escape codes
    local color_off='\[\e[0m\]'
    local color_red='\[\e[0;31m\]'
    local color_green='\[\e[0;32m\]'
    local color_yellow='\[\e[0;33m\]'
    local color_blue='\[\e[0;34m\]'
    local color_purple='\[\e[0;35m\]'
    local color_cyan='\[\e[0;36m\]'

    # add purple exit code if non-zero
    if [[ $last_command != 0 ]]; then
	PS1+=$color_purple
	PS1+='$? '
	PS1+=$color_off
    fi

    # shortened working directory
    PS1+='\w '

    # add Git status with color hints
    PS1+="$(__git_ps1 "%s ")"

    # red for root, off for user
    if [[ $EUID == 0 ]]; then
	PS1+=$color_red
    else
	PS1+=$color_off
    fi

    # end of prompt
    PS1+='|-'
    PS1+=$color_red
    PS1+='/ '
    PS1+=$color_off
}
PROMPT_COMMAND='set_prompt'

# aliases
source ~/.shell/aliases.sh

# enable ls colors
if ls --color=auto &> /dev/null; then
    alias ls="ls --color=auto"
else
    export CLICOLOR=1
fi

# uses 'thefuck' to fix common command mistakes
# https://github.com/nvbn/thefuck
alias fuck='eval $(thefuck $(fc -ln -1)); history -r'

# add FZF completions
if [[ -r ~/.fzf.bash ]]; then
    source ~/.fzf.bash
fi

# colored man pages
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

# disable flow control
stty -ixon

# source local configurations
if [[ -r ~/.shell_local.sh ]]; then
    source ~/.shell_local.sh
fi

#MOAR ALIASES!!!!

# Kill all running containers.
alias dockerkillall='docker kill $(docker ps -q)'

# Delete all stopped containers.
alias dockercleanc='printf "\n>>> Deleting stopped containers\n\n" && docker rm $(docker ps -a -q)'

# Delete all untagged images.
alias dockercleani='printf "\n>>> Deleting untagged images\n\n" && docker rmi $(docker images -q -f dangling=true)'

# Delete all stopped containers and untagged images.
alias dockerclean='docker system prune -af && dockercleanc || true && dockercleani'

# run the gitpitch desktop docker image, with the current folder mounted for slides
alias gitpitch='docker run -it -v $(pwd):/repo -p 9000:9000 gitpitch/desktop:pro'

# commented out for troubleshooting purposes
# added by travis gem
#[ -f /home/hpottinger/.travis/travis.sh ] && source /home/hpottinger/.travis/travis.sh

alias sync-ezid-plugin='rsync -avzSCH /Users/hpotting/workspace/janeway/src/plugins/ezid/. /Users/hpotting/workspace/EarthArXiv/plugins/ezid/'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# export AWS_PROFILE=uclalibrary

# set up nvm
export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# fix the accessibility bus warnings
export NO_AT_BRIDGE=1

# init pyenv
eval "$(pyenv init -)"

# use Node 12 by default
nvm use 12

# ezid testing environment variables
export EZID_SHOULDER="doi:10.15697/"
export EZID_USERNAME="apitest"
export EZID_PASSWORD="apitest"
export EZID_URL="https://uc3-ezidx2-stg.cdlib.org" # stage, sometimes better for testing
# export EZID_URL="https://ezid.cdlib.org" # prod, ok for testing
