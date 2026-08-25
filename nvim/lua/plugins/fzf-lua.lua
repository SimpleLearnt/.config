-- fzf-lua :: the pickers fff does not do
--
-- Deliberately small role. fff owns files and grep; this covers editor
-- introspection (help, keymaps, commands, marks, registers) plus git browsing.
-- There are intentionally NO file or live-grep bindings here, so the two
-- pickers never compete for the same job.
--
-- Also the backend for yazi's <c-s> "grep in directory" integration and
-- todo-comments' <leader>ft.
--
-- Requires the `fzf` binary (present) and ripgrep for its grep-family pickers.

return {
  "ibhagwan/fzf-lua",
  dependencies = { "echasnovski/mini.icons" },
  cmd = "FzfLua",

  opts = {
    winopts = {
      height = 0.85,
      width = 0.85,
      border = "rounded",
      preview = {
        layout = "flex",
        flip_columns = 130, -- same threshold fff uses, so both feel alike
      },
    },
    -- Derive fzf's colors from the active colorscheme instead of fzf's
    -- defaults, which clash badly with tokyonight.
    fzf_colors = true,
    keymap = {
      builtin = {
        ["<C-u>"] = "preview-page-up",
        ["<C-d>"] = "preview-page-down",
      },
    },
  },

  keys = {
    -- ── Project (<leader>f) ─────────────────────────────────────────────
    { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },

    -- ── Editor introspection (<leader>s) ────────────────────────────────
    { "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Help tags" },
    { "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Keymaps" },
    { "<leader>sc", "<cmd>FzfLua commands<cr>", desc = "Commands" },
    { "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Marks" },
    { "<leader>sr", "<cmd>FzfLua registers<cr>", desc = "Registers" },
    { "<leader>sH", "<cmd>FzfLua highlights<cr>", desc = "Highlight groups" },
    { "<leader>sR", "<cmd>FzfLua resume<cr>", desc = "Resume last picker" },

    -- ── Git browsing (<leader>g) ────────────────────────────────────────
    -- gitsigns owns the hunk-level bindings; these are repository-level.
    { "<leader>gc", "<cmd>FzfLua git_commits<cr>", desc = "Git commits" },
    { "<leader>gB", "<cmd>FzfLua git_branches<cr>", desc = "Git branches" },
    { "<leader>gS", "<cmd>FzfLua git_status<cr>", desc = "Git status" },
  },
}
