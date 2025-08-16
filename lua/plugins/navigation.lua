local icons = {
    File = ' ',
    Module = ' ',
    Namespace = ' ',
    Package = ' ',
    Class = ' ',
    Method = ' ',
    Property = ' ',
    Field = ' ',
    Constructor = ' ',
    Enum = ' ',
    Interface = ' ',
    Function = ' ',
    Variable = ' ',
    Constant = ' ',
    String = ' ',
    Number = ' ',
    Boolean = '󰦐 ',
    Array = ' ',
    Object = ' ',
    Key = ' ',
    Null = ' ',
    EnumMember = ' ',
    Struct = ' ',
    Event = ' ',
    Operator = ' ',
    TypeParameter = ' '
}
return {
    {
        "Bekaboo/dropbar.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            icons = {
                kinds = {
                    symbols = icons,
                }
            }
        },
    },
    {
        "stevearc/aerial.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            backends = {
                ['_'] = { "lsp", "treesitter", "markdown", "asciidoc", "man" },
            },
            filter_kind = false,
            icons = icons,
            show_guides = true,
            attach_mode = "global",

            nav = {
                win_opts = {
                    winblend = 10,
                },
                keymaps = {
                    ["q"] = "actions.close",
                    ["<esc>"] = "actions.close"
                },
                preview = true,
            }
        }
    }
}
