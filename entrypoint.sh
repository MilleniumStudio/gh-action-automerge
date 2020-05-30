#!/bin/bash

set -e

if [[ -z "${!GITHUB_TOKEN}" ]]; then
  echo "GITHUB_TOKEN env variable is not set"
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
git remote set-url origin https://x-access-token:${!GITHUB_TOKEN}@github.com/$GITHUB_REPOSITORY.git
git config --global user.name "$INPUT_USER_NAME"
git config --global user.email "$INPUT_USER_EMAIL"

# Fetch branches
git fetch origin $INPUT_SOURCE_BRANCH
git checkout -b $INPUT_SOURCE_BRANCH origin/$INPUT_SOURCE_BRANCH

git fetch origin $INPUT_DESTINATION_BRANCH
git checkout -b $INPUT_DESTINATION_BRANCH origin/$INPUT_DESTINATION_BRANCH

if git merge-base --is-ancestor $INPUT_SOURCE_BRANCH $INPUT_DESTINATION_BRANCH; then
  echo "No merge is necessary"
  exit 0
fi;

echo
echo "'AutoMerge Action' is trying to merge the '$INPUT_SOURCE_BRANCH' branch into the '$INPUT_DESTINATION_BRANCH' branch"
echo

# Merge the branches
git merge $FF_MODE --no-edit $INPUT_SOURCE_BRANCH

# Push the branch
git push origin $INPUT_DESTINATION_BRANCH
