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
        dependencies = { "nvim-tree/nvim-web-devicons", "cbochs/grapple.nvim" },
        opts = {
            options = {
                globalstatus = true,
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
                    { 'overseer', colored = false },
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
                    {
                        icon = "󰛢",
                        function()
                            local active = "[%s]"
                            local inactive = " %s "

                            local tags = require("grapple").tags()
                            if not tags then return end

                            local status = ""
                            for i, tag in ipairs(tags) do
                                local tag_name = tostring(i)
                                if i <= 4 then
                                    tag_name = ({ 'h', 'j', 'k', 'l' })[i]
                                end
                                status = status ..
                                    string.format(vim.fn.expand("%:p") == tag.path and active or inactive, tag_name)
                            end

                            return status
                        end,
                        color = "Winbar",
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
                lualine_x = {
                    {
                        icon = "󰛢",
                        function()
                            local active = "[%s]"
                            local inactive = " %s "

                            local tags = require("grapple").tags()
                            if not tags then return end

                            local status = ""
                            for i, tag in ipairs(tags) do
                                local tag_name = tostring(i)
                                if i <= 4 then
                                    tag_name = ({ 'h', 'j', 'k', 'l' })[i]
                                end
                                status = status ..
                                    string.format(vim.fn.expand("%:p") == tag.path and active or inactive, tag_name)
                            end

                            return status
                        end,
                        color = "WinbarNC",
                    },
                },
            },
            -- NOTE: Re-enable once coloring of icons gets fixed
            --
            -- tabline = {
            --     lualine_a = {
            --         {
            --             'buffers',
            --
            --             component_separators = { left = "|", right = "|" },
            --             section_separators = { left = "", right = "" },
            --
            --             buffers_color = {
            --                 active = theme.normal.b,
            --                 inactive = theme.normal.c
            --             },
            --             symbols = {
            --                 modified = " δ",
            --                 alternate_file = "ψ "
            --             },
            --         }
            --     },
            --     lualine_z = {
            --         {
            --             'tabs',
            --
            --             cond = function()
            --                 return #vim.api.nvim_list_tabpages() > 1
            --             end,
            --
            --             component_separators = { left = "|", right = "|" },
            --             section_separators = { left = "", right = "" },
            --
            --             tabs_color = {
            --                 active = theme.normal.b,
            --                 inactive = theme.normal.c
            --             },
            --         },
            --     }
            -- },
            extensions = {
                "lazy",
                "mason",
                "aerial",
                "nvim-dap-ui",
                "oil",
                "toggleterm",
            },
        }
    }
}
