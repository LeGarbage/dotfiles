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

-- Completely disable the Gitlab lsp so it doesn't start every time :lsp enable is run
vim.lsp.config("gitlab_duo", { filetypes = {} })

-- Show colors as colored squares
vim.lsp.document_color.enable(true, nil, { style = "virtual" })

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
            -- Toggle codelens
            vim.keymap.set("n", "<leader>dl",
                function()
                    vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled({ bufnr = 0 }), { bufnr = 0 })
                end, { desc = "Toggle codelens (buffer)" })

            vim.keymap.set("n", "<leader>dL",
                function()
                    vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled())
                end, { desc = "Toggle codelens (workspace)" })
        end

        -- Auto-format ("lint") on save.
        -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
        -- if not client:supports_method('textDocument/willSaveWaitUntil')
        --     and client:supports_method('textDocument/formatting') then
        if client:supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
                buffer = args.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
                end,
            })
        end

        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "gri", builtin.lsp_implementations, { desc = "Telescope LSP implementations" })
        vim.keymap.set("n", "grr", builtin.lsp_references, { desc = "Telescope LSP references" })
        vim.keymap.set("n", "grt", builtin.lsp_type_definitions, { desc = "Telescope LSP type definitions" })
        vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "Telescope LSP definitions" })
        vim.keymap.set("n", "go", builtin.lsp_document_symbols, { desc = "Telescope LSP symbols (buffer)" })
        vim.keymap.set("n", "gO", builtin.lsp_workspace_symbols, { desc = "Telescope LSP symbols (workspace)" })
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

-- TODO: :help LspProgress once ui2 becomes more stable
