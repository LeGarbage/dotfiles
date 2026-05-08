#!/usr/bin/env bash

entries=(window monitor region)

declare -A icons
icons[window]="window"
icons[monitor]="display"
icons[region]="region"

declare -A display
display[window]="Window"
display[monitor]="Monitor"
display[region]="Region"

if [ -n "$1" ]; then
    case "$ROFI_INFO" in
        window)
            coproc ( hyprshot -m window  > /dev/null  2>&1 )
            ;;
        monitor)
            coproc ( hyprshot -m output  > /dev/null  2>&1 )
            ;;
        region)
            coproc ( hyprshot -m region  > /dev/null  2>&1 )
            ;;
    esac
    exit 0
fi

# Don't allow custom entries
echo -e "\0no-custom\x1ftrue"

for entry in "${entries[@]}"; do
    echo -e "${display[$entry]}\0icon\x1f${icons[$entry]}\x1finfo\x1f$entry"
done
