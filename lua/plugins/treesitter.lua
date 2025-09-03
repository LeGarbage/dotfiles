return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        branch = 'main',
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter').setup({
                highlight = {
                    enable = true,

                    disable = { "cpp", "c", "lua", },
                },
            })
            local languages = { 'c', 'lua', 'cpp', 'gitignore', 'html', 'css', 'javascript', 'python', 'markdown',
                'cmake', 'vim', 'vimdoc', }
            require('nvim-treesitter').install(languages)
            local plug_group = vim.api.nvim_create_augroup("plug_group", { clear = true })
            vim.api.nvim_create_autocmd('FileType', {
                pattern = languages,
                group = plug_group,
                callback = function()
                    vim.treesitter.start()
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
            enabled = true,
            trim_scope = "inner",
            max_lines = 0,
            mode = "topline",
        }
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        branch = "main",
        opts = {
            textobjects = {
                select = {
                    enable = true,

                    lookahead = true,
                },
                move = {
                    enable = true,
                    set_jumps = true,
                },
            },
        },
        keys = {
            {
                "af",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
                end,
                mode = { "x", "o" }
            },
            {
                "if",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
                end,
                mode = { "x", "o" }
            },
            {
                "ac",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
                end,
                mode = { "x", "o" }
            },
            {
                "ic",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
                end,
                mode = { "x", "o" }
            },
            {
                "aa",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
                end,
                mode = { "x", "o" }
            },
            {
                "ia",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
                end,
                mode = { "x", "o" }
            },
            {
                "ak",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@block.inner", "textobjects")
                end,
                mode = { "x", "o" }
            },
            {
                "ik",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@block.outer", "textobjects")
                end,
                mode = { "x", "o" }
            },
            {
                "]f",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
                end,
                mode = { "x", "o", "n" }
            },
            {
                "]c",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
                end,
                mode = { "x", "o", "n" }
            },
            {
                "]k",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_start("@block.outer", "textobjects")
                end,
                mode = { "x", "o", "n" }
            },
            {
                "]F",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
                end,
                mode = { "x", "o", "n" }
            },
            {
                "]C",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
                end,
                mode = { "x", "o", "n" }
            },
            {
                "]K",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_end("@block.outer", "textobjects")
                end,
                mode = { "x", "o", "n" }
            },
            {
                "[f",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
                end,
                mode = { "x", "o", "n" }
            },
            {
                "[c",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
                end,
                mode = { "x", "o", "n" }
            },
            {
                "[k",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_start("@block.outer", "textobjects")
                end,
                mode = { "x", "o", "n" }
            },
            {
                "[F",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
                end,
                mode = { "x", "o", "n" }
            },
            {
                "[C",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
                end,
                mode = { "x", "o", "n" }
            },
            {
                "[K",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
                end,
                mode = { "x", "o", "n" }
            },
            {
                "f",
                function()
                    return require("nvim-treesitter-textobjects.repeatable_move").builtin_f_expr()
                end,
                mode = { "x", "o", "n" },
                expr = true,
            },
            {
                "t",
                function()
                    return require("nvim-treesitter-textobjects.repeatable_move").builtin_t_expr()
                end,
                mode = { "x", "o", "n" },
                expr = true,
            },
            {
                "F",
                function()
                    return require("nvim-treesitter-textobjects.repeatable_move").builtin_F_expr()
                end,
                mode = { "x", "o", "n" },
                expr = true,
            },
            {
                "T",
                function()
                    return require("nvim-treesitter-textobjects.repeatable_move").builtin_T_expr()
                end,
                mode = { "x", "o", "n" },
                expr = true,
            },
            {
                ";",
                function()
                    local keys = require("nvim-treesitter-textobjects.repeatable_move").repeat_last_move()
                    if keys then
                        vim.cmd(('normal! %d%s'):format(vim.v.count1, vim.keycode(keys)))
                    end
                end,
                mode = { "x", "o", "n" },
            },
            {
                ",",
                function()
                    local keys = require("nvim-treesitter-textobjects.repeatable_move").repeat_last_move_opposite()
                    if keys then
                        vim.cmd(('normal! %d%s'):format(vim.v.count1, vim.keycode(keys)))
                    end
                end,
                mode = { "x", "o", "n" },
            },

        }
    }
}
