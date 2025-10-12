return {
    {
        "cbochs/grapple.nvim",
        dependencies = { 'nvim-telescope/telescope.nvim' },
        opts = {
            scope = "git", -- also try out "git_branch"
            status = true,
            icons = true,
        },
        config = function(opts)
            require("grapple").setup(opts)

            require("telescope").load_extension("grapple")
        end,
        keys = {
            { "<leader>ga", "<cmd>Grapple toggle<cr>",         desc = "Grapple a file" },
            { "<leader>gf", "<cmd>Telescope grapple tags<cr>", desc = "Open grapple menu" },

            { "<leader>gh", "<cmd>Grapple select index=1<cr>", desc = "Grapple to first" },
            { "<leader>gj", "<cmd>Grapple select index=2<cr>", desc = "Grapple to second" },
            { "<leader>gk", "<cmd>Grapple select index=3<cr>", desc = "Grapple to third" },
            { "<leader>gl", "<cmd>Grapple select index=4<cr>", desc = "Grapple to fourth" },
        },
    }
}
