---@type Plugin
return {
    {
        src = "gh:neovim/nvim-lspconfig",
        dependencies = { {
            src = "gh:folke/lazydev.nvim",
            setup = function()
                require("lazydev").setup({
                    library = {
                        -- See the configuration section for more details
                        -- Load luvit types when the `vim.uv` word is found
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                })
            end
        } }
    }
}
