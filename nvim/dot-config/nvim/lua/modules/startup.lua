local M = {}
local startup_data = {
    time = 0,
    total = 0,
    streak = nil
}

function M.counter_increment()
    local path = vim.fn.stdpath("data") .. "/startup_count"
    local file = io.open(path, "r")

    if file then
        startup_data.time = tonumber(file:read("*l")) or 0
        startup_data.total = tonumber(file:read("*l")) or 0
        startup_data.streak = tonumber(file:read("*l"))
        file:close()
    end

    local current_date = os.date("*t")
    local current_time = os.time({ year = current_date.year, month = current_date.month, day = current_date.day })

    local last_date = os.date("*t", startup_data.time)
    local last_time = os.time({ year = last_date.year, month = last_date.month, day = last_date.day })

    local diff_days = math.floor(os.difftime(current_time, last_time) / (24 * 60 * 60))

    if diff_days > 1 then
        startup_data.streak = 1
    elseif diff_days == 1 then
        startup_data.streak = startup_data.streak + 1
    end

    startup_data.total = startup_data.total + 1

    file = io.open(path, "w")
    if file then
        file:write(string.format("%d\n%d\n%d", current_time, startup_data.total, startup_data.streak))
        file:close()
    end
end

function M.get_streak()
    return startup_data.streak
end

return M
