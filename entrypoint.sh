#!/bin/bash

set -e

FF_MODE="--ff-only"  # Always use fast-forward mode

git config --global --add safe.directory /github/workspace

# Config git user
git config --global user.name "$INPUT_USER_NAME"
git config --global user.email "$INPUT_USER_EMAIL"

# Fetch source branch
git fetch origin $INPUT_SOURCE_BRANCH
git switch -C $INPUT_SOURCE_BRANCH origin/$INPUT_SOURCE_BRANCH

# Fetch destination branch
git fetch origin $INPUT_DESTINATION_BRANCH
git switch -C $INPUT_DESTINATION_BRANCH origin/$INPUT_DESTINATION_BRANCH

if git merge-base --is-ancestor $INPUT_SOURCE_BRANCH $INPUT_DESTINATION_BRANCH; then
  echo "No rebase is necessary"
  exit 0
fi;

echo
echo "'AutoRebase Action' is trying to rebase the '$INPUT_SOURCE_BRANCH' branch onto the '$INPUT_DESTINATION_BRANCH' branch"
echo

# Rebase the branches
git pull origin $INPUT_DESTINATION_BRANCH
git rebase $FF_MODE origin/$INPUT_SOURCE_BRANCH

# Push the rebased branch
git push origin $INPUT_DESTINATION_BRANCH -f
