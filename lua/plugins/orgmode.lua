return {
    {
        'nvim-orgmode/orgmode',
        dependencies = { "danilshvalov/org-modern.nvim" },
        event = 'VeryLazy',
        ft = { 'org' },
        config = function()
            -- Setup orgmode
            require('orgmode').setup({
                org_agenda_files = '~/org/**/*',
                org_default_notes_file = '~/org/refile.org',
                calendar_week_start_day = 0,
                org_capture_templates = {
                    t = {
                        description = "Task",
                        template = "* TODO %?\n %u",
                    },
                    n = {
                        description = "Note",
                        template = "* %?",
                    },
                    ---@diagnostic disable-next-line
                    e = 'Event',
                    er = {
                        description = 'Recurring',
                        template = '** %?\n %T',
                        target = '~/org/calendar.org',
                        headline = 'Recurring'
                    },
                    eo = {
                        description = 'One-time',
                        template = '** %?\n %T',
                        target = '~/org/calendar.org',
                        headline = 'One-time'
                    },
                },

                ui = {
                    menu = {
                        ---@diagnostic disable-next-line
                        handler = function(data)
                            require("org-modern.menu"):new({
                                window = {
                                    margin = { 1, 0, 1, 0 },
                                    padding = { 0, 1, 0, 1 },
                                    title_pos = "center",
                                    border = "single",
                                    zindex = 1000,
                                },
                                icons = {
                                    separator = "➜",
                                },
                            }):open(data)
                        end,
                    },
                    input = {
                        use_vim_ui = true
                    },
                },
            })
        end,
    },
    {
        "nvim-orgmode/telescope-orgmode.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-orgmode/orgmode",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("telescope").load_extension("orgmode")

            vim.keymap.set("n", "<leader>or", require("telescope").extensions.orgmode.refile_heading)
            vim.keymap.set("n", "<leader>of", require("telescope").extensions.orgmode.search_headings)
            vim.keymap.set("n", "<leader>oi", require("telescope").extensions.orgmode.insert_link)
        end,
    },
    {
        "nvim-orgmode/org-bullets.nvim",
        config = function()
            require("org-bullets").setup()
        end
    },
    {
        "lukas-reineke/headlines.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-orgmode/orgmode" },
        opts = {
            org = {
                headline_highlights = {},
                fat_headlines = false,
            },
        },
    },
}
