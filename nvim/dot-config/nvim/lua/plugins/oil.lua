local detail = false
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
                ["gd"] = {
                    desc = "Toggle file detail view",
                    callback = function()
                        detail = not detail
                        if detail then
                            require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
                        else
                            require("oil").set_columns({ "icon" })
                        end
                    end
                }
            },
            view_options = {
                show_hidden = true,
                is_always_hidden = function(name)
                    return name == ".." or name == ".git"
                end
            },
            lsp_file_methods = {
                autosave_changes = "unmodified"
            },
            skip_confirm_for_simple_edits = true,
            confirmation = {
                border = "rounded"
            },
            keymaps_help = {
                border = "rounded"
            }
        }
    },
    {
        "refractalize/oil-git-status.nvim",
        dependencies = { "stevearc/oil.nvim" },
        config = true
    }
}
