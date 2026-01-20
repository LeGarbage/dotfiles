vim.o.hidden = true
vim.g.mapleader = " "

vim.opt.sessionoptions = { "buffers", "curdir", "folds", "globals", "help", "tabpages", "terminal", "winsize" }

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
vim.opt.indentkeys:append("!<Tab>")

vim.o.ignorecase = true
vim.o.smartcase = true

vim.opt.conceallevel = 2
vim.opt.concealcursor = ''

vim.o.undofile = true

vim.opt.listchars = { trail = "~", tab = "⭲ " }
vim.o.list = true

vim.opt.shortmess:append("c")

vim.cmd.colorscheme("onedark")

-- Neovide
vim.g.neovide_floating_shadow = false

-- *** PLUGINS ***
require("config.lazy")

-- Configure illuminate here due to using .configure instead of .setup
require("illuminate").configure({
    filetypes_denylist = {
        'NeogitStatus',
        'TelescopePrompt',
        'aerial-nav',
        'oil',
        'snacks_input',
        'snacks_dashboard',
        'orgagenda',
    },
})

-- *** DIAGNOSTICS ***
vim.diagnostic.config({
    underline = {
        severity = { min = vim.diagnostic.severity.INFO }
    },
    virtual_text = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '󰅚',
            [vim.diagnostic.severity.WARN] = '󰀪',
            [vim.diagnostic.severity.INFO] = '󰋽',
            [vim.diagnostic.severity.HINT] = '󰌶',
        },
    },
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = false,
        header = "",
        prefix = "",
        -- suffix = "",
    },
    severity_sort = true,
    update_in_insert = true,
})
local function open_float()
    vim.diagnostic.open_float()
end
vim.keymap.set({ "n", "i" }, "<C-k>", open_float)
vim.keymap.set("n", "<S-k>", function()
    vim.lsp.buf.hover({ border = "rounded" })
    Snacks.image.hover()
end)

vim.keymap.set("n", "<leader>ds", function()
    vim.diagnostic.setqflist()
end, { desc = "Add diagnostics to quickfix list" })

-- *** LSP ***

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

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        -- Add inlay hints
        if client:supports_method('textDocument/inlayHint') then
            -- Toggle inlay hints
            vim.keymap.set("n", "<leader>di",
                function()
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }),
                        { bufnr = 0 })
                end, { desc = "Toggle inlay hints" })
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

vim.api.nvim_create_autocmd('LspDetach', {
    callback = function(args)
        -- Get the detaching client
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        -- Remove the autocommand to format the buffer on save, if it exists
        if client:supports_method('textDocument/formatting') then
            vim.api.nvim_clear_autocmds({
                event = 'BufWritePre',
                buffer = args.buf,
                group = 'my.lsp',
            })
        end
    end,
})

-- *** AUTOCMDS ***
-- Relative lines in visual mode
local init_group = vim.api.nvim_create_augroup("my.init_group", {})
vim.api.nvim_create_autocmd("ModeChanged", {
    group = init_group,
    pattern = { "*:[vV\x16]*" },
    callback = function()
        vim.wo.relativenumber = true
    end,
})
vim.api.nvim_create_autocmd("ModeChanged", {
    group = init_group,
    pattern = { "[vV\x16]*:*" },
    callback = function()
        vim.wo.relativenumber = false
    end,
})

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

-- Breifly highlight text after it's yanked
vim.api.nvim_create_autocmd("TextYankPost", {
    group = init_group,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ timeout = 300 })
    end
})

-- *** COMMANDS ***
-- Snacks bufdelete
vim.api.nvim_create_user_command("Bd", function(opts)
    Snacks.bufdelete.delete({ file = opts.fargs[1] })
end, { nargs = "?", complete = "buffer" })

-- *** KEYMAPS ***

-- Disable arrow keys
vim.keymap.set("n", "<Up>", "")
vim.keymap.set("n", "<Down>", "")
vim.keymap.set("n", "<Left>", "")
vim.keymap.set("n", "<Right>", "")
vim.keymap.set("i", "<Up>", "")
vim.keymap.set("i", "<Down>", "")
vim.keymap.set("i", "<Left>", "")
vim.keymap.set("i", "<Right>", "")

-- General utils
vim.keymap.set("i", "jk", "<esc>", { desc = "Exit insert mode" })
vim.keymap.set("n", "<leader><leader>", "<cmd>w<cr>", { desc = "Write file" })
vim.keymap.set("n", "<leader>w", "<C-w>", { desc = "Alias for <C-w> for easier window management" })
vim.keymap.set("n", "<leader>z", "za", { desc = "Toggle fold" })
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<leader>cc", function()
    if vim.wo.colorcolumn == "" then
        vim.wo.colorcolumn = "80"
    else
        vim.wo.colorcolumn = ""
    end
end, { desc = "Toggle colorcolumn" })

-- Quickfix
vim.keymap.set("n", "-", function()
    local windows = vim.fn.getwininfo()

    for _, win in ipairs(windows) do
        if win.quickfix == 1 and win.loclist == 0 then
            vim.cmd("cclose")
            return
        end
    end
    vim.cmd("copen")
end)
vim.keymap.set("n", "+", function()
    local windows = vim.fn.getwininfo()

    for _, win in ipairs(windows) do
        if win.quickfix == 1 and win.loclist == 1 then
            vim.cmd("lclose")
            return
        end
    end
    vim.cmd("lopen")
end)

-- Snacks
vim.keymap.set('n', "<leader>bd", Snacks.bufdelete.delete)

-- Todo comments
vim.keymap.set("n", "<leader>tq", "<cmd>TodoQuickFix<cr>", { desc = "Quickfix todos" })

-- Neogit
vim.keymap.set("n", "<leader>n", "<cmd>Neogit<cr>", { desc = "Open Neogit" })

-- Aerial
vim.keymap.set('n', '<leader>at', "<cmd>AerialToggle!<cr>", { desc = "Toggle aerial sidebar" })
vim.keymap.set('n', '<leader>an', "<cmd>AerialNavToggle<cr>", { desc = "Toggle aerial nav" })
vim.keymap.set('n', '<leader>,', "<cmd>AerialPrev<cr>", { desc = "Aerial jump backward" })
vim.keymap.set('n', '<leader>.', "<cmd>AerialNext<cr>", { desc = "Aerial jump forward" })

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>fi', builtin.current_buffer_fuzzy_find, { desc = 'Telescope in current buffer' })
vim.keymap.set('n', '<leader>fr', builtin.registers, { desc = 'Telescope registers' })
vim.keymap.set('n', '<leader>fj', builtin.jumplist, { desc = 'Telescope jump points' })
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Telescope diagnostics' })
vim.keymap.set('n', '<leader>fs', builtin.spell_suggest, { desc = 'Telescope spell' })
vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Telescope keymaps' })
vim.keymap.set('n', '<leader>fx', builtin.highlights, { desc = 'Telescope highlights' })
vim.keymap.set('n', '<leader>ft', "<cmd>TodoTelescope<cr>", { desc = 'Telescope todos' })
vim.keymap.set('n', '<leader>fa', function()
    require("telescope").extensions.aerial.aerial()
end, { desc = 'Telescope aerial' })
vim.keymap.set('n', "<leader>fn", function()
    require("telescope").extensions.fidget.fidget()
end, { desc = "Telescope notification history" })

-- Oil
vim.keymap.set('n', "<leader>i", "<cmd>Oil<cr>", { desc = "Open oil" })

-- Gitsigns
vim.keymap.set('n', "]h", function() require("gitsigns").nav_hunk("next") end, { desc = "Next hunk" })
vim.keymap.set('n', "[h", function() require("gitsigns").nav_hunk("prev") end, { desc = "Previous hunk" })
vim.keymap.set('n', "<leader>hs", function() require("gitsigns").stage_hunk() end, { desc = "Stage hunk" })
vim.keymap.set('v', "<leader>hs", function() require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
    { desc = "Stage hunk" })
vim.keymap.set('n', "<leader>hr", function() require("gitsigns").reset_hunk() end, { desc = "Reset hunk" })
vim.keymap.set('v', "<leader>hr", function() require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
    { desc = "Reset hunk" })
vim.keymap.set('n', "<leader>hi", function() require("gitsigns").preview_hunk_inline() end, { desc = "Preview hunk" })
vim.keymap.set('n', "<leader>hb", function() require("gitsigns").toggle_current_line_blame() end, { desc = "Blame line" })
vim.keymap.set('n', "<leader>hQ", function() require("gitsigns").setqflist("all") end, { desc = "Quickfix repo diff" })
vim.keymap.set('n', "<leader>hq", function() require("gitsigns").setloclist() end, { desc = "Quickfix buffer diff" })
vim.keymap.set({ 'o', 'x' }, "ih", function() require("gitsigns").select_hunk() end)

-- Session management
vim.keymap.set("n", "<leader>ss", function() require("session_manager").load_session(false) end,
    { desc = "Load session" })
vim.keymap.set("n", "<leader>sl", function() require("session_manager").load_last_session(false) end,
    { desc = "Load last session" })
vim.keymap.set("n", "<leader>sd", function() require("session_manager").delete_session() end,
    { desc = "Delete session" })

-- Toggleterm
vim.keymap.set({ "n", "t" }, "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Toggle floating terminal" })
vim.keymap.set({ "n", "t" }, "<leader>tb", "<cmd>ToggleTerm direction=horizontal<cr>",
    { desc = "Toggle bottom terminal" })
vim.keymap.set("t", "jk", [[<C-\><C-n>]])

-- Dap
local dap = require("dap")
vim.keymap.set("n", "<leader>dd", require('persistent-breakpoints.api').toggle_breakpoint,
    { desc = "Toggle breakpoint" })
vim.keymap.set("n", "<leader>d?", function()
    require("dapui").eval(nil)
end, { desc = "Evaluate under cursor" })
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
vim.keymap.set("n", "<leader>dq", dap.terminate, { desc = "Quit debugging session" })
vim.keymap.set("n", "<leader>dr", dap.restart, { desc = "Restart" })
vim.keymap.set("n", "<Up>", dap.restart_frame, { desc = "Restart frame" })
vim.keymap.set("n", "<Down>", dap.step_over, { desc = "Step over" })
vim.keymap.set("n", "<Left>", dap.step_out, { desc = "Step out" })
vim.keymap.set("n", "<Right>", dap.step_into, { desc = "Step into" })

-- Overseer
vim.keymap.set("n", "<leader>cr", "<cmd>OverseerRun<cr>",
    { desc = "Run an Overseer task from a template" })
vim.keymap.set("n", "<leader>ct", "<cmd>OverseerToggle<cr>",
    { desc = "Toggle the Overseer tasks window" })
vim.keymap.set("n", "<leader>cs", "<cmd>OverseerShell<cr>",
    { desc = "Run a shell command as an Overseer task" })

local winid = -1
vim.keymap.set("n", "<leader>co", function()
    if vim.api.nvim_win_is_valid(winid) then
        vim.api.nvim_win_close(winid, false)
    else
        winid = vim.api.nvim_open_win(0, false, {
            split = "below",
            height = 12,
        })

        require("overseer").create_task_output_view(winid, {
            list_task_opts = {
                filter = function(task)
                    return task.time_start ~= nil
                end
            },
            select = function(_, tasks)
                table.sort(tasks, function(a, b)
                    return a.time_start > b.time_start
                end)
                return tasks[1]
            end
        })
    end
end, { desc = "Open an output stream of the last task's output" })
