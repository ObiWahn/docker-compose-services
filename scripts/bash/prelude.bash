#!/usr/bin/env bash

## copy this to a new file
#current_dir="$(realpath -s "$(dirname "$(readlink -s -f "${BASH_SOURCE[0]}")")")" #this must be the script dir
#. "$current_dir/bash/prelude.bash" || { echo "failed to source prelude"; exit 13; }
##

lib_dir="$(realpath "$current_dir"/bash)"
repo_dir="$(realpath "$current_dir"/..)"
server_dir="${project_root:-"$repo_dir"}"

ferr() {
    echo "FATAL ERROR: $*"
    exit 1
}

msg () {
    echo "$*"
}

run() {
    echo "run: $*"
    "$@"
    return $?
}
