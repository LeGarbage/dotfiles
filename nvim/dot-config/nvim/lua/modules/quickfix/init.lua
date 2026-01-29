-- Inspired by https://github.com/yorickpeterse/nvim-pqf
local M = {}

local type_mapping = {
    E = { text = "󰅚", hl = "DiagnosticSignError" },
    W = { text = "󰀪", hl = "DiagnosticSignWarn" },
    I = { text = "󰋽", hl = "DiagnosticSignInfo" },
    H = { text = "󰌶", hl = "DiagnosticSignHint" }
}

local ns = vim.api.nvim_create_namespace("quickfixinternal")

local function pad_right(string, pad_to)
    local new = string

    if pad_to == 0 then
        return string
    end

    for _ = vim.fn.strwidth(string), pad_to do
        new = new .. ' '
    end

    return new
end

local function trim_path(path)
    local fname = vim.fn.fnamemodify(path, ":p:.")

    return fname
end

local function list_items(args)
    if args.quickfix == 1 then
        return vim.fn.getqflist({ id = args.id, items = 1, qfbufnr = 1, winid = 1 })
    else
        return vim.fn.getloclist(args.winid, { id = args.id, items = 1, qfbufnr = 1, winid = 1 })
    end
end

local function apply_highlights(bufnr, highlights)
    for _, hl in ipairs(highlights) do
        vim.highlight.range(
            bufnr,
            ns,
            hl.group,
            { hl.line, hl.col },
            { hl.line, hl.end_col }
        )
    end
end

function M.format(args)
    local list = list_items(args)
    local qf_bufnr = list.qfbufnr
    local qf_winid = list.winid
    local raw_items = list.items
    local lines = {}
    local pad_to = 0

    local items = {}
    local show_sign = false

    -- If starting a new list rather that adding to an existing one, clear highlights
    if args.start_idx == 1 then
        vim.api.nvim_buf_clear_namespace(qf_bufnr, ns, 0, -1)
    end

    for i = args.start_idx, args.end_idx do
        local raw = raw_items[i]

        if raw then
            local item = {
                type = raw.type,
                text = raw.text,
                location = "",
                path_size = 0,
                line_col_size = 0,
                index = i
            }

            if type_mapping[item.type] then
                show_sign = true
            end

            if raw.bufnr > 0 then
                item.location = trim_path(vim.fn.bufname(raw.bufnr))
                item.path_size = #item.location
            end

            if raw.lnum and raw.lnum > 0 then
                local lnum = raw.lnum

                if raw.end_lnum and raw.end_lnum > 0 and raw.end_lnum ~= lnum then
                    lnum = lnum .. '-' .. raw.end_lnum
                end

                if #item.location > 0 then
                    item.location = item.location .. ' ' .. lnum
                else
                    item.location = tostring(lnum)
                end

                -- Column numbers without line numbers make no sense, and may confuse
                -- the user into thinking they are actually line numbers.
                if raw.col and raw.col > 0 then
                    local col = raw.col

                    if raw.end_col and raw.end_col > 0 and raw.end_col ~= col then
                        col = col .. '-' .. raw.end_col
                    end

                    item.location = item.location .. ':' .. col
                end

                item.line_col_size = #item.location - item.path_size
            end

            local size = vim.fn.strwidth(item.location)

            if size > pad_to then
                pad_to = size
            end

            table.insert(items, item)
        end
    end

    local highlights = {}

    for _, item in ipairs(items) do
        local line_idx = item.index - 1

        -- Quickfix items only support singe-line messages, and show newlines as
        -- funny characters. In addition, many language servers (e.g.
        -- rust-analyzer) produce super noisy multi-line messages where only the
        -- first line is relevant.
        --
        -- To handle this, we only include the first line of the message in the
        -- quickfix line.
        local text = vim.split(item.text, '\n')[1]
        local location = item.location

        text = vim.fn.trim(text)

        if text ~= '' then
            location = pad_right(location, pad_to)
        end

        local sign_conf = type_mapping[item.type]
        local sign = ' '
        local sign_hl = nil

        if sign_conf then
            sign = sign_conf.text
            sign_hl = sign_conf.hl
        end

        local prefix = show_sign and sign .. ' ' or ''
        local line = prefix .. location .. text

        if #prefix > 0 then
            -- Constrain the cursor to the main content
            vim.api.nvim_create_autocmd("CursorMoved", {
                buffer = qf_bufnr,
                group = vim.api.nvim_create_augroup("quickfixinternal", {}),
                callback = function()
                    local cursor = vim.api.nvim_win_get_cursor(qf_winid)

                    if cursor[2] < #prefix then
                        vim.api.nvim_win_set_cursor(qf_winid, { cursor[1], #prefix })
                    end
                end
            })
        end

        -- If a line is completely empty, Vim uses the default format, which
        -- involves inserting `|| `. To prevent this from happening we'll just
        -- insert an empty space instead.
        if line == '' then
            line = ' '
        end

        if show_sign and sign_hl then
            table.insert(
                highlights,
                { group = sign_hl, line = line_idx, col = 0, end_col = #sign }
            )
        end

        if item.path_size > 0 then
            table.insert(highlights, {
                group = 'Directory',
                line = line_idx,
                col = #prefix,
                end_col = #prefix + item.path_size,
            })
        end

        if item.line_col_size > 0 then
            local col_start = #prefix + item.path_size

            table.insert(highlights, {
                group = 'Number',
                line = line_idx,
                col = col_start,
                end_col = col_start + item.line_col_size,
            })
        end

        table.insert(lines, line)
    end

    -- Applying highlights has to be deferred, otherwise they won't apply to the
    -- lines inserted into the quickfix window.
    vim.schedule(function()
        apply_highlights(qf_bufnr, highlights)
    end)

    return lines
end

return M
