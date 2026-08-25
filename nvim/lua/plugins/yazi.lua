-- yazi :: file explorer / file manager
--
-- Complements fff rather than overlapping it. fff answers "I know the file,
-- take me there." Yazi answers "show me what's here" and, more importantly,
-- lets you act on files -- rename, move, delete, bulk operations.
--
-- Requires the `yazi` binary (installed system-wide, 26.5.6).

return {
  "mikavilpas/yazi.nvim",
  version = "*", -- track tagged releases, not main
  event = "VeryLazy", -- must be loaded before a directory buffer is opened
  cmd = "Yazi", -- so the startup autocmd below can pull it in deterministically
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },
  },

  -- Runs during startup even though the plugin itself is lazy-loaded, which is
  -- what makes a VimEnter hook possible here rather than in core/autocmds.lua.
  init = function()
    local group = vim.api.nvim_create_augroup("nvim_lab_yazi_startup", { clear = true })

    -- `cat file | nvim` populates the buffer from stdin. That fires before
    -- VimEnter, so record it and stand down when it happens.
    vim.api.nvim_create_autocmd("StdinReadPre", {
      group = group,
      callback = function()
        vim.g.nvim_lab_read_from_stdin = true
      end,
    })

    -- Open the explorer when nvim is launched with nothing to edit, so a bare
    -- `nn` lands in yazi instead of an empty buffer.
    vim.api.nvim_create_autocmd("VimEnter", {
      group = group,
      callback = function()
        -- argc(-1) counts the real argument list, unaffected by any buffer
        -- another plugin may already have created.
        if vim.fn.argc(-1) > 0 or vim.g.nvim_lab_read_from_stdin then
          return
        end

        -- Bail unless this is a genuinely untouched scratch buffer. Guards
        -- against `nvim -c ...`, a restored session, or any plugin that got
        -- there first.
        local buf = vim.api.nvim_get_current_buf()
        if vim.api.nvim_buf_get_name(buf) ~= "" or vim.bo[buf].filetype ~= "" then
          return
        end
        if vim.api.nvim_buf_line_count(buf) > 1 then
          return
        end
        if (vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or "") ~= "" then
          return
        end

        vim.cmd("Yazi cwd")
      end,
    })
  end,

  keys = {
    { "<leader>e", "<cmd>Yazi<cr>", mode = { "n", "v" }, desc = "Explorer (current file)" },
    { "<leader>E", "<cmd>Yazi cwd<cr>", desc = "Explorer (cwd)" },
    -- Deliberately no <leader>e* binding for `:Yazi toggle`: any such mapping
    -- would make plain <leader>e wait timeoutlen (300ms) on every press.
  },

  opts = {
    -- Replaces netrw, so `nvim .` or `:e some/dir/` opens yazi. netrw is
    -- already prevented from loading in core/lazy.lua via lazy.nvim's
    -- performance.rtp.disabled_plugins, which is what upstream's
    -- `vim.g.loaded_netrwPlugin = 1` advice accomplishes.
    open_for_directories = true,

    -- Left at the default (false) on purpose: changing Neovim's cwd on close
    -- would silently move the goalposts for fff's cwd-scoped searches.
    change_neovim_cwd_on_close = false,

    open_multiple_tabs = false,
    floating_window_scaling_factor = 0.9,
    -- yazi_floating_window_border is intentionally unset -- it defaults to
    -- vim.opt.winborder, which core/options.lua already sets to "rounded".

    keymaps = {
      show_help = "<f1>",
      open_file_in_vertical_split = "<c-v>",
      open_file_in_horizontal_split = "<c-x>",
      open_file_in_tab = "<c-t>",
      cycle_open_buffers = "<tab>",
      copy_relative_path_to_selected_files = "<c-y>",
      send_to_quickfix_list = "<c-q>",
      change_working_directory = "<c-\\>",

      -- Enabled in Phase 5, now that their backing plugins exist.
      grep_in_directory = "<c-s>", -- -> fzf-lua, scoped to the hovered dir
      replace_in_directory = "<c-g>", -- -> grug-far, prefilled with that path

      -- Permanently disabled: the only implementation upstream offers for
      -- window-picking is snacks.picker, and this config does not use snacks.
      open_and_pick_window = false,
    },

    integrations = {
      -- Upstream defaults both of these to "telescope", which this config
      -- will never install. Set correctly now so that re-enabling the two
      -- keymaps above in Phase 5 is the only change needed.
      grep_in_directory = "fzf-lua",
      grep_in_selected_files = "fzf-lua",
    },
  },
}
