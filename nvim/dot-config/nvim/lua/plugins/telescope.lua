---@type Plugin
return {
    {
        src = "gh:nvim-telescope/telescope.nvim",
        dependencies = {
            "gh:nvim-lua/plenary.nvim",
            "gh:nvim-tree/nvim-web-devicons",
            {
                src = "gh:nvim-telescope/telescope-fzf-native.nvim",
                build = function(data)
                    if data.kind == "install" or data.kind == "update" then
                        vim.system({ "make" }, { cwd = data.path })
                    end
                end
            },
            { src = "gh:nvim-telescope/telescope-ui-select.nvim" },
        },
        setup = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")

            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<esc>"] = actions.close
                        },
                    },
                    file_ignore_patterns = { ".git/" }
                },

                pickers = {
                    buffers = {
                        mappings = {
                            i = {
                                -- Double backslash switches to alternate buffer
                                ["\\"] = actions.select_default
                            },
                        },
                        sort_lastused = true,
                        sort_mru = true,
                    },
                    find_files = {
                        hidden = true
                    },
                    live_grep = {
                        additional_args = { "--hidden" }
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
}
