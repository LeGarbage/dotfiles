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

local function assign_workspaces()
    local monitors = hl.get_monitors()
    table.sort(monitors, function(a, b) return a.id > b.id end)

    for i = 1, 10 do
        local monitor = monitors[(i % #monitors) + 1]
        hl.workspace_rule({ workspace = tostring(i), monitor = monitor.name, default = i <= #monitors })
    end
end

hl.on("monitor.added", assign_workspaces)
hl.on("monitor.removed", assign_workspaces)
