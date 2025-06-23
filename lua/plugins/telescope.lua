return {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-fzy-native.nvim', },
    config = function()
        local actions = require("telescope.actions")
        require('telescope').setup {
            defaults = {
                mappings = {
                    i = {
                        ["<esc>"] = actions.close
                    },
                },
            }
        }
        require('telescope').load_extension('fzy_native')
    end,
}
