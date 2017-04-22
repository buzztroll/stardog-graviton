#!/bin/bash

set -e

SKIP=$1
export AWS_ACCESS_KEY_ID=$2
export AWS_SECRET_ACCESS_KEY=$32

STAGE_BUCKET=$4
STARDOG_VERSION=$5
BUILD_DIR=$6
OUT_DIR=$7

if [ $SKIP -eq 1 ]; then
    echo "Skipping the graviton tests"
    exit 0
fi

THIS_DIR=$(pwd)
GRAV=$(ls $STAGE_BUCKET/stardog-graviton*linux_amd64)
release=$THIS_DIR/build-dir/stardog-$STARDOG_VERSION.zip
license=$THIS_DIR/build-dir/stardog-license-key.bin
sed -e "s^@@LICENSE@@^$license^" -e "s^@@RELEASE@@^$release^" -e "s^@@VERSION@@^$STARDOG_VERSION^" graviton-repo/ci/default.json.template > build-dir/default.json

cat $BUILD_DIR/default.json
chmod 755 $THIS_DIR/$GRAV
export STARDOG_VIRTUAL_APPLIANCE_CONFIG_DIR=$THIS_DIR/$BUILD_DIR

LAUNCH_NAME=pipetest$RANDOM
echo $LAUNCH_NAME > $BUILD_DIR/name

set +e
$THIS_DIR/$GRAV launch --force $LAUNCH_NAME
rc=$?
cp -r $BUILD_DIR/* $OUT_DIR
echo "BUILD"
ls $BUILD_DIR
echo "OUT"
ls $OUT_DIR
if [ $rc -ne 0 ]; then
    echo "FAILED"
    cat $STARDOG_VIRTUAL_APPLIANCE_CONFIG_DIR/deployments/$LAUNCH_NAME/logs/graviton.log
    exit 1
fi
exit 0
