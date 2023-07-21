#!/usr/bin/env bash

info() {
    printf "\033[36m%s\033[0m\n" "$*" >&2
}

warn() {
    printf "\033[33mWarning: %s\033[0m\n" "$*" >&2
}

error() {
    printf "\033[31mError: %s\033[0m\n" "$*" >&2
    exit 1
}

is_installed() {
    type "$1" > /dev/null 2>&1
}

# Function to create symbolic links for files in a directory
symlink_files() {
  local source_directory="$1"
  local target_directory="$2"

  # Check if source directory exists
  if [[ ! -d "$source_directory" ]]; then
    echo "Source directory not found: $source_directory"
    exit 1
  fi

  # Check if target directory exists
  if [[ ! -d "$target_directory" ]]; then
    echo "Target directory not found: $target_directory"
    exit 1
  fi

  # Create symbolic links for files (including hidden files) in the source directory
  find "$source_directory" -type f -exec ln -sf {} "$target_directory" \;

  echo "Symbolic links created successfully!"
}
