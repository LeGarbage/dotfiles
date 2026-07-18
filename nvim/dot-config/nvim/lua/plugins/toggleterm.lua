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
            })
        end
    }
}
