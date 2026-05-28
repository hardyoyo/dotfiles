# this file is sourced by non-login interactive shells and ~/.bash_profile

# set the umask to something reasonable
umask 002

# function to determine whether we've booted recently
recent_boot() {
    local boot_age
    boot_age=$(( $(date +%s) - $(sysctl -n kern.boottime | awk '{print $4}' | tr -d ',') ))
    [[ "$boot_age" -lt 3600 ]]
}


# aw, homebrew, you da best
eval "$(/opt/homebrew/bin/brew shellenv)"

# let's use the bleeding-edge version of Ansible

#source $HOME/workspace/ansible/hacking/env-setup

# and lets give the gnome keyring daemon what it wants
# this doesn't appear to work at all, but I'll leave it here for giggles
# does not work on mac
#SSH_AUTH_SOCK=`ssh -xl | grep -o '/run/user/1000/keyring-.*/ssh'`
#[ -z "$SSH_AUTH_SOCK" ] || export SSH_AUTH_SOCK

if [ -n "$DESKTOP_SESSION" ];then
    eval $(gnome-keyring-daemon --start)
    export SSH_AUTH_SOCK
fi

# use this AWS Profile most of the time
# export AWS_PROFILE=cdl-pad-prd

# set gopath
export GOPATH=~/gocode

# set up pyenv early for minimal complaining later
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init -)"

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

# handy alias to obsfucate ANYPOINT_CLIENT_* vars
alias obsfucate="sed 's/^\(ANYPOINT_CLIENT[^=]*\)=.*/\1=OBSFUCATED/'"

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
path_front $HOME/.cargo/bin
path_front $HOME/sessionmanager-bundle/bin
path_front ~/.rbenv/plugins/ruby-build/bin
path_front /usr/local/opt/mysql@5.7/bin $HOME/.local/bin ~/bin /usr/local/sbin /usr/local/bin $GOPATH/bin /usr/local/idea/bin
path_back /opt/homebrew/bin /opt/homebrew/sbin
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

# man-hunt setup
source ~/.shell/man-hunt.sh

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

############################################# BEGIN INTERACTIVE SHELL STUFF ####
# only do these if we are in an interactive shell
if [[ -t 0 && -t 1 ]]; then

    # Martin's Fancy AWS Session stuff
    source ~/.shell/aws-session.sh

    ### if we've just started up the computer (time limit 60 minutes), we might be interested in the weather forecast
    # [[ $(( $(date +%s) - $(sysctl -n kern.boottime | awk '{print $4}' | tr -d ',') )) -lt 3600 ]] && $HOME/.cargo/bin/wthrr | grep -v friend && $HOME/bin/todays-events.sh
    WEATHER_CACHE="$HOME/.cache/wthrr.txt"

    if recent_boot; then
        if [[ -f "$WEATHER_CACHE" ]]; then
            cat "$WEATHER_CACHE"
        fi

        (
            WEATHER_OUTPUT="$(gtimeout 8 "$HOME/.cargo/bin/wthrr" 2>/dev/null | grep -v friend)"

            if [[ -n "$WEATHER_OUTPUT" ]]; then
                {
                    printf '[weather updated %s]\n' "$(date)"
                    printf '%s\n' "$WEATHER_OUTPUT"
                } > "$WEATHER_CACHE.tmp"

                mv "$WEATHER_CACHE.tmp" "$WEATHER_CACHE"

                echo
                cat "$WEATHER_CACHE"
                echo
            fi
        ) & disown

        # what's happening today?
        $HOME/bin/todays-events.sh

        # can't wait!
        $HOME/bin/days_until.py /Users/hpottinger/.event_list.txt

    fi
fi

############################################### END INTERACTIVE SHELL STUFF ####

# prompt setup
PROMPT_DIRTRIM=2

# aliases
source ~/.shell/aliases.sh

# # enable ls colors
# if ls --color=auto &> /dev/null; then
#     alias ls="ls --color=auto"
# else
#     export CLICOLOR=1
# fi

# uses 'thefuck' to fix common command mistakes
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

alias sync-ezid-plugin='rsync -avzSCH /Users/hpottinger/workspace/janeway/src/plugins/ezid/. /Users/hpottinger/workspace/EarthArXiv/plugins/ezid/'
alias sync-GP-theme='rsync -avzSCH /Users/hpottinger/workspace/janeway/src/themes/GP/. /Users/hpottinger/workspace/GP/'

# set up nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# fix the accessibility bus warnings
export NO_AT_BRIDGE=1

# # use Node 18 by default
# # nvm use 18 --silent
# nvm alias default 18

# ddate is awesome, but a bit slow
#/opt/homebrew/bin/ddate

if [[ -z "$AWS_CHECK_DONE" ]]; then
    # add some goober-y caching
    export AWS_CHECK_DONE=1
    # only warn us about AWS login state if we're in an interactive shell
    if [[ -t 0 && -t 1 ]]; then
        # check whether our AWS credentials are stale and gently warn us about it, but run this in the background
        {
          if nc -zw1 google.com 443 >/dev/null 2>&1; then
              if ! aws sts get-caller-identity > /dev/null 2>&1; then
                  echo -e "$(tput setaf 1)❱❱❱ AWS credentials are STALE, you should get on that soon: $(tput setaf 2)aws sso login$(tput sgr0)"
              fi
          else
              echo -e "$(tput setaf 57)❌ No network, you should jack in! ;-) Skipping AWS credential check...$(tput sgr0)"
          fi
        } & disown
    fi
fi
# ezid testing environment variables
export EZID_SHOULDER="doi:10.15697/"
export EZID_USERNAME="apitest"
export EZID_PASSWORD="apitest"
export EZID_URL="https://uc3-ezidx2-stg.cdlib.org"

# set the default for FZF
export FZF_DEFAULT_COMMAND='fd'

# set GPG_TTY
GPG_TTY=$(tty)
export GPG_TTY

# set LESS to get out of the way for less than one page of output
export LESS='FXmR'

path_front /usr/local/opt/gnu-getopt/bin

# Docker stuff
export COMPOSE_HTTP_TIMEOUT=600

# source .cargo/env if we have one
cargo_env_path="$HOME/.cargo/env"; [ -e "$cargo_env_path" ] && . "$cargo_env_path"

export COLUMNS="120"

# sentiment precommit-hook script config
export MIN_COMMIT_MSG_LENGTH="240"

######################## SET UP DEV TOOLS LAST ####################################################

# chruby is good
source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh
source $(brew --prefix)/opt/chruby/share/chruby/auto.sh
chruby ruby-3.3.4

# and lets' use jenv, too
command -v jenv > /dev/null 2>&1 && eval "$(jenv init -)"
export JAVA_HOME="$(/usr/libexec/java_home)"

# and pyenv (interactive shell integration)
# command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init -)"

export PGPASSFILE="$HOME/.pgpass"

# direnv is nice, and it requests to go last, so... here it is
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook bash)"

# Lando
path_front /Users/hpottinger/.lando/bin

source /Users/hpottinger/.config/broot/launcher/bash/br

###### Zed configs #######
export ZED_AWS_PROFILE="bedrock"
export ZED_AWS_REGION="us-west-2"
export ZED_AWS_ENDPOINT="https://unified-api.ucsf.edu/general/awsai"

##### Obsidian REST ######
export OBSIDIAN_API_KEY=0979ba2ee720db474d77dc0767494edfeb5d28650002a0f4408362ad919f7839
export OBSIDIAN_HOST=http://127.0.0.1
export OBSIDIAN_PORT=27123


# ##### Dedupe the PATH #####
# dedupe_path() {
#   awk -v RS=: '
#     !seen[$0]++ {
#       paths[++n] = $0
#     }
#     END {
#       for (i = 1; i <= n; i++) {
#         printf "%s%s", paths[i], (i<n?":":"")
#       }
#     }
#   ' <<< "$PATH"
# }
# export PATH="$(dedupe_path)"

# OK, we get it, PyEnv, you want to be set up right... but you are... mostly
export PYENV_SILENCE_WARNING=1

