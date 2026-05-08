#!/usr/bin/env bash

# Don't allow custom entries
echo -e "\0no-custom\x1ftrue"

# If there is an entry
if [ -n "$1" ]; then
    # Was it deleted?
    if [ "$ROFI_RETV" -eq 3 ]; then
        cliphist delete <<<"$1"
    else
        # Copy it and exit
        cliphist decode <<<"$1" | wl-copy
        exit $?
    fi
fi

cliphist list |
    while IFS= read -r line; do
        preview="${line#*$'\t'}"
        printf '%s\0display\x1f%s\n' "$line" "$preview"
    done
