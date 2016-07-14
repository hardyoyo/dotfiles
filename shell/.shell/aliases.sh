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

# oracle stuff
alias ostart='vboxmanage startvm "Oracle DB Developer VM" -type headless'
alias oshut='vboxmanage controlvm "Oracle DB Developer VM" savestate'
export ORACLE_HOME=/usr/local/oracle
export LD_LIBRARY_PATH=/usr/local/oracle:${LD_LIBRARY_PATH}
export PATH=/usr/local/oracle:${PATH}
export SQLPATH=/usr/local/oracle:${SQLPATH}
export NLS_LANG=AMERICAN_AMERICA.UTF8
