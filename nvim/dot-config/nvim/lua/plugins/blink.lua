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

                ['<Tab>'] = { "select_next", "snippet_forward", function(cmp)
                    local c = vim.fn.col('.') - 1
                    local is_whitespace = c == 0 or vim.fn.getline('.'):sub(c, c):match('%s')

                    if is_whitespace then return end
                    cmp.show()
                    return true
                end, "fallback" },
                ['<C-n>'] = { "snippet_forward", "fallback" },
                ['<C-p>'] = { "snippet_backward", "fallback" },
                ['<S-Tab>'] = { "select_prev", "snippet_backward", "fallback" },
                ['<Enter>'] = { "accept", "fallback" },
                ['<C-s>'] = { "show_signature", "hide_signature" },
            },

            completion = {
                list = { selection = { preselect = true, auto_insert = false } },

                menu = {
                    auto_show = true,
                    max_height = 5,
                    scrollbar = false,
                    border = "none"
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
                default = function(_)
                    local success, node = pcall(vim.treesitter.get_node)
                    if success and node and vim.tbl_contains({ "comment", "line_comment", "block_comment", "string" }, node:type()) then
                        -- Only show buffer completions in comments and strings
                        return { "buffer" }
                    elseif vim.bo.filetype == "lua" then
                        -- Use lazydev completions in lua
                        return { "lazydev", "lsp", "snippets", "path" }
                    else
                        return { "lsp", "snippets", "path" }
                    end
                end,
                per_filetype = {
                    markdown = { "buffer" },
                    org = { "buffer" }
                },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        -- make lazydev completions top priority (see `:h blink.cmp`)
                        score_offset = 100,
                    },
                    snippets = {
                        should_show_items = function(ctx)
                            return ctx.trigger.initial_kind ~= "trigger_character"
                        end
                    }
                },
            },

            signature = {
                enabled = true,
                trigger = {
                    show_on_keyword = true,
                    show_on_insert = true,
                },
                window = {
                    border = "rounded"
                },
            },
            cmdline = {
                keymap = {
                    preset = 'inherit',
                    ['<Tab>'] = { "select_next", "show_and_insert" },
                    ['<Enter>'] = { "accept_and_enter", "fallback" },
                    ['<Space>'] = { function(cmp)
                        -- Accept the selected item and insert a space
                        cmp.accept({
                            callback = function()
                                vim.api.nvim_feedkeys(" ", "i", false)
                            end
                        })
                    end, "fallback" },
                },
                completion = {
                    menu = { auto_show = true, },
                    list = {
                        selection = { preselect = false, auto_insert = true },
                    },
                },
            },
        },

        opts_extend = { "sources.default" },
    },
    {
        "saghen/blink.pairs",
        version = "*",
        dependencies = "saghen/blink.download",
        opts = {
            highlights = {
                enabled = false
            }
        }
    }
}
