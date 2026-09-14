local constants = require("overseer.constants")
local TAG = constants.TAG

local function find_godotproject(opts)
    return vim.fs.find("project.godot", {
        upward = true,
        type = "file",
        path = opts.dir
    })[1]
end

local commands = {
    { name = "Open Godot editor", command = "godot", args = { "-e" } },
    { name = "Run Godot project", command = "godot", tags = { TAG.RUN } },
}

---@type overseer.TemplateFileProvider
return {
    generator = function(opts)
        if vim.fn.executable("godot") == 0 then
            return 'Command "godot" not found'
        end
        local godotproject = find_godotproject(opts)
        if not godotproject then
            return "No project.godot file found"
        end

        local templates = {}
        for _, command in ipairs(commands) do
            table.insert(templates, {
                name = command.name,
                builder = function()
                    local cmd = { command.command }
                    for _, arg in ipairs(command.args) do
                        table.insert(cmd, arg)
                    end
                    return {
                        cmd = cmd,
                        cwd = vim.fs.dirname(godotproject)
                    }
                end,
                tags = command.tags
            })
        end

        return templates
    end
}
