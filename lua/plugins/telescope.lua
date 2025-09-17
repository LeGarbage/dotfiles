return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        'nvim-telescope/telescope-ui-select.nvim',
    },
    config = function()
        local actions = require("telescope.actions")
        local make_entry = require("telescope.make_entry")

        local original_gen = make_entry.gen_from_buffer

        local function buffer_entry(opts)
            local gen = original_gen(opts)
            return function(entry)
                local original = gen(entry)
                local flags = original.indicator

                if flags:find("a") and #vim.fn.win_findbuf(original.bufnr) == 0 then
                    flags = flags:gsub("a", " ")
                end

                flags = flags:gsub("%%", "θ")
                flags = flags:gsub("h", "β")
                flags = flags:gsub("a", "α")
                flags = flags:gsub("#", "ψ")
                flags = flags:gsub("+", "δ")
                flags = flags:gsub("=", "ϱ")

                original.indicator = flags
                return original
            end
        end
        make_entry.gen_from_buffer = buffer_entry
        require('telescope').setup {
            defaults = {
                mappings = {
                    i = {
                        ["<esc>"] = actions.close
                    },
                },
            },

            -- pickers = {
            --     buffers = {
            --         entry_maker = buffer_entry({})
            --     }
            -- },

            extensions = {
                ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
                ["fzf"] = {},
            }
        }
        require('telescope').load_extension('fzf')
        require('telescope').load_extension('ui-select')
    end,
}
