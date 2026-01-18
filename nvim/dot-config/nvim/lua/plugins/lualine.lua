local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
        return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed
        }
    end
end

local colors = {
    gray1  = '#282c34',
    gray2  = '#31353f',
    gray3  = '#393f4a',
    gray4  = '#5c6370',
    gray5  = '#abb2bf',
    red    = '#e86671',
    green  = '#98c379',
    yellow = '#e5c07b',
    blue   = '#61afef',
    purple = '#c678dd',
    cyan   = '#56b6c2',
    orange = '#d19a66',
    indigo = '#7681de',
}
local theme = {
    normal = {
        a = { bg = colors.blue, fg = colors.gray2 },
        b = { bg = colors.gray3, fg = colors.gray5 },
        c = { bg = colors.gray2, fg = colors.gray4 }
    },
    insert = {
        a = { bg = colors.green, fg = colors.gray2 },
        b = { bg = colors.gray3, fg = colors.gray5 },
        c = { bg = colors.gray2, fg = colors.gray4 }
    },
    visual = {
        a = { bg = colors.purple, fg = colors.gray2 },
        b = { bg = colors.gray3, fg = colors.gray5 },
        c = { bg = colors.gray2, fg = colors.gray4 }
    },
    replace = {
        a = { bg = colors.red, fg = colors.gray2 },
        b = { bg = colors.gray3, fg = colors.gray5 },
        c = { bg = colors.gray2, fg = colors.gray4 }
    },
    command = {
        a = { bg = colors.orange, fg = colors.gray2 },
        b = { bg = colors.gray3, fg = colors.gray5 },
        c = { bg = colors.gray2, fg = colors.gray4 }
    },
    inactive = {
        a = { bg = colors.gray4, fg = colors.gray2 },
        b = { bg = colors.gray3, fg = colors.gray5 },
        c = { bg = colors.gray2, fg = colors.gray4 }
    },
}

return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                globalstatus = true,
                always_show_tabline = false,
                theme = theme,
            },
            sections = {
                lualine_b = {
                    { 'b:gitsigns_head', icon = '󰘬' },
                    function()
                        return require("direnv").statusline()
                    end,
                    {
                        'diagnostics',
                        sources = { 'nvim_diagnostic' },
                        update_in_insert = true,
                    },
                },
                lualine_c = {
                    {
                        'filename',
                        path = 1,
                        newfile_status = true,
                        symbols = { modified = 'δ', readonly = 'ϱ', unnamed = 'χ', newfile = 'ν' },
                    },
                },
                lualine_x = {
                    {
                        'lsp_status',
                        symbols = { done = '󰸞' }
                    },
                    'filetype'
                },
                lualine_y = {
                    {
                        'diff', source = diff_source
                    },
                    { 'overseer' },
                    function()
                        return vim.fn.fnamemodify(vim.fn.getcwd(), ':~:t')
                    end
                },
                lualine_z = { '%l/%L:%v' }
            },
            winbar = {
                lualine_c = {
                    {
                        function()
                            ---@diagnostic disable-next-line: undefined-field
                            return _G.dropbar()
                        end,
                        color = "Winbar",
                    },
                },
                lualine_x = {
                    {
                        function()
                            ---@diagnostic disable-next-line: undefined-field
                            return _G.orgmode.statusline()
                        end
                    },
                },
            },
            inactive_winbar = {
                lualine_c = {
                    {
                        'filename',
                        path = 1,
                        symbols = { modified = 'δ', readonly = 'ϱ', unnamed = 'χ', newfile = 'ν' },
                        draw_empty = true,
                    }
                },
            },
            tabline = {
                lualine_a = {
                    {
                        'tabs',
                        max_length = vim.o.columns,
                        use_mode_colors = true,
                        mode = 2,
                        tabs_color = {
                            inactive = 'lualine_c_inactive',
                        },
                    }
                }
            },
            extensions = {
                "lazy",
                "mason",
                "aerial",
                "nvim-dap-ui",
                "oil",
                "toggleterm",
                "overseer",
                "quickfix",
                "man"
            },
        }
    }
}
