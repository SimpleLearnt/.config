-- lazydev :: make lua_ls actually understand Neovim
--
-- Loads the Neovim API and your installed plugins' type definitions on demand,
-- based on what the file references. Without it, editing this config gives you
-- "undefined global `vim`" and no completion for any plugin module.
--
-- On-demand is the point: loading every plugin's types eagerly would make
-- lua_ls crawl.
--
-- The matching blink.cmp completion source is registered in blink-cmp.lua --
-- one file per plugin means cross-plugin wiring lives with the consumer.

return {
  "folke/lazydev.nvim",
  ft = "lua", -- nothing else can benefit from it

  opts = {
    library = {
      -- vim.uv is a separate library from the Neovim API, pulled in only when
      -- a file actually mentions it.
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      -- nvim-dap-ui ships type annotations; upstream recommends loading them
      -- so its API completes properly while editing plugins/nvim-dap-ui.lua.
      { path = "nvim-dap-ui", words = { "dapui" } },
    },
  },
}
