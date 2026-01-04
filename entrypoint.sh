#!/bin/bash

set -e

# Export environment variables
export OPENVLA_REPO=/root/openvla
export PRETRAINED_CHECKPOINT_ROOT=/root/checkpoint
export WORKSPACE_MAIN=/root/workspace/main

# Also add to bashrc for future sessions
echo "export OPENVLA_REPO=/root/openvla" >>~/.bashrc
echo "export PRETRAINED_CHECKPOINT_ROOT=/root/checkpoint" >>~/.bashrc
echo "export WORKSPACE_MAIN=/root/workspace/main" >>~/.bashrc
# you can add more customized cmds here

# Start bash shell
/bin/bash