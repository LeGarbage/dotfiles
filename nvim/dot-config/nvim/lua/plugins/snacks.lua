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
        setup = function()
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
                        { text = { neovim_text, hl = "Function" },                                           padding = 3 },
                        { section = "keys",                                                                  gap = 1,    padding = 2 },
                        { text = { vim.fn.system("fortune -s"), hl = "String", width = 0, align = "center" } },
                    },
                },
            })
        end
    }
}
