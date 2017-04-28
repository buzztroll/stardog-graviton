#!/bin/bash

set -eu

env

TAG=$1
GRAV_REPO=$2
LINUX_STAGE=$3
DARWIN_STAGE=$4
EXE_OUTPUT=$5

echo $TAG

THIS_DIR=$(pwd)
LINUX_GRAV_EXE=$(ls $THIS_DIR/$LINUX_STAGE/stardog-graviton-*)
DARWIN_GRAV_EXE=$(ls $THIS_DIR/$DARWIN_STAGE/stardog-graviton-*)
DESTNAME=$(basename $LINUX_GRAV_EXE)

VER=$(echo $DESTNAME | sed 's/stardog-graviton-//')

if [ "X$TAG" != "X0" ]; then
    DESTNAME=stardog-graviton-$TAG
    pushd $GRAV_REPO

    git config --global user.name "Release Pipeline"
    git config --global user.email "support@stardog.com"
    echo "${GIT_SSH_KEY}" > /tmp/key
    chmod 600 /tmp/key
    export GIT_SSH_COMMAND="ssh -i /tmp/key -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
    git tag $TAG
    git tag
    echo "Push the tags $GIT_SSH_COMMAND"
    git push origin $TAG
    VER=$TAG
    popd
fi

echo "make the dirs"
ls $EXE_OUTPUT
mkdir -p $EXE_OUTPUT/$VER

cp $LINUX_GRAV_EXE stardog-graviton
zip "$EXE_OUTPUT/$VER/stardog-graviton_$VER""_linux_amd64.zip" stardog-graviton
cp $DARWIN_GRAV_EXE stardog-graviton
zip "$EXE_OUTPUT/$VER/stardog-graviton_$VER""_darwin_amd64.zip" stardog-graviton

