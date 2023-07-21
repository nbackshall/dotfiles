#!/usr/bin/env bash

set -e

source "$(pwd)/scripts/util.sh"

DEBIAN_FRONTEND=noninteractive

do_install() {
    local packages=(
        curl
        htop
        httpie
        jq
        moreutils
        python3
        tree
        unzip
        wget
        xclip
        build-essential
        cmake
        libreadline-dev
        ncurses-term
        python3-pip
        python3-venv
        unrar
        uuid-runtime
    )

    info "[pkg] Install"
    sudo apt update
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "${packages[@]}"
}

main() {
    command=$1
    case $command in
        "install")
            shift
            do_install "$@"
            ;;
        *)
            error "$(basename "$0"): '$command' is not a valid command"
            ;;
    esac
}

main "$@"
