local M = {}

function M.load_last_session()
    require("auto-session").restore_session(M.get_last_session(), {})
end

function M.get_last_session()
    return require("auto-session.lib").get_latest_session(require("auto-session").get_root_dir())
end

return M
