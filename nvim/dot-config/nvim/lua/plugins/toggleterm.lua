---@type Plugin
return {
    {
        src = "gh:akinsho/toggleterm.nvim",
        setup = function()
            require("toggleterm").setup({
                close_on_exit = true,
                shade_terminals = false,
                open_mapping = [[<C-\>]],
                float_opts = {
                    border = "rounded",
                    title_pos = "center",
                },
                winbar = {
                    enabled = true,
                    name_formatter = function(term)
                        local exe = vim.fn.fnamemodify(term.display_name or vim.split(term.name, ";")[1], ":t")
                        return string.format("%d:%s", term.id, exe)
                    end
                }
            })
        end
    }
}
