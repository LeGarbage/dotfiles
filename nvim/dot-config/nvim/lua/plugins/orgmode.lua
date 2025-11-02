local org_query = nil
local color_cache = {}

local function parse_org(ctx)
    if not org_query then
        org_query = vim.treesitter.query.parse(
            "org",
            [[
                (headline (stars) @headline)

                (
                    (expr) @dash
                    (#match? @dash "^-----+$")
                )

                (block
                    name: (expr) @_name
                    (#match? @_name "(SRC|src)")
                ) @codeblock

                (paragraph . (expr) @quote
                    (#eq? @quote ">")
                )

                (listitem (bullet) @list)

                (listitem (checkbox) @checkbox)

            ]]
        )
    end
    local marks = {}
    local dash_highlight = "Dash"
    local dash_string = "─"
    local quote_highlight = "Quote"
    local quote_string = "┃"
    local codeblock_highlight = "ColorColumn"
    local bullets = { "◉", "○", "✸", "✿" }
    local headline_highlights = { "Headline" }
    local list_bullet = "•"
    local checkbox_symbols = { x = { "✓", "@org.keyword.done" }, ["-"] = { "", "@org.checkbox.halfchecked" } }

    local bullet_highlights = {
        "@org.headline.level1",
        "@org.headline.level2",
        "@org.headline.level3",
        "@org.headline.level4",
        "@org.headline.level5",
        "@org.headline.level6",
        "@org.headline.level7",
        "@org.headline.level8",
    }

    local width = vim.api.nvim_win_get_width(0)

    for id, node in org_query:iter_captures(ctx.root, ctx.buf) do
        local capture = org_query.captures[id]
        ---@diagnostic disable-next-line: unused-local
        local start_row, start_column, end_row, end_column = node:range()

        if capture == "headline" then
            local get_text_function = vim.treesitter.get_node_text(node, ctx.buf)
            local level = #vim.trim(get_text_function)

            local hl_group = headline_highlights[math.min(level, #headline_highlights)]
            local bullet_hl_group = bullet_highlights[math.min(level, #bullet_highlights)]
            local virt_text = {}

            if bullets and #bullets > 0 then
                local bullet = bullets[((level - 1) % #bullets) + 1]
                virt_text[1] = {
                    string.rep(" ", level - vim.fn.strwidth(bullet)) .. bullet,
                    { hl_group, bullet_hl_group },
                }
            end

            table.insert(marks, {
                start_row = start_row,
                start_col = 0,
                opts = {
                    end_col = 0,
                    end_row = start_row + 1,
                    hl_group = hl_group,
                    virt_text = virt_text,
                    virt_text_pos = "overlay",
                    hl_eol = true,
                },
            })
        end

        if capture == "list" then
            table.insert(marks, {
                start_row = start_row,
                start_col = start_column,
                opts = {
                    virt_text = { { list_bullet, headline_highlights[1] } },
                    virt_text_pos = "overlay"
                }
            })
        end

        if capture == "checkbox" then
            local status_node = node:field('status')[1]
            if status_node then
                local status_text = vim.treesitter.get_node_text(status_node, ctx.buf)
                local status_symbol = checkbox_symbols[status_text:lower()]
                if status_symbol then
                    table.insert(marks, {
                        start_row = start_row,
                        start_col = start_column,
                        opts = {
                            virt_text = { { "[", "NonText" }, status_symbol, { "]", "NonText" } },
                            virt_text_pos = "overlay"
                        }
                    })
                end
            else
                print(end_column)
                table.insert(marks, {
                    start_row = start_row,
                    start_col = start_column,
                    opts = {
                        end_col = end_column,
                        hl_group = "NonText",
                    }
                })
            end
        end

        if capture == "dash" then
            table.insert(marks, {
                start_row = start_row,
                start_col = 0,
                opts = {
                    virt_text = { { dash_string:rep(width), dash_highlight } },
                    virt_text_pos = "overlay",
                    hl_mode = "combine",
                },
            })
        end

        if capture == "codeblock" then
            table.insert(marks, {
                start_row = start_row,
                start_col = 0,
                conceal = false,
                opts = {
                    end_col = 0,
                    end_row = end_row,
                    hl_group = codeblock_highlight,
                    hl_eol = true,
                },
            })

            local lang_node = node:field('parameter')[1]

            if not lang_node then
                table.insert(marks, {
                    start_row = start_row,
                    start_col = 0,
                    opts = {
                        conceal_lines = ""
                    },
                })
            else
                local start_line = vim.api.nvim_buf_get_lines(ctx.buf, start_row, start_row + 1, false)[1]
                local lang_text = vim.treesitter.get_node_text(lang_node, ctx.buf)
                local lang_icon, lang_color = require('nvim-web-devicons').get_icon_color_by_filetype(lang_text)

                if not color_cache[lang_color] then
                    local bg_color = vim.api.nvim_get_hl(0, { name = codeblock_highlight }).bg
                    vim.api.nvim_set_hl(0, lang_text .. "ParseOrgCode", { fg = lang_color, bg = bg_color })
                    color_cache[lang_color] = true
                end

                local spaces = string.rep(" ", #start_line - (#lang_text))
                table.insert(marks, {
                    start_row = start_row,
                    start_col = 0,
                    opts = {
                        virt_text = { { lang_icon .. " " .. lang_text .. spaces, lang_text .. "ParseOrgCode" } },
                        virt_text_pos = "overlay",
                    }
                })
            end

            table.insert(marks, {
                start_row = end_row - 1,
                start_col = 0,
                opts = {
                    conceal_lines = ""
                },
            })
        end

        if capture == "quote" then
            table.insert(marks, {
                start_row = start_row,
                start_col = start_column,
                opts = {
                    virt_text = { { quote_string, quote_highlight } },
                    virt_text_pos = "overlay",
                    hl_mode = "combine",
                },
            })
        end
    end
    return marks
end
return {
    {
        'nvim-orgmode/orgmode',
        dependencies = { "danilshvalov/org-modern.nvim" },
        event = 'VeryLazy',
        ft = { 'org' },
        config = function()
            -- Setup orgmode
            require('orgmode').setup({
                org_agenda_files = '~/org/**/*',
                org_default_notes_file = '~/org/refile.org',
                -- org_todo_keywords = { 'TODO', 'STARTED', 'WAITING', '|', 'DONE', 'CANCELLED' },
                org_startup_folded = "inherit",
                -- org_startup_indented = true,
                -- org_indent_mode_turns_on_hiding_stars = false,
                org_agenda_start_on_weekday = 7,
                calendar_week_start_day = 0,
                org_capture_templates = {
                    t = {
                        description = "Task",
                        template = "* TODO %?\n  %T\n  %U",
                    },
                    n = {
                        description = "Note",
                        template = "* %?\n  %U",
                    },
                    e = {
                        description = 'Event',
                        template = '* %?\n  %T\n  %U',
                    },
                    j = {
                        description = 'Journal',
                        template = '-----\n* %<%A %B %d, %Y>\n  %U\n  %?',
                        target = '~/org/journal/%<%Y-%m>.org',
                    }
                },

                mappings = {
                    org = {
                        ---@diagnostic disable-next-line: assign-type-mismatch
                        org_refile = false,
                    },
                },

                ui = {
                    menu = {
                        ---@diagnostic disable-next-line
                        handler = function(data)
                            require("org-modern.menu"):new({
                                window = {
                                    margin = { 1, 0, 1, 0 },
                                    padding = { 0, 1, 0, 1 },
                                    title_pos = "center",
                                    border = "single",
                                    zindex = 1000,
                                },
                                icons = {
                                    separator = "➜",
                                },
                            }):open(data)
                        end,
                    },
                    input = {
                        use_vim_ui = true
                    },
                },
            })
        end,
    },
    {
        "nvim-orgmode/telescope-orgmode.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-orgmode/orgmode",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("telescope").load_extension("orgmode")

            vim.keymap.set("n", "<leader>or", require("telescope").extensions.orgmode.refile_heading)
            vim.keymap.set("n", "<leader>of", require("telescope").extensions.orgmode.search_headings)
            vim.keymap.set("n", "<leader>oi", require("telescope").extensions.orgmode.insert_link)
        end,
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons", "nvim-orgmode/orgmode" },
        ft = { "markdown", "org" },
        opts = {
            completions = { blink = { enabled = true } },
            sign = {
                enabled = false,
            },
            custom_handlers = {
                org = {
                    parse = parse_org
                }
            }
        },
    },
}
