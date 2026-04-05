---@type Plugin
return {
    {
        src = "gh:Bekaboo/dropbar.nvim",
        dependencies = { "gh:nvim-tree/nvim-web-devicons" },
        setup = function()
            require("dropbar").setup({
                -- Bar is managed through Lualine
                bar = { enable = false },
                icons = {
                    kinds = {
                        symbols = require("modules.icons").symbol_icons,
                    }
                }
            })
        end
    },
    {
        src = "gh:stevearc/aerial.nvim",
        dependencies = { "gh:nvim-tree/nvim-web-devicons" },
        setup = function()
            require("aerial").setup({
                backends = {
                    ['_'] = { "lsp", "treesitter", "markdown", "asciidoc", "man" },
                },
                icons = require("modules.icons").symbol_icons,
                filter_kind = false,
                show_guides = true,
                attach_mode = "global",

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
