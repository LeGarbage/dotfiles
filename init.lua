vim.o.hidden = true
vim.g.mapleader = " "

vim.opt.sessionoptions = { "buffers", "curdir", "folds", "help", "tabpages", "winsize" }

vim.o.belloff = "all"
vim.o.errorbells = false
vim.o.number = true

vim.o.mouse = ""
vim.o.scrolloff = 5
vim.o.pumheight = 5

vim.cmd.syntax = "ON"
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
vim.keymap.set({ "n", "t" }, "<leader>tb", "<cmd>BottomTerminal<cr>")
vim.keymap.set({ "n", "t" }, "<leader>tf", "<cmd>FloatTerminal<cr>")
vim.keymap.set("t", "jk", [[<C-\><C-n>]])

-- *** PLUGINS ***
require("config.lazy")
require("custom.plugins.termless")
vim.cmd("source ~/.config/nvim/custom/plugins/lessline.vim")

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
vim.keymap.set("n", "<C-d>", open_float)
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
-- Clear the command line after 10 seconds
local cmd_msg_clear = vim.api.nvim_create_augroup("cmd_msg_clr", { clear = true })
function Clear_cmd()
    vim.cmd('echon ""')
end

vim.api.nvim_create_autocmd({ "CmdLineLeave" }, {
    pattern = ":",
    group = cmd_msg_clear,
    callback = function() vim.defer_fn(Clear_cmd, 10000) end
})
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

-- *** MAPPINGS ***
-- Set keybinds

-- Open this file
vim.keymap.set("n", "<leader>ev", "<cmd>split $MYVIMRC<cr>")
-- Refresh the config
vim.keymap.set("n", "<leader>sv", "<cmd>source $MYVIMRC<cr>")

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
vim.keymap.set("n", "<leader>\"", "viw<esc>a\"<esc>bi\"<esc>lel")
-- Exit insert mode
vim.keymap.set("i", "jk", "<esc>")
vim.keymap.set("i", "<esc>", "")
-- Save the current session and exit
vim.keymap.set("n", "<leader>sq", "<cmd>mksession!<cr><cmd>wqa<cr>")
-- Load the old session
vim.keymap.set("n", "<leader>sl", "<cmd>source Session.vim<cr>")
-- Switch buffers
vim.keymap.set("n", "<leader>b", "<C-^>")
-- Easier window management
vim.keymap.set("n", "<leader>w", "<C-w>")
-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
