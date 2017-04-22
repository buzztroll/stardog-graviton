#!/bin/bash

set -e

SKIP=$1
export AWS_ACCESS_KEY_ID=$2
export AWS_SECRET_ACCESS_KEY=$3

GRAV_REPO=$4
CONFIG_DIR=$5
STAGE_DIR=$6
STARDOG_VERSION=$7

if [ $SKIP -eq 1 ]; then
    echo "Skipping the graviton tests"
    exit 0
fi

THIS_DIR=$(pwd)
GRAV_PGM=$(ls $STAGE_DIR/stardog-graviton*linux_amd64)
RELEASE=$THIS_DIR/$CONFIG_DIR/stardog-$STARDOG_VERSION.zip
export STARDOG_VIRTUAL_APPLIANCE_CONFIG_DIR=$THIS_DIR/$CONFIG_DIR
LAUNCH_NAME=$(cat $CONFIG_DIR/name)

chmod 755 $THIS_DIR/$GRAV
export STARDOG_HOME=$THIS_DIR/$CONFIG_DIR
python $GRAV_REPO/ci/create_db.py $THIS_DIR/$CONFIG_DIR $RELEASE $GRAV_PGM $LAUNCH_NAME $GRAV_REPO
exit 0
