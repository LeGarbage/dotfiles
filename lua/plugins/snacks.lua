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
            indent = {
                animate = {
                    enabled = false,
                },
            },
            input = {
                enabled = true,
            },
            notifier = {
                enabled = true,
                timeout = 0,
                style = function(buf, notif, ctx)
                    ctx.opts.focusable = false
                    local title = vim.trim(notif.icon .. " " .. (notif.title or ""))
                    if title ~= "" then
                        ctx.opts.title = { { " " .. title .. " ", ctx.hl.title } }
                        ctx.opts.title_pos = "center"
                    end
                    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(notif.msg, "\n"))
                    ctx.opts.on_win = function(win)
                        local animation_time = 400
                        local notification_timeout = 5000

                        local animate = require("snacks.animate")
                        local config = vim.api.nvim_win_get_config(win.win)
                        local target_col = config.col or 0
                        local rel = config.relative
                        local row = config.row or 0
                        local width = config.width
                        local screen_width = vim.o.columns
                        vim.api.nvim_win_set_config(win.win,
                            { col = screen_width + width, row = row, relative = rel, fixed = true })

                        animate.add(screen_width + width, target_col, function(val)
                            if (not win.closed) or vim.api.nvim_win_is_valid(win.win) then
                                vim.api.nvim_win_set_config(win.win, { col = val, row = row, relative = rel })
                            else
                                animate.del("ease-in-" .. win.win)
                            end
                        end, {
                            duration = { total = animation_time },
                            fps = 60,
                            easing = "outCubic",
                            id = "ease-in-" .. win.win
                        })

                        vim.defer_fn(function()
                            animate.add(target_col, screen_width + width, function(val)
                                if (not win.closed) or vim.api.nvim_win_is_valid(win.win) then
                                    vim.api.nvim_win_set_config(win.win, { col = val, row = row, relative = rel })
                                else
                                    animate.del("ease-out-" .. win.win)
                                end
                            end, {
                                duration = { total = animation_time },
                                fps = 60,
                                easing = "outCubic",
                                id = "ease-out-" .. win.win
                            })

                            vim.defer_fn(function()
                                animate.del("ease-out-" .. win.win)
                                require("snacks.notifier").hide(win.id)
                            end, animation_time)
                        end, notification_timeout)
                    end
                end,
            },
            statuscolumn = {
                folds = {
                    open = true,
                    left = { "sign" },
                }
            },
            dashboard = {
                preset = {
                    keys = {
                        { icon = " ", key = "f", desc = "Find File", action = "<leader>ff" },
                        { icon = " ", key = "a", desc = "Open Agenda", action = ":Org agenda" },
                        {
                            icon = " ",
                            key = "s",
                            desc = "List Sessions",
                            action = function()
                                require("persistence")
                                    .select()
                            end
                        },
                        { icon = "󰒲 ", key = "l", desc = "Manage Plugins", action = ":Lazy" },
                        { icon = " ", key = "q", desc = "Quit NVim", action = ":qa" },
                    },
                },
                formats = {
                    key = { "%s", hl = "Special" },
                    icon = { "%s", hl = "Special" },
                    desc = { "%s", hl = "Normal" },
                },
                sections = {
                    { text = { neovim_text, hl = "Function" }, padding = 3 },
                    { section = "keys", gap = 1, padding = 2 },
                    { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
                    { text = { vim.fn.system("fortune -s"), hl = "String", width = 0, align = "center" } },
                },
            },
        }
    }
}
