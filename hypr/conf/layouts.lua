-----------------
---- LAYOUTS ----
-----------------
-- Was: conf/layouts.conf

hl.config({
	dwindle = {
		preserve_split = true,
	},
})

hl.workspace_rule({
	workspace = "2",
	layout = "scrolling",
	layout_opts = { direction = "right" },
})
hl.workspace_rule({
	workspace = "1",
	layout = "scrolling",
	layout_opts = { direction = "right" },
})
