return {
    {
        "hasansujon786/nvim-navbuddy",
        dependencies = {
            "neovim/nvim-lspconfig",
            "MunifTanjim/nui.nvim",
            "nvim-telescope/telescope.nvim",
            "SmiteshP/nvim-navic",
        },
        opts = {
            window = {
                border = "rounded",
                size = "80%",
            },
            lsp = {
                auto_attach = true,
            },
            icons = {
                File = ' ',
                Module = ' ',
                Namespace = ' ',
                Package = ' ',
                Class = ' ',
                Method = ' ',
                Property = ' ',
                Field = ' ',
                Constructor = ' ',
                Enum = ' ',
                Interface = ' ',
                Function = ' ',
                Variable = ' ',
                Constant = ' ',
                String = ' ',
                Number = ' ',
                Boolean = '󰦐 ',
                Array = ' ',
                Object = ' ',
                Key = ' ',
                Null = ' ',
                EnumMember = ' ',
                Struct = ' ',
                Event = ' ',
                Operator = ' ',
                TypeParameter = ' '
            }
        }
    }
}
