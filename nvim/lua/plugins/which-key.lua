-- which-key :: shows what a prefix can do, after you have already pressed it
--
-- Also the single place prefix GROUPS are named. Every plugin supplies its own
-- `desc` on individual keys; this file only labels the prefixes those keys hang
-- off, so a new plugin usually needs no edit here -- only a brand new prefix
-- does.
--
-- Popup delay is core/options.lua's timeoutlen (300ms).

return {
  "folke/which-key.nvim",
  event = "VeryLazy",

  opts = {
    preset = "modern",
    win = { wo = { winblend = 0 } },

    spec = {
      -- Namespaces. See ~/notes/nvim-notes.md for the reasoning behind the
      -- f/s split: <leader>f locates things in the project, <leader>s searches
      -- Neovim itself.
      { "<leader>f", group = "find (project)" },
      { "<leader>s", group = "search (editor)" },
      { "<leader>c", group = "code" },
      { "<leader>b", group = "buffer" },
      { "<leader>w", group = "window" },
      { "<leader>u", group = "ui toggle" },
      { "<leader>q", group = "quit" },
      { "<leader>g", group = "git" },
      { "<leader>x", group = "diagnostics" },
      { "<leader>d", group = "debug" },
      { "<leader>j", group = "jupyter" },
      { "<leader>i", group = "ai" },

      -- Motion prefixes, so ] and [ are discoverable too. These carry the
      -- treesitter-textobjects motions, gitsigns hunks (]h/[h), yanky's ring
      -- ([y/]y), plus Neovim's builtin ]d / ]q.
      { "]", group = "next" },
      { "[", group = "prev" },

      -- mini.surround lives here rather than on bare `s`, which flash owns.
      { "gs", group = "surround" },

      -- Single bindings that are not groups, listed here only so the popup
      -- shows a useful label instead of the raw callback.
      { "<leader>e", desc = "Explorer (current file)" },
      { "<leader>E", desc = "Explorer (cwd)" },
      { "<leader>a", desc = "Harpoon add file" },
      { "<leader>l", desc = "Lazy" },
      { "<leader>-", desc = "Split below" },
      { "<leader>|", desc = "Split right" },
    },
  },

  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer local keymaps",
    },
  },
}
