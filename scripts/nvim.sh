#!/usr/bin/env bash
set -e

source "$(pwd)/scripts/util.sh"

do_install() {
  if is_installed nvim; then
    info "[nvim] Already installed!"
    return
  fi

  info "[nvim] Install"

  if [ "$(uname)" == "Darwin" ]; then
    brew install neovim node
  elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    sudo wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage -O /usr/bin/nvim
    sudo chmod +x /usr/bin/nvim
    if is_installed apt-get; then
      pkg_install fuse3 libfuse2 nodejs
    elif is_installed dnf || is_installed yum; then
      pkg_install fuse fuse-libs nodejs
    fi
  fi
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
