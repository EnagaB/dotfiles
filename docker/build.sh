#!/bin/bash
set -u

root_dir=$(cd "$(dirname "${BASH_SOURCE:-$0}")/.." || exit; pwd)

image=${IMAGE:-""}
if [ -z "$image" ]; then
    image="${USER}/denv:latest"
fi
echo "image: $image"

docker build \
    -f "${root_dir}/docker/Dockerfile" \
    -t "$image" \
    --build-arg USER_NAME="$USER" \
    --build-arg GROUP_NAME="$(id -g -n "$USER")" \
    --build-arg USER_ID="$(id -u "$USER")" \
    --build-arg GROUP_ID="$(id -g "$USER")" \
    "$root_dir"
