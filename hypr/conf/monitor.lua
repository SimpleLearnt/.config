------------------
---- MONITORS ----
------------------
-- Was: conf/monitor.conf (+ debug from main conf)

hl.monitor({
	output = "DP-1",
	mode = "highres", --mode = "3440x1440@100.00",
	position = "0x0",
	scale = 1,
})

hl.config({
	xwayland = {
		force_zero_scaling = true,
	},
	debug = {
		disable_logs = false,
	},
})

hl.env("GDK_SCALE", "2")
hl.env("XCURSOR_SIZE", "32")
