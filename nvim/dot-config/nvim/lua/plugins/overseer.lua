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
                }
            })
        end
    }
}
