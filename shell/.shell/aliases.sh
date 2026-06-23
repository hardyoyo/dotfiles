# p: a common package manager interface
source ~/.shell/packages.sh

# system dependent
if [[ $OSTYPE == darwin* ]]
then
    # power
    alias shutdown='sudo shutdown -h now'
    alias reboot='sudo reboot now'
    alias sleep='shutdown -s now'

    # misc
    alias unlock_files='chflags -R nouchg *'
elif [[ $OSTYPE == linux-gnu ]]
then
    # power
    alias shutdown='sudo shutdown -P now'
    alias reboot='sudo shutdown -r now'
    alias halt='sudo halt -P'
fi

# Claude Code
alias claude="$HOME/bin/claude-maybe.sh --permission-mode plan"

# miscellaneous
alias sudo='sudo ' # enable alias expansion for sudo
alias g='git'
complete -o default -o nospace -F _git g
# alias make='gmake --debug=b' # enable if you need debug on all the time
alias make='gmake'
alias ping='ping -c 8'
alias r='run'
alias root='sudo su'
alias cppc='cppcheck --std=c++11 --enable=all --suppress=missingIncludeSystem .'
alias octave='octave --quiet'

# MINE MINE MINE
alias du='du -h'
alias df='df -h'
alias whatismyip='dig +short myip.opendns.com @resolver1.opendns.com'
alias amiatucop='current_ip=$(dig +short myip.opendns.com @resolver1.opendns.com) && if [[ $current_ip =~ ^128\.48\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then echo -e "\033[0;32mOn\033[0m UCOP VPN"; else echo -e "\033[0;31mNot on\033[0m UCOP VPN"; fi'
# alias polipo-offline="/usr/bin/curl -m 5 -d 'proxyOffline=true' http://localhost:8123/polipo/config?"
# alias polipo-online="/usr/bin/curl -m 5 -d 'proxyOffline=false' http://localhost:8123/polipo/config?"
# alias vpn="sudo openconnect -b https://anyconnect.missouri.edu --config=/home/pottingerhj/.config/openconnect/config"
# alias vpnoff="sudo killall openconnect"
alias kill-vagrant-notify="kill $(ps aux | grep 8100 | grep -v grep | awk '{print $2}')"
alias vim-init="vim +PluginInstall +qall -q /dev/null && cd $HOME/.vim/bundle/Command-T/ruby/command-t && ruby extconf.rb && make"
alias be='bundle exec'
alias ls='eza --icons'
alias notes='notes|glow'

# FUNCTIONS ARE KINDA LIKE ALIASES, THESE HANDLE EM-DASHES
emdash-on() {
    sed 's/--/—/g'
}

emdash-off() {
    sed 's/—/--/g'
}

# what's all this then? use an LLM to figure out what the code in this branch is doing
alias whatsallthisthen-development='git log development..HEAD --pretty=format:%s -p | llm -s "Write a succinct description of the current state of this work based on the commit messages and diff."'
alias whatsallthisthen-main='git log main..HEAD --pretty=format:%s -p | llm -s "Write a succinct description of the current state of this work based on the commit messages and diff."'
alias whatsallthisthen-master='git log master..HEAD --pretty=format:%s -p | llm -s "Write a succinct description of the current state of this work based on the commit messages and diff."'
alias whatsallthisthen-staged='git diff --cached --pretty=format:%s -p | llm -s "Write a succinct description of the current state of this work based on the diff."'

#alias yamllint='yamllint -d relaxed'

# UCSF DevEx Stuff
alias ghe.prod='ssh -p 122 admin@git.ucsf.edu'
alias ghe.test='ssh -p 122 admin@git-test.ucsf.edu'
alias ghe.stage='ssh -p 122 admin@git-stage.ucsf.edu'

# jschol stuff
# alias watch-dev='watch -d aws --profile pub elasticbeanstalk describe-environments --environment-name eb-pub-jschol2-dev'
# alias watch-stg='watch -d aws --profile pub elasticbeanstalk describe-environments --environment-name eb-pub-jschol2-stg'
# alias watch-prd='watch -d aws --profile pub elasticbeanstalk describe-environments --environment-name eb-pub-jschol2-prd'
# alias health-dev='aws --profile pub elasticbeanstalk describe-instances-health --environment-name eb-pub-jschol2-dev --attribute-names All'
# alias health-stg='aws --profile pub elasticbeanstalk describe-instances-health --environment-name eb-pub-jschol2-stg --attribute-names All'
# alias health-prd='aws --profile pub elasticbeanstalk describe-instances-health --environment-name eb-pub-jschol2-prd --attribute-names All'


# DSpace stuff
# alias dspace.fetchupstreamdspace="cd $HOME/workspace/dspace && git config --add remote.upstream-dspace.fetch +refs/pull/*/head:refs/remotes/upstream-dspace/pr/*"
# alias dspace.fetchupstreamucla="cd $HOME/workspace/dspace && git config --add remote.upstream-ucla.fetch +refs/pull/*/head:refs/remotes/upstream-ucla/pr/*"
# alias dspace.ctags="cd $HOME/workspace/dspace && ctags -R $HOME/workspace/dspace -f $HOME/workspace/dspace/tags --exclude *target*"

# DSpace docker-dev aliases
# alias dsd.up="export DPROJ=d6 && cd $HOME/workspace/dspace-docker-dev && docker-compose -p ${DPROJ} up -d"
# alias dsd.start="export DPROJ=d6 && cd $HOME/workspace/dspace-docker-dev && docker-compose -p ${DPROJ} start -d"
# alias dsd.stop="export DPROJ=d6 && cd $HOME/workspace/dspace-docker-dev && docker-compose -p ${DPROJ} stop"
# alias dsd.down="export DPROJ=d6 && cd $HOME/workspace/dspace-docker-dev && docker-compose -p ${DPROJ} down"

# VSim docker-dev aliases
# alias vsimd.up="export DPROJ=v6 && cd $HOME/workspace/dspace-docker-dev && docker-compose -p ${DPROJ} up -d"
# alias vsimd.start="export DPROJ=v6 && cd $HOME/workspace/dspace-docker-dev && docker-compose -p ${DPROJ} start -d"
# alias vsimd.stop="export DPROJ=v6 && cd $HOME/workspace/dspace-docker-dev && docker-compose -p ${DPROJ} stop"
# alias vsimd.down="export DPROJ=v6 && cd $HOME/workspace/dspace-docker-dev && docker-compose -p ${DPROJ} down"
# alias vsimd.logs="export DPROJ=v6 && cd $HOME/workspace/dspace-docker-dev && docker-compose -p ${DPROJ} logs -f"
# alias vsimd.home="cd $HOME/workspace/dspace"
# alias vsimd.mvn="cd $HOME/workspace/dspace && mvn clean package -Dmirage2.on=true -P'!dspace-jspui,!dspace-rdf,!dspace-sword'"
# alias vsimd.mvntest="cd $HOME/workspace/dspace && mvn test -Dmaven.test.skip=false"
# alias vsimd.ant="export DPROJ=v6 && cd $HOME/workspace/dspace-docker-dev && docker exec -w /dspace-src/dspace/target/dspace-installer ${DPROJ}_dspace_1 ant update clean_backups"
# alias vsimd.restart-tomcat="export DPROJ=v6 && cd $HOME/workspace/dspace-docker-dev && docker-compose -p ${DPROJ} restart"

# Your Code as a Crimescene tools
alias maat="java -jar $HOME/opt/code-maat.jar"


# oracle stuff
# alias ostart='vboxmanage startvm "Oracle DB Developer VM" -type headless'
# alias oshut='vboxmanage controlvm "Oracle DB Developer VM" savestate'
# export ORACLE_HOME=/usr/local/oracle
# export LD_LIBRARY_PATH=/usr/local/oracle:${LD_LIBRARY_PATH}
# export PATH=/usr/local/oracle:${PATH}
# export SQLPATH=/usr/local/oracle:${SQLPATH}
# export NLS_LANG=AMERICAN_AMERICA.UTF8

# i3wm stuff
alias make-screen-res-readable='xrandr --output eDP-1 --mode 1920x1080' 

# bfg
alias bfg='java -jar /usr/local/lib/bfg.jar'

# freelibrary
alias rb='mvn info.freelibrary:freelib-utils:generate-codes -DmessageFiles=$(find src -name "*_messages.xml")'

# whatismyip
alias whatismyip='dig +short myip.opendns.com @resolver1.opendns.com'

# amidone
alias amidone='notes'

# propose git commit message
alias "propose-commit-msg"='git diff HEAD | llm --system "Propose a git commit message for this git diff"'

# clean keyboard
# alias cleankeyboard='echo "Press Ctrl-C to exit. Scrub away!"; trap "exit 0" SIGINT; while true; do read -rsn1 _; done'
alias cleankeyboard='(stty -echo; echo "Press Ctrl-C to exit. Scrub away!"; trap "stty echo; exit 0" SIGINT; while true; do read -rsn1 _; done)'

# how much space on a mac
alias how-much-space-do-I-have-left="diskutil info / | grep 'Container Free Space'"

alias mdless='mdless --no-color'


# grab the weather from wttr.in
weather() {
    curl "wttr.in/$1?uqTF"
}

## UCSF GITHUB STUFF
alias git-ucsf-edu-diagnostics='filename="ghes-diagnostics-$(date +%Y%m%d-%H%M%S).txt"; ssh -p 122 admin@git.ucsf.edu "ghe-diagnostics" > "$filename" && echo "Diagnostics report saved to: $filename"'


# Makefile template
make-init() {
  cat > Makefile <<'EOF'
.DEFAULT_GOAL := help
help: ## Show help
	@awk 'BEGIN {FS = ":.*##"} \
	/^[a-zA-Z_-]+:.*?##/ { \
		printf "  \033[36m%-15s\033[0m %s\n", \
		$$1, $$2 \
	}' $(MAKEFILE_LIST)
EOF
  echo "Created Makefile with help target"
}

# defang some commands that agents like to run
kubectl() {
    safeguard-cmd.sh kubectl "$@"
}

aws() {
    safeguard-cmd.sh aws "$@"
}

kubectl() {
    safeguard-cmd.sh kubectl "$@"
}

terraform() {
    safeguard-cmd.sh terraform "$@"
}

helm() {
    safeguard-cmd.sh helm "$@"
}
