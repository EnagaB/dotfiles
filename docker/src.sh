default_image_name="${USER}/denv:latest"

function get_denv_container_names() {
    names=$(docker container ls --format "{{.Names}}" | grep "denv")
    echo "${names[@]}"
}
