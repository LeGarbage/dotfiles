return {
    {
        "Shatur/neovim-session-manager",
        event = "BufReadPre",
        opts = {
            -- Disable automatic session loading
            autoload_mode = 0
        },
    }
}
