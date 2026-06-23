#!/usr/bin/env bash
# my own custom workspace function

export WORKSPACE="$HOME/workspace"

# helper: print a full-width horizontal divider
function _ws_divider {
    printf '%.s─' $(seq 1 $(tput cols))
    printf '\n'
}

# helper: print a section header - bold text on light grey background, full terminal width
function _ws_header {
    local cols
    cols=$(tput cols)
    printf "\033[47m\033[1m%-${cols}s\033[0m\n" "$1"
}

# helper: run gfold with priority highlighting and status color coding
# reads $WORKSPACE/.priorities (one repo name per line) to highlight priority repos
function _ws_gfold {
    local pfile="$WORKSPACE/.priorities"
    gfold -d classic | awk -v pfile="$pfile" '
    BEGIN {
        while ((getline ln < pfile) > 0) priorities[ln] = 1
        close(pfile)
        G = "\033[0;32m"; Y = "\033[0;33m"; R = "\033[0;31m"
        B = "\033[1m"; E = "\033[0m"
    }
    {
        line = $0
        if      ($2 == "clean")    sub(/ clean/,    " " G "clean" E, line)
        else if ($2 == "unclean")  sub(/ unclean/,  " " Y "unclean" E, line)
        else if ($2 == "unpushed") sub(/ unpushed/, " " R "unpushed" E, line)

        if ($1 in priorities)
            printf "%s\n", B line E
        else
            printf "%s\n", line
    }'
}

# helper: find any Claude sessions
function _ws_claude_sessions {
    local project_dir
    local session_count
    local newest_session
    local age_seconds
    local last_activity
    local last_prompt
    local status

    project_dir="$HOME/.claude/projects/${PWD//\//-}"

    [[ -d "$project_dir" ]] || return 0

    shopt -s nullglob
    local sessions=( "$project_dir"/*.jsonl )
    shopt -u nullglob

    session_count=${#sessions[@]}
    [[ "$session_count" -gt 0 ]] || return 0

    newest_session=$(
    find "$project_dir" -maxdepth 1 -type f -name '*.jsonl' \
        -exec stat -f '%m %N' {} \; |
        sort -nr |
        head -1 |
        cut -d' ' -f2-
)

    age_seconds=$(( $(date +%s) - $(stat -f '%m' "$newest_session") ))

    if (( age_seconds < 3600 )); then
        last_activity="$(( age_seconds / 60 ))m ago"
    elif (( age_seconds < 86400 )); then
        last_activity="$(( age_seconds / 3600 ))h ago"
    else
        last_activity="$(( age_seconds / 86400 ))d ago"
    fi

    last_prompt=$(
        jq -r '
            select(.type == "last-prompt")
            | .lastPrompt
        ' "$newest_session" 2>/dev/null | tail -1
    )

    [[ "$last_prompt" == "null" ]] && last_prompt=""

    if [[ ${#last_prompt} -gt 60 ]]; then
        last_prompt="${last_prompt:0:57}..."
    fi

    if tail -20 "$newest_session" |
        jq -e '
            select(.type == "system")
            | select(.subtype == "turn_duration")
        ' >/dev/null 2>&1
    then
        status="✅ cleanly exited"
    else
        status="🚧 possibly interrupted"
    fi

    _ws_header " C L A U D E"

    printf "Claude sessions: %s\n" "$session_count"
    printf "Last activity: %s\n" "$last_activity"

    if [[ -n "$last_prompt" ]]; then
        printf "Last prompt: %s\n" "$last_prompt"
    fi

    printf "Status: %s\n" "$status"
    printf "Resume with: \033[1mclaude --continue\033[0m\n"
    echo
}


# workspace function
function ws {
    cd "$HOME/workspace/$1" || return 1

    # if we are in our WORKSPACE root, and we have gfold, let's run gfold
    if [ "$PWD" == "$WORKSPACE" ]; then
        if command -v gfold >/dev/null 2>&1; then
            _ws_divider
            _ws_gfold
            _ws_divider
        fi
    fi

    if [ -d .svn ]; then
        svn info
        svn status
    fi
    if git rev-parse --git-dir >/dev/null 2>&1; then
        _ws_header " R E M O T E S"
        git remote -v
        echo

        _ws_header " B R A N C H"
        git branch -vv
        echo

        _ws_header " L A S T   C O M M I T"
        git log -1 --format="%cr by %an"
        echo

        if [[ -n $(git status --porcelain) ]]; then
            echo "🚧 Status: Dirty"
            git status --short
        else
            echo "✅ Status: Clean"
        fi
        echo

        _ws_claude_sessions

        _ws_header " Hint: be sure you're working with the most recent changes..."
        echo "git fetch --all"
        echo "git checkout main #may have to git stash first"
        echo "git pull upstream main"
        echo "git push origin main"
        echo "git pull origin main #not necessary but a nice sanity check"
        echo "git checkout BRANCHNAME"
        echo "git rebase -i main"
        echo
    fi
    printf " ⟶ use \033[1mbr\033[0m (broot) to get an overview of this project's structure\n"
    printf " ⟶ use \033[1mnotes\033[0m to see what needs to be done\n"
}
