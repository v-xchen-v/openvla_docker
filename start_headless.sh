#!/bin/bash

"""Usage: 
  PRETRAINED_CHECKPOINT_ROOT=/home/xx/Documents/repos/hf_checkpoints \
  OPENVLA_REPO=/home/xx/Documents/repos/openvla \
  ./start_headless.sh
"""

# current folder as WORD_DIR
CURRENT_DIR=$(pwd)

set -eo pipefail

echo "using WORKSPACE_MAIN='$CURRENT_DIR'"
if [ -z "$OPENVLA_REPO" ]; then
    echo "You need to set \$OPENVLA_REPO eg. OPENVLA_REPO=~/openvla"
    exit 1
else
    echo "using OPENVLA_REPO='$OPENVLA_REPO'"
fi
if [ -z "$PRETRAINED_CHECKPOINT_ROOT" ]; then
    echo "You need to set \$PRETRAINED_CHECKPOINT_ROOT eg. PRETRAINED_CHECKPOINT_ROOT=~/checkpoint"
    exit 1
else
    echo "using PRETRAINED_CHECKPOINT_ROOT='$PRETRAINED_CHECKPOINT_ROOT'"
fi

docker run -itd --name openvla \
    --gpus all \
    --rm \
    --network=host \
    --privileged \
    --entrypoint /root/workspace/main/entrypoint.sh \
    -v $PRETRAINED_CHECKPOINT_ROOT:/root/checkpoint:rw \
    -v $OPENVLA_REPO:/root/openvla:rw \
    -v $CURRENT_DIR:/root/workspace/main:rw \
    -w /root/workspace/main \
    openvla:latest