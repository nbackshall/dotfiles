#!/usr/bin/env bash
set -e

source "$(pwd)/scripts/util.sh"

do_install() {
  if is_installed zsh; then
    info "[zsh] Already installed!"
    return
  fi

  info "[zsh] Install"

  if [ "$(uname)" == "Darwin" ]; then
    brew install zsh fzf ripgrep
  elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    sudo apt-get update
    sudo apt install -y zsh fzf ripgrep
  fi
}

do_configure() {
  info "[zsh] Configure"
  symlink_files "/$(pwd)/zsh" "$HOME"
  info "[zsh] Set as default shell"
  sudo chsh -s $(which zsh) $(whoami)
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

