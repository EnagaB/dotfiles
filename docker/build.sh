#!/bin/bash
set -u

root_dir=$(cd "$(dirname ${BASH_SOURCE:-$0})/.."; pwd)

image=${IMAGE:-""}
if [ -z "$image" ]; then
    image="denv:latest"
fi
echo "image: $image"

docker build \
    -f "${root_dir}/docker/Dockerfile" \
    -t "$image" \
    "$root_dir"
