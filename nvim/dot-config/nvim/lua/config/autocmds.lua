local init_group = vim.api.nvim_create_augroup("my.init_group", {})

-- Briefly highlight text after it's yanked
vim.api.nvim_create_autocmd("TextYankPost", {
    group = init_group,
    callback = function()
        vim.hl.on_yank({ timeout = 300 })
    end
})

-- Disable spellchecking in the terminal
vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        local winid = vim.api.nvim_get_current_win()
        vim.wo[winid][0].spell = false
    end
})

vim.api.nvim_create_autocmd("FileType", {
    group = init_group,
    pattern = "*",
    callback = function(opt)
        local winid = vim.api.nvim_get_current_win()
        if not vim.bo[opt.buf].modifiable then
            vim.wo[winid][0].spell = false
        end
    end,
})

-- Treesitter stuff
vim.api.nvim_create_autocmd("FileType", {
    group = init_group,
    pattern = "*",
    callback = function(opt)
        local ts = require("nvim-treesitter")
        local lang = vim.treesitter.language.get_lang(opt.match)

        if not lang then return end

        if vim.tbl_contains(ts.get_available(), lang) then
            -- Enable treesitter
            -- This call will fail if the language does not have a parser
            local ok = pcall(vim.treesitter.start, opt.buf, lang)

            if not ok then
                ts.install(lang):await(function()
                    vim.treesitter.start(opt.buf, lang)
                end)
            end

            -- Org does its own indent handling
            -- Don't enable treesitter intents when not supported
            if opt.match ~= "org" and vim.treesitter.query.get(lang, "indents") then
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end

            local winid = vim.api.nvim_get_current_win()
            vim.wo[winid][0].foldmethod = "expr"
            vim.wo[winid][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end
    end
})

-- Set textwidth for org and markdown
vim.api.nvim_create_autocmd("FileType", {
    group = init_group,
    pattern = { "org", "markdown" },
    callback = function()
        vim.bo.textwidth = 80
    end
})

-- Disable Snacks' statuscolumn where it may cause issues
vim.api.nvim_create_autocmd("FileType", {
    group = init_group,
    pattern = { "oil", "man" },
    callback = function()
        local winid = vim.api.nvim_get_current_win()
        vim.wo[winid][0].statuscolumn = ""
        vim.wo[winid][0].spell = false
    end
})
