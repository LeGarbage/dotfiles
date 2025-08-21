return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        'nvim-telescope/telescope-ui-select.nvim',
    },
    config = function()
        local actions = require("telescope.actions")
        require('telescope').setup {
            defaults = {
                mappings = {
                    i = {
                        ["<esc>"] = actions.close
                    },
                },
            },

            extensions = {
                ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
                ["fzf"] = {},
            }
        }
        require('telescope').load_extension('fzf')
        require('telescope').load_extension('ui-select')
    end,
}
