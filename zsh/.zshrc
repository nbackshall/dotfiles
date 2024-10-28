# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load Antigen
source ~/antigen.zsh

# Load Antigen configurations
antigen init ~/.antigenrc

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/opt/google-cloud-sdk/path.zsh.inc' ]; then . '/opt/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/opt/google-cloud-sdk/completion.zsh.inc' ]; then . '/opt/google-cloud-sdk/completion.zsh.inc'; fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

install-nvim() {
  rm ~/.local/bin/nvim || true
  if [[ -n $1 && $1 == "nightly" ]]; then
    wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -O ~/.local/bin/nvim
  else
    wget https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -O ~/.local/bin/nvim
  fi
  chmod +x ~/.local/bin/nvim
}


install_nvim_in_container() {
  local container_name=$1

  if [ "$(docker exec $container_name sh -c 'if [ -d "$HOME/.config/nvim" ]; then echo "1"; else echo "0"; fi')" -eq 0 ]; then
    docker cp ~/.config/nvim "$container_name":$HOME/.config/
  fi

  docker exec -it $container_name bash -c "sudo wget https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -O /usr/bin/nvim && \
    sudo chmod +x /usr/bin/nvim && \
    sudo apt update && \
    sudo apt install fuse3 libfuse2"
}

fnvim() {
  # Nvim with fuzzy finder
  nvim $(rg --hidden -l "" | fzf)
}

gnvim() {
  # Nvim with fuzzy finder and rg
  local out file lineNumber
  out=$(rg --hidden -n "" | fzf)
  file=$(echo "$out" | cut -d':' -f1)
  lineNumber=$(echo "$out" | cut -d':' -f2)
  eval "nvim -c \"${lineNumber}\" $file"
}

wt() {
  if (( $# < 1 || $# > 2 )); then
    echo "Usage: wt <worktree name> [branch name]"
    return 1
  fi

  local root_dir
  root_dir=$(git rev-parse --show-toplevel)
  
  if ! [[ $1 = *(${(j:|)__fish_git_worktrees_names})* ]]; then
    if (( $# == 1 )); then
      echo "Worktree $1 does not exist, and no branch name was provided."
      return 1
    else
      git worktree add "$root_dir/$1" "$2"
    fi
  fi

  cd "$root_dir/$1"
}

[ -f ~/.zshrc.local ] && source ~/.zshrc.local
