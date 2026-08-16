---------------
---- INPUT ----
---------------
-- Was: conf/input.conf (kb + mouse devices)

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "caps:escape",
		kb_rules = "",

		follow_mouse = 2,
		sensitivity = 0,

		touchpad = {
			natural_scroll = false,
		},
	},
})

-- SteelSeries Aerox 9 wireless (multiple device nodes)
local aerox = {
	"steelseries-steelseries-aerox-9-wireless-3",
	"steelseries-steelseries-aerox-9-wireless-2",
	"steelseries-steelseries-aerox-9-wireless-1",
	"steelseries-steelseries-aerox-9-wireless",
}
for _, name in ipairs(aerox) do
	hl.device({
		name = name,
		scroll_button = 274,
		scroll_button_lock = true,
	})
end
