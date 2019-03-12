# p: a common package manager interface
source ~/.shell/packages.sh

# system dependent
if [[ $OSTYPE == darwin* ]]
then
    # power
    alias shutdown='sudo shutdown -hP now'
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

# miscellaneous
alias sudo='sudo ' # enable alias expansion for sudo
alias g='git'
complete -o default -o nospace -F _git g
alias make='make --debug=b'
alias ping='ping -c 8'
alias r='run'
alias root='sudo su'
alias cppc='cppcheck --std=c++11 --enable=all --suppress=missingIncludeSystem .'
alias octave='octave --quiet'

# MINE MINE MINE
alias du='du -h'
alias df='df -h'
alias whatismyip='dig +short myip.opendns.com @resolver1.opendns.com'
alias polipo-offline="/usr/bin/curl -m 5 -d 'proxyOffline=true' http://localhost:8123/polipo/config?"
alias polipo-online="/usr/bin/curl -m 5 -d 'proxyOffline=false' http://localhost:8123/polipo/config?"
alias vpn="sudo openconnect -b https://anyconnect.missouri.edu --config=/home/pottingerhj/.config/openconnect/config"
alias vpnoff="sudo killall openconnect"
alias kill-vagrant-notify="kill $(ps aux | grep 8100 | grep -v grep | awk '{print $2}')"
alias vim-init="vim +PluginInstall +qall -q /dev/null && cd $HOME/.vim/bundle/Command-T/ruby/command-t && ruby extconf.rb && make"
alias be='bundle exec'

# DSpace stuff
alias dspace.fetchupstreamdspace="cd $HOME/workspace/dspace && git config --add remote.upstream-dspace.fetch +refs/pull/*/head:refs/remotes/upstream-dspace/pr/*"
alias dspace.fetchupstreamucla="cd $HOME/workspace/dspace && git config --add remote.upstream-ucla.fetch +refs/pull/*/head:refs/remotes/upstream-ucla/pr/*"
alias dspace.ctags="cd $HOME/workspace/dspace && ctags -R $HOME/workspace/dspace -f $HOME/workspace/dspace/tags --exclude *target*"

# DSpace docker-dev aliases
alias dsd.up="export DPROJ=d6 && cd $HOME/workspace/dspace-docker-dev && docker-compose -p ${DPROJ} up -d"
alias dsd.start="export DPROJ=d6 && cd $HOME/workspace/dspace-docker-dev && docker-compose -p ${DPROJ} start -d"
alias dsd.stop="export DPROJ=d6 && cd $HOME/workspace/dspace-docker-dev && docker-compose -p ${DPROJ} stop"
alias dsd.down="export DPROJ=d6 && cd $HOME/workspace/dspace-docker-dev && docker-compose -p ${DPROJ} down"

# VSim docker-dev aliases
alias vsimd.up="export DPROJ=v6 && cd $HOME/workspace/dspace-docker-dev && docker-compose -p ${DPROJ} up -d"
alias vsimd.start="export DPROJ=v6 && cd $HOME/workspace/dspace-docker-dev && docker-compose -p ${DPROJ} start -d"
alias vsimd.stop="export DPROJ=v6 && cd $HOME/workspace/dspace-docker-dev && docker-compose -p ${DPROJ} stop"
alias vsimd.down="export DPROJ=v6 && cd $HOME/workspace/dspace-docker-dev && docker-compose -p ${DPROJ} down"
alias vsimd.logs="export DPROJ=v6 && cd $HOME/workspace/dspace-docker-dev && docker-compose -p ${DPROJ} logs -f"
alias vsimd.home="cd $HOME/workspace/dspace"
alias vsimd.mvn="cd $HOME/workspace/dspace && mvn clean package -Dmirage2.on=true -P'!dspace-jspui,!dspace-rdf,!dspace-sword'"
alias vsimd.mvntest="cd $HOME/workspace/dspace && mvn test -Dmaven.test.skip=false"
alias vsimd.ant="export DPROJ=v6 && cd $HOME/workspace/dspace-docker-dev && docker exec -w /dspace-src/dspace/target/dspace-installer ${DPROJ}_dspace_1 ant update clean_backups"
alias vsimd.restart-tomcat="export DPROJ=v6 && cd $HOME/workspace/dspace-docker-dev && docker-compose -p ${DPROJ} restart"

# oracle stuff
alias ostart='vboxmanage startvm "Oracle DB Developer VM" -type headless'
alias oshut='vboxmanage controlvm "Oracle DB Developer VM" savestate'
export ORACLE_HOME=/usr/local/oracle
export LD_LIBRARY_PATH=/usr/local/oracle:${LD_LIBRARY_PATH}
export PATH=/usr/local/oracle:${PATH}
export SQLPATH=/usr/local/oracle:${SQLPATH}
export NLS_LANG=AMERICAN_AMERICA.UTF8

# i3wm stuff
alias make-screen-res-readable='xrandr --output eDP-1 --mode 1920x1080' 
