local programs = require("hyprland.programs")

hl.bind("SUPER + Return", hl.dsp.exec_cmd(programs.terminal))
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("ALT + F4", hl.dsp.window.kill())
hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind("SUPER + P", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen())
hl.bind("SUPER + F", hl.dsp.window.float())

hl.bind("SUPER + grave", hl.dsp.global("com.mitchellh.ghostty:LOGO+grave"))

hl.bind("SUPER + Space", hl.dsp.exec_cmd(programs.rofi.launcher))
hl.bind("SUPER + ALT + Space", hl.dsp.exec_cmd(programs.rofi.launcher_actions))
hl.bind("SUPER + C", hl.dsp.exec_cmd(programs.rofi.calc))
hl.bind("SUPER + V", hl.dsp.exec_cmd(programs.rofi.clipboard))
hl.bind("SUPER + S", hl.dsp.exec_cmd(programs.rofi.screenshot))
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd(programs.rofi.powermenu))

hl.bind("SUPER + B", hl.dsp.exec_cmd(programs.browser))
hl.bind("SUPER + N", hl.dsp.exec_cmd(programs.editor))
hl.bind("SUPER + A", hl.dsp.exec_cmd(programs.calendar))
hl.bind("SUPER + T", hl.dsp.exec_cmd(programs.tasks))
hl.bind("SUPER + O", hl.dsp.exec_cmd(programs.obsidian))
hl.bind("SUPER + E", hl.dsp.exec_cmd(programs.file_manager))
hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd(programs.task_manager))

hl.bind("SUPER + PRINT", hl.dsp.exec_cmd(programs.screenshot.window))
hl.bind("PRINT", hl.dsp.exec_cmd(programs.screenshot.monitor))
hl.bind("SUPER + SHIFT + PRINT", hl.dsp.exec_cmd(programs.screenshot.region))

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("SUPER + H", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "d" }))

hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "d" }))

hl.bind("SUPER + Tab", hl.dsp.focus({ monitor = "+1" }))
hl.bind("SUPER + SHIFT + Tab", hl.dsp.focus({ monitor = "+1" }))

hl.bind("SUPER + CTRL + Right", hl.dsp.focus({ workspace = "m+1" }))
hl.bind("SUPER + CTRL + Left", hl.dsp.focus({ workspace = "m-1" }))

for i = 1, 10 do
    local key = i % 10 -- Map workspace 1-10 to keys 1-9 and 0
    hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
    hl.bind("SUPER + ALT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

hl.bind("SUPER + W", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind("SUPER + SHIFT + W", hl.dsp.window.move({ workspace = "special:scratchpad" }))
hl.bind("SUPER + ALT + W", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true })
hl.bind("SHIFT + XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 1%+"),
    { locked = true, repeating = true })
hl.bind("SHIFT + XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("SHIFT + XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 1%+"),
    { locked = true, repeating = true })
hl.bind("SHIFT + XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 1%-"),
    { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true })
hl.bind("ALT + XF86AudioNext", hl.dsp.exec_cmd("playerctl position 5+"), { locked = true })
hl.bind("ALT + XF86AudioPrev", hl.dsp.exec_cmd("playerctl position 5-"), { locked = true })
