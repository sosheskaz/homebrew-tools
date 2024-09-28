#!/usr/bin/env bash

set -e

BREW="${BREW:-brew}"
DRY_RUN="${DRY_RUN:-}"

if ! which "${BREW}" > /dev/null; then
	echo "Error: Homebrew binary '${BREW}' not found in PATH."
	exit 1
else
	echo "Using Homebrew from $(which "${BREW}"): $("${BREW}" --version | head -n1)"
fi

echodo() {
	echo "+ $@"
	if [ -z "${DRY_RUN}" ]
	then
		"$@"
	fi
}

eval "$("${BREW}" shellenv)"

GIT="${GIT:-git}"
if ! which "${GIT}" > /dev/null; then
	echo "Error: Git binary '${GIT}' not found in PATH."
	exit 1
else
	echo "Using Git from $(which "${GIT}"): $("${GIT}" --version | head -n1)"
fi

BREW_DIR="${HOMEBREW_REPOSITORY}"
TAPS_DIR="${HOMEBREW_REPOSITORY}/Library/Taps"

BEFORE="$(du -sh "${BREW_DIR}" | awk '{print $1}')"

if [[ ! -d "$BREW_DIR" ]]
then
	echo "Error: Homebrew directory '$BREW_DIR' not found."
	exit 1
fi

if [[ ! -d "$TAPS_DIR" ]]
then
	echo "Error: Homebrew taps directory '$TAPS_DIR' not found."
	exit 1
fi

echo "Cleaning up homebrew installs..."
echodo "${BREW}" cleanup --prune=all
echo

echo "Cleaning core homebrew installation..."
echodo "${GIT}" -C "${HOMEBREW_REPOSITORY}" gc --aggressive
echo

while read -r tap
do
	echo "Cleaning tap $subdir..."
	echodo "${GIT}" -C "${tap}" gc --aggressive
	echo
	cd ../..
done <<< "$(find "${TAPS_DIR}" -type d -name .git -exec dirname '{}' \;)"

AFTER="$(du -sh "${BREW_DIR}" | awk '{print $1}')"

echo "Before: $BEFORE"
echo "After:  $AFTER"
