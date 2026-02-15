local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = true,
    lineFoldingOnly = true,
}
capabilities.textDocument.semanticTokens.multilineTokenSupport = true
capabilities.textDocument.completion.completionItem.snippetSupport = true
vim.lsp.config("*", {
    capabilities = capabilities,
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        -- Add inlay hints
        if client:supports_method('textDocument/inlayHint') then
            -- Toggle inlay hints
            vim.keymap.set("n", "<leader>di",
                function()
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }),
                        { bufnr = 0 })
                end, { desc = "Toggle inlay hints (buffer)" })
            vim.keymap.set("n", "<leader>dI",
                function()
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                end, { desc = "Toggle inlay hints (workspace)" })
        end

        -- Add codelens
        if client:supports_method('textDocument/codeLens') then
            local enable_codelens = false
            vim.keymap.set("n", "grc",
                function()
                    vim.lsp.codelens.run()
                end, { desc = "Run codelens" })

            -- Toggle codelens
            vim.keymap.set("n", "<leader>dl",
                function()
                    enable_codelens = not enable_codelens
                    if enable_codelens then
                        vim.lsp.codelens.refresh({ bufnr = 0 })
                    else
                        vim.lsp.codelens.clear(nil, 0)
                    end
                end, { desc = "Toggle codelens" })

            vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
                buffer = args.buf,
                callback = function()
                    if enable_codelens then
                        vim.lsp.codelens.refresh()
                    end
                end,
            })
        end

        -- Auto-format ("lint") on save.
        -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
        if not client:supports_method('textDocument/willSaveWaitUntil')
            and client:supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
                buffer = args.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
                end,
            })
        end
    end,
})

vim.api.nvim_create_autocmd('LspDetach', {
    callback = function(args)
        -- Get the detaching client
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        -- Remove the autocommand to format the buffer on save, if it exists
        if client:supports_method('textDocument/formatting') then
            vim.api.nvim_clear_autocmds({
                event = 'BufWritePre',
                buffer = args.buf,
                group = 'my.lsp',
            })
        end
    end,
})
