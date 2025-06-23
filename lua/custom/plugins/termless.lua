local term_buf = -1
local float_window = -1
local bottom_window = -1

vim.api.nvim_create_user_command("FloatTerminal", function()
    if not vim.api.nvim_buf_is_valid(term_buf) then
        term_buf = vim.api.nvim_create_buf(false, true)
    end

    if vim.api.nvim_win_is_valid(float_window) then
        vim.api.nvim_win_hide(float_window)
    else
        local width = math.floor(vim.o.columns * 0.8)
        local height = math.floor(vim.o.lines * 0.8)

        local x = (vim.o.columns - width) / 2
        local y = (vim.o.lines - height) / 2
        float_window = vim.api.nvim_open_win(term_buf, true,
            {
                relative = 'editor',
                width = width,
                height = height,
                col = x,
                row = y,
                style = 'minimal',
                border =
                'rounded'
            })
        if vim.bo.buftype ~= 'terminal' then
            vim.cmd.term()
        end

        vim.cmd("startinsert")
    end
end, {})

vim.api.nvim_create_user_command("BottomTerminal", function()
    if not vim.api.nvim_buf_is_valid(term_buf) then
        term_buf = vim.api.nvim_create_buf(false, true)
    end

    if vim.api.nvim_win_is_valid(bottom_window) then
        vim.api.nvim_win_close(bottom_window, false)
    else
        bottom_window = vim.api.nvim_open_win(term_buf, true,
            { height = 5, style = 'minimal', split = 'below', win = -1 })
        if vim.bo.buftype ~= 'terminal' then
            vim.cmd.term()
        end

        vim.cmd("startinsert")
    end
end, {})
