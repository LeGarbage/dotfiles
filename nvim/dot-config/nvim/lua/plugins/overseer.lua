---@type Plugin
return {
    {
        src = "gh:stevearc/overseer.nvim",
        setup = function()
            require("overseer").setup({
                form = {
                    border = "rounded"
                },
                task_win = {
                    border = "rounded"
                },
                component_aliases = {
                    default = {
                        "on_exit_set_status",
                        "on_complete_notify",
                        "open_output"
                    }
                }
            })
        end
    }
}
