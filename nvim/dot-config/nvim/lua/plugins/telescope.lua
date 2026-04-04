return {
    'nvim-telescope/telescope.nvim',
    version = "*",
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        'nvim-telescope/telescope-ui-select.nvim',
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        telescope.setup({
            defaults = {
                mappings = {
                    i = {
                        ["<esc>"] = actions.close
                    },
                },
            },

            pickers = {
                buffers = {
                    sort_lastused = true,
                    sort_mru = true
                },
                find_files = {
                    hidden = true
                }
            },

            extensions = {
                ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
                fzf = {},
                aerial = {},
                fidget = {}
            }
        })
        telescope.load_extension('fzf')
        telescope.load_extension('ui-select')
        telescope.load_extension('aerial')
        telescope.load_extension('fidget')
        telescope.load_extension('session-lens')
    end,
}
