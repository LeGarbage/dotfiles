return {
    {
        "NotAShelf/direnv.nvim",
        config = function()
            require("direnv").setup({
                statusline = {
                    enabled = true,
                    icon = "󰇧"
                },

                autoload_direnv = true,

                keybindings = {
                    allow = "<leader>ea",
                    deny = "<leader>ed",
                    reload = "<leader>er",
                    edit = "<leader>ee",
                },
            })

            vim.api.nvim_create_autocmd("User", {
                pattern = "DirenvLoaded",
                callback = function()
                    vim.cmd("LspStart")
                end
            })
        end,
    }
}
