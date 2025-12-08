#!/usr/bin/env bash

if [ -z "$1" ]; then
    cliphist list |
        while IFS= read -r line; do
            preview="${line#*$'\t'}"
            printf '%s\0display\x1f%s\n' "$line" "$preview"
        done
else
    cliphist decode <<<"$1" | wl-copy
fi
