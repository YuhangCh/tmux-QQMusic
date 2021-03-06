#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers.sh"

playing_icon=""
paused_icon=""
stopped_icon=""

playing_default="▶︎"
paused_default="■"
mscApp_default="spotify"

spotify_status() {
read -r -d '' SCRIPT <<'END'
set theApp to "Music"

if application theApp is running then
  tell application "Music"
    return player state as string
  end tell
end if
END

osascript -e "${SCRIPT}"
}

print_spotify_status() {
  local status=$(spotify_status)

  if [[ "$status" == "playing" ]]; then
    echo "${playing_icon}"
  elif [[ "$status" == "paused" ]]; then
    echo "${paused_icon}"
  else
    echo "${stopped_icon:-$paused_icon}"
  fi
}

update_status_icon() {
  playing_icon=$(get_tmux_option "@spotify_playing_icon" "$playing_default")
  paused_icon=$(get_tmux_option "@spotify_paused_icon" "$paused_default")
  stopped_icon=$(get_tmux_option "@spotify_stopped_icon" "$paused_default")
}

main() {
  update_status_icon
  print_spotify_status
}

main


