---@type Plugin
return {
    {
        src = "gh:NotAShelf/direnv.nvim",
        setup = function()
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
                    for _, lsp in ipairs(vim.lsp.get_configs({ enabled = true })) do
                        vim.lsp.enable(lsp.name)
                    end
                end
            })
        end
    }
}
