---@type Plugin
return {
    {
        src = "gh:folke/todo-comments.nvim",
        dependencies = {
            "gh:nvim-lua/plenary.nvim",
            "gh:nvim-telescope/telescope.nvim",
        },
        setup = function()
            require("todo-comments").setup()
        end
    }
}
