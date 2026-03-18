#!/usr/bin/env bash
set -e

source "$(pwd)/scripts/util.sh"

do_install() {
  if is_installed zsh; then
    info "[zsh] Already installed!"
    return
  fi

  info "[zsh] Install"

  pkg_install zsh fzf ripgrep
}

do_configure() {
  info "[zsh] Configure"
  symlink_files "/$(pwd)/zsh" "$HOME"
  info "[zsh] Set as default shell"
  if is_installed chsh; then
    sudo chsh -s $(which zsh) $(whoami)
  elif is_installed usermod; then
    sudo usermod -s $(which zsh) $(whoami)
  else
    warn "chsh not found — add 'exec zsh' to your .bashrc or set shell manually"
  fi
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

