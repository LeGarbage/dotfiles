local constants = require("overseer.constants")
local TAG = constants.TAG

local function find_flake(opts)
    return vim.fs.find("flake.nix", {
        upward = true,
        type = "file",
        path = opts.dir
    })[1]
end

local commands = {
    { sub = "build", tags = { TAG.BUILD } },
    { sub = "run",   tags = { TAG.RUN } },
}

---@type overseer.TemplateFileProvider
return {
    generator = function(opts)
        if vim.fn.executable("nix") == 0 then
            return 'Command "nix" not found'
        end
        local flake = find_flake(opts)
        if not flake then
            return "No flake.nix file found"
        end

        local templates = {}
        for _, command in ipairs(commands) do
            table.insert(templates, {
                name = "nix " .. command.sub,
                builder = function()
                    return {
                        cmd = { "nix", command.sub },
                    }
                end,
                tags = command.tags
            })
        end

        return templates
    end
}
