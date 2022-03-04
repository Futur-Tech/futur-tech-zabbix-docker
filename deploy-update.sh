#!/usr/bin/env bash

# General deploy script with GIT Pull if needed v1.1

usage()
{
    echo "Usage: deploy-update.sh [-b <repo_branch>] [-f force the reset of the GIT] <other args which will be passed to deploy.sh>" 1>&2
    exit 1
}

[ $# -eq 0 ] && usage
while getopts "fb:" o; do
    case "${o}" in
        b)
            export GIT_BRANCH_DEPLOY="${OPTARG}"
            ;;

        f)
            GIT_RESET=true
            ;;

        : | *)
            usage
            ;;
    esac
done
shift "$((OPTIND - 1))"

if [ -z "$GIT_BRANCH_DEPLOY" ]
then 
    usage
fi

source "$(dirname "$0")/ft-util/ft_util_inc_var"

$S_LOG -d $S_NAME "Start $S_NAME $*"

cd $S_DIR

git checkout $GIT_BRANCH_DEPLOY &>/dev/null
$S_LOG -s $? -d $S_NAME "Branch selected is '$GIT_BRANCH_DEPLOY'"

GIT_STATUS="$(git status --porcelain)"
if [ -n "$GIT_STATUS" ]
then
    if [ "$GIT_RESET" = true ]
    then 
        git reset --hard origin/$GIT_BRANCH_DEPLOY | $S_LOG -d "$S_NAME" -i 
    else
        $S_LOG -s err -d $S_NAME "GIT STATUS: there are local modifications in the repo which are not sync. Use -f is you want to reset the local repo. Exit."
        exit 1
    fi
fi

git fetch | $S_LOG -d "$S_NAME" -i 

DIFF="$(git diff origin/$GIT_BRANCH_DEPLOY)"
if [ -n "$DIFF" ]
then
    $S_LOG -d $S_NAME "Found a new version of me, updating myself..."
    git pull --force | $S_LOG -d "$S_NAME" -i 
    if [ "$?" -ne 0 ]
    then
        $S_LOG -s err -d $S_NAME "Git pull error $?. Exit."
        exit 1
    else
        $S_LOG -d $S_NAME "Running the new version..."
        args="-b $GIT_BRANCH_DEPLOY $@"
        exec "$S_PATH" $args
        # Now exit this old instance
        exit 0
    fi
fi

$S_LOG -d $S_NAME "Already the latest version."

exec "./deploy.sh" "$@"
