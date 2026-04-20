---@type Plugin
return {
    {
        src = "gh:rmagatti/auto-session",
        dependencies = { "gh:stevearc/overseer.nvim" },
        setup = function()
            require("auto-session").setup({
                suppressed_dirs = { "~" },
                bypass_save_filetypes = { "snacks_dashboard", "oil" },
                legacy_cmds = false,
                close_filetypes_on_save = { "checkhealth", "aerial" },
                show_auto_restore_notif = true,

                ---@class Data
                ---@field tasks overseer.TaskDefinition[]

                save_extra_data = function(_)
                    local task_list = require("overseer").list_tasks({ status = "RUNNING" })
                    ---@type Data
                    local data = { tasks = {} }
                    for _, task in ipairs(task_list) do
                        table.insert(data.tasks, task:serialize())
                    end
                    local json = vim.json.encode(data)

                    return json
                end,

                restore_extra_data = function(_, json)
                    -- Dispose all tasks before loading new ones
                    for _, task in ipairs(require("overseer").list_tasks()) do
                        task:dispose(true)
                    end

                    ---@type Data
                    local data = vim.json.decode(json)

                    if data.tasks then
                        for _, task in ipairs(data.tasks) do
                            require("overseer").new_task(task):start()
                        end
                    end
                end,

                session_lens = {
                    picker = "telescope",

                    mappings = {
                        delete_session = { "i", "<A-d>" },
                        alternate_session = { "i", "<A-s>" },
                        copy_session = { "i", "<A-y>" }
                    }
                }
            })
        end
    }
}
