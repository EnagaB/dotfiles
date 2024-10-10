run_all=false

_n_args="$#"
_args=("$@")
_invalid_args=false

if [ "$_n_args" -lt 2 ]; then
    for _arg in "${_args[@]}"; do
        case "$_arg" in
            "all") run_all=true ;;
            *) _invalid_args=true ;;
        esac
    done
else
    _invalid_args=true
fi

if $_invalid_args; then
    echo_err "ERROR: Invalid arguments."
    echo "$usage"
    exit 1
fi

unset _n_args
unset _args
unset _arg
unset _invalid_args
