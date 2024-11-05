#!/bin/bash
SCROLL_BUFFER=()
SCROLL_LINES=${SCROLL_LINES:-10}
SCROLL_RUNNING=false

SCROLL_FADED="\033[90m"
SCROLL_RESET="\033[0m"

CLEAR_LINE="\033[K"  # ANSI escape code to clear the current line
UP_ONE_LINE="\033[A" # ANSI escape code to move the cursor up one line
HIDE_CURSOR="\033[?25l" # ANSI escape code to hide the cursor
SHOW_CURSOR="\033[?25h" # ANSI escape code to show the cursor

cleanup_scroll() {
  SCROLL_RUNNING=false
  destroy_scroll
}

trap cleanup_scroll SIGINT SIGTERM SIGHUP

initialize_scroll() {
  SCROLL_BUFFER=()
  SCROLL_RUNNING=true
  printf "${HIDE_CURSOR}"
  for ((i = 0; i < SCROLL_LINES; i++)); do
    SCROLL_BUFFER+=(" ")
    echo
  done
}

clear_lines() {
  local n=$1
  for ((i = 0; i < n; i++)); do
    printf "${CLEAR_LINE}"
    printf "${UP_ONE_LINE}"
  done
  printf "${CLEAR_LINE}"
}

update_scroll() {
  local line=$1
  SCROLL_BUFFER+=("$line")
  if (( ${#SCROLL_BUFFER[@]} > SCROLL_LINES )); then
    SCROLL_BUFFER=("${SCROLL_BUFFER[@]:1}")
  fi
  clear_lines $SCROLL_LINES
  for line in "${SCROLL_BUFFER[@]}"; do
    echo -e "${SCROLL_FADED}${line}${SCROLL_RESET}"
  done
}

destroy_scroll() {
  clear_lines $SCROLL_LINES
  printf "${SHOW_CURSOR}"
}

scroll_output() {
  local cmd=$1
  shift
  local args=("$@")

  initialize_scroll

  output=$($cmd "${args[@]}" 2>&1)
  exit_code=$?

  while IFS= read -r line || [[ -n "$line" ]]; do
    if ! $SCROLL_RUNNING; then
      break
    fi
    update_scroll "$line"
    sleep 0.005
  done < <(echo "$output")

  cleanup_scroll

  return $exit_code
}
