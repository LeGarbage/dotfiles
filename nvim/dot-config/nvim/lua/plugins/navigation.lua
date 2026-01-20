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
            bar = { enable = false },
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
            icons = icons,
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
        }
    },
    {
        url = "https://codeberg.org/andyg/leap.nvim",
        config = function()
            vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
            vim.keymap.set("n", "S", "<Plug>(leap-from-window)")
            require("leap").opts.preview_filter =
                function(ch0, ch1, ch2)
                    return not (
                        ch1:match('%s') or
                        ch0:match('%a') and ch1:match('%a') and ch2:match('%a')
                    )
                end
            require('leap').opts.equivalence_classes = { ' \t\r\n', '([{', ')]}', '\'"`' }
        end
    },
    {
        "serhez/bento.nvim",
        opts = {
            main_keymap = "\\",
            lock_char = "󰌾",
            map_last_accessed = true,
            ui = {
                floating = {
                    max_rendered_buffers = 8,
                }
            },
            highlights = {
                previous = "ErrorMsg"
            }
        }
    }
}
