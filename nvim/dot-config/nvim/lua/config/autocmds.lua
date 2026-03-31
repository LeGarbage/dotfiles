local init_group = vim.api.nvim_create_augroup("my.init_group", {})

-- Briefly highlight text after it's yanked
vim.api.nvim_create_autocmd("TextYankPost", {
    group = init_group,
    callback = function()
        vim.highlight.on_yank({ timeout = 300 })
    end
})

-- Disable spellchecking in the terminal
vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        local winid = vim.api.nvim_get_current_win()
        vim.wo[winid][0].spell = false
    end
})

-- Set folding and intent options on file load
vim.api.nvim_create_autocmd("FileType", {
    group = init_group,
    pattern = "*",
    callback = function(opt)
        -- Set folding
        vim.opt.foldlevel = 99
        vim.o.foldlevelstart = 99
        vim.opt.foldcolumn = "1"

        vim.opt.indentkeys:append("!<Tab>")

        -- Org does its own indent handling
        -- Don't enable treesitter intents when not supported
        if opt.match ~= "org" and vim.treesitter.query.get(vim.bo.filetype, "indents") then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
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

        if vim.tbl_contains(ts.get_available(), lang) then
            -- Enable treesitter
            -- This call will fail if the language does not have a parser
            local ok = pcall(vim.treesitter.start, opt.buf, lang)

            if not ok then
                ts.install(lang):await(function()
                    vim.treesitter.start(opt.buf, lang)
                end)
            end
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
