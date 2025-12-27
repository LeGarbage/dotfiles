#!/usr/bin/env bash

AC_PATH="/sys/class/power_supply/ACAD/online"
TARGET_MONITOR="HDMI-A-1"
CONFIG_FILE="$HOME/.local/share/Steam/steamapps/common/wallpaper_engine/config.json"
HYPRLAND_SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

set_wallpaper() {
        if [[ "$1" == "$TARGET_MONITOR" ]]; then
            DAY_INDEX=$(date +%w)

            # Parse the config.json to get the file for today from playlist "Playlist"
            WALLPAPER_PATH=$(jq -r --argjson day "$DAY_INDEX" '
                .steamuser.general
              .playlists[] 
              | select(.name == "Playlist") 
              | .items[$day]' "$CONFIG_FILE")

            WALLPAPER_PATH=${WALLPAPER_PATH##*:}

            WALLPAPER_ID=$(basename "$(dirname "$WALLPAPER_PATH")")

            linux-wallpaperengine --screen-root "$1" --bg "$WALLPAPER_ID" --silent --scaling fill &
        fi
}

start_wallpapers() {
    for MONITOR in $(hyprctl -j monitors | jq -r ".[].name"); do
        set_wallpaper "$MONITOR"
    done
}

# pause_wallpapers() {
#     pkill -STOP -f linux-wallpaperengine
# }
#
# continue_wallpapers() {
#     pkill -CONT -f linux-wallpaperengine
# }

stop_wallpapers() {
    pkill -SIGINT -f linux-wallpaperengine
}

# watch_battery() {
#     # Do an initial chack incase the computer is unplugged on startup
#     if [ "$(cat $AC_PATH)" -eq 1 ]; then
#         continue_wallpapers
#     else
#         pause_wallpapers
#     fi
#
#     acpi_listen | while read -r event; do
#         if echo "$event" | grep -q "ac_adapter"; then
#             if [ "$(cat $AC_PATH)" -eq 1 ]; then
#                 continue_wallpapers
#             else
#                 pause_wallpapers
#             fi
#         fi
#     done
# }

watch_monitors() {
    socat - UNIX-CONNECT:"$HYPRLAND_SOCKET" | while read -r event; do
        case "$event" in
            monitoradded*|monitorremoved*|monitorchanged*)
               MONITORS=$(hyprctl -j monitors | jq -r ".[].name")
               for PID in $(pgrep -f "linux-wallpaperengine --screen-root "); do
                    MON=$(ps -o args= -p "$PID" | grep -oP '(?<=--screen-root )\S+')
                    if ! echo "$MONITORS" | grep -qx "$MON"; then
                        kill "$PID"
                    fi
               done

                for MONITOR in $MONITORS; do
                    if ! pgrep -f "linux-wallpaperengine --screen-root $MONITOR" >/dev/null; then
                        set_wallpaper "$MONITOR"
                    fi
                done
                ;;
        esac
    done
}

case "$1" in
    start)
        start_wallpapers
        # watch_battery &
        watch_monitors &
        ;;
    stop)
        stop_wallpapers
        ;;
esac
