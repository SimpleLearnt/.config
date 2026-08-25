-- mason-lspconfig :: bridge between Mason package names and LSP config names
--
-- Since Neovim 0.11 made LSP setup native, this plugin's job shrank to two
-- things: installing servers, and optionally auto-enabling them.
--
-- automatic_enable is OFF deliberately. Every server in this config is turned
-- on by a line you can read in nvim-lspconfig.lua, rather than appearing
-- because it happened to be installed.

return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = {
    "mason-org/mason.nvim",
    "neovim/nvim-lspconfig",
  },
  event = { "BufReadPre", "BufNewFile" },

  opts = {
    ensure_installed = {
      "lua_ls",
      "basedpyright",
      "ruff",
      "clangd",
      "vtsls",
      "jsonls",
      "marksman",
    },

    -- See the file header. nvim-lspconfig.lua calls vim.lsp.enable() itself.
    automatic_enable = false,
  },
}
