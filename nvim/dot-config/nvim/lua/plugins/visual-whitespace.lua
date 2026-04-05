---@type Plugin
return {
    {
        src = "gh:mcauley-penney/visual-whitespace.nvim",
        setup = function()
            require("visual-whitespace").setup({
                match_types = {
                    space = true,
                    tab = false,
                    nbsp = true,
                    lead = false,
                    trail = false,
                },
                list_chars = {
                    space = "·",
                    nbsp = "␣",
                },
                fileformat_chars = {
                    unix = "⏎",
                    mac = "←",
                    dos = "↙",
                }
            })
        end
    }
}
