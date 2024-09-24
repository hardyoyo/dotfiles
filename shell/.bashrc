# this file is sourced by non-login interactive shells and ~/.bash_profile

# set the umask to something reasonable
/usr/bin/umask 002

# let's use a visible bell
set bell-style visible

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

# use this AWS Profile most of the time
# export AWS_PROFILE=cdl-pad-prd

# aw, homebrew... you da best
eval "$(/opt/homebrew/bin/brew shellenv)"

# set gopath
export GOPATH=~/gocode/

# really really don't want to run zsh, stop going on about it, plz
export BASH_SILENCE_DEPRECATION_WARNING=1

# set up DSpace docker-compose stuff
# export DSPACE_SRC=$HOME/workspace/dspace
# export DSPACE_VER=dspace-6_x-jdk8-test
# export DPROJ=v6

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

# remember the flags for diffing folders as a command
alias folderdiff='diff -rq'

# remember the mute startup sound command
# other possible values: %01, %00 or " "
# alias mute_startup_sound='sudo nvram SystemAudioVolume=%80'
alias mute_startup_sound='sudo nvram StartupMute=%01'

# use the reverse version of dust all the time
alias dust='dust --reverse'

# set the PYENV_ROOT
export PYENV_ROOT="$HOME/.pyenv"

# more aliases
# alias ecrlogin="export AWS_PROFILE=cdl-pad-dev && aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 866216109762.dkr.ecr.us-west-2.amazonaws.com"
alias record-alacritty='t-rec -w $(t-rec --ls-win | grep -i alacritty | awk "{print \$NF}")'

# set up java, maven, and ant
# NOTE: no trailing slash on JAVA_HOME, *EVER*
# skip on mac
#export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
#export MAVEN3_HOME=/usr/share/maven
#export ANT_HOME=/usr/share/ant



# path setup
source ~/.shell/path-edit.sh
path_front $PYENV_ROOT/shims
path_front $HOME/.cargo/bin
path_back /opt/homebrew/bin
path_front ~/.rbenv/plugins/ruby-build/bin
path_front /usr/local/opt/mysql@5.7/bin $HOME/.local/bin ~/bin /usr/local/sbin /usr/local/bin $GOPATH/bin /usr/local/idea/bin
path_front /usr/local/android-studio/bin
path_back /sbin /bin /usr/sbin /usr/bin $JAVA_HOME/bin /usr/local/kakadu /usr/local/idea/bin /usr/local/visualvm/bin /usr/local/yjp/bin /usr/local/node/bin $M2_HOME/bin $ANT_HOME/bin /usr/local/pycharm/bin
# icu4c needs to be up front so I can use uconv to keep Excel from munging UTF-8 characters
path_front /usr/local/opt/icu4c/bin

# openssl munging so MySQL works
path_back /usr/local/opt/openssl@1.1/bin
export LDFLAGS="-L/opt/homebrew/opt/openssl@1.1/lib"
export CPPFLAGS="-I/opt/homebrew/opt/openssl@1.1/include"
export LIBRARY_PATH=$LIBRARY_PATH:/opt/homebrew/opt/openssl@1.1/lib/

# workspace(s) setup
source ~/.shell/workspace.sh
source ~/.shell/dspace-workspace.sh
source ~/.shell/dspace-cris-workspace.sh

# run setup
source ~/.shell/run.sh

# # only run this for interactive shells, skip otherwise
# if [ -z ${PS1+x} ]; then
#     # show a fortune
#     # source ~/.shell/fortune.sh
#     # echo "--"
# fi

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

# source our credentials file, if it's there
if [[ -r "${HOME}/.creds.env" ]]; then
    source "${HOME}/.creds.env"
fi

# source my own bash_completeions, plz
source ~/.bash_completion

# source powerbash
# source ~/workspace/powerbash/powerbash.sh

# let's try starship instead
eval "$(starship init bash)"

# Starship completion
if [ -f ~/.bash_completion.d/starship.bash ]; then
      . ~/.bash_completion.d/starship.bash
fi


# Martin's Fancy AWS Session stuff
# source ~/.shell/aws-session.sh

# prompt setup
PROMPT_DIRTRIM=2

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWCOLORHINTS=1
GIT_PS1_SHOWUPSTREAM=auto


# only attempt to config the prompt in interactive shells, skip otherwise
if [ -n "$PS1" ]; then

    sleep 1
    # # set the powerbash path format
    # powerbash path mini
    #
    # # set powerbash to show my hostname, because it's funny
    # powerbash host on
    #
    # # set powerbash to show Python virtualenvironments
    # powerbash py virtualenv on
    #
    # # use powerbash to set the term environment variable to xterm, which produces higher-contrast output
    # powerbash term xterm

fi



# my old prompt, replaced by powerbash
# set_prompt () {
#     local last_command=$?
#     PS1='\u@\h:'
#     # save after every command
#     history -a
#
#     # color escape codes
#     local color_off='\[\e[0m\]'
#     local color_red='\[\e[0;31m\]'
#     local color_green='\[\e[0;32m\]'
#     local color_yellow='\[\e[0;33m\]'
#     local color_blue='\[\e[0;34m\]'
#     local color_purple='\[\e[0;35m\]'
#     local color_cyan='\[\e[0;36m\]'
#
#     # add purple exit code if non-zero
#     if [[ $last_command != 0 ]]; then
# 	PS1+=$color_purple
# 	PS1+='$? '
# 	PS1+=$color_off
#     fi
#
#     # shortened working directory
#     PS1+='\w '
#
#     # add Git status with color hints
#     PS1+="$(__git_ps1 "%s ")"
#
#     # red for root, off for user
#     if [[ $EUID == 0 ]]; then
# 	PS1+=$color_red
#     else
# 	PS1+=$color_off
#     fi
#
#     # end of prompt
#     PS1+='|-'
#     PS1+=$color_red
#     PS1+='/ '
#     PS1+=$color_off
# }
# PROMPT_COMMAND='set_prompt'

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
# lots more in .shell/aliases.sh you should probably put aliases in there

# Kill all running containers.
alias dockerkillall='docker kill $(docker ps -q)'

# Delete all stopped containers.
alias dockercleanc='printf "\n>>> Deleting stopped containers\n\n" && docker rm $(docker ps -a -q)'

# Delete all untagged images.
alias dockercleani='printf "\n>>> Deleting untagged images\n\n" && docker rmi $(docker images -q -f dangling=true)'

# Delete all stopped containers and untagged images.
alias dockerclean='docker system prune -af && dockercleanc || true && dockercleani'

# Delete all Lando stuff (cache and docker images)
alias landoclean='printf "\n>>> Deleting Lando caches\n\n" && rm -Rf ~/.lando/cache/* && rm -Rf ~/.lando/compose/* && docker system prune -af && dockercleanc || true && dockercleani'

# really really rebuild a Lando project
alias landonuke='lando destroy -y && lando rebuild -y'

# run the gitpitch desktop docker image, with the current folder mounted for slides
alias gitpitch='docker run -it -v $(pwd):/repo -p 9000:9000 gitpitch/desktop:pro'

# commented out for troubleshooting purposes
# added by travis gem
#[ -f /home/hpottinger/.travis/travis.sh ] && source /home/hpottinger/.travis/travis.sh

alias sync-ezid-plugin='rsync -avzSCH /Users/hpotting/workspace/janeway/src/plugins/ezid/. /Users/hpotting/workspace/EarthArXiv/plugins/ezid/'
alias sync-GP-theme='rsync -avzSCH /Users/hpotting/workspace/janeway/src/themes/GP/. /Users/hpotting/workspace/GP/'

# set up nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# fix the accessibility bus warnings
export NO_AT_BRIDGE=1

# init pyenv
eval "$(pyenv init -)"

# use Node 18 by default
nvm use 18 --silent

# ddate is awesome, but a bit slow
#/opt/homebrew/bin/ddate

# can't wait!
$HOME/bin/days_until.py /Users/hpotting/.event_list.txt

# check whether our AWS credentials are stale and gently warn us about it
if nc -zw1 google.com 443 >/dev/null 2>&1; then
    if aws sts get-caller-identity > /dev/null 2>&1; then
        echo -e "$(tput setaf 2)❱❱❱ AWS credentials are current, good for you!$(tput sgr0)"
    else
        echo -e "$(tput setaf 1)❱❱❱ AWS credentials are STALE, you should get on that soon: $(tput setaf 2)aws-adfs login$(tput sgr0)"
    fi
else
    echo -e "$(tput setaf 57)❌ No network, you should jack in! ;-) Skipping AWS credential check...$(tput sgr0)"
fi


# ezid testing environment variables
export EZID_SHOULDER="doi:10.15697/"
export EZID_USERNAME="apitest"
export EZID_PASSWORD="apitest"
export EZID_URL="https://uc3-ezidx2-stg.cdlib.org" # stage, sometimes better for testing
# export EZID_URL="https://ezid.cdlib.org" # prod, ok for testing

# we don't use terraform, no reason to source this
# complete -C /usr/local/bin/terraform terraform

# set the default for FZF
export FZF_DEFAULT_COMMAND='fd'

# set GPG_TTY
GPG_TTY=$(tty)
export GPG_TTY

# set LESS to get out of the way for less than one page of output
export LESS='FXmR'

export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"

# Docker stuff
export COMPOSE_HTTP_TIMEOUT=600

# source .cargo/env if we have one
cargo_env_path="$HOME/.cargo/env"; [ -e "$cargo_env_path" ] && . "$cargo_env_path"

# Load Angular CLI autocompletion.
# source <(ng completion script)

export COLUMNS="120"

# sentiment precommit-hook script config
export MIN_COMMIT_MSG_LENGTH="240"
# export SENTIMENT_THRESHOLD="0.01" # probably don't need to tinker with this

### if we've just started up the computer (time limit 60 minutes), we might be interested in the weather forecast
[[ $(( $(date +%s) - $(sysctl -n kern.boottime | awk '{print $4}' | tr -d ',') )) -lt 3600 ]] && $HOME/.cargo/bin/wthrr | grep -v friend
# [[ $(( $(date +%s) - $(sysctl -n kern.boottime | awk '{print $4}' | tr -d ',') )) -lt 3600 ]] && curl 'wttr.in/kcou?uqTF'

### set my hostname to EDGECASE if it isn't already EDGECASE
# sudoers is still not working correctly for no-password configs, so let's skip this for now
#[ "$(hostname)" != "EDGECASE" ] && /Users/hpotting/bin/edgecase-is-dead-long-live-edgecase.sh


######################## SET UP DEV TOOLS LAST ####################################################
# set up our dev tools as the very last thing, so we have a good chance of finding them in the path
# and they win any fights with homebrew paths

# if we have rbenv, let's use it
# if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# but chruby is better
source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh
source $(brew --prefix)/opt/chruby/share/chruby/auto.sh
chruby ruby-3.3.4

# and lets' use jenv, too
if which jenv > /dev/null; then eval "$(jenv init -)"; fi
export JAVA_HOME="$(/usr/libexec/java_home)"

# and pyenv
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

export PGPASSFILE="$HOME/.pgpass"

# direnv is nice, and it requests to go last, so... here it is
eval "$(direnv hook bash)"

# source /Users/hpotting/.config/broot/launcher/bash/br

# source ~/.pyenv/versions/3.11.5/bin/virtualenvwrapper.sh

# Lando
export PATH="/Users/hpottinger/.lando/bin${PATH+:$PATH}"; #landopath

source /Users/hpottinger/.config/broot/launcher/bash/br
