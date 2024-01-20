#!/bin/bash

set -e

REPO="git@github.com:MVS-source/AREA-DOC.git"
TARGET_BRANCH="main"
DOC_DIR="doc"
README="README.md"
CLONE_DIR="AREA-DOC-clone"
COMMIT_MESSAGE="Update documentation"

if [ ! -d "$CLONE_DIR" ]; then
    git clone --branch $TARGET_BRANCH $REPO $CLONE_DIR
else
    echo "Using existing '$CLONE_DIR' directory."
    cd $CLONE_DIR
    git pull
    cd ..
fi

cp -r $DOC_DIR/* $CLONE_DIR/
cp $README $CLONE_DIR/

cd $CLONE_DIR

git add --all .

if git diff --cached --quiet; then
    echo "No changes to the documentation to commit."
    exit 0
else
    echo "Changes detected, preparing to commit."
fi

git config user.name "MVS-source"
git config user.email "victor-michael.smith@epitech.eu"

git commit -m "$COMMIT_MESSAGE"

git push origin $TARGET_BRANCH

echo "La documentation a été déployée."

cd ..
rm -rf $CLONE_DIR
