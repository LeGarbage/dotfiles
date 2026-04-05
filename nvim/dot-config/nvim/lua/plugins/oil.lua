---@type Plugin
return {
    {
        src = "gh:stevearc/oil.nvim",
        dependencies = { "gh:nvim-tree/nvim-web-devicons" },
        setup = function()
            local detail = false

            require("oil").setup({
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
                constrain_cursor = "name",
                skip_confirm_for_simple_edits = true,
                confirmation = {
                    border = "rounded"
                },
                keymaps_help = {
                    border = "rounded"
                }
            })
        end
    },
    {
        src = "gh:refractalize/oil-git-status.nvim",
        dependencies = { "gh:stevearc/oil.nvim" },
        setup = function()
            require("oil-git-status").setup({})
        end
    }
}
