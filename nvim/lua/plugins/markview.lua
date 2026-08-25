-- markview :: in-buffer Markdown / LaTeX / HTML / YAML previewer
--
-- Replaces the render-markdown.nvim slot from the original design. Renders
-- headings, lists, checkboxes, tables, callouts, code blocks and inline LaTeX
-- directly in the buffer, while the text stays editable.
--
-- Two features render-markdown does not have:
--   * hybrid mode -- the line under the cursor un-renders to raw markdown so
--     you can edit it, while every other line stays previewed
--   * splitview  -- rendered preview side-by-side with the source
--
-- Upstream requirements, all satisfied here: Neovim >= 0.10.3, a treesitter
-- colorscheme (tokyonight), and the markdown / markdown_inline / html / yaml /
-- latex / comment parsers, which nvim-treesitter.lua installs.

return {
  "OXY2DEV/markview.nvim",

  -- Upstream is explicit: DO NOT lazy-load this. The plugin already lazy-loads
  -- itself internally, and deferring it makes previews slower to appear, not
  -- faster. No `ft`, no `event`, no `cmd`.
  lazy = false,

  -- Default priority (50) is deliberate: it must load AFTER the colorscheme so
  -- it derives its highlight groups from tokyonight, which loads at 1000.
  dependencies = { "echasnovski/mini.icons" },

  opts = {
    preview = {
      -- "internal" | "mini" | "devicons". mini.icons is already the config's
      -- single icon source, so reuse it rather than adding a second one.
      icon_provider = "mini",
    },
  },

  config = function(_, opts)
    require("markview").setup(opts)

    local map = vim.keymap.set

    -- Toggles live under <leader>u with the other UI toggles rather than
    -- getting their own prefix -- markview is a display mode, not a workflow.
    map("n", "<leader>um", "<cmd>Markview Toggle<cr>", { desc = "Markview preview toggle" })
    map("n", "<leader>uh", "<cmd>Markview HybridToggle<cr>", { desc = "Markview hybrid mode toggle" })
    map("n", "<leader>uv", "<cmd>Markview splitToggle<cr>", { desc = "Markview splitview toggle" })
  end,
}
