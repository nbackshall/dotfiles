#!/usr/bin/env bash
set -e

source "$(pwd)/scripts/util.sh"

do_install() {
  if is_installed nvim; then
    info "[nvim] Already installed!"
    return
  fi

  info "[nvim] Install"

  sudo wget https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -O /usr/bin/nvim
  sudo chmod +x /usr/bin/nvim
  sudo apt-get update
  sudo apt-get install fuse3 libfuse2 -y
}

do_configure() {
  info "[nvim] Configure"
  mkdir -p $HOME/.config
  ln -sf "/$(pwd)/nvim/config/nvim" "$HOME/.config"
}

main() {
    command=$1
    case $command in
        "install")
            shift
            do_install "$@"
            ;;
        "configure")
            shift
            do_configure "$@"
            ;;
        *)
            error "$(basename "$0"): '$command' is not a valid command"
            ;;
    esac
}

main "$@"
