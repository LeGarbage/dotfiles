---@type Plugin
return {
    {
        src = "gh:MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "gh:nvim-tree/nvim-web-devicons", "gh:nvim-treesitter/nvim-treesitter" },
        setup = function()
            require("render-markdown").setup({
                completions = { lsp = { enabled = true } },
                render_modes = true,
                sign = {
                    enabled = false,
                },
                code = {
                    width = "block",
                    left_pad = 1,
                    right_pad = 4,
                    border = "thick",
                    language_border = " ",
                    language_left = "",
                    language_right = "",
                },
                heading = {
                    backgrounds = {},
                    foregrounds = {
                        "Title",
                        "Constant",
                        "Identifier",
                        "Statement",
                        "PreProc",
                        "Type",
                        "Special",
                        "String",
                    },
                },
                html = {
                    comment = {
                        conceal = false
                    }
                },
                link = {
                    footnote = {
                        icon = " "
                    }
                },
                overrides = {
                    buftype = {
                        nofile = {
                            anti_conceal = { enabled = false },
                            code = { border = "hide", language = false }
                        }
                    }
                }
            })
        end
    }
}
