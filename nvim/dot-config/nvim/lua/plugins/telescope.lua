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
        local telescope = require("telescope")

        -- Preserve original generator
        -- Returns a function that formats each entry
        local original_gen = make_entry.gen_from_buffer

        -- Custom entry generator
        local function buffer_entry(opts)
            -- Use the default generator as a baseline
            local gen = original_gen(opts)

            -- Entry generator
            return function(entry)
                local original = gen(entry)

                -- Extract the flags (active, hidden, alt, etc.)
                local flags = original.indicator

                -- Fix telescope's interpretation of hidden and active buffers
                if flags:find("a") and #vim.fn.win_findbuf(original.bufnr) == 0 then
                    flags = flags:gsub("a", " ")
                end

                -- Sub the symbols
                flags = flags:gsub("%%", "θ")
                flags = flags:gsub("h", "β")
                flags = flags:gsub("a", "α")
                flags = flags:gsub("#", "ψ")
                flags = flags:gsub("+", "δ")
                flags = flags:gsub("=", "ϱ")

                -- Inject the new flags
                original.indicator = flags
                return original
            end
        end
        -- Overwrite the old telescope buffer list generator with custom
        make_entry.gen_from_buffer = buffer_entry
        telescope.setup({
            defaults = {
                mappings = {
                    i = {
                        ["<esc>"] = actions.close
                    },
                },
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
    end,
}
