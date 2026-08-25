-- molten :: run code in a live Jupyter kernel, output inline
--
-- This is the "interactive Python" half. Send a line, a selection, or a cell to
-- a running kernel and the result -- text, dataframes, plots -- appears under
-- the code. State persists between sends, so it behaves like a REPL that lives
-- inside the buffer instead of beside it.
--
-- Works for any language with a Jupyter kernel, not just Python.
--
-- ── REQUIRES (install these before first use; see notes) ────────────────
-- A Python interpreter that has `pynvim` and `jupyter_client` importable, and
-- which core/options.lua points at via vim.g.python3_host_prog. Molten is a
-- REMOTE PLUGIN: after installing it you must run :UpdateRemotePlugins once
-- and restart, or none of its commands exist.
--
-- ── IMAGES ─────────────────────────────────────────────────────────────
-- image_provider = "wezterm" because this machine now runs WezTerm. It renders
-- plots with wezterm's imgcat in a split pane. Two consequences:
--   * it does NOT work through tmux (known upstream limitation)
--   * if you go back to kitty, switch to "image.nvim" and add that plugin --
--     image.nvim only properly supports the Kitty graphics protocol

return {
  "benlubas/molten-nvim",
  version = "^1.0.0",
  dependencies = { "willothy/wezterm.nvim" }, -- required by the wezterm image provider
  build = ":UpdateRemotePlugins",
  ft = { "python", "markdown", "quarto" },

  init = function()
    -- Molten reads global variables, not a setup() table, so these must be set
    -- before the remote plugin starts.
    vim.g.molten_image_provider = "wezterm"
    vim.g.molten_output_win_max_height = 20
    vim.g.molten_auto_open_output = false -- virtual text first; :MoltenShowOutput for detail
    vim.g.molten_virt_text_output = true -- results as virtual text under the code
    vim.g.molten_virt_lines_off_by_1 = true -- lines up with cell markers
    vim.g.molten_wrap_output = true
    vim.g.molten_output_virt_lines = false
    vim.g.molten_split_direction = "right"
    vim.g.molten_split_size = 40
  end,

  keys = {
    { "<leader>ji", "<cmd>MoltenInit<cr>", desc = "Jupyter: init kernel" },
    { "<leader>jd", "<cmd>MoltenDeinit<cr>", desc = "Jupyter: stop kernel" },
    { "<leader>jl", "<cmd>MoltenEvaluateLine<cr>", desc = "Jupyter: run line" },
    { "<leader>jc", "<cmd>MoltenReevaluateCell<cr>", desc = "Jupyter: re-run cell" },
    {
      "<leader>jv",
      ":<C-u>MoltenEvaluateVisual<cr>gv",
      mode = "x",
      desc = "Jupyter: run selection",
    },
    { "<leader>jo", "<cmd>MoltenShowOutput<cr>", desc = "Jupyter: show output" },
    { "<leader>jh", "<cmd>MoltenHideOutput<cr>", desc = "Jupyter: hide output" },
    { "<leader>je", "<cmd>MoltenEnterOutput<cr>", desc = "Jupyter: enter output window" },
    { "<leader>jn", "<cmd>MoltenNext<cr>", desc = "Jupyter: next cell" },
    { "<leader>jp", "<cmd>MoltenPrev<cr>", desc = "Jupyter: prev cell" },
    -- Import/export round-trips outputs to a real .ipynb, which is what makes
    -- jupytext.nvim's plaintext editing lossless for results as well as code.
    { "<leader>jI", "<cmd>MoltenImportOutput<cr>", desc = "Jupyter: import outputs" },
    { "<leader>jE", "<cmd>MoltenExportOutput<cr>", desc = "Jupyter: export outputs" },
  },
}
