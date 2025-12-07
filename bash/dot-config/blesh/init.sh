my/vim-load-hook() {
    # Use different cursors based on the mode
    # Default
    ble-bind -m vi_cmap --cursor 0
    # Steady bar
    ble-bind -m vi_imap --cursor 6
    # Steady block
    ble-bind -m vi_nmap --cursor 2
    # Steady underline
    ble-bind -m vi_omap --cursor 4
    ble-bind -m vi_smap --cursor 2
    ble-bind -m vi_xmap --cursor 2

    # Use jk to exit insert mode
    ble-bind -m vi_imap -f 'j k' 'vi_imap/normal-mode'
    ble-bind -m vi_imap -T j 1000

    # Don't show a status in normal mode
    bleopt keymap_vi_mode_string_nmap=

    # *** PLUGINS ***
    # Surround
    ble-import lib/vim-surround
}

bind 'set completion-ignore-case on'

# Don't show exit status mark
bleopt exec_errexit_mark=

# Share history among sessions
bleopt history_share=1

# Use transient prompt
bleopt prompt_ps1_transient=always:trim
bleopt prompt_ps1_final='[$(starship module time)]─$(starship module character)'

# *** COLORS ***
# Autocompletion ghost text
ble-face auto_complete='fg=gray'
# Menu completion
ble-face region_insert='fg=cyan,bg=gray'

# Load the vim settings after it loads
blehook/eval-after-load keymap_vi my/vim-load-hook
