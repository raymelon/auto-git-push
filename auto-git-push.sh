#!/bin/bash

# auto-git-push.sh
#
# A utility script to manage auto-commit and auto-push of local repositories
# Add this script to your cron and you're good to go!
#
# A good use case is if you want to automatically update a remote repo
# Another is if you want to backup a local repo
#
# Use this utility script to automate the following commands in order:
#   1. git add
#   2. git commit
#   3. git push
# 
# Use auto-git-push.json to:
#   1. Edit the repository local paths (path field per item)
#   2. The automated commit message (commit_msg field per item)
#   3. The remote name so the script knows the remote url to push the changes to (remote field per item)
#   4. and the branch to push the changes to (branch field per item)

logger_func() {
  local log_message="$1"
  log_file="/var/log/auto-git-push.log"
  timestamp_for_commit=$(date +"%Y-%m-%dT%H:%M:%S%:z")
  echo "auto-git-push: $timestamp_for_commit: $log_message" | tee -a "$log_file"
}

while
do
  logger_func " log in /var/log/auto-git-push"

  logger_func  Welcome to auto-git-push
  logger_func  Checking if 'jq' command is installed...

  # this script uses jq
  #   hence, the command check
  #
  if type -P jq
  then
    logger_func  command 'jq' already exists, skipping install
  else
    logger_func  command 'jq' does not exist, installing...
    curl -sS https://webi.sh/jq | bash
  fi

  # get current pwd,
  #   so the script can go back to it later after the series of cd
  #   'hwd' means 'home working directory' (??)
  #
  hwd=$(pwd)
  logger_func " hwd is: $hwd"

  logger_func " loop about to start for reading the items inside auto-git-push.json..."
  ctr=0
  jq -c '.repos.[]' auto-git-push.json | while read line; do
    
    # $line is a json string, so we will still need jq to parse it

    # path field check:
    #   the item is skipped if path is empty
    #
    path=$(logger_func $line | jq -r ".path")
    if [ "$path" == "null" ] || [ "$path" == "" ]
    then
      logger_func " Element: $ctr, path is: null or empty, hence skipping this item..."
      continue
    elif [ "$path" == "$hwd" ]
    then
      # protect the hwd,
      #   the git repo where this script is running is prohibited from modifications
      logger_func " Element: $ctr, path is: $path which is the same as hwd, hence skipping this item..."
      continue
    else
      logger_func " Element: $ctr, path is: $path"
      cd "$path"
      logger_func " Element: $ctr, pwd is: $(pwd)"
    fi

    # commit_msg check
    #
    commit_msg=$(logger_func $line | jq -r ".commit_msg")
    if [ "$commit_msg" == "null" ] || [ "$commit_msg" == "" ]
    then
      logger_func " Element: $ctr, commit_msg is: null or empty"
    else
      logger_func " Element: $ctr, commit_msg is: $commit_msg"
    fi

    logger_func  Element: $ctr, Commit Message: $commit_msg
    
    timestamp_for_commit=$(date +"%Y-%m-%dT%H:%M:%S%:z")
    logger_func " Element: $ctr, timestamp is: $timestamp_for_commit"

    # remote field check
    #
    remote=$(logger_func $line | jq -r ".remote")
    if [ "$remote" == "null" ] || [ "$remote" == "" ]
    then
      logger_func " Element: $ctr, remote is: null or empty, hence skipping this item.."
      continue
    else
      logger_func " Element: $ctr, remote is: $remote"
    fi

    # branch field check
    #
    branch=$(logger_func $line | jq -r ".branch")
    if [ "$branch" == "null" ] || [ "$branch" == "" ]
    then
      logger_func " Element: $ctr, branch is: null or empty, hence skipping this item.."
      continue
    else
      logger_func " Element: $ctr, branch is: $branch"
    fi

    # git add, git commit and git push execution
    #   marked this so it can easily be found
    #   comment the next 2 lines in case unexpected things happen
    #   and you have to debug the conditionals on this script
    #
    eval "git add . && git commit -m '${commit_msg} ${timestamp}' && git push ${remote} ${branch}"

    cd $hwd
    logger_func " Element: $ctr, went back to hwd, hence pwd is: $(pwd)"

    ((ctr++))

  done

  sleep 1
done
