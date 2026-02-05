-- Override qmlls command
vim.lsp.config.qmlls = {
    cmd = { "qmlls" }
}
vim.lsp.enable("qmlls")
