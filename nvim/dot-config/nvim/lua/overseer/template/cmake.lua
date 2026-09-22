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
    {
        name = "cmake build && cmake test",
        cmd = {},
        tags = { TAG.BUILD, TAG.TEST },
        strategy = { "orchestrator", tasks = { "cmake build", "cmake test" } }
    },

    { name = "cmake build",             cmd = { "cmake", "--build", "build", "--parallel" },             tags = { TAG.BUILD } },
    { name = "cmake test",              cmd = { "ctest", "--test-dir", "build", "--output-on-failure" }, tags = { TAG.TEST } },
    { name = "cmake install",           cmd = { "cmake", "--install", "build" } },
    { name = "cmake configure debug",   cmd = { "cmake", "-DCMAKE_BUILD_TYPE=Debug", "-B", "build" } },
    { name = "cmake configure release", cmd = { "cmake", "-DCMAKE_BUILD_TYPE=Release", "-B", "build" } },
    { name = "cmake reconfigure",       cmd = { "cmake", "build", "--fresh" } },
    { name = "cmake clean",             cmd = { "cmake", "--build", "build", "--target", "clean" },      tags = { TAG.CLEAN } }
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
                    return {
                        cmd = command.cmd,
                        strategy = command.strategy
                    }
                end,
                tags = command.tags
            })
        end

        return templates
    end
}
