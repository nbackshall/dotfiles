#!/usr/bin/env bash

set -e

source "$(pwd)/scripts/util.sh"

DEBIAN_FRONTEND=noninteractive

do_install() {
    local shared_packages=(
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
    )

    info "[pkg] Install"

    if [ "$(uname)" == "Darwin" ]; then
        brew install "${shared_packages[@]}"
        brew install --cask font-hack-nerd-font
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        local deb_packages=(
            build-essential
            cmake
            dconf-cli
            libreadline-dev
            ncurses-term
            python3-pip
            units
            unrar
            uuid-runtime
        )
        local rpm_packages=(
            cmake
            readline-devel
            ncurses
            python3-pip
            units
            unrar
        )
        if is_installed apt-get; then
            pkg_install "${shared_packages[@]}"
            pkg_install "${deb_packages[@]}"
        elif is_installed dnf || is_installed yum; then
            pkg_install "${shared_packages[@]}"
            pkg_install "${rpm_packages[@]}"
        fi
    fi
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
