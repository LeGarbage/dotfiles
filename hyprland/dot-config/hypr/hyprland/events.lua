hl.on("hyprland.start", function()
    hl.exec_cmd("tailscale systray")
    hl.exec_cmd("TZDIR=/etc/zoneinfo uwsm-app -s app.slice -- io.github.alainm23.planify --background")
end)
