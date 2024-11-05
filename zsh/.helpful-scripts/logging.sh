#!/bin/bash

readonly RED='\033[38;2;200;60;60m'     # More muted red
readonly YELLOW='\033[38;2;200;200;60m'  # More muted yellow
readonly BLUE='\033[38;2;60;60;200m'     # More muted blue
readonly GREEN='\033[38;2;60;200;60m'    # More muted green
readonly CYAN='\033[38;2;60;200;200m'    # More muted cyan
readonly RESET='\033[0m'

colorize() {
    local color=$1
    shift
    echo -n "${color}${*}${RESET}"
}

green() { colorize "$GREEN" "$@"; }
red() { colorize "$RED" "$@"; }
yellow() { colorize "$YELLOW" "$@"; }
blue() { colorize "$BLUE" "$@"; }
cyan() { colorize "$CYAN" "$@"; }

replace_last_output() {
    # Move up one line and clear it, then execute the command and print its output
    echo -e "\033[A\033[K$(eval "$@")"
}

# Log level (0=error/success only, 1=normal, 2=verbose)
LOG_LEVEL=${LOG_LEVEL:-1}

_log() {
  local color=$1
  local level=$2
  local min_level=$3
  shift 3

  if (( ${LOG_LEVEL:-1} < min_level )); then
    return
  fi

  printf "${color}$level${RESET} $1\n" "${@:2}" >&2
}

log_error()   { _log "$RED"    "[ERROR]" 0 "$@"; }
log_success() { _log "$GREEN"  "[OK]   " 0 "$@"; }
log_warning() { _log "$YELLOW" "[WARN] " 1 "$@"; }
log_info()    { _log "$CYAN"   "[INFO] " 1 "$@"; }
log_debug()   { _log "$BLUE"   "[DEBUG]" 2 "$@"; }
