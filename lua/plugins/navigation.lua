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
    },
    {
        "ggandor/leap.nvim",
        config = function()
            require("leap").set_default_mappings()
            require("leap").opts.preview_filter =
                function(ch0, ch1, ch2)
                    return not (
                        ch1:match('%s') or
                        ch0:match('%a') and ch1:match('%a') and ch2:match('%a')
                    )
                end
            require('leap').opts.equivalence_classes = { ' \t\r\n', '([{', ')]}', '\'"`' }
            require('leap.user').set_repeat_keys('<enter>', '<backspace>')
        end
    }
}
