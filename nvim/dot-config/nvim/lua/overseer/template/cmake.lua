local constants = require("overseer.constants")
local TAG = constants.TAG

local function find_cmakelists(opts)
    return vim.fs.find("CMakeLists.txt", {
        upward = true,
        type = "file",
        path = opts.dir
    })[1]
end

local commands = {
    { name = "cmake configure debug",   command = "cmake", args = { "-DCMAKE_BUILD_TYPE=Debug", "-B", "build" } },
    { name = "cmake configure release", command = "cmake", args = { "-DCMAKE_BUILD_TYPE=Release", "-B", "build" } },
    { name = "cmake build",             command = "cmake", args = { "--build", "build", "--parallel" },             tags = { TAG.BUILD } },
    { name = "cmake test",              command = "ctest", args = { "--test-dir", "build", "--output-on-failure" }, tags = { TAG.TEST } },
    { name = "cmake install",           command = "cmake", args = { "--install", "build" } },
    { name = "cmake reconfigure",       command = "cmake", args = { "build", "--fresh" } },
    { name = "cmake clean",             command = "cmake", args = { "--build", "build", "--target", "clean" },      tags = { TAG.CLEAN } }
}

---@type overseer.TemplateFileProvider
return {
    generator = function(opts)
        if vim.fn.executable("cmake") == 0 then
            return 'Command "cmake" not found'
        end
        local cmakelists = find_cmakelists(opts)
        if not cmakelists then
            return "No CMakeLists.txt file found"
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
                    }
                end,
                tags = command.tags
            })
        end

        return templates
    end
}
