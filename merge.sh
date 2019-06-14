#!/usr/bin/env bash
# specify the argument(s) if you want to list the conflict(s) that happened while merging
# change WORKING_PATH below to the path of kernel source directory

set -e

WORKING_PATH=~/GitHub/Simplicity

if [[ $(pwd) -ef ${WORKING_PATH} ]]; then
	active_branch=$(git branch | grep \* | cut -d ' ' -f2)
	kernel_version=$(make kernelversion)
	IFS='.' read -r -a version <<< "${kernel_version}"
	range="v${version[0]}.${version[1]}.$((${version[2]} - 1))..v${kernel_version}"
	commit_msg=$(mktemp)

	echo "Merge ${kernel_version} into ${active_branch}" >> "${commit_msg}"
	echo -e "\nChanges in ${kernel_version}: ($(git rev-list --count ${range} 2> /dev/null) commits)" >> "${commit_msg}"
	git log --reverse --format="        %s" "${range}" >> "${commit_msg}"

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

