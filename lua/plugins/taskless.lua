return {
    {
        "LeGarbage/taskless.nvim",
        -- dir = "~/projects/taskless",
        -- name = "taskless",
        -- lazy = false,
        config = function(opts)
            require("taskless").setup(opts)
        end
    }
}
