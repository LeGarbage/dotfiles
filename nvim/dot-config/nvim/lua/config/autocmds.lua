local init_group = vim.api.nvim_create_augroup("my.init_group", {})

-- Breifly highlight text after it's yanked
vim.api.nvim_create_autocmd("TextYankPost", {
    group = init_group,
    callback = function()
        vim.highlight.on_yank({ timeout = 300 })
    end
})


-- Relative lines in visual mode
vim.api.nvim_create_autocmd("ModeChanged", {
    group = init_group,
    pattern = { "*:[vV\x16]*" },
    callback = function()
        vim.wo.relativenumber = true
    end,
})

-- Turn off relative lines after leaving visual mode
vim.api.nvim_create_autocmd("ModeChanged", {
    group = init_group,
    pattern = { "[vV\x16]*:*" },
    callback = function()
        vim.wo.relativenumber = false
    end,
})

-- Do some things for each buffer load
vim.api.nvim_create_autocmd("FileType", {
    group = init_group,
    pattern = "*",
    callback = function(opt)
        -- Set folding
        vim.opt.foldlevel = 99
        vim.o.foldlevelstart = 99
        vim.opt.foldcolumn = "1"

        -- Enable treesitter
        -- This call will fail if the language does not have a parser
        pcall(vim.treesitter.start)

        -- Org does its own indent handling
        -- Don't enable treesitter intents when not spported
        if opt.match ~= "org" and vim.treesitter.query.get(vim.bo.filetype, "indents") then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end,
})

-- Check spelling for org and markdown
vim.api.nvim_create_autocmd("FileType", {
    group = init_group,
    pattern = { "org", "markdown" },
    callback = function()
        local winid = vim.api.nvim_get_current_win()
        vim.wo[winid][0].spell = true
        vim.bo.spelllang = "en_us"

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
    end
})
