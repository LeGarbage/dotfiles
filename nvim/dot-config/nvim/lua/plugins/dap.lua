return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            { "jay-babu/mason-nvim-dap.nvim", dependencies = { "mason-org/mason.nvim" } },
            "theHamsta/nvim-dap-virtual-text",
            "Weissle/persistent-breakpoints.nvim",
        },
        config = function()
            local dap = require("dap")
            local ui = require("dapui")
            local mason_dap = require("mason-nvim-dap")

            require("nvim-dap-virtual-text").setup({ all_references = true })

            require("persistent-breakpoints").setup({
                load_breakpoints_event = { "BufReadPost" },
            })

            ui.setup()
            dap.listeners.before.attach.dapui_config = function()
                ui.open()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false)
            end
            dap.listeners.before.launch.dapui_config = function()
                ui.open()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false)
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                ui.close()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false)
            end
            dap.listeners.before.event_exited.dapui_config = function()
                ui.close()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false)
            end

            vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })

            mason_dap.setup({
                ensure_installed = {},
                automatic_installation = true,
            })

            dap.configurations.c = {
                {
                    name = "Debug",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        local pickers = require("telescope.pickers")
                        local finders = require("telescope.finders")
                        local conf = require("telescope.config").values
                        local actions = require("telescope.actions")
                        local action_state = require("telescope.actions.state")
                        return coroutine.create(function(coro)
                            local opts = {}
                            pickers
                                .new(opts, {
                                    prompt_title = "Path to executable",
                                    finder = finders.new_oneshot_job({ "fd", "--hidden", "--no-ignore", "--type", "x" },
                                        {}),
                                    sorter = conf.generic_sorter(opts),
                                    attach_mappings = function(buffer_number)
                                        actions.select_default:replace(function()
                                            actions.close(buffer_number)
                                            coroutine.resume(coro, action_state.get_selected_entry()[1])
                                        end)
                                        return true
                                    end,
                                })
                                :find()
                        end)
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                },
            }
            dap.configurations.cpp = dap.configurations.c
            dap.configurations.rust = dap.configurations.c
        end,
    }
}
