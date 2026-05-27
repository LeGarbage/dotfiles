---@diagnostic disable: assign-type-mismatch
local neovim_text =
    [[     ___          ___          ___         ___                     ___     ]] .. "\n" ..
    [[    /\__\        /\  \        /\  \       /\__\         ___       /\__\    ]] .. "\n" ..
    [[   /::|  |      /::\  \      /::\  \     /:/  /        /\  \     /::|  |   ]] .. "\n" ..
    [[  /:|:|  |     /:/\:\  \    /:/\:\  \   /:/  /         \:\  \   /:|:|  |   ]] .. "\n" ..
    [[ /:/|:|  |__  /::\~\:\  \  /:/  \:\  \ /:/__/  ___     /::\__\ /:/|:|__|__ ]] .. "\n" ..
    [[/:/ |:| /\__\/:/\:\ \:\__\/:/__/ \:\__\|:|  | /\__\ __/:/\/__//:/ |::::\__\]] .. "\n" ..
    [[\/__|:|/:/  /\:\~\:\ \/__/\:\  \ /:/  /|:|  |/:/  //\/:/  /   \/__/~~/:/  /]] .. "\n" ..
    [[    |:/:/  /  \:\ \:\__\   \:\  /:/  / |:|__/:/  / \::/__/          /:/  / ]] .. "\n" ..
    [[    |::/  /    \:\ \/__/    \:\/:/  /   \::::/__/   \:\__\         /:/  /  ]] .. "\n" ..
    [[    /:/  /      \:\__\       \::/  /     ~~~~        \/__/        /:/  /   ]] .. "\n" ..
    [[    \/__/        \/__/        \/__/                               \/__/    ]]
---@type Plugin
return {
    {
        src = "gh:folke/snacks.nvim",
        dependencies = { "gh:rmagatti/auto-session" },
        setup = function()
            require("modules.startup").counter_increment()

            local plugin_count = #vim.pack.get(nil, { info = false })
            local nvim_version = vim.version()
            local streak = require("modules.startup").get_streak()

            require("snacks").setup({
                bigfile = {
                    enabled = true
                },
                bufdelete = {
                    enabled = true
                },
                indent = {
                    animate = {
                        enabled = false,
                    },
                    filter = function(buf)
                        return vim.o.expandtab and (vim.filetype.match({ buf = buf }) ~= "org") and
                            (vim.bo[buf].buftype ~= "nofile")
                    end,
                },
                image = {
                    enabled = true,
                    doc = {
                        inline = false,
                        float = false,
                    },
                },
                -- notifier = {
                --     enabled = true,
                --     timeout = 5000,
                -- },
                statuscolumn = {
                    enabled = true,
                },
                dashboard = {
                    preset = {
                        keys = {
                            {
                                icon = " ",
                                key = "l",
                                desc = "Load Last Session",
                                action = function()
                                    require("modules.sessions").load_last_session()
                                end
                            },
                            {
                                icon = " ",
                                key = "s",
                                desc = "List Sessions",
                                action = function()
                                    require("auto-session").search()
                                end
                            },
                            {
                                icon = " ",
                                key = "f",
                                desc = "Find File",
                                action = function()
                                    require("telescope.builtin").find_files()
                                end
                            },
                            { icon = " ", key = "i", desc = "Browse Files", action = ":Oil" },
                            { icon = " ", key = "q", desc = "Quit NVim", action = ":qa" },
                        },
                    },
                    formats = {
                        key = { "%s", hl = "Special" },
                        icon = { "%s", hl = "Special" },
                        desc = { "%s", hl = "Normal" },
                    },
                    sections = {
                        {
                            text = { neovim_text, hl = "Function" }, padding = 3
                        },
                        {
                            {
                                text = {
                                    { "󰃭  ", hl = "Special" },
                                    { os.date("%A, %B %d, %Y") }
                                }
                            },
                            {
                                text = {
                                    { "  ", hl = "Special" },
                                    { vim.fn.fnamemodify(require("modules.sessions").get_last_session() or "", ":~") }
                                }
                            },
                            gap = 1,
                            padding = 2
                        },
                        {
                            section = "keys", gap = 1, padding = 2
                        },
                        {
                            text = {
                                string.format(
                                    "󰏗 %d plugins ·  v%d.%d.%d · 󰈸 %d %s",
                                    plugin_count,
                                    nvim_version.major,
                                    nvim_version.minor,
                                    nvim_version.patch,
                                    streak,
                                    streak == 1 and "day" or "days"
                                ),
                                hl = "String"
                            },
                            align = "center"
                        },
                    },
                },
            })
        end
    }
}
