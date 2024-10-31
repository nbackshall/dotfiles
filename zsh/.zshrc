# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Environment Variables
export PATH="$HOME/.local/bin:$PATH"
export EDITOR="nvim"
export VISUAL="$EDITOR"
export TERM="xterm-256color"

# History Configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS  # Don't record duplicates
setopt HIST_SAVE_NO_DUPS     # Don't write duplicates
setopt HIST_REDUCE_BLANKS    # Remove unnecessary blanks
setopt INC_APPEND_HISTORY    # Add commands immediately
setopt EXTENDED_HISTORY      # Add timestamps to history

# Load Antigen
if [[ -f ~/antigen.zsh ]]; then
  source ~/antigen.zsh
  antigen init ~/.antigenrc
else
  echo "Warning: antigen.zsh not found. Please install Antigen."
fi
#
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# Load powerlevel10k theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Google Cloud SDK Integration
if [ -f '/opt/google-cloud-sdk/path.zsh.inc' ]; then 
  . '/opt/google-cloud-sdk/path.zsh.inc'
fi

if [ -f '/opt/google-cloud-sdk/completion.zsh.inc' ]; then 
  . '/opt/google-cloud-sdk/completion.zsh.inc'
fi

# Aliases
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'

# Neovim Installation Functions
install-nvim() {
  local nvim_path="$HOME/.local/bin/nvim"
  local version=${1:-stable}
  
  # Create .local/bin if it doesn't exist
  mkdir -p "$HOME/.local/bin"
  
  # Remove existing nvim if present
  [[ -f "$nvim_path" ]] && rm "$nvim_path"
  
  if [[ "$version" == "nightly" ]]; then
    wget "https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage" -O "$nvim_path"
  else
    wget "https://github.com/neovim/neovim/releases/latest/download/nvim.appimage" -O "$nvim_path"
  fi
  
  chmod +x "$nvim_path"
  echo "Neovim $(nvim --version | head -n1) installed successfully!"
}

install_nvim_in_container() {
  local container_name=$1
  
  if [[ -z "$container_name" ]]; then
    echo "Usage: install_nvim_in_container <container_name>"
    return 1
  fi
  
  # Check if container exists and is running
  if ! docker ps | grep -q "$container_name"; then
    echo "Container $container_name not found or not running"
    return 1
  fi
  
  if [ "$(docker exec $container_name sh -c 'if [ -d "$HOME/.config/nvim" ]; then echo "1"; else echo "0"; fi')" -eq 0 ]; then
    echo "Copying Neovim configuration..."
    docker cp ~/.config/nvim "$container_name":$HOME/.config/
  fi
  
  echo "Installing Neovim and dependencies..."
  docker exec -it $container_name bash -c "
    sudo wget https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -O /usr/bin/nvim && \
    sudo chmod +x /usr/bin/nvim && \
    sudo apt-get update && \
    sudo apt-get install -y fuse3 libfuse2"
}

# Enhanced Neovim Functions
fnvim() {
  if ! command -v fzf >/dev/null; then
    echo "Error: fzf not installed"
    return 1
  fi
  
  if ! command -v rg >/dev/null; then
    echo "Error: ripgrep not installed"
    return 1
  fi
  
  local file=$(rg --hidden -l "" | fzf --preview 'bat --style=numbers --color=always {}')
  [[ -n "$file" ]] && nvim "$file"
}

gnvim() {
  if ! command -v fzf >/dev/null || ! command -v rg >/dev/null; then
    echo "Error: both fzf and ripgrep are required"
    return 1
  fi
  
  local selection file line
  selection=$(rg --hidden -n "" | fzf --preview 'bat --style=numbers --color=always {1} -H {2}')
  
  if [[ -n "$selection" ]]; then
    file=$(echo "$selection" | cut -d':' -f1)
    line=$(echo "$selection" | cut -d':' -f2)
    nvim "+${line}" "$file"
  fi
}

# Git Worktree Function
wt() {
  if (( $# < 1 || $# > 2 )); then
    echo "Usage: wt <worktree name> [branch name]"
    return 1
  fi

  # Check if we're in a git repository
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: not in a git repository"
    return 1
  fi

  local root_dir=$(git rev-parse --show-toplevel)
  local worktree_path="$root_dir/$1"
  
  # Check if worktree exists
  if ! git worktree list | grep -q "$worktree_path"; then
    if (( $# == 1 )); then
      echo "Worktree $1 does not exist, and no branch name was provided."
      return 1
    else
      echo "Creating new worktree '$1' with branch '$2'..."
      git worktree add "$worktree_path" "$2"
    fi
  fi

  cd "$worktree_path"
}

# Load local configurations if they exist
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

