#!/bin/bash

set -ue

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
git checkout $MERGE_BRANCH
git merge --ff-only $CURRENT_BRANCH

REMOTE_URL=$(echo $REMOTE_REPO | sed s^://^://${GITHUB_CREDS_USR}:${GITHUB_CREDS_PSW}^)

echo $REMOTE_URL
git remote add to_push $REMOTE_URL

git push to_push $MERGE_BRANCH
