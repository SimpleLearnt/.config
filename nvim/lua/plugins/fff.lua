-- fff :: primary picker -- fuzzy file finding + live grep
--
-- Rust-backed. Ranks results by frecency (frequency + recency), so files you
-- actually work in float to the top instead of you retyping full paths.
--
-- Needs NO external binaries -- the grep engine is its own Rust implementation,
-- not a ripgrep wrapper. The build step downloads a prebuilt binary and only
-- falls back to `cargo build` if none matches this platform.
--
-- Scope: files and text. It deliberately has no LSP/diagnostics/buffer pickers
-- -- those go to trouble.nvim and fzf-lua later.
--
-- NOTE: the package was renamed from `fff.nvim` to `fff` upstream.

return {
  "dmtrKovalenko/fff",

  build = function()
    require("fff.download").download_or_build_binary()
  end,

  -- The plugin lazy-initialises internally, so lazy.nvim should not defer it;
  -- deferring would delay the file index and make the first open feel slow.
  lazy = false,

  opts = {
    -- Index the current working directory on startup. Indexing $HOME here
    -- walks ~1.6M files (caches, backups, plugin git repos) and the
    -- fff-git-status thread has wedged the kernel twice. Home search is on
    -- <leader>ff; ~/.ignore keeps that scan bounded (walker honours it via
    -- .ignore(true) -- see fff-core/src/walk/ripgrep.rs).
    base_path = vim.fn.getcwd(),
    enable_home_dir_scanning = true,
    enable_fs_root_scanning = false, -- indexing / would be enormous and useless

    prompt = "> ",
    title = "FFFiles",
    max_results = 100,
    max_threads = 4,
    lazy_sync = true,
    follow_symlinks = false,

    layout = {
      height = 0.8,
      width = 0.8,
      prompt_position = "bottom",
      preview_position = "right",
      preview_size = 0.5,
      -- Below 130 columns the side-by-side preview gets cramped, so the
      -- layout flips to preview-on-top.
      flex = { size = 130, wrap = "top" },
      min_list_height = 10,
      show_scrollbar = true,
      path_shorten_strategy = "middle_number",
    },

    preview = {
      enabled = true,
      max_size = 10 * 1024 * 1024,
      line_numbers = false,
      wrap_lines = false,
      -- Prose and markup are unreadable truncated; wrap those only.
      filetypes = {
        svg = { wrap_lines = true },
        markdown = { wrap_lines = true },
        text = { wrap_lines = true },
      },
    },

    grep = {
      max_file_size = 10 * 1024 * 1024,
      max_matches_per_file = 100,
      smart_case = true,
      time_budget_ms = 150, -- keeps typing responsive on large trees
      modes = { "plain", "regex", "fuzzy" }, -- cycle with <S-Tab>
      enable_filename_constraint = false,
    },

    -- All three DB/log paths go through stdpath(), so they land under
    -- ~/.cache/nvim-lab and ~/.local/state/nvim-lab. The frecency database is
    -- therefore FRESH -- ranking history from your main config does not carry
    -- over, and needs a few days of use to become useful.
    frecency = {
      enabled = true,
      db_path = vim.fn.stdpath("cache") .. "/fff_nvim",
    },
    history = {
      enabled = true,
      db_path = vim.fn.stdpath("data") .. "/fff_queries",
      min_combo_count = 3,
      combo_boost_score_multiplier = 100,
    },
    logging = {
      log_file = vim.fn.stdpath("log") .. "/fff.log",
      log_level = "info",
      retain_runs = 20,
    },

    -- Keymaps INSIDE the picker window only. These do not affect global maps,
    -- so the <leader>l here does not collide with <leader>l for :Lazy.
    keymaps = {
      close = "<Esc>",
      select = "<CR>",
      select_split = "<C-s>",
      select_vsplit = "<C-v>",
      select_tab = "<C-t>",
      move_up = { "<Up>", "<C-p>" },
      move_down = { "<Down>", "<C-n>" },
      preview_scroll_up = "<C-u>",
      preview_scroll_down = "<C-d>",
      cycle_grep_modes = "<S-Tab>",
      grep_jump_to_next_file = { "<C-A-n>", "<A-Down>" },
      grep_jump_to_prev_file = { "<C-A-p>", "<A-Up>" },
      cycle_previous_query = "<C-Up>",
      toggle_select = "<Tab>",
      send_to_quickfix = "<C-q>",
      toggle_debug = "<F2>",
      focus_list = "<leader>l",
      focus_preview = "<leader>p",
    },
  },

  keys = {
    {
      "<leader>ff",
      function()
        require("fff").find_files({ cwd = vim.env.HOME })
      end,
      desc = "Find files (home)",
    },
    {
      "<leader>fF",
      function()
        require("fff").find_files()
      end,
      desc = "Find files (cwd)",
    },
    {
      "<leader><leader>",
      function()
        require("fff").find_files()
      end,
      desc = "Find files",
    },
    -- Everything fff does lives under <leader>f, so which-key shows the whole
    -- plugin in one popup. Mirrors the bare ff/fg/fz/fw bindings from the
    -- previous config, just leader-prefixed to keep the `f` motion instant.
    {
      "<leader>fg",
      function()
        require("fff").live_grep()
      end,
      desc = "Grep (live)",
    },
    {
      "<leader>fz",
      function()
        require("fff").live_grep({ grep = { modes = { "fuzzy", "plain" } } })
      end,
      desc = "Grep (fuzzy)",
    },
    {
      "<leader>fw",
      function()
        require("fff").live_grep_under_cursor()
      end,
      mode = { "n", "x" },
      desc = "Grep word / selection",
    },
  },
}
