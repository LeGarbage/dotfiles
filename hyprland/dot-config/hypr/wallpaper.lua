local target_monitor = "HDMI-A-1"
local wallpaper_config = os.getenv("HOME") .. "/.local/share/Steam/steamapps/common/wallpaper_engine/config.json"
local json = require("lib.json")
local active_monitors = {}

local function read_file(path)
    local file = io.open(path, "r")
    if file == nil then error("File " .. path .. " not found") end
    local content = file:read("*a")
    file:close()
    return content
end

local function set_wallpaper(monitor)
    if monitor == target_monitor then
        local day_index = os.date("%w") + 1

        local wallpaper_data = json.decode(read_file(wallpaper_config))
        ---@type string
        local wallpaper_path

        for _, playlist in ipairs(wallpaper_data.steamuser.general.playlists) do
            if playlist.name == "Playlist" then
                wallpaper_path = playlist.items[day_index]
                break
            end
        end

        -- Remove the leading Z: in the paths
        wallpaper_path = wallpaper_path:gsub("^.*:", "")

        local wallpaper_id = wallpaper_path:gsub("^(.*)/.*$", "%1"):gsub("^.*/(.*)$", "%1")

        local command = string.format([[linux-wallpaperengine --screen-root "%s" --bg "%s" --silent --scaling fill]],
            monitor,
            wallpaper_id)

        hl.exec_cmd(command)
        active_monitors[monitor] = command
    end
end

hl.on("monitor.added", function(monitor)
    hl.timer(function()
        set_wallpaper(monitor.name)
    end, { timeout = 1000, type = "oneshot" })
end)

hl.on("monitor.removed", function(monitor)
    if active_monitors[monitor.name] then
        hl.exec_cmd(string.format([[pkill -SIGINT -f "%s"]], active_monitors[monitor.name]))
    end
end)
