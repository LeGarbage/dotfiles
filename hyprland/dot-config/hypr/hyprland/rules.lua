-- Make the desktop portal behave like a dialog
hl.window_rule({
    match = {
        class = "xdg-desktop-portal-gtk"
    },
    float = true,
    size = { 900, 600 },
    stay_focused = true,
    dim_around = true
})

-- Force steam big picture to always be fullscreen
hl.window_rule({
    match = {
        initial_title = "Steam Big Picture Mode"
    },
    fullscreen = true
})

-- Ignore maximize requests from all apps. You'll probably like this.
hl.window_rule({
    match = {
        class = ".*"
    },
    suppress_event = "maximize"
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false
    },
    no_focus = true
})

-- Some QoL for rofi to make it feel nicer to use
hl.layer_rule({
    match = {
        namespace = "rofi"
    },
    dim_around = true,
    animation = "popin"
})

-- Same with ghostty dropdown terminal
hl.layer_rule({
    match = {
        namespace = "ghostty-quick-terminal"
    },
    dim_around = true,
    animation = "slide"
})
