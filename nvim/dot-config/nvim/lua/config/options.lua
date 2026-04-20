vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = "a"
vim.o.scrolloff = 7
vim.o.cursorline = true
vim.o.showmode = false

vim.opt.backspace = { "indent", "eol", "start" }

vim.o.breakindent = true
vim.o.wrap = true
vim.o.linebreak = true
vim.o.showbreak = "󱞩 "

vim.o.spell = true
vim.o.spelllang = "en_us"

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

vim.o.showcmd = true

vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.smartindent = true
vim.o.smarttab = true
vim.o.expandtab = true
vim.opt.indentkeys:append("!<Tab>")

vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldmethod = "indent"

vim.o.ignorecase = true
vim.o.smartcase = true

vim.opt.conceallevel = 2
vim.opt.concealcursor = ''

vim.o.splitkeep = "screen"
vim.o.splitright = true

vim.o.undofile = true

vim.opt.listchars = { tab = "⭲ " }
vim.o.list = true

vim.opt.shortmess:append("c")

vim.o.winborder = "rounded"

vim.g.mapleader = " "

vim.cmd.colorscheme("onedark")

require("vim._core.ui2").enable({
    enable = true,
    -- msg = {
    --     targets = {
    --         [""] = "msg",
    --         empty = "cmd",
    --         bufwrite = "msg",
    --         confirm = "cmd",
    --         emsg = "pager",
    --         echo = "msg",
    --         echomsg = "msg",
    --         echoerr = "pager",
    --         completion = "cmd",
    --         list_cmd = "pager",
    --         lua_error = "pager",
    --         lua_print = "msg",
    --         progress = "msg",
    --         rpc_error = "pager",
    --         quickfix = "msg",
    --         search_cmd = "cmd",
    --         search_count = "cmd",
    --         shell_cmd = "pager",
    --         shell_err = "pager",
    --         shell_out = "pager",
    --         shell_ret = "msg",
    --         undo = "msg",
    --         verbose = "pager",
    --         wildlist = "cmd",
    --         wmsg = "msg",
    --         typed_cmd = "cmd",
    --     },
    --     cmd = {
    --         height = 0.5,
    --     },
    --     dialog = {
    --         height = 0.5,
    --     },
    --     msg = {
    --         height = 0.3,
    --         timeout = 5000,
    --     },
    --     pager = {
    --         height = 0.5,
    --     },
    -- },
})

-- Neovide
if vim.g.neovide then
    vim.g.neovide_floating_shadow = false
end
