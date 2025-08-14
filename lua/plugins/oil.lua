return {
    {
        "stevearc/oil.nvim",
        lazy = false,
        enabled = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            win_options = {
                signcolumn = "auto:2",
            },
            keymaps = {
                ["q"] = { "actions.close", mode = "n" },
            },
            view_options = {
                show_hidden = true,
            }
        }
    },
}
