#!/bin/bash


THIS_DIR=`dirname $0`
cd $THIS_DIR/..
BASE_DIR=`pwd`
BIN_DIR=$BASE_DIR/bin

if [ "X$GRAVITON_FORCE_TAG" == "X" ]; then
    branch=$(git rev-parse --abbrev-ref HEAD)
    v=$(git describe --abbrev=0 --tags ${branch} 2> /dev/null)
    if [ $? -ne 0 ]; then
        v="0.0.0"
    fi
else
    v=$GRAVITON_FORCE_TAG
fi
which go-bindata
if [ $? -ne 0 ]; then
    go get -u github.com/jteeuwen/go-bindata/...
fi
set -e
t=$(git rev-parse HEAD)
echo $v+$t > etc/version

export PATH=$GOPATH/bin:$PATH

go-bindata -prefix aws -o aws/data.go -pkg aws aws/etc/...
go-bindata -o data.go -pkg main etc/...

go install github.com/stardog-union/stardog-graviton
