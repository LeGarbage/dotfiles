return {
    {
        "NotAShelf/direnv.nvim",
        config = function()
            require("direnv").setup({
                statusline = {
                    enabled = true,
                    icon = "󰇧 "
                },

                keybindings = {
                    allow = "<leader>ea",
                    deny = "<leader>ed",
                    reload = "<leader>er",
                    edit = "<leader>ee",
                },

            })
        end,
    }
}
