return {
    {
        "Shatur/neovim-session-manager",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "BufReadPre",
        config = function()
            require("session_manager").setup({
                -- Disable automatic session loading
                autoload_mode = require("session_manager.config").AutoloadMode.Disabled
            })
        end,
    }
}
