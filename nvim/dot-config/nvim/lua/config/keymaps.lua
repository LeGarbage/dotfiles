vim.g.mapleader = " "

local function open_float()
    vim.diagnostic.open_float()
end
vim.keymap.set({ "n", "i" }, "<C-k>", open_float)
vim.keymap.set("n", "<S-k>", function()
    vim.lsp.buf.hover({ border = "rounded" })
    require("snacks").image.hover()
end)

vim.keymap.set("n", "<leader>ds", function()
    vim.diagnostic.setqflist()
end, { desc = "Add diagnostics to quickfix list" })

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
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "*", "*zz")
vim.keymap.set("n", "#", "#zz")
vim.keymap.set("n", "g*", "g*zz")
vim.keymap.set("n", "g#", "g#zz")
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

    local should_open = true
    for _, win in ipairs(windows) do
        if win.quickfix == 1 and win.loclist == 0 then
            vim.cmd("cclose")
            should_open = false
        elseif win.quickfix == 1 and win.loclist == 1 then
            vim.cmd("lclose")
            should_open = false
        end
    end

    if should_open then
        vim.cmd("copen")
    end
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
vim.keymap.set("n", "<leader>bd", require("snacks").bufdelete.delete)

-- Todo comments
vim.keymap.set("n", "<leader>tq", "<cmd>TodoQuickFix<cr>", { desc = "Quickfix todos" })

-- Neogit
vim.keymap.set("n", "<leader>n", "<cmd>Neogit<cr>", { desc = "Open Neogit" })

-- Aerial
vim.keymap.set("n", "<leader>at", "<cmd>AerialToggle!<cr>", { desc = "Toggle aerial sidebar" })
vim.keymap.set("n", "<leader>an", "<cmd>AerialNavToggle<cr>", { desc = "Toggle aerial nav" })
vim.keymap.set("n", "<leader>,", "<cmd>AerialPrev<cr>", { desc = "Aerial jump backward" })
vim.keymap.set("n", "<leader>.", "<cmd>AerialNext<cr>", { desc = "Aerial jump forward" })

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>fi", builtin.current_buffer_fuzzy_find, { desc = "Telescope in current buffer" })
vim.keymap.set("n", "<leader>fr", builtin.registers, { desc = "Telescope registers" })
vim.keymap.set("n", "<leader>fj", builtin.jumplist, { desc = "Telescope jump points" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Telescope diagnostics" })
vim.keymap.set("n", "<leader>fs", builtin.spell_suggest, { desc = "Telescope spell" })
vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Telescope keymaps" })
vim.keymap.set("n", "<leader>fx", builtin.highlights, { desc = "Telescope highlights" })
vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Telescope todos" })
vim.keymap.set("n", "<leader>fa", function()
    require("telescope").extensions.aerial.aerial()
end, { desc = "Telescope aerial" })
vim.keymap.set("n", "<leader>fn", function()
    require("telescope").extensions.fidget.fidget()
end, { desc = "Telescope notification history" })

-- Oil
vim.keymap.set("n", "<leader>i", "<cmd>Oil<cr>", { desc = "Open oil" })

-- Gitsigns
vim.keymap.set("n", "]h", function() require("gitsigns").nav_hunk("next") end, { desc = "Next hunk" })
vim.keymap.set("n", "[h", function() require("gitsigns").nav_hunk("prev") end, { desc = "Previous hunk" })
vim.keymap.set("n", "<leader>hs", function() require("gitsigns").stage_hunk() end, { desc = "Stage hunk" })
vim.keymap.set("v", "<leader>hs", function() require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
    { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>hr", function() require("gitsigns").reset_hunk() end, { desc = "Reset hunk" })
vim.keymap.set("v", "<leader>hr", function() require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
    { desc = "Reset hunk" })
vim.keymap.set("n", "<leader>hi", function() require("gitsigns").preview_hunk_inline() end, { desc = "Preview hunk" })
vim.keymap.set("n", "<leader>hb", function() require("gitsigns").toggle_current_line_blame() end, { desc = "Blame line" })
vim.keymap.set("n", "<leader>hQ", function() require("gitsigns").setqflist("all") end, { desc = "Quickfix repo diff" })
vim.keymap.set("n", "<leader>hq", function() require("gitsigns").setloclist() end, { desc = "Quickfix buffer diff" })
vim.keymap.set({ "o", "x" }, "ih", function() require("gitsigns").select_hunk() end)

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
vim.keymap.set("n", "<leader>dd", require("persistent-breakpoints.api").toggle_breakpoint,
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
        return
    end
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
end, { desc = "Open an output stream of the last task's output" })
