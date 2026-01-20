vim.diagnostic.config({
    underline = {
        severity = { min = vim.diagnostic.severity.INFO }
    },
    virtual_text = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '󰅚',
            [vim.diagnostic.severity.WARN] = '󰀪',
            [vim.diagnostic.severity.INFO] = '󰋽',
            [vim.diagnostic.severity.HINT] = '󰌶',
        },
    },
    float = {
        -- focusable = false,
        style = "minimal",
        border = "rounded",
        source = false,
        header = "",
        prefix = "",
    },
    severity_sort = true,
    update_in_insert = true,
})
