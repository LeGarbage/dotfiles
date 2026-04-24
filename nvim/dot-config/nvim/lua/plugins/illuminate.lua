---@type Plugin
return {
    {
        src = "gh:RRethy/vim-illuminate",
        setup = function()
            require("illuminate").configure({
                filetypes_denylist = {
                    'NeogitStatus',
                    'NeogitCommitView',
                    'NeogitDiffView',
                    'TelescopePrompt',
                    'aerial-nav',
                    'oil',
                    'snacks_dashboard',
                    'orgagenda',
                    'qf',
                    'checkhealth'
                },
                modes_denylist = {
                    "v",
                    "V",
                    "\x16"
                }
            })
        end
    }
}
