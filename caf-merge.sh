#!/usr/bin/env bash
# specify the argument(s) if you want to list the conflict(s) that happened while merging
# change WORKING_PATH below to the path of kernel source directory

set -e

WORKING_PATH=~/GitHub/Simplicity

if [[ ! -z "$1" ]]; then
    if [[ $(pwd) -ef ${WORKING_PATH} ]]; then
        active_branch=$(git branch | grep \* | cut -d ' ' -f2)
        range=$1
        tmp=${range//".."/$'\2'}
        IFS=$'\2' read -a tag <<< "${tmp}"
        merged_tag="${tag[1]}"
        commit_msg=$(mktemp)

        echo "Merge tag '${merged_tag}' into ${active_branch}" >> "${commit_msg}"
        echo -e "\n\"${merged_tag}\"" >> "${commit_msg}"
        echo -e "\n* tag '${merged_tag}':" >> "${commit_msg}"
        git log --reverse --format="  %s" "${range}" >> "${commit_msg}"

        shift
        if [[ ! $# -eq 0 ]]; then
            echo -e "\nConflicts:" >> "${commit_msg}"
            for conflict in "$@"; do
                echo -e "\t$conflict" >> "${commit_msg}"
            done
        fi

        git commit --amend --date="$(date)" --file "${commit_msg}" --no-edit --quiet
        rm -f "${commit_msg}"
    else
        echo "Please run this script from kernel source directory!"
    fi
else
    echo "Please specify the tag range! (<previous_tag>..<latest_tag>)"
fi
