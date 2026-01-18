return {
    {
        "kevinhwang91/nvim-bqf",
        ft = "qf",
        opts = {
            auto_resize_height = true,
            preview = {
                winblend = 0,
                show_title = false,
                show_scroll_bar = false,
            }
        }
    }
    -- {
    --     "stevearc/quicker.nvim",
    --     ft = "qf",
    --     opts = {
    --         -- trim_leading_whitespace = "all",
    --         keys = {
    --             {
    --                 "<esc>",
    --                 function()
    --                     require("quicker").close()
    --                 end
    --             },
    --             {
    --                 ">",
    --                 function()
    --                     require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
    --                 end,
    --                 desc = "Expand quickfix context",
    --             },
    --             {
    --                 "<",
    --                 function()
    --                     require("quicker").collapse()
    --                 end,
    --                 desc = "Collapse quickfix context",
    --             },
    --         },
    --     }
    -- }
}
