# AutoMerge Action

Automatically merge a branch into another.

Inspired by [robotology/gh-action-nightly-merge](https://github.com/robotology/gh-action-nightly-merge)

If the merge is not necessary, the action will do nothing.
If the merge fails due to conflicts, the action will fail, and the repository
maintainer should perform the merge manually.

## Installation

To enable the action simply create the `.github/workflows/automerge.yml`
file with the following content:

```yml
name: 'AutoMerge'

on:
  schedule:
    - cron:  '0 0 * * *'

jobs:
  automerge:

    runs-on: ubuntu-latest

    steps:
    - name: Checkout
      uses: actions/checkout@v1

    - name: AutoMerge
      uses: MilleniumStudio/gh-action-automerge@v1.0.0
      with:
        source_branch: 'dev'
        destination_branch: 'master'
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

Even though this action was created to run as a scheduled workflow,
[`on`](https://help.github.com/en/articles/workflow-syntax-for-github-actions#on)
can be replaced by any other trigger.
For example, this will run the action whenever something is pushed on the
`master` branch:

```yml
on:
  push:
    branches:
      - master
```

## Parameters

### `source_branch`

The name of the source branch (required).

### `destination_branch`

The name of the destination branch (required).

### `allow_ff`

Allow fast forward merge (default `false`). If not enabled, merges will use
`--no-ff`.

### `ff_only`

Refuse to merge and exit unless the current HEAD is already up to date or the
merge can be resolved as a fast-forward (default `false`).
Requires `allow_ff=true`.

### `user_name`

User name for git commits (default `GitHub AutoMerge Action`).

### `user_email`

User email for git commits (default `actions@github.com`).
