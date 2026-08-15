local programs = require("hyprland.programs")

hl.on("hyprland.start", function()
    hl.exec_cmd("tailscale systray")
    hl.exec_cmd("TZDIR=/etc/zoneinfo uwsm-app -s app.slice -- io.github.alainm23.planify --background")
    hl.exec_cmd(programs.calendar, { workspace = "2 silent" })
    hl.exec_cmd(programs.tasks, { workspace = "3" })
end)
