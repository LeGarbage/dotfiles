---@type Plugin
return {
    {
        src = "gh:stevearc/aerial.nvim",
        dependencies = { "gh:nvim-tree/nvim-web-devicons" },
        setup = function()
            require("aerial").setup({
                backends = {
                    ['_'] = { "lsp", "treesitter", "markdown", "asciidoc", "man" },
                },
                icons = vim.tbl_map(function(icon)
                    return vim.trim(icon)
                end, require("modules.icons").symbol_icons),
                filter_kind = false,
                show_guides = true,
                attach_mode = "global",

                ignore = {
                    filetypes = {
                        "oil"
                    }
                },

                keymaps = {
                    ["<Tab>"] = "actions.tree_toggle"
                },

                layout = {
                    placement = "edge"
                },

                nav = {
                    win_opts = {
                        winblend = 0,
                    },
                    keymaps = {
                        ["q"] = "actions.close",
                        ["<esc>"] = "actions.close"
                    },
                    preview = true,
                    height = 0.6,
                    width = 0.3,
                }
            })
        end
    }
}
