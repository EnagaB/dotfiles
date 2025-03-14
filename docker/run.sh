#!/bin/bash
set -u

display=:0
work_dir="$(pwd)"
dkr_work_dir="/work"
dkr_home="$HOME"
mnt_docker_socket="${MNT_DOCKER_SOCKET:-"false"}"
mnt_host="${MNT_HOST:-"false"}"
use_gpu="${USE_GPU:-"false"}"
use_gui="${USE_GUI:-"true"}"
detachkeys="ctrl-\\,ctrl-\\"

root_dir=$(cd "$(dirname "${BASH_SOURCE:-$0}")/.." || exit; pwd)
df_dir="${root_dir}/dotfiles"
runopts=(
    -it --rm
    -e "TERM=$TERM"
    -w "$dkr_work_dir"
)

image=${IMAGE:-""}
if [ -z "$image" ]; then
    image="${USER}/denv:latest"
fi
echo "image: $image"

container_name=${CONTAINER_NAME:-""}
if [ -z "$container_name" ]; then
    container_name="${image}"
    container_name="${container_name//:/-}"
    container_name="${container_name//\//-}"
    # suffix="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)"
    suffix="$(date "+%Y%m%dT%H%M%S")"
    container_name="${container_name}_${suffix}"
fi
echo "container name: $container_name"
runopts+=(
    --name "$container_name"
    -e "CONTAINER_NAME=$container_name"
)

# user
echo "user: $USER"
runopts+=(
    "-u=$(id -u):$(id -g)"
    -v /etc/group:/etc/group:ro
    -v /etc/passwd:/etc/passwd:ro
)
for group_id in $(id -G "$USER"); do
    runopts+=("--group-add" "$group_id")
done

# mount
echo "mount work directory: $work_dir -> $dkr_work_dir"
echo "mount dotfiles"
runopts+=(
    --mount "type=bind,src=${work_dir},dst=${dkr_work_dir}"
    --mount "type=bind,src=${root_dir},dst=${dkr_home}/dotfiles,readonly"
    --mount "type=bind,src=${df_dir}/.bashrc,dst=${dkr_home}/.bashrc,readonly"
    --mount "type=bind,src=${df_dir}/.bash_profile,dst=${dkr_home}/.bash_profile,readonly"
    --mount "type=bind,src=${df_dir}/.bashenv,dst=${dkr_home}/.bashenv,readonly"
    --mount "type=bind,src=${df_dir}/.dir_colors,dst=${dkr_home}/.dir_colors,readonly"
    --mount "type=bind,src=${df_dir}/.shrc.sh,dst=${dkr_home}/.shrc.sh,readonly"
    --mount "type=bind,src=${df_dir}/.shenv.sh,dst=${dkr_home}/.shenv.sh,readonly"
    --mount "type=bind,src=${df_dir}/.template,dst=${dkr_home}/.template,readonly"
    --mount "type=bind,src=${df_dir}/.vim,dst=${dkr_home}/.vim"
    --mount "type=bind,src=${df_dir}/.vim,dst=${dkr_home}/.config/nvim"
)
bash_hist="${HOME}/.bash_history"
[ -f "$bash_hist" ] && runopts+=(--mount "type=bind,src=${bash_hist},dst=${dkr_home}/.bash_history")
gitconf="${HOME}/.gitconfig"
[ -f "$gitconf" ] && runopts+=(--mount "type=bind,src=${gitconf},dst=${dkr_home}/.gitconfig,readonly")
if "$mnt_docker_socket"; then
    dkr_skt=/var/run/docker.sock
    if [ -S "$dkr_skt" ]; then
        echo "mount docker socket"
        runopts+=(-v "${dkr_skt}:${dkr_skt}")
    fi
fi
if "$mnt_host"; then
    echo "mount host in read-only mode"
    runopts+=(--mount "type=bind,src=/,dst=/mnt/host,readonly")
fi

# GPU
if "$use_gpu"; then
    echo "use GPU"
    runopts+=(--gpus all --ipc=host --ulimit memlock=-1 --ulimit stack=67108864)
fi

# GUI
if "$use_gui"; then
    echo "use GUI (DISPLAY=${display})"
    runopts+=(
        --net host
        --env DISPLAY="$display"
    )
    mnt_wslg=/mnt/wslg
    if [ -d "$mnt_wslg" ]; then
        runopts+=(--mount "type=bind,src=/mnt/wslg/.X11-unix,dst=/tmp/.X11-unix")
    else
        runopts+=(--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw")
    fi
    xauthority="${HOME}/.Xauthority"
    [ -f "$xauthority" ] && runopts+=(--mount "type=bind,src=${xauthority},dst=${xauthority}")
fi

echo "detach key: $detachkeys"
runopts+=(--detach-keys="$detachkeys")

docker run "${runopts[@]}" "$image" /bin/bash
