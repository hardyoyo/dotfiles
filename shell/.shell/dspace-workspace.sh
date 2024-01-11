# my own custom workspace function

export DSWORKSPACE="$HOME/dspace-workspace"

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
function ds {
    cd $DSWORKSPACE/$1

    # if we are in our DSWORKSPACE root, let's run gfold
    if [ "$PWD" == "$DSWORKSPACE" ]; then
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
alias ds.dockerup="cd $DSWORKSPACE/dspace && docker-compose -p d7 up -d"
alias ds.dockerdown="cd $DSWORKSPACE && docker-compose -p d7 down"
alias ds.dockerlogs="cd $DSWORKSPACE && docker-compose -p d7 logs -f"
alias dsa.dockerup="cd $DSWORKSPACE/dspace-angular && docker-compose -p d7 -f docker/docker-compose.yml up -d"
alias dsa.dockerlogs="cd $DSWORKSPACE/dspace-angular && docker-compose -p d7 -f docker/docker-compose.yml logs -f"
