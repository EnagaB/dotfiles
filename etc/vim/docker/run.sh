#!/bin/bash

declare -r image_name="evim"
declare -r rand8=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
# host
declare -r script_dir=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
declare -r dotvim=~/.vim
# docker
declare -r docker_work_dir=/work
declare -r docker_home=/dkrhome

IMAGE=${IMAGE:-"$image_name"}
CONTAINER_NAME=${CONTAINER_NAME:-"${image_name}_${rand8}"}
WORK_DIR=${WORK_DIR:-$(pwd)}
VIM=${VIM:-"$dotvim"}

docker run -it --rm \
    --name "$CONTAINER_NAME" \
    -u=$(id -u):$(id -g) -v /etc/group:/etc/group:ro -v /etc/passwd:/etc/passwd:ro \
    $(for i in $(id -G "$USER"); do echo --group-add "$i"; done) \
    --mount type=bind,src="$VIM",dst="${docker_home}/.vim" \
    --mount type=bind,src="$VIM",dst="${docker_home}/.config/nvim" \
    --mount type=bind,src="${script_dir}/.bashrc",dst="${docker_home}/.bashrc" \
    --mount type=bind,src="${HOME}/.bash_history",dst="${docker_home}/.bash_history" \
    --mount type=bind,src="$WORK_DIR",dst="$docker_work_dir" \
    -w "$docker_work_dir" \
    "$IMAGE" \
    /bin/bash

# EOF
