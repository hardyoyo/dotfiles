# my own custom workspace function

# workspace function
function ws {
    cd $HOME/workspace/$1
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

        echo "== Configuration (.git/config)"
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

