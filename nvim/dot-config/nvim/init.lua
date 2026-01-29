require("config.options")
require("config.lazy")
require("config.diagnostics")
require("config.lsp")
require("config.autocmds")
require("config.keymaps")

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
