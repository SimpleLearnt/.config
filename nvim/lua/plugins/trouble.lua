-- trouble :: structured lists for diagnostics, references, and symbols
--
-- Covers what fff deliberately lacks. It is also a better fit than a fuzzy
-- picker for this data: these are lists you navigate repeatedly, jumping back
-- and forth with the source visible, rather than search-once-and-open.
--
-- NOTE on bindings: upstream's README puts symbols on <leader>cs and the LSP
-- list on <leader>cl. Both are moved to <leader>x here -- <leader>cl is
-- nvim-lint's "lint buffer", and everything in this plugin is a list, which is
-- what <leader>x means in this config.

return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  opts = {
    focus = false, -- opening the list does not steal the cursor
    auto_preview = true,
    win = { size = 0.3 },
  },

  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (workspace)" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics (buffer)" },
    { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Document symbols" },
    {
      "<leader>xr",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "LSP references / definitions",
    },
    { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location list" },
    { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list" },
  },
}
