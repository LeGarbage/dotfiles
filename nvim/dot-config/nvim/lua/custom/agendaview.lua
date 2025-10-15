local M = {}

function M.AgendaView()
    vim.o.number = false
    vim.o.ruler = false
    vim.o.mouse = ""
    require('lualine').hide({
        place = { 'statusline', 'tabline', 'winbar' },
        unhide = false
    })
    vim.o.laststatus = 0

    require('fishtank').setup({ screensaver = { enabled = false } })
    ---@diagnostic disable-next-line: undefined-field, undefined-global
    Org.agenda.a()
    vim.wait(100)
    vim.cmd("only")
    print()
end

return M
