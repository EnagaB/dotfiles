#!/bin/bash

declare -r image_name="evim"
declare -r script_dir=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

IMAGE=${IMAGE:-"$image_name"}
DOCKERFILE=${DOCKERFILE:-"${script_dir}/Dockerfile"}

cd "$script_dir"
docker build -f "$DOCKERFILE" -t "$IMAGE" .

# EOF