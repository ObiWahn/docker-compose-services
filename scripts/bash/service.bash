#!/usr/bin/env bash

msg "setting up $service_name service"
services_dir="${server_dir}/docker/services"
service_dir="${services_dir}/$service_name"

service_name_cap=${service_name^^}

msg "service service dir: $service_dir"
msg "capitalized service name: $service_name_cap"

echo ${service_name_cap}_DIR="$service_dir"
[[ -d $service_dir ]] || ferr "$service_name service directory '$service_dir' does not exist"

check_env() {
    [[ -f $env ]] || ferr "no env file for service $service_name in: $env"
}

init_service() {
    local env_name=${1:-lab}
    msg "using envionment $env_name"


    local env_dir="$server_dir/envs/$env_name"
    if ! [[ -d "$env_dir" ]]; then
        ferr "directory for env '$env_name' does not exist in '$env_dir'"
    fi

    env_prefix="$env_dir/${service_name}-env"
    local env_final="$env_dir/${service_name}-env.final"

    cat "${env_prefix}.static"  > "$env_final" || ferr "failed to apped"
    cat "${env_prefix}.private" >> "$env_final" || ferr "failed to apped"
    echo "${service_name_cap}_DIR=$service_dir" >> "$env_final"

    env="$env_final"
}

finish_env() {
    if [[ -f "$env_prefix.overrides" ]]; then
        cat "$env_prefix.overrides" >> "$env" || ferr "failed to apped"
    fi

    msg "final env used for $service_name"
    ln -s "$env" "$service_dir/.env"
    msg "----------------------------------------------------"
    cat "$env" | grep -v -E '^#'
    msg "----------------------------------------------------"
}

cd_service () {
    cd $service_dir || ferr "could not change into $service_name service dir: $service_dir"
}
