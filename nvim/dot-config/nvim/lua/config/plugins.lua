---@class (exact) PluginEventData
---@field active boolean Whether plugin was added via vim.pack.add() to current session
---@field kind "install"|"update"|"delete" One of "install" (install on disk; before loading), "update" (update already installed plugin; might be not loaded), "delete" (delete from disk)
---@field spec vim.pack.SpecResolved Plugin's specification with defaults made explicit
---@field path string Full path to plugin's directory

---@class (exact) PluginSpec: vim.pack.Spec
---@field setup? fun() Function to be executed when the plugin is loaded
---@field dependencies? (string|PluginSpec)[] List of dependencies that should be loaded before this plugin.
---                                           Strings are treated as the src of the plugin and should be used to specify only the order of plugins.
---                                           PluginSpecs install the specified plugin using the spec and should not be added anywhere else
---@field build? fun(data: PluginEventData) Function to be executed when the plugin is affected by a PackChanged event. Receives the data passed into the PackChanged event

---@class (exact) ResolvedPluginSpec: vim.pack.Spec
---@field setup? fun() Function to be executed when the plugin is loaded
---@field dependencies string[] List of dependencies that should be loaded before this plugin.
---@field build? fun(data: PluginEventData) Function to be executed when the plugin is installed. Receives the data passed into the PackChanged event

---@alias Plugin PluginSpec[]

---@param plugins ResolvedPluginSpec[]
---@return ResolvedPluginSpec[]
local function sort_plugins(plugins)
    ---@type ResolvedPluginSpec[]
    local result = {}
    ---@type ResolvedPluginSpec[]
    local queue = {}
    ---@type { [string]: ResolvedPluginSpec[] }
    local graph = {}
    ---@type { [string]: number }
    local in_degree = {}

    for _, plugin in ipairs(plugins) do
        in_degree[plugin.src] = #plugin.dependencies

        for _, dependency in ipairs(plugin.dependencies) do
            if not graph[dependency] then
                graph[dependency] = {}
            end

            table.insert(graph[dependency], plugin)
        end

        if in_degree[plugin.src] == 0 then
            table.insert(queue, plugin)
        end
    end

    local pointer = 1
    while pointer <= #queue do
        ---@type ResolvedPluginSpec
        local plugin = queue[pointer]
        pointer = pointer + 1

        table.insert(result, plugin)

        for _, dependent in ipairs(graph[plugin.src] or {}) do
            in_degree[dependent.src] = in_degree[dependent.src] - 1

            if in_degree[dependent.src] == 0 then
                table.insert(queue, dependent)
            end
        end
    end

    if #result ~= #plugins then
        error("Cyclical dependency detected")
    end

    return result
end

---@param plugin ResolvedPluginSpec
local function expand_plugin_src(plugin)
    plugin.src = plugin.src:gsub("^gh:", "https://github.com/"):gsub("^cb:", "https://codeberg.org/")

    for i, dependency in ipairs(plugin.dependencies) do
        plugin.dependencies[i] =
            dependency:gsub("^gh:", "https://github.com/"):gsub("^cb:", "https://codeberg.org/")
    end
end

---@param plugins PluginSpec[]
local function resolve_plugins(plugins)
    local i = 1
    while i <= #plugins do
        local plugin = plugins[i]
        plugin.dependencies = plugin.dependencies or {}

        for j, dependency in ipairs(plugin.dependencies) do
            if type(dependency) == "table" then
                table.insert(plugins, dependency)
                plugin.dependencies[j] = dependency.src
            end
        end

        i = i + 1
    end
end

--- Makes sure that every string dependency is defined and that the same plugin isn't defined twice
---@param plugins ResolvedPluginSpec[]
local function validate_deps(plugins)
    ---@type { [string]: boolean }
    local seen = {}

    for _, plugin in ipairs(plugins) do
        if seen[plugin.src] then
            error("Plugin defined in multiple places: " .. plugin.src)
        end
        seen[plugin.src] = true
    end

    for _, plugin in ipairs(plugins) do
        for _, dependency in ipairs(plugin.dependencies) do
            if not seen[dependency] then
                error("Dependency not defined: " .. dependency)
            end
        end
    end
end

---@type PluginSpec[]
local flattened_plugins = vim.iter(require("modules.utils").require_all("plugins")):flatten():totable()

---@cast flattened_plugins -number
local unsorted_plugins = flattened_plugins

resolve_plugins(unsorted_plugins)

---@cast unsorted_plugins ResolvedPluginSpec[]

for _, plugin in ipairs(unsorted_plugins) do
    expand_plugin_src(plugin)
end

validate_deps(unsorted_plugins)

-- Sort for better determinism
table.sort(unsorted_plugins, function(a, b)
    return a.src < b.src
end)

local plugins = sort_plugins(unsorted_plugins)

vim.api.nvim_create_autocmd("PackChanged", {
    group = vim.api.nvim_create_augroup("my_vim.pack", {}),
    callback = function(ev)
        ---@type PluginEventData
        local data = ev.data
        for _, plugin in ipairs(plugins) do
            if data.spec.src == plugin.src and plugin.build then
                plugin.build(data)
            end
        end
    end
})

vim.pack.add(vim.iter(plugins):map(function(plugin)
    ---@type vim.pack.Spec
    return {
        src = plugin.src,
        version = plugin.version,
        name = plugin.name,
        data = plugin.data
    }
end):totable())

for _, plugin in ipairs(plugins) do
    if plugin.setup then plugin.setup() end
end

local function complete_packages(arg_lead)
    arg_lead = arg_lead or ""

    return vim.iter(vim.pack.get())
        :map(function(pack)
            return pack.spec.name
        end)
        :filter(function(name)
            return vim.startswith(name, arg_lead)
        end)
        :totable()
end

vim.api.nvim_create_user_command("PackUpdate", function(args)
    if #args.fargs then
        vim.pack.update(args.fargs, { force = args.bang })
    else
        vim.pack.update(nil, { force = args.bang })
    end
end, {
    desc = "Update plugins",
    nargs = "*",
    bang = true,
    complete = complete_packages
})

vim.api.nvim_create_user_command("PackRestore", function(args)
    if #args.fargs then
        vim.pack.update(args.fargs, { force = args.bang, target = "lockfile" })
    else
        vim.pack.update(nil, { force = args.bang, target = "lockfile" })
    end
end, {
    desc = "Restore plugins to state in lockfile",
    nargs = "*",
    bang = true,
    complete = complete_packages
})

vim.api.nvim_create_user_command("PackInfo", function(_)
    vim.pack.update(nil, { offline = true })
end, {
    desc = "Get plugin info",
    nargs = 0
})

vim.api.nvim_create_user_command("PackDelete", function(args)
    vim.pack.del(args.fargs, { force = args.bang })
end, {
    desc = "Delete plugins",
    nargs = "+",
    bang = true,
    complete = complete_packages
})
