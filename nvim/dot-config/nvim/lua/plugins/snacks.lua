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
return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
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
                                require("session_manager").load_last_session(false)
                            end
                        },
                        { icon = " ", key = "a", desc = "Open Agenda", action = ":Org agenda a" },
                        {
                            icon = " ",
                            key = "s",
                            desc = "List Sessions",
                            action = function()
                                require("session_manager").load_session(false)
                            end
                        },
                        { icon = "󰒲 ", key = "p", desc = "Manage Plugins", action = ":Lazy" },
                        { icon = " ", key = "q", desc = "Quit NVim", action = ":qa" },
                    },
                },
                formats = {
                    key = { "%s", hl = "Special" },
                    icon = { "%s", hl = "Special" },
                    desc = { "%s", hl = "Normal" },
                },
                sections = {
                    { text = { neovim_text, hl = "Function" },                                           padding = 3 },
                    { section = "keys",                                                                  gap = 1,    padding = 2 },
                    { text = { vim.fn.system("fortune -s"), hl = "String", width = 0, align = "center" } },
                },
            },
        }
    }
}
