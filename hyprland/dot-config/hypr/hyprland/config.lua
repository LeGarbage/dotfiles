hl.config({
    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 2,

        col = {
            active_border = "rgb(61afef)",
            inactive_border = "rgb(5c6370)"
        },

        -- Please see https://wiki.hypr.land/Configuring/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle"
    },
    decoration = {
        blur = {
            enabled = false
        },
        shadow = {
            enabled = false
        }
    },
    input = {
        repeat_rate = 30,
        repeat_delay = 300,

        tablet = {
            output = "current",
            relative_input = true
        }
    },
    misc = {
        force_default_wallpaper = 0,  -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
        focus_on_activate = true,
        disable_splash_rendering = true
    },
    xwayland = {
        force_zero_scaling = true
    }
})
