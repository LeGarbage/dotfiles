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
                org_todo_keywords = { 'TODO', 'STARTED', 'WAITING', '|', 'DONE', 'CANCELLED' },
                org_startup_folded = "inherit",
                org_agenda_start_on_weekday = 0,
                calendar_week_start_day = 0,
                org_capture_templates = {
                    t = {
                        description = "Task",
                        template = "* TODO %?\n %T",
                        target = '~/org/agenda.org'
                    },
                    n = {
                        description = "Note",
                        template = "* %?",
                    },
                    r = {
                        description = 'Recurring',
                        template = '* %?\n %T',
                        target = '~/org/calendar/recurring.org',
                    },
                    e = {
                        description = 'Event',
                        template = '* %?\n %T',
                        target = '~/org/calendar/events.org',
                    },
                    j = {
                        description = 'Journal',
                        template = '* %<%A %B %d, %Y>\n  %U\n  %?',
                        target = '~/org/journal/%<%Y-%m>.org',
                    }
                },

                mappings = {
                    org = {
                        ---@diagnostic disable-next-line
                        org_refile = false,
                    },
                },

                notifications = {
                    cron_enabled = true,
                    cron_notifier = function(tasks)
                        for _, task in ipairs(tasks) do
                            local title = string.format('%s (%s)', task.category, task.humanized_duration)
                            local subtitle = string.format('%s %s %s', string.rep('*', task.level), task.todo, task
                                .title)
                            local date = string.format('%s: %s', task.type, task.time:to_string())

                            -- Linux
                            if vim.fn.executable('notify-send') == 1 then
                                vim.system({
                                    'notify-send',
                                    '--icon=/home/logan/.local/share/nvim/lazy/orgmode/assets/nvim-orgmode-small.png',
                                    '--app-name=orgmode',
                                    title,
                                    string.format('%s\n%s', subtitle, date),
                                })
                            end
                        end
                    end,

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
