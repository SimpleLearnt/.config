-- mini.surround :: add / change / delete surrounding characters
--
-- ON THE `gs` PREFIX, not mini.surround's default `s`. flash.nvim owns bare
-- `s` and `S` in this config, and flash's jump is used far more often than
-- surround operations, so surround yields.
--
-- `gs` is safe to take: Vim's builtin `gs` means "sleep for N seconds", which
-- nobody uses interactively.
--
--   gsa)  surround with parens     gsaiw"  quote a word
--   gsd"  delete surrounding quotes
--   gsr"' change surrounding " to '
--   gsf / gsF  find surrounding, forward / backward
--   gsh   highlight surrounding

return {
  "echasnovski/mini.surround",
  keys = {
    { "gsa", mode = { "n", "v" }, desc = "Add surrounding" },
    { "gsd", desc = "Delete surrounding" },
    { "gsr", desc = "Replace surrounding" },
    { "gsf", desc = "Find surrounding (right)" },
    { "gsF", desc = "Find surrounding (left)" },
    { "gsh", desc = "Highlight surrounding" },
    { "gsn", desc = "Update n_lines" },
  },

  opts = {
    mappings = {
      add = "gsa",
      delete = "gsd",
      replace = "gsr",
      find = "gsf",
      find_left = "gsF",
      highlight = "gsh",
      update_n_lines = "gsn",
      -- Disabled: these would claim `[` and `]` prefixes that the treesitter
      -- motions and gitsigns hunk navigation already use.
      suffix_last = "",
      suffix_next = "",
    },
  },
}
