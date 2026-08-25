-- yanky :: yank ring
--
-- After pasting, cycle backward through previous yanks to replace what you
-- just pasted. Also highlights yanked and pasted regions.
--
-- TWO DELIBERATE DEVIATIONS FROM UPSTREAM DEFAULTS:
--
-- 1. Cycling is on [y / ]y, not <C-p> / <C-n>. harpoon owns normal-mode <C-n>
--    (slot 3) in this config, and a yank-ring binding that only works
--    immediately after a paste is not worth taking a jump key for.
--
-- 2. This replaces the `x p -> "_dP` mapping that was in core/keymaps.lua.
--    That existed so pasting over a selection did not clobber the unnamed
--    register. yanky solves the same problem better: the overwritten text
--    enters the ring, so [y recovers it instead of it being discarded.
--
-- The history picker is NOT available: upstream implements it as a telescope
-- extension, and this config has no telescope. Cycling covers the real use.

return {
  "gbprod/yanky.nvim",
  event = { "BufReadPost", "BufNewFile" },

  opts = {
    highlight = {
      on_put = true,
      on_yank = true,
      timer = 150, -- matches the yank highlight in core/autocmds.lua
    },
    ring = {
      history_length = 50,
      storage = "shada", -- persists across sessions via ~/.local/state/nvim-lab
    },
  },

  keys = {
    { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank" },
    { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put after" },
    { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put before" },
    { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put after (cursor at end)" },
    { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put before (cursor at end)" },
    { "[y", "<Plug>(YankyPreviousEntry)", desc = "Previous yank" },
    { "]y", "<Plug>(YankyNextEntry)", desc = "Next yank" },
  },
}
