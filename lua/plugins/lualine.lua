local colors = {
    gray1  = '#212121',
    gray2  = '#292929',
    gray3  = '#474646',
    gray4  = '#6a6c6c',
    gray5  = '#b7bdc0',
    red    = '#de3758',
    green  = '#2f8c1c',
    yellow = '#d6a940',
    blue   = '#3663c9',
    purple = '#6333cc',
    cyan   = '#337a80',
    orange = '#bf6430',
    indigo = '#ff69b4',
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
}

return {
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                globalstatus = true,
                theme = theme,
            },
            sections = {
                lualine_b = {
                    { 'branch', icon = '󰘬' },
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
                        symbols = { modified = '●', readonly = 'ϱ' }
                    }
                },
                lualine_x = {
                    {
                        'lsp_status',
                        symbols = { done = '󰸞' }
                    }, 'filetype'
                },
                lualine_y = { function()
                    return vim.fn.fnamemodify(vim.fn.getcwd(), ':~:t')
                end },
                lualine_z = { '%p%%', '%l/%L' }
            },
            winbar = {
                lualine_c = {
                    {
                        function()
                            local navic = require("nvim-navic")
                            return navic.get_location()
                        end,
                        draw_empty = true,
                        color = "Winbar"
                    },
                },
            },
            inactive_winbar = {
                lualine_c = {
                    {
                        'filename',
                        path = 1,
                        symbols = { modified = '●', readonly = 'ϱ' },
                        draw_empty = true,
                        color = "WinbarNC",
                    }
                },
            },
            extensions = {
                "fugitive",
                "lazy",
                "mason",
                "nvim-dap-ui",
                "oil",
                "toggleterm",
            },
        }
    }
}
