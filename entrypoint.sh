#!/bin/bash

set -e

if [[ -z "${!INPUT_PUSH_TOKEN}" ]]; then
  echo "INPUT_PUSH_TOKEN env variable is not set"
  exit 1
fi

FF_MODE="--no-ff"
if $INPUT_ALLOW_FF; then
  FF_MODE="--ff"
  if $INPUT_FF_ONLY; then
    FF_MODE="--ff-only"
  fi
fi

# Init
git remote set-url origin https://x-access-token:${!INPUT_PUSH_TOKEN}@github.com/$GITHUB_REPOSITORY.git
git config --global user.name "$INPUT_USER_NAME"
git config --global user.email "$INPUT_USER_EMAIL"

git branch

# Fetch branches
# git fetch origin $INPUT_SOURCE_BRANCH
# git switch -C $INPUT_SOURCE_BRANCH origin/$INPUT_SOURCE_BRANCH

git fetch origin $INPUT_DESTINATION_BRANCH
git switch -C $INPUT_DESTINATION_BRANCH origin/$INPUT_DESTINATION_BRANCH

if git merge-base --is-ancestor $INPUT_SOURCE_BRANCH $INPUT_DESTINATION_BRANCH; then
  echo "No merge is necessary"
  exit 0
fi;

echo
echo "'AutoMerge Action' is trying to merge the '$INPUT_SOURCE_BRANCH' branch into the '$INPUT_DESTINATION_BRANCH' branch"
echo

# Merge the branches
git merge $FF_MODE --no-edit origin/$INPUT_SOURCE_BRANCH

# Push the branch
git push origin $INPUT_DESTINATION_BRANCH

# cleanup
git branch -D $INPUT_SOURCE_BRANCH
git branch -D $INPUT_DESTINATION_BRANCH
