local launcher_cmd = [[rofi -show drun -modes "drun,window" -run-command "uwsm-app -s app.slice -- {cmd}"]]

local M = {
    terminal = "uwsm-app -s app.slice -- com.mitchellh.ghostty.desktop:new-window",
    file_manager = "uwsm-app -s app.slice -- org.gnome.Nautilus.desktop:new-window",
    task_manager = "uwsm-app -s app.slice -- io.missioncenter.MissionCenter.desktop",
    browser = "uwsm-app -s app.slice -- firefox.desktop",
    editor = "uwsm-app -s app.slice -- neovide.desktop",
    calendar = "uwsm-app -s app.slice -- org.gnome.Calendar.desktop",
    obsidian = "uwsm-app -s app.slice -- obsidian.desktop",

    rofi = {
        launcher = launcher_cmd,
        launcher_actions = launcher_cmd .. " -drun-show-actions",
        calc = "rofi -show calc -modes calc -theme calc -no-show-match -no-sort",
        clipboard = "rofi -show clipboard -modes clipboard -theme clipboard",
        powermenu = "rofi -show powermenu -modes powermenu -theme powermenu -hover-select",
        screenshot = "rofi -show screenshot -modes screenshot -theme screenshot"
    },

    screenshot = {
        window = "hyprshot -m window",
        monitor = "hyprshot -m output",
        region = "hyprshot -m region",
    }
}

return M
