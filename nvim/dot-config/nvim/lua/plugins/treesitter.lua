---@type Plugin
return {
    {
        src = "gh:nvim-treesitter/nvim-treesitter",
        build = function(data)
            -- Update treesitter parsers whenever treesitter updates
            if data.kind == "update" then
                -- Make sure that treesitter is loaded to use :TSUpdate
                if not data.active then vim.cmd.packadd("nvim-treesitter") end
                vim.cmd("TSUpdate")
            end
        end,
        setup = function()
            require("nvim-treesitter").setup({
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            })
        end,
    },
    {
        src = "gh:nvim-treesitter/nvim-treesitter-context",
        dependencies = { "gh:nvim-treesitter/nvim-treesitter" },
        setup = function()
            require("treesitter-context").setup({
                enabled = true,
                mode = "topline",
                multiwindow = true
            })
        end
    }
}
