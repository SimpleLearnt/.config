-- nvim-lab :: entry point
--
-- This file stays short on purpose. It does three things, in this order:
--   1. Set the leader keys (must happen BEFORE lazy.nvim loads any plugin,
--      because plugin `keys = {}` specs are resolved against the leader at
--      load time -- set it after, and every <leader> mapping silently breaks).
--   2. Load core editor settings that do not depend on any plugin.
--   3. Bootstrap lazy.nvim, which imports everything in lua/plugins/.
--
-- Run with:  NVIM_APPNAME=nvim-lab nvim
--
-- DESIGN RULE: nothing in this config hardcodes the string "nvim-lab".
-- All paths go through vim.fn.stdpath(), which derives from NVIM_APPNAME at
-- runtime. That is what keeps this config relocatable.

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("core.options")
require("core.keymaps")
require("core.autocmds")
require("core.lazy")
