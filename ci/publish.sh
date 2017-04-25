#!/bin/bash

set -eu

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

if [ "X$TAG" != "X" ]; then
    DESTNAME=stardog-graviton-$TAG
fi

echo "make the dirs"
ls $EXE_OUTPUT
mkdir -p $EXE_OUTPUT/linux
mkdir -p $EXE_OUTPUT/darwin

cp $LINUX_GRAV_EXE $EXE_OUTPUT/linux/$DESTNAME
cp $DARWIN_GRAV_EXE $EXE_OUTPUT/darwin/$DESTNAME
