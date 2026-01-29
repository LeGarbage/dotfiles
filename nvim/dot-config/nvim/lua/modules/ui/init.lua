---@class UI
---@field ns integer
local M = {}

M.ns = vim.api.nvim_create_namespace("uiinternal")

vim.ui_attach(M.ns, { ext_messages = true }, function() end)

return M
