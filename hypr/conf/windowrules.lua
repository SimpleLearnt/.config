--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------
-- Was: conf/windowrules.conf

hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },
	float = true,
})

hl.window_rule({
	name = "HyprTile",
	match = { class = "HyprTile" },
	move = "0 0",
	float = true,
	border_size = 0,
	rounding = 0,
	no_anim = true,
})

hl.window_rule({
	name = "RuneLite",
	match = { title = "RuneLite" },
	float = true,
	border_size = 0,
	rounding = 0,
	no_anim = true,
	no_blur = true,
	no_shadow = true,
})

hl.window_rule({
	name = "xwayland-video-bridge-fixes",
	match = { class = "xwaylandvideobridge" },
	no_initial_focus = true,
	no_focus = true,
	no_anim = true,
	no_blur = true,
	max_size = "1 1",
	opacity = 0.0,
})
