return {
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        opts = {
            disable_hint = true,
            graph_style = "ascii",
            initial_branch_name = "main",
            kind = "split_above_all",
            process_spinner = true,
            commit_editor = {
                kind = "floating",
                show_staged_diff = false,
            },
            commit_select_view = {
                kind = "floating",
            },
            log_view = {
                kind = "floating",
            },
            reflog_view = {
                kind = "floating",
            },
            stash = {
                kind = "floating",
            },
            refs_view = {
                kind = "floating",
            },
            signs = {
                -- { CLOSED, OPENED }
                hunk = { "", "" },
                item = { "", "" },
                section = { "", "" },
            },
        }
    },
    {
        "esmuellert/codediff.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        cmd = "CodeDiff",
    },
    {
        "lewis6991/gitsigns.nvim"
    }
}
