return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        branch = 'main',
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter').setup()
            languages = { 'c', 'lua', 'cpp', 'gitignore', 'html', 'css', 'javascript', 'python', 'markdown', 'cmake', 'vim', 'vimdoc', }
            require('nvim-treesitter').install(languages)
            local plug_group = vim.api.nvim_create_augroup("plug_group", { clear = true })
            vim.api.nvim_create_autocmd('FileType', {
              pattern = languages,
              group = plug_group,
              callback = function()
                  vim.treesitter.start()
                  vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
              end,
            })
        end,
    }
}
