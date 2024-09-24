# Private function used by session() to maintain a cache of profile+instName -> instId
function __build-inst-cache() {
    local cacheDir=~/.aws/my-inst-cache
    echo "Refreshing ec2 instance id cache." >&2
    if [ ! -f ~/.aws/config ]; then echo "Error: ~/.aws/config not found" >&2; return 1; fi
    local profiles=$(egrep '\[profile' ~/.aws/config | awk '{print $2}' | sed 's/\]//')
    if [ "$profiles" == "" ]; then echo "Error: no profiles found in ~/.aws/config" >&2; return 1; fi
    mkdir -p $cacheDir; rm -f $cacheDir/*
    set +m  # disable job control messages
    for profile in $profiles; do
        { aws --profile $profile ec2 describe-instances --output text \
            --query 'Reservations[*].Instances[*].[InstanceId, Tags[?Key == `Name`] | [0].Value]' \
            >> $cacheDir/$profile & } 2>/dev/null
    done
    wait
    set -m  # re-enable job control messages
}
# Start a session on an instance by name. Searches every SSO profile for the name (with a cache for speed).
# Usage e.g. `session pub-aws2-ops`
function session() {
    local instName=$1
    local cacheDir=~/.aws/my-inst-cache
    local chk=$(egrep -H "$instName" $cacheDir/* 2>/dev/null)
    if [ "$chk" == "" ]; then 
        __build-inst-cache
        chk=$(egrep -H "$instName" $cacheDir/* 2>/dev/null)
        if [ "$chk" == "" ]; then echo "Error: instance '$instName' not found." >&2; return 1; fi
    fi
    local params=$(echo $chk | head -1 | sed 's/ .*//' | sed 's/^.*my-inst-cache./--profile /' | sed 's/:i-/ --target=i-/')
    local cmd="aws ssm start-session $params"
    echo $cmd >&2
    $cmd
    stty sane; tput cnorm  # fix terminal if session times out
}

complete -W "$(cut -f2 ~/.aws/my-inst-cache/*)" session
