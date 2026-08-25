-- lazy.nvim bootstrap and configuration.
--
-- Everything under lua/plugins/ is imported automatically -- one file per
-- plugin, filename mirroring the plugin name. Adding a plugin means adding a
-- file; there is no central registry to keep in sync.

-- stdpath("data") resolves from NVIM_APPNAME, so this lands in
-- ~/.local/share/nvim-lab/lazy/ and never touches the main config's plugins.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },

  -- Colorscheme used while plugins are installing on first launch.
  install = { colorscheme = { "tokyonight", "habamax" } },

  -- Check for plugin updates in the background, but do not interrupt with a
  -- notification about it. `:Lazy` shows what is available when you care.
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },

  ui = { border = "rounded" },

  performance = {
    rtp = {
      -- Builtin plugins this config does not use. Each one skipped is
      -- startup time saved.
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "netrwPlugin",
      },
    },
  },
})

-- `:Lazy` is bound here rather than in keymaps.lua because it only exists
-- once lazy.nvim itself is loaded.
vim.keymap.set("n", "<leader>l", "<cmd>Lazy<CR>", { desc = "Lazy plugin manager" })
