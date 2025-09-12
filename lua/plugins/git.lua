return {
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim",
        },
        opts = {
            graph_style = "kitty",
            kind = "split_above_all",
            signs = {
                -- { CLOSED, OPENED }
                hunk = { "", "" },
                item = { "", "" },
                section = { "", "" },
            },
        }
    }
}
