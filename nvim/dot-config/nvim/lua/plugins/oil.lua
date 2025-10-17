return {
    {
        "stevearc/oil.nvim",
        lazy = false,
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
                is_always_hidden = function(name)
                    return vim.endswith(name, ".uid")
                end
            },
            skip_confirm_for_simple_edits = true,
            confirmation = {
                border = "rounded"
            }
        }
    },
}
