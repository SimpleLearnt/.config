-- gitsigns :: per-hunk git integration
--
-- Gutter signs, inline blame, and stage/reset/preview without leaving the
-- buffer. Repository-level browsing (commits, branches, status) belongs to
-- fzf-lua -- both live under <leader>g, split by scope: hunk vs repo.

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },

  opts = {
    signs = {
      add = { text = "\u{2502}" }, -- │
      change = { text = "\u{2502}" },
      delete = { text = "\u{2500}" }, -- ─
      topdelete = { text = "\u{2500}" },
      changedelete = { text = "\u{223c}" }, -- ∼
      untracked = { text = "\u{2506}" }, -- ┆
    },

    -- Off by default; <leader>gb toggles it. Always-on blame turns every line
    -- into a distraction.
    current_line_blame = false,
    current_line_blame_opts = { delay = 300, virt_text_pos = "eol" },

    on_attach = function(buf)
      local gs = require("gitsigns")
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
      end

      -- ── Navigation ────────────────────────────────────────────────────
      -- ]h / [h rather than ]c / [c: ]c is Vim's builtin diff-mode motion and
      -- overriding it breaks :diffthis.
      map("n", "]h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, "Next hunk")

      map("n", "[h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, "Prev hunk")

      -- ── Actions ───────────────────────────────────────────────────────
      map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
      map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
      map("v", "<leader>gs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Stage selected lines")
      map("v", "<leader>gr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Reset selected lines")

      map("n", "<leader>gp", gs.preview_hunk_inline, "Preview hunk")
      map("n", "<leader>gd", gs.diffthis, "Diff this file")
      map("n", "<leader>gb", gs.toggle_current_line_blame, "Toggle line blame")

      -- ── Text object ───────────────────────────────────────────────────
      -- `ih` = inner hunk, so `dih` discards a hunk, `vih` selects one.
      map({ "o", "x" }, "ih", gs.select_hunk, "Inner hunk")
    end,
  },
}
