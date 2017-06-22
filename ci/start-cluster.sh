#!/bin/bash

set -eu

START_DIR=$(pwd)
OUTPUT_DIR=${START_DIR}/OUTPUT

GRAV_EXE=$(ls $OUTPUT_DIR/linux/stardog-graviton-*)

echo $GRAV_EXE
chmod 755 $GRAV_EXE
export STARDOG_VIRTUAL_APPLIANCE_CONFIG_DIR=$OUTPUT_DIR

LAUNCH_NAME=pipetest$BUILD_ID
echo $LAUNCH_NAME > $OUTPUT_DIR/name

RELEASE_FILE=$OUTPUT_DIR/stardog-$STARDOG_VERSION.zip
LICENSE_FILE=$OUTPUT_DIR/stardog-license-key.bin

$GRAV_EXE launch --force $LAUNCH_NAME
