vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("my.hls-attach", {}),
    callback = function(event)
        local client_id = event.data.client_id
        local client = vim.lsp.get_client_by_id(client_id)
        if not client or client.name ~= "hls" then
            return
        end

        local ns = vim.lsp.diagnostic.get_namespace(client_id)
        -- Use virtual_lines instead of virtual_text
        vim.diagnostic.config({
            virtual_text = false,
            virtual_lines = true,
        }, ns)
    end,
})

vim.lsp.enable("hls")
