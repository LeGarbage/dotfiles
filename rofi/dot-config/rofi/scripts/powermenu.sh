#!/usr/bin/env bash

entries=(suspend lock logout reboot shutdown)

declare -A icons
icons[suspend]="system-suspend"
icons[lock]="system-lock-screen"
icons[logout]="system-log-out"
icons[reboot]="system-restart"
icons[shutdown]="system-shutdown"

declare -A display
display[suspend]="Suspend"
display[lock]="Lock"
display[logout]="Log Out"
display[reboot]="Restart"
display[shutdown]="Shut Down"

if [ -n "$1" ]; then
    case "$ROFI_INFO" in
        suspend)
            coproc ( sleep 1 && systemctl suspend  > /dev/null  2>&1 )
            ;;
        lock)
            coproc ( sleep 1 && loginctl lock-session  > /dev/null  2>&1 )
            ;;
        logout)
            coproc ( sleep 1 && hyprshutdown -t "Logging Out..." > /dev/null  2>&1 )
            ;;
        reboot)
            coproc ( sleep 1 && hyprshutdown -t "Restarting..." --post-cmd "systemctl reboot"  > /dev/null  2>&1 )
            ;;
        shutdown)
            coproc ( sleep 1 && hyprshutdown -t "Shutting Down..." --post-cmd "systemctl poweroff"  > /dev/null  2>&1 )
            ;;
    esac
    exit 0
fi

# Don't allow custom entries
echo -e "\0no-custom\x1ftrue"

for entry in "${entries[@]}"; do
    echo -e "${display[$entry]}\0icon\x1f${icons[$entry]}\x1finfo\x1f$entry"
done
