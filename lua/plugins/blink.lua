return {
    {
        "saghen/blink.cmp",

        dependencies = { 'rafamadriz/friendly-snippets' },

        version = "1.*",

        opts = {
            appearance = {
                kind_icons = {
                    Class = " ",
                    Color = " ",
                    Constant = " ",
                    Constructor = " ",
                    Enum = " ",
                    EnumMember = " ",
                    Event = " ",
                    Field = " ",
                    File = " ",
                    Folder = " ",
                    Function = "󰊕 ",
                    Interface = " ",
                    Keyword = " ",
                    Method = "ƒ ",
                    Module = "󰏗 ",
                    Property = " ",
                    Snippet = " ",
                    Struct = " ",
                    Text = " ",
                    Unit = " ",
                    Value = " ",
                    Variable = " ",
                },
            },
            keymap = {
                preset = "none",

                ['<Tab>'] = { "snippet_forward", "select_next", function(cmp)
                    local c = vim.fn.col('.') - 1
                    local is_whitespace = c == 0 or vim.fn.getline('.'):sub(c, c):match('%s')

                    if is_whitespace then return end
                    cmp.show()
                    return true
                end, "fallback" },

                ['<S-Tab>'] = { "snippet_backward", "select_prev", "fallback" },
                ['<Enter>'] = { "accept", "fallback" },
                ['<C-s'] = { "show_signature", "fallback" },
            },

            completion = {
                list = { selection = { preselect = true, auto_insert = false } },

                menu = {
                    auto_show = true,
                    max_height = 5,
                    scrollbar = false,
                },

                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 500,

                    window = {
                        border = "rounded",
                        scrollbar = false,
                        direction_priority = {
                            menu_south = { 'e', 'w', 's', 'n' },
                            menu_north = { 'e', 'w', 'n', 's' },
                        },
                    }
                },
                ghost_text = { enabled = true },
            },

            sources = {
                default = { "lsp", "path", "snippets" }
            },

            signature = {
                enabled = true,
                window = {
                    border = "rounded"
                }
            }
        },

        opts_extend = { "sources.default" },
    }
}
