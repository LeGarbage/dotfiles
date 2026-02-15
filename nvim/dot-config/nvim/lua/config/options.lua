vim.o.hidden = true

vim.o.belloff = "all"
vim.o.errorbells = false
vim.o.number = true

vim.o.mouse = "a"
vim.o.scrolloff = 7
vim.o.cursorline = true
vim.o.showmode = false

vim.o.hlsearch = false

vim.opt.backspace = { "indent", "eol", "start" }

vim.o.wrap = true
vim.o.linebreak = true
vim.o.showbreak = "+++ "

vim.o.showcmd = true

vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.smartindent = true
vim.o.smarttab = true
vim.o.expandtab = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.opt.conceallevel = 2
vim.opt.concealcursor = ''

vim.o.undofile = true

vim.opt.listchars = { trail = "~", tab = "⭲ " }
vim.o.list = true

vim.opt.shortmess:append("c")

vim.o.quickfixtextfunc = "v:lua.require'modules.quickfix'.format"

vim.cmd.colorscheme("onedark")

-- Neovide
vim.g.neovide_floating_shadow = false
