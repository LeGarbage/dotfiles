vim.loader.enable()

require("config.options")
require("config.plugins")
require("config.diagnostics")
require("config.lsp")
require("config.autocmds")
require("config.keymaps")

vim.cmd.packadd("nohlsearch")
vim.cmd.packadd("nvim.undotree")
