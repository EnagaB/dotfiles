#!/bin/bash
set -u

work_dir="$(pwd)"

root_dir=$(cd "$(dirname "${BASH_SOURCE:-$0}")/.." || exit; pwd)
df_dir="${root_dir}/dotfiles"

image=${IMAGE:-""}
if [ -z "$image" ]; then
    image="denv:latest"
fi
echo "image: $image"

container_name=${CONTAINER_NAME:-""}
if [ -z "$container_name" ]; then
    container_name="${image//:/-}"
    # suffix="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)"
    suffix="$(date "+%Y%m%dT%H%M%S")"
    container_name="${container_name}_${suffix}"
fi
echo "container name: $container_name"

dkr_home=/dkrhome
echo "docker home: $dkr_home"

set_user=(
    "-u=$(id -u):$(id -g)"
    -v /etc/group:/etc/group:ro
    -v /etc/passwd:/etc/passwd:ro
)
for group_id in $(id -G "$USER"); do
    set_user+=("--group-add" "$group_id")
done
echo "user: $USER"

dkr_work_dir="/work"
mnt_work=(--mount "type=bind,src=${work_dir},dst=${dkr_work_dir}")
echo "mount work: $work_dir -> $dkr_work_dir"

mnt_root=(--mount "type=bind,src=${root_dir},dst=${dkr_home}/dotfiles,readonly")
echo "mount dotfiles repository in read-only mode"

mnt_dotfiles=(
    --mount "type=bind,src=${df_dir}/.bashrc,dst=${dkr_home}/.bashrc,readonly"
    --mount "type=bind,src=${df_dir}/.bash_profile,dst=${dkr_home}/.bash_profile,readonly"
    --mount "type=bind,src=${df_dir}/.bashenv,dst=${dkr_home}/.bashenv,readonly"
    --mount "type=bind,src=${df_dir}/.dir_colors,dst=${dkr_home}/.dir_colors,readonly"
    --mount "type=bind,src=${df_dir}/.shrc.sh,dst=${dkr_home}/.shrc.sh,readonly"
    --mount "type=bind,src=${df_dir}/.shenv.sh,dst=${dkr_home}/.shenv.sh,readonly"
    --mount "type=bind,src=${df_dir}/.template,dst=${dkr_home}/.template,readonly"
    --mount "type=bind,src=${df_dir}/.tmux.conf,dst=${dkr_home}/.tmux.conf,readonly"
    --mount "type=bind,src=${df_dir}/.vim,dst=${dkr_home}/.vim"
    --mount "type=bind,src=${df_dir}/.vim,dst=${dkr_home}/.config/nvim"
)
echo "mount dotfiles"

bash_hist="${HOME}/.bash_history"
if [ -f "$bash_hist" ]; then
    mnt_dotfiles+=(--mount "type=bind,src=${bash_hist},dst=${dkr_home}/.bash_history")
fi

gitconf="${HOME}/.gitconfig"
if [ -f "$gitconf" ]; then
    mnt_dotfiles+=(--mount "type=bind,src=${gitconf},dst=${dkr_home}/.gitconfig,readonly")
fi

dkr_skt=/var/run/docker.sock
mnt_dkr_skt=()
if [ -S "$dkr_skt" ]; then
    mnt_dkr_skt=(-v "${dkr_skt}:${dkr_skt}")
    echo "mount docker socket"
fi

# mnt_host=(--mount "type=bind,src=/,dst=/mnt/host,readonly")
# echo "mount host in read-only mode"
mnt_host=()

detachkeys="ctrl-\\,ctrl-\\"
echo "detach key: $detachkeys"

docker run -it --rm \
    --name "$container_name" \
    "${set_user[@]}" \
    "${mnt_work[@]}" \
    "${mnt_root[@]}" \
    "${mnt_dotfiles[@]}" \
    "${mnt_dkr_skt[@]}" \
    "${mnt_host[@]}" \
    -e "TERM=$TERM" \
    -e "CONTAINER_NAME=$container_name" \
    --detach-keys="$detachkeys" \
    -w "$dkr_work_dir" \
    "$image" /bin/bash
