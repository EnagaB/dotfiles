#!/bin/bash
set -u

root_dir=$(cd "$(dirname "${BASH_SOURCE:-$0}")/.." || exit; pwd)
dkr_dir="${root_dir}/docker"
. "${dkr_dir}/src.sh"

ctr_names=( $(get_denv_container_names) )

if [ "${#ctr_names[@]}" -ne 1 ]; then
    echo "ERROR: The number of denv containers is not 1."
    exit 1
fi

ctr_name="${ctr_names[0]}"

docker exec -it "$ctr_name" bash
