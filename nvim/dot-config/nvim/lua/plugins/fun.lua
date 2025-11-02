return {
    {
        "Eandrju/cellular-automaton.nvim",
        keys = {
            {
                "<leader>fml",
                "<cmd>CellularAutomaton make_it_rain<cr>",
            }
        }
    },
    {
        "nullromo/fishtank.nvim",
        opts = {
            screensaver = {
                -- 10 minutes
                timeout = 60 * 1000 * 10
            }
        }
    },
    {
        "seandewar/killersheep.nvim",
        opts = {},
        cmd = "KillKillKill"
    }
}
