-- todo-comments :: highlight and list TODO / FIXME / HACK / NOTE / WARN
--
-- Resolves the namespace question that was left open: it gets BOTH bindings,
-- because they are genuinely different activities.
--   <leader>ft  fuzzy-search todos   (finding one -- a project content search)
--   <leader>xt  todo list in trouble (working through them -- a list)
--
-- No ]t / [t jump motions. Upstream defaults to those, but
-- nvim-treesitter-textobjects already uses ]t / [t / ]T / [T for class
-- navigation, and inventing a third-choice key for a motion the list already
-- covers is not worth the collision.

return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TodoTrouble", "TodoFzfLua", "TodoQuickFix" },

  opts = {
    signs = true,
    keywords = {
      FIX = { icon = "\u{f188}", color = "error", alt = { "FIXME", "BUG", "ISSUE" } },
      TODO = { icon = "\u{f0ae}", color = "info" },
      HACK = { icon = "\u{f0e7}", color = "warning" },
      WARN = { icon = "\u{f071}", color = "warning", alt = { "WARNING", "XXX" } },
      PERF = { icon = "\u{f0e4}", alt = { "OPTIM", "PERFORMANCE" } },
      NOTE = { icon = "\u{f249}", color = "hint", alt = { "INFO" } },
      TEST = { icon = "\u{f0e7}", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
    },
    highlight = {
      -- Match only when the keyword is followed by a colon, so prose
      -- containing the word "note" is not lit up.
      pattern = [[.*<(KEYWORDS)\s*:]],
    },
    search = {
      pattern = [[\b(KEYWORDS):]],
    },
  },

  keys = {
    { "<leader>ft", "<cmd>TodoFzfLua<cr>", desc = "Find todos" },
    { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo list" },
  },
}
