#!/bin/bash

SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
cd "$SCRIPT_DIR"

IMAGE=${IMAGE:-"evim"}
DOCKERFILE=${DOCKERFILE:-"${SCRIPT_DIR}/Dockerfile"}

docker build -f "$DOCKERFILE" -t "$IMAGE" .

# EOF