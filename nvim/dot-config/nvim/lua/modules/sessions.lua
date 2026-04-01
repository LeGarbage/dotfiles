local M = {}

function M.load_last_session()
    local autosession = require("auto-session")
    local last_session_name = require("auto-session.lib")
        .get_latest_session(autosession.get_root_dir())

    autosession.restore_session(last_session_name, {})
end

return M
