vim.o.hidden = true
vim.g.mapleader = " "

vim.opt.sessionoptions = { "buffers", "curdir", "folds", "help", "tabpages", "winsize" }

vim.o.belloff = "all"
vim.o.errorbells = false
vim.o.number = true

vim.o.mouse = "a"
vim.o.scrolloff = 7
vim.o.cursorline = true

vim.o.hlsearch = false

vim.opt.backspace = { "indent", "eol", "start" }

vim.o.wrap = true
vim.o.linebreak = true
vim.o.showbreak = "+++"

vim.o.showcmd = true

vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.smartindent = true
vim.o.smarttab = true
vim.o.expandtab = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.undofile = true

vim.opt.listchars = { trail = "~", tab = "->" }
vim.o.list = true

vim.cmd.colorscheme("colorless")

-- *** TERMINAL ***
-- Toggleterm
vim.keymap.set({ "n", "t" }, "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Toggle floating terminal" })
vim.keymap.set({ "n", "t" }, "<leader>tb", "<cmd>ToggleTerm direction=horizontal<cr>",
    { desc = "Toggle bottom terminal" })
vim.keymap.set("t", "jk", [[<C-\><C-n>]])

-- *** PLUGINS ***
require("config.lazy")
vim.cmd("source ~/.config/nvim/custom/plugins/lessline.vim")

vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"

-- Diagnostic stuff
vim.diagnostic.config({
    underline = {
        severity = { min = vim.diagnostic.severity.INFO }
    },
    virtual_text = {
        --prefix = '',
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '>>',
            [vim.diagnostic.severity.WARN] = '--',
            [vim.diagnostic.severity.HINT] = '!',
            [vim.diagnostic.severity.INFO] = '^',
        },
    },
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = false,
        header = "",
        prefix = "",
        suffix = "",
    },
    severity_sort = true,
    update_in_insert = true,
})
local function open_float()
    vim.diagnostic.open_float()
end
vim.keymap.set("n", "<leader>df", open_float)
vim.keymap.set("i", "<C-d>", open_float)
vim.keymap.set("n", "<leader>da", function()
    vim.lsp.buf.code_action({ apply = true })
end)
vim.keymap.set("n", "<S-k>", function() vim.lsp.buf.hover({ border = "rounded" }) end)

--local icons = {
--}
--
--local completion_kinds = vim.lsp.protocol.CompletionItemKind
--for i, kind in ipairs(completion_kinds) do
--    completion_kinds[i] = icons[kind] and icons[kind] .. kind or kind
--end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = true,
    lineFoldingOnly = true,
}
capabilities.textDocument.semanticTokens.multilineTokenSupport = true
capabilities.textDocument.completion.completionItem.snippetSupport = true
vim.lsp.config("*", {
    capabilities = capabilities,
})

vim.opt.shortmess:append("c")
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        -- Add inlay hints
        if client:supports_method('textDocument/inlayHint') then
            -- Toggle inlay hints
            vim.keymap.set("n", "<leader>dy",
                function()
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }),
                        { bufnr = 0 })
                end)
        end

        -- Auto-format ("lint") on save.
        -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
        if not client:supports_method('textDocument/willSaveWaitUntil')
            and client:supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
                buffer = args.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
                end,
            })
        end
    end,
})

-- *** AUTOCMDS ***
-- Relative lines in visual mode
local visual_group = vim.api.nvim_create_augroup("visual_group", { clear = true })
vim.api.nvim_create_autocmd("ModeChanged", {
    group = visual_group,
    pattern = { "*:[vV\x16]*" },
    callback = function()
        vim.wo.relativenumber = true
    end,
})
vim.api.nvim_create_autocmd("ModeChanged", {
    group = visual_group,
    pattern = { "[vV\x16]*:*" },
    callback = function()
        vim.wo.relativenumber = false
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.opt.foldlevel = 99
        vim.opt.foldcolumn = "1"
        vim.opt.foldtext = "getline(v:foldstart) .. ' [' .. (v:foldend - v:foldstart + 1) .. '](' .. v:foldlevel .. ')'"
    end,
})

-- *** MAPPINGS ***
-- Set keybinds

-- Config utilities
vim.keymap.set("n", "<leader>ve", "<cmd>split $MYVIMRC<cr>", { desc = "Open init.lua in split" })
vim.keymap.set("n", "<leader>vs", function()
    vim.cmd("source $MYVIMRC")
    vim.notify("Successfuly sourced init.lua", vim.log.levels.INFO, { title = "init.lua" })
end, { desc = "Source init.lua" })

-- Disable arrow keys
vim.keymap.set("n", "<Up>", "")
vim.keymap.set("n", "<Down>", "")
vim.keymap.set("n", "<Left>", "")
vim.keymap.set("n", "<Right>", "")
vim.keymap.set("i", "<Up>", "")
vim.keymap.set("i", "<Down>", "")
vim.keymap.set("i", "<Left>", "")
vim.keymap.set("i", "<Right>", "")

-- Add quotes arround current word
vim.keymap.set("n", "<leader>\"", "viw<esc>a\"<esc>bi\"<esc>lel", { desc = "Add quotes around word" })
-- Exit insert mode
vim.keymap.set("i", "jk", "<esc>", { desc = "Exit insert mode" })
-- Switch buffers
vim.keymap.set("n", "<leader>b", "<C-^>", { desc = "Swap between buffers" })
-- Easier window management
vim.keymap.set("n", "<leader>w", "<C-w>", { desc = "Alias for <C-w> for easier window management" })
-- Toggle fold
vim.keymap.set("n", "<leader>z", "za", { desc = "Toggle fold" })
-- Show notification history
vim.keymap.set("n", "<leader>n", function()
    require("snacks").notifier.show_history()
end, { desc = "Show notification history" })
-- Navbuddy
vim.keymap.set('n', '<leader><leader>', "<cmd>Navbuddy<cr>", { desc = "Show navbuddy menu" })
-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>fi', builtin.current_buffer_fuzzy_find, { desc = 'Telescope in current buffer' })
vim.keymap.set('n', '<leader>fr', builtin.registers, { desc = 'Telescope registers' })
vim.keymap.set("n", "<leader>vf", function()
    builtin.find_files({
        cwd = vim.fn.stdpath("config")
    })
end)

-- Session management
vim.keymap.set("n", "<leader>sc", function() require("persistence").load() end, { desc = "Load session" })
vim.keymap.set("n", "<leader>ss", function() require("persistence").select() end, { desc = "Select session" })
vim.keymap.set("n", "<leader>sl", function() require("persistence").load({ last = true }) end,
    { desc = "Load last absolute session" })
vim.keymap.set("n", "<leader>sd", function() require("persistence").stop() end,
    { desc = "Disable session saving for this sesison" })

-- CMake
vim.keymap.set("n", "<leader>cr", "<cmd>Taskless run<cr>", { silent = true, desc = "Build and run project" })
vim.keymap.set("n", "<leader>cb", "<cmd>Taskless build<cr>", { silent = true, desc = "Build project" })
vim.keymap.set("n", "<leader>cc", "<cmd>Taskless configure<cr>", { silent = true, desc = "Configure project" })
vim.keymap.set("n", "<leader>ct", "<cmd>Taskless target<cr>",
    { silent = true, desc = "Set target to run" })
vim.keymap.set("n", "<leader>cp", "<cmd>Taskless preset<cr>", { silent = true, desc = "Select Preset" })
