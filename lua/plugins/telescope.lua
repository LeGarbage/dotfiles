return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        'nvim-telescope/telescope-ui-select.nvim',
    },
    config = function()
        local actions = require("telescope.actions")
        -- TODO: Fix this so that the telescope buffer symbols actually change without erroring
        --
        -- local entry_display = require("telescope.pickers.entry_display")
        -- local make_entry = require("telescope.make_entry")
        --
        -- local function buffer_entry(opts)
        --     local displayer = entry_display.create({
        --         separator = " ",
        --         items = {
        --             { width = opts.bufnr_width }, { width = 4 },
        --             { width = 1 },
        --             { remaining = true }
        --         },
        --     })
        --
        --     local function make_display(entry)
        --         local flags = entry.indicator
        --
        --         flags = flags:gsub("%%", "θ")
        --         flags = flags:gsub("h", "ω")
        --         flags = flags:gsub("a", "σ")
        --         flags = flags:gsub("#", "ψ")
        --
        --         return displayer({
        --             { tostring(entry.bufnr), "TelescopeResultsNumber" },
        --             { flags,       "TelescopeResultsComment" },
        --             entry.icon,
        --             entry.filename .. ":" .. entry.lnum
        --         })
        --     end
        --
        --     return function(entry)
        --         local original = make_entry.gen_from_buffer(opts)(entry)
        --         original.display = make_display
        --         return original
        --     end
        -- end
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
            --         entry_maker = buffer_entry {}
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
