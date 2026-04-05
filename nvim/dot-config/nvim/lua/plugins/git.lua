---@type Plugin
return {
    {
        src = "gh:NeogitOrg/neogit",
        dependencies = {
            "gh:nvim-lua/plenary.nvim",
            "gh:nvim-telescope/telescope.nvim",
        },
        setup = function()
            require("neogit").setup({
                disable_hint = true,
                graph_style = "unicode",
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
            })
        end
    },
    {
        src = "gh:esmuellert/codediff.nvim"
    },
    {
        src = "gh:lewis6991/gitsigns.nvim"
    }
}
