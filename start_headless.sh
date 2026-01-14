#!/bin/bash

"""Usage: 
PRETRAINED_CHECKPOINT_ROOT=/home/xx/Documents/repos/hf_checkpoint \
OPENVLA_REPO=/home/xx/Documents/repos/openvla \
FINETUNE_DATASET_DIR=/home/xx/Documents/repos/hf_dataset \
./start_headless.sh
"""

# current folder as WORK_DIR
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
# Finetune data mounts
echo "using FINETUNE_DATASET_DIR='$FINETUNE_DATASET_DIR'"
if [ -z "$FINETUNE_DATASET_DIR" ]; then
    echo "You need to set \$FINETUNE_DATASET_DIR eg. FINETUNE_DATASET_DIR=~/finetune_data"
    exit 1
else
    echo "using FINETUNE_DATASET_DIR='$FINETUNE_DATASET_DIR'"
fi

docker run -itd --name openvla \
    --gpus all \
    --rm \
    --network=host \
    --privileged \
    --entrypoint /root/workspace/main/entrypoint.sh \
    --shm-size=16G \
    -v $PRETRAINED_CHECKPOINT_ROOT:/root/checkpoint:rw \
    -v $OPENVLA_REPO:/root/openvla:rw \
    -v $CURRENT_DIR:/root/workspace/main:rw \
    -v $FINETUNE_DATASET_DIR:/root/finetune_data:rw \
    -w /root/workspace/main \
    openvla:latest