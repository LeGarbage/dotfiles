local ft_options = {
    org = "",
    snacks_dashboard = "",
}

return {
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        opts = {
            provider_selector = function(_, filetype, _)
                return ft_options[filetype] or { "treesitter", "indent" }
            end
        }
    }
}
