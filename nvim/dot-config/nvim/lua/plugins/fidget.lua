return {
    {
        "j-hui/fidget.nvim",
        config = function()
            local notification = require("fidget.notification")
            local default_config = {
                name = "Notifications",
                icon = "❰❰",
                ttl = 5,
                group_style = "Comment",
                icon_style = "Special",
                annote_style = "Question",
                debug_style = "DiagnosticHint",
                info_style = "DiagnosticInfo",
                warn_style = "DiagnosticWarn",
                error_style = "DiagnosticError",
                debug_annote = "DEBUG",
                info_annote = "INFO",
                warn_annote = "WARN",
                error_annote = "ERROR",
                update_hook = function(item)
                    notification.set_content_key(item)
                end
            }

            require("fidget").setup({
                progress = {
                    display = {
                        done_icon = "󰸞",
                        done_ttl = 5
                    }
                },

                notification = {
                    filter = vim.log.levels.TRACE,
                    configs = {
                        default = default_config
                    },
                    window = {
                        normal_hl = "Normal",
                        tabstop = 2
                    }
                }
            })

            ---@diagnostic disable-next-line: duplicate-set-field
            vim.notify = function(msg, level, opts)
                if opts and opts.title then
                    opts.group = opts.title
                    notification.set_config(opts.title, vim.tbl_extend("force", default_config, { name = opts.group }),
                        false)
                end

                notification.notify(msg, level, opts)
            end
        end
    }
}
