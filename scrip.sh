#!/bin/bash

current_branch=$(git rev-parse --abbrev-ref HEAD)

if [ -z "$current_branch" ]; then
    echo "Error: Could not determine the current branch."
    exit 1
fi

if [ $# -eq 0 ]; then
    echo "Usage: $0 <branch-to-merge>"
    exit 1
fi

to_merge=$1

if [ "$current_branch" == "$to_merge" ]; then
    echo "Error: The branch to merge cannot be the same as the current branch."
    exit 1
fi

new_branch="merge-$current_branch/$to_merge"

git checkout -b "$new_branch"

if [ $? -ne 0 ]; then
    echo "Error: Failed to create or checkout branch $new_branch."
    exit 1
fi

git merge "$to_merge"

if [ $? -ne 0 ]; then
    echo "Error: Merge failed."
    exit 1
fi

git push origin "$new_branch"

if [ $? -ne 0 ]; then
    echo "Error: Push failed."
    exit 1
fi

echo "Branch $new_branch created, merged, and pushed successfully."