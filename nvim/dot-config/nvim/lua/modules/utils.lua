local M = {}

function M.require_all(module_path)
    ---@type unknown[]
    local required = {}

    local path = vim.fs.joinpath(vim.fn.stdpath("config"), "lua", module_path, "*.lua")
    ---@type string[]
    local files = vim.fn.glob(path, false, true)

    for _, file in ipairs(files) do
        -- Get the file name only
        local filename = vim.fn.fnamemodify(file, ":t:r")
        local module = module_path .. "." .. filename

        table.insert(required, require(module))
    end

    return required
end

return M
