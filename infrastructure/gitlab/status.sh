#!/bin/sh


# Exit when any command fails
set -e


# Example
# state: running, success, failed, canceled
# ./infrastructure/gitlab/status.sh "state=failed"

# https://docs.gitlab.com/ce/api/commits.html#post-the-build-status-to-a-commit
# https://help.github.com/en/actions/configuring-and-managing-workflows/using-environment-variables

if [ -z "$GIT_LAB_ACCESS_TOKEN" ]; then
    echo "Please sure that GIT_LAB_ACCESS_TOKEN exists"
    exit 1
fi

if [ -z "$GIT_LAB_PIPELINE_ID" ]; then
    echo "Please sure that GIT_LAB_PIPELINE_ID exists"
    exit 1
fi

if [ -z "$GIT_LAB_COMMIT_SHA" ]; then
    echo "Please sure that GIT_LAB_COMMIT_SHA exists"
    exit 1
fi

if [ -z "$GITHUB_RUN_ID" ]; then
    echo "Please sure that GITHUB_RUN_ID exists"
    exit 1
fi

TARGET_URL="https://github.com/ischeduler-attendance/ischeduler-attendance-builds/actions/runs/$GITHUB_RUN_ID"
PROJECT_ID=9734432

curl --fail --request POST --header "PRIVATE-TOKEN: $GIT_LAB_ACCESS_TOKEN" "https://gitlab.com/api/v4/projects/$PROJECT_ID/statuses/$GIT_LAB_COMMIT_SHA?pipeline_id=$GIT_LAB_PIPELINE_ID&target_url=$TARGET_URL&name=$GITHUB_JOB&$1"
