---------------------
---- MY PROGRAMS ----
---------------------
-- Was: conf/autostart.conf variables
-- Returned so binds.lua can share the same names without duplication.

local M = {
	terminal = "kitty",
	fileManager = "dolphin",
	menu = "wofi",
	statusBar = "waybar",
	hyprcolor = "hyprpicker -a -f rgb",
	browser = "/usr/bin/zen-browser",
}

-------------------
---- AUTOSTART ----
-------------------
-- Was: conf/autostart.conf exec-once lines

hl.on("hyprland.start", function()
	hl.exec_cmd(M.statusBar)
	hl.exec_cmd(M.terminal)
	hl.exec_cmd(M.browser)
	hl.exec_cmd(M.terminal)
	hl.exec_cmd("systemctl --user start hyprpolkitagent.service")
	-- Note: original used --gapplication.service; common flag is --gapplication-service
	hl.exec_cmd("systemctl --user start elephant.service & walker --gapplication-service & disown")
	hl.exec_cmd("nm-applet &")
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("hyprsunset")
	hl.exec_cmd("hyprpaper")
end)

return M
