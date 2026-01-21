-- WARN: As of now, this is all still experimantal and references noice.nvim.
--       When this becomes stable I will return to this

local ui = require("modules.ui")

---@class SearchText
---@field extmark? integer
---@field bufnr? number
---Manages the virtual search text
local M = {}

function M:show()
    self:hide()
    self.buf = vim.api.nvim_get_current_buf()

    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    line = line - 1

    self.extmark = vim.api.nvim_buf_set_extmark(self.buf, ui.ns, line, col, {
        virt_text_pos = "eol",
        virt_text = { "", "IncSearch" },
        hl_mode = "combine"
    })
end

function M:hide()
    if self.extmark and vim.api.nvim_buf_is_valid(self.bufnr) then
        vim.api.nvim_buf_del_extmark(self.bufnr, ui.ns, self.extmark)
    end
end

return M

-- Stuff for future reference
-- local function search(keys)
--     vim.api.nvim_feedkeys(keys, "n", false)
--
--     vim.schedule(function()
--         local ns = vim.api.nvim_create_namespace("search_indicator")
--         vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
--
--         local searches = vim.fn.searchcount()
--
--         local bottom = searches.total
--         if searches.incomplete == 2 then
--             bottom = ">99"
--         end
--
--         vim.api.nvim_buf_set_extmark(0, ns, vim.api.nvim_win_get_cursor(0)[1] - 1, 0, {
--             virt_text = { { string.format("[%d/%d]", searches.current, bottom), "IncSearch" } },
--             virt_text_pos = "eol",
--             hl_mode = "combine"
--         })
--     end)
-- end


-- local ns = vim.api.nvim_create_namespace("search_indicator")
-- vim.api.nvim_create_autocmd({ "CursorMoved", "ModeChanged", "BufLeave" }, {
--     group = init_group,
--     callback = function()
--         vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
--     end
-- })
--
-- vim.api.nvim_create_autocmd("CmdlineLeave", {
--     group = init_group,
--     callback = function(args)
--         if args.file ~= "/" and args.file ~= "?" then return end
--         vim.schedule(function()
--             vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
--
--             local searches = vim.fn.searchcount()
--
--             local bottom = searches.total
--             if searches.incomplete == 2 then
--                 bottom = ">99"
--             end
--             vim.api.nvim_buf_set_extmark(0, ns, vim.api.nvim_win_get_cursor(0)[1] - 1, 0, {
--                 virt_text = { { string.format("[%d/%d]", searches.current, bottom), "IncSearch" } },
--                 virt_text_pos = "eol",
--                 hl_mode = "combine"
--             })
--         end)
--     end
-- })
