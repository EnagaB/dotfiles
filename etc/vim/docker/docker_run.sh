#!/bin/bash

IMAGE=${IMAGE:-"evim"}

WORK_DIR=${WORK_DIR:-$(pwd)}


docker run -it --rm \
    --name 


 --name ${CNAME} \
    -u $(id -u):$(id -g) \
    -v /etc/group:/etc/group:ro -v /etc/passwd:/etc/passwd:ro \

    --mount type=bind,src="$WORK_DIR",dst="$WORK_DIR" \
    "$IMAGE" \
    /bin/bash


# EOF