return {
    {
        "Shatur/neovim-session-manager",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "BufReadPre",
        opts = {
            -- Disable automatic session loading
            autoload_mode = 0
        },
    }
}
