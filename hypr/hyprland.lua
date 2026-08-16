-- =============================================================================
-- Hyprland Lua entrypoint (modular — mirrors conf/*.conf layout)
-- =============================================================================
-- Same structure as hyprland.conf.pl:
--   conf/monitor, autostart, environments, input, general, decorations,
--   animations, layouts, gestures, misc, windowrules, binds
--
-- Each module lives at conf/<name>.lua and is required below.
-- Legacy hyprlang files remain in conf/*.conf as reference/backup.
--
-- Full compositor restart required after structural changes (not just reload).
-- =============================================================================

-- Allow require("conf.monitor") → ~/.config/hypr/conf/monitor.lua
local hypr = (os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")) .. "/hypr"
package.path = hypr .. "/?.lua;" .. hypr .. "/?/init.lua;" .. package.path

-- Load order matches hyprland.conf.pl
require "conf.monitor"
require "conf.autostart"
require "conf.environments"
require "conf.input"
require "conf.general"
require "conf.decorations"
require "conf.animations"
require "conf.layouts"
require "conf.gestures"
require "conf.misc"
require "conf.windowrules"
require "conf.binds"
