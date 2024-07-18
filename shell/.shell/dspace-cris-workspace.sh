# my own custom workspace function

export DSCWORKSPACE="$HOME/workspace/dspace-cris"

# add a hooray to docker-compose
docker-compose() {
    local cmd="docker-compose $@"
    if command $cmd; then
        osascript -e "display notification \"${cmd}\" with title \"Docker-Compose Done\" sound name \"cheers\""
    else
        osascript -e "display notification \"${cmd}\" with title \"Docker-Compose Failed\" sound name \"Sosumi\""
    fi
}

# add a hooray to mvn
mvn() {
    local cmd="mvn $@"
    if command $cmd; then
        osascript -e "display notification \"${cmd}\" with title \"Maven Done\" sound name \"cheers\""
    else
        osascript -e "display notification \"${cmd}\" with title \"Maven Failed\" sound name \"Sosumi\""
    fi
}

# DSpace workspace function
function dsc {
    cd $DSCWORKSPACE/$1

    # if we are in our DSCWORKSPACE root, let's run gfold
    if [ "$PWD" == "$DSCWORKSPACE" ]; then
        printf '%.s─' $(seq 1 $(tput cols))
        gfold -d classic
        printf '%.s─' $(seq 1 $(tput cols))
    fi
    if [ -d .svn ]; then
        svn info
        svn status
    fi
    if [ -d .git ]; then
        echo "== Remote URL: `git remote -v`"

        echo "== Remote Branches: "
        git branch -r
        echo

        echo "== Local Branches:"
        git branch
        echo

        echo "== Configuration \(.git/config\)"
        cat .git/config
        echo

        echo "== Most Recent Commit"
        git --no-pager log --max-count=1
        echo

        echo "== Status:"
        git status -sb
        echo

        echo "== Hint: be sure you're working with the most recent changes:"
        echo "git fetch --all"
        echo "git checkout master #may have to git stash first"
        echo "git pull upstream master"
        echo "git push origin master"
        echo "git pull origin master #not necessary but a nice sanity check"
        echo "git checkout BRANCHNAME"
        echo "git rebase -i master"
        echo

    fi
}

# Docker-Compose aliases for DSpace
alias dsc.dockerup="cd $DSCWORKSPACE/dspace && docker-compose -p d7 up -d"
alias dsc.dockerdown="cd $DSCWORKSPACE/dspace && docker-compose -p d7 down"
alias dsc.dockerlogs="cd $DSCWORKSPACE/dspace && docker-compose -p d7 logs -f"
alias dsca.dockerup="cd $DSCWORKSPACE/dspace-angular && docker-compose -p d7 -f docker/docker-compose.yml up -d"
alias dsca.dockerlogs="cd $DSCWORKSPACE/dspace-angular && docker-compose -p d7 -f docker/docker-compose.yml logs -f"
alias dsc.dockershell="cd $DSCWORKSPACE/dspace && docker exec -it dspace /bin/bash"
