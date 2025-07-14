return {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-fzy-native.nvim', 'nvim-telescope/telescope-ui-select.nvim', },
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
                ["ui-select"] = { require("telescope.themes").get_dropdown({}) }
            }
        }
        require('telescope').load_extension('fzy_native')
        require('telescope').load_extension('ui-select')
    end,
}
