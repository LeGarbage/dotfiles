require("config.options")
require("config.lazy")
require("config.diagnostics")
require("config.lsp")
require("config.autocmds")
require("config.keymaps")

vim.cmd.packadd("nohlsearch")
vim.cmd.packadd("nvim.undotree")


-- Configure illuminate here due to using .configure instead of .setup
require("illuminate").configure({
    filetypes_denylist = {
        'NeogitStatus',
        'TelescopePrompt',
        'aerial-nav',
        'oil',
        'snacks_dashboard',
        'orgagenda',
        'qf'
    },
})
